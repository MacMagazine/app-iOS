//
//  LazyImage.swift
//  LazyImage
//
//  Created by Lampros Giampouras on 5/4/15.
//  Copyright (c) 2015 Lampros Giampouras. All rights reserved.
//  https://github.com/lamprosg/LazyImage

//  Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
//  Version 6.4.2


import Foundation
import UIKit

/// LazyImage error object
///
/// - CallFailed: The download request did not succeed.
/// - noDataAvailable: The download request returned nil response.
/// - CorruptedData: The downloaded data are corrupted and can not be read.
public enum LazyImageError: Error {
	case CallFailed
	case noDataAvailable
	case CorruptedData
}

extension LazyImageError: LocalizedError {
	
	public var errorDescription: String? {
		switch self {
		case .CallFailed:
			return NSLocalizedString("The download request did not succeed.", comment: "Error")
			
		case .noDataAvailable:
			return NSLocalizedString("The download request returned nil response.", comment: "Error")
			
		case .CorruptedData:
			return NSLocalizedString("The downloaded data are corrupted and can not be read.", comment: "Error")
		}
	}
}




class LazyImage: NSObject {
	
	var backgroundView:UIView?
	var oldFrame:CGRect = CGRect()
	var imageAlreadyZoomed:Bool = false     // Flag to track whether there is currently a zoomed image
	var showSpinner:Bool = false            // Flag to track wether to show spinner
	var forceDownload:Bool = false          // Flag to force download an image even if it is cached on the disk
	var spinner:UIActivityIndicatorView?    // Actual spinner
	var desiredImageSize:CGSize?
	
	
	//MARK: - URL string stripping
	
	//TODO: Change this to hash the url
	private func stripURL(url:String) -> String {
		return url.replacingOccurrences(of: "/", with: "", options: NSString.CompareOptions.literal, range: nil)
	}
	
	/*
	private func SHA256(url:String) -> String {
	
	let data = url(using: String.Encoding.utf8)
	let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH))
	CC_SHA256(((data! as NSData)).bytes, CC_LONG(data!.count), res?.mutableBytes.assumingMemoryBound(to: UInt8.self))
	let hashedString = "\(res!)".replacingOccurrences(of: "", with: "").replacingOccurrences(of: " ", with: "")
	let badchar: CharacterSet = CharacterSet(charactersIn: "\"<\",\">\"")
	let cleanedstring: String = (hashedString.components(separatedBy: badchar) as NSArray).componentsJoined(by: "")
	return cleanedstring
	
	}
	*/
	
	//MARK: - Image storage
	
	private func storagePathforImageName(name:String) -> String {
		return String(format:"%@/%@", NSTemporaryDirectory(), name)
	}
	
	
	private func saveImage(image:UIImage, imagePath:String) {
		
		//Store image to the temporary folder for later use
		var error: NSError?
		
		do {
			try UIImagePNGRepresentation(image)!.write(to: URL(fileURLWithPath: imagePath), options: [])
		} catch let error1 as NSError {
			error = error1
			if let actualError = error {
				Swift.debugPrint("Image not saved. \(actualError)")
			}
		} catch {
			fatalError()
		}
	}
	
	
	private func readImage(imagePath:String) -> UIImage? {
		
		//Read the image
		var image:UIImage?
		if let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
			//Image exists
			let dat:Data = imageData
			
			image = UIImage(data:dat)
		}
		return image
	}
	
	
	//MARK: - Clear cache for specific URLs
	
	
	/// Clear the storage for specific URLs if they are already downloaded
	///
	/// - Parameter urls: The urls array for which the storage will be cleared
	func clearCacheForURLs(urls:Array<String>) -> Void {
		
		for i in stride(from: 0, to: urls.count, by: 1) {
			
			let imgName:String = self.stripURL(url: urls[i])
			
			//Image path
			let imagePath:String = self.storagePathforImageName(name: imgName)
			
			//Check if image exists
			let imageExists:Bool = FileManager.default.fileExists(atPath: imagePath)
			
			if imageExists {
				var error: NSError?
				
				do {
					try FileManager.default.removeItem(atPath: imagePath)
				} catch let error1 as NSError {
					error = error1
					if let actualError = error {
						Swift.debugPrint("Image not saved. \(actualError)")
					}
				} catch {
					fatalError()
				}
			}
		}
	}
	
	
	//MARK - Check image existence
	
	
	/// Checks if image exists in storage
	///
	/// - Parameter url: The image URL
	/// - Returns: returns the image path or nil if image does not exists
	private func checkIfImageExists(url:String) -> String? {
		
		let imgName:String = self.stripURL(url: url)
		
		//Image path
		var imagePath:String? = self.storagePathforImageName(name: imgName)
		
		//Check if image exists
		let imageExists:Bool = FileManager.default.fileExists(atPath: imagePath!)
		
		if !imageExists {
			imagePath = nil
		}
		
		return imagePath
	}
	
	
	//MARK: - Preload setup image
	
	
	/// Sets up the image before loading with a default image
	private func setupImageBeforeLoading(imageView:UIImageView, defaultImage:String?) -> Void {
		
		if let defaultImg = defaultImage {
			imageView.image = UIImage(named:defaultImg)
		}
	}
	
	
	//MARK: - Setup 0 framed image
	
	private func setUpZeroFramedImageIfNeeded(imageView:UIImageView) -> Void {
		
		//Check if imageview size is 0
		let width:CGFloat = imageView.bounds.size.width;
		let height:CGFloat = imageView.bounds.size.height;
		
		//In case of default cell images (Dimensions are 0 when not present)
		if height == 0 && width == 0 {
			
			var frame:CGRect = imageView.frame
			frame.size.width = 40
			frame.size.height = 40
			imageView.frame = frame
		}
	}
	
	
	//MARK: - Image lazy loading
	
	//MARK: Image lazy loading without completion
	
	
	/// Downloads and shows an image URL to the specified image view
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	func show(imageView:UIImageView, url:String?) -> Void {
		self.showSpinner = false
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: nil) {_ in}
	}
	
	
	/// Downloads and shows an image URL to the specified image view presenting a spinner until the data are fully downloaded
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	func showWithSpinner(imageView:UIImageView, url:String?) -> Void {
		self.showSpinner = true
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: nil) {_ in}
	}
	
	
	/// Downloads and shows an image URL to the specified image view presenting a default image until the data are fully downloaded
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - defaultImage: The default image to be shown until the image data are fully downloaded
	func show(imageView:UIImageView, url:String?, defaultImage:String?) -> Void {
		self.showSpinner = false
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: defaultImage) {_ in}
	}
	
	
	/// Downloads and shows an image URL to the specified image view presenting both a default image and a spinner until the data are fully downloaded
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - defaultImage: The default image to be shown until the image data are fully downloaded
	func showWithSpinner(imageView:UIImageView, url:String?, defaultImage:String?) -> Void {
		self.showSpinner = true
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: defaultImage) {_ in}
	}
	
	
	//MARK: Image lazy loading with completion
	
	
	/// Downloads and shows an image URL to the specified image view presenting a spinner until the data are fully downloaded
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func showWithSpinner(imageView:UIImageView, url:String?, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = true
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	/// Downloads and shows an image URL to the specified image view
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func show(imageView:UIImageView, url:String?, completion: @escaping ( _ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = true
		self.forceDownload = false
		self.desiredImageSize = nil
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	//MARK: Image lazy loading with completion and image resizing
	
	
	/// Downloads and shows an image URL to the specified image view presenting a spinner until the data are fully downloaded.
	/// The image is rescaled according to the size provided for better rendering
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - size: The new scaling size of the image
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func showWithSpinner(imageView:UIImageView, url:String?, size:CGSize, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = true
		self.forceDownload = false
		self.desiredImageSize = size
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	/// Downloads and shows an image URL to the specified image view.
	/// The image is rescaled according to the size provided for better rendering
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - size: The new scaling size of the image
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func show(imageView:UIImageView, url:String?, size:CGSize, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = false
		self.forceDownload = false
		self.desiredImageSize = size
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	//MARK: Image lazy loading with force download, with completion and image resizing
	
	/// Force downloads, even if cached, and shows an image URL to the specified image view presenting a spinner.
	/// The image is rescaled according to the size provided for better rendering
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - size: The new scaling size of the image
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func showOverrideWithSpinner(imageView:UIImageView, url:String?, size:CGSize, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = true
		self.forceDownload = true
		self.desiredImageSize = size
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	/// Force downloads, even if cached, and shows an image URL to the specified image view.
	/// The image is rescaled according to the size provided for better rendering
	///
	/// - Parameters:
	///   - imageView: The image view reference to show the image
	///   - url: The URL of the image to be downloaded
	///   - size: The new scaling size of the image
	///   - completion: The completion closure when the data are fully downloaded and presented on the image view
	func showOverride(imageView:UIImageView, url:String?, size:CGSize, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		self.showSpinner = false
		self.forceDownload = true
		self.desiredImageSize = size
		self.load(imageView: imageView, url: url, defaultImage: nil) {
			(error:LazyImageError?) in
			
			//Call completion block
			completion(error)
		}
	}
	
	
	
	//MARK: - Show Image
	
	
	fileprivate func load(imageView:UIImageView, url:String?, defaultImage:String?, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		
		self.setupImageBeforeLoading(imageView: imageView, defaultImage: defaultImage)
		
		if url == nil || url!.isEmpty {
			let error: LazyImageError = LazyImageError.CallFailed
			completion(error)
			return //URL is null, don't proceed
		}
		
		//Clip subviews for image view
		imageView.clipsToBounds = true;
		
		//Force download image if required
		if self.forceDownload == true {
			
			//Lazy load image (Asychronous call)
			self.lazyLoad(imageView: imageView, url: url) {
				(error:LazyImageError?) in
				
				//Completion block reference
				completion(error)
			}
			return
		}
		
		//Check if image exists
		let imagePath:String? = self.checkIfImageExists(url: url!)
		
		if let imagePath = imagePath {
			
			self.setUpZeroFramedImageIfNeeded(imageView: imageView)
			
			//Try to read the image
			let image = self.readImage(imagePath: imagePath)
			
			if let image = image {
				//Image read successfully
				
				self.updateImageView(imageView:imageView, fetchedImage:image) {
					
					//Completion block
					//Data available with no errors
					completion(nil)
					return
				}
			}
			else {
				//Image exists but corrupted. Load it again
				
				//Lazy load image (Asychronous call)
				self.lazyLoad(imageView: imageView, url: url) {
					(error:LazyImageError?) in
					
					//Call completion block
					completion(error)
				}
			}
		}
		else
		{
			//Image does not exist. Load it
			
			//Lazy load image (Asychronous call)
			self.lazyLoad(imageView: imageView, url: url) {
				(error:LazyImageError?) in
				
				//Completion block reference
				completion(error)
			}
			
		}
	}
	
	
	private func lazyLoad(imageView:UIImageView, url:String?, completion: @escaping (_ error:LazyImageError?) -> Void) -> Void {
		
		if url == nil || url!.isEmpty {
			let error: LazyImageError = LazyImageError.CallFailed
			completion(error)
			return //URL is null, don't proceed
		}
		
		//Show spinner
		if self.showSpinner {
			self.showActivityIndicatory(view:imageView)
		}
		
		//Make the call
		self.fetchImage(url: url) {
			
			[weak self] (image:UIImage?, error:LazyImageError?) in
			
			var finalError = error
			if finalError == nil {
				
				if let img = image {
					
					let imgName:String? = self?.stripURL(url: url!)
					
					//Image path
					let imagePath:String? = self?.storagePathforImageName(name: imgName!)
					
					//Save the image
					self?.saveImage(image: img, imagePath: imagePath!)
				}
				else {
					//Completion block
					//Data available but corrupted
					finalError = LazyImageError.CorruptedData
				}
			}
			
			//Update the UI
			self?.updateImageView(imageView:imageView, fetchedImage:image) {
				
				//Completion block
				//Data available with no errors
				completion(finalError)
			}
		}
	}
	
	
	//MARK: - Call
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		
		if challenge.previousFailureCount > 0 {
			completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
		} else if let serverTrust = challenge.protectionSpace.serverTrust {
			completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
		} else {
			print("unknown state. error: \(String(describing: challenge.error))")
			// do something w/ completionHandler here
		}
	}

	func fetchImage(url:String?, completion: @escaping (_ image:UIImage?, _ error:LazyImageError?) -> Void) -> Void {
		
		guard let url = url else {
			
			//Call did not succeed
			let error: LazyImageError = LazyImageError.CallFailed
			completion(nil, error)
			return
		}
		
		//Lazy load image (Asychronous call)
		let urlObject:URL = URL(string:url)!
		let urlRequest:URLRequest = URLRequest(url: urlObject)
		
		let backgroundQueue = DispatchQueue(label:"imageBackgroundQue",
											qos: .background,
											target: nil)
		
		backgroundQueue.async(execute: {
			
			let session:URLSession = URLSession(configuration: URLSessionConfiguration.default)
			let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
				
				if response != nil {
					let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
					
					if httpResponse.statusCode != 200 {
						Swift.debugPrint("LazyImage status code : \(httpResponse.statusCode)")
						
						//Completion block
						//Call did not succeed
						let error: LazyImageError = LazyImageError.CallFailed
						completion(nil, error)
						return
					}
				}
				
				if data == nil {
					if error != nil {
						Swift.debugPrint("Error : \(error!.localizedDescription)")
					}
					Swift.debugPrint("LazyImage: No image data available")
					
					//No data available
					let error: LazyImageError = LazyImageError.noDataAvailable
					completion(nil, error)
					return
				}
				
				completion(UIImage(data:data!), nil)
				return
			})
			task.resume()
		})
	}
	
	
	//MARK: Update the image
	
	private func updateImageView(imageView:UIImageView, fetchedImage:UIImage?,
								 completion: @escaping () -> Void) -> Void {
		
		//Check if we have a new size
		var image:UIImage? = fetchedImage
		
		if let _ = image, let newSize = self.desiredImageSize {
			image = self.resizeImage(image: image!, targetSize: newSize)
		}
		
		//Go to main thread and update the UI
		DispatchQueue.main.async(execute: { [weak self] () -> Void in
			
			//Hide spinner
			if let _ = self?.showSpinner {
				self?.removeActivityIndicator()
				self?.showSpinner = false
			}
			
			//Set the image
			imageView.image = image;
			
			//Completion block
			completion()
		})
	}
	
	
	/****************************************************/
	//MARK: - Show activity indicator
	
	func showActivityIndicatory(view: UIView) {
		
		self.removeActivityIndicator()
		self.spinner = UIActivityIndicatorView()
		self.spinner!.frame = view.bounds
		self.spinner!.hidesWhenStopped = true
		self.spinner!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		view.addSubview(self.spinner!)
		self.spinner!.startAnimating()
	}
	
	func removeActivityIndicator() {
		
		if let spinner = self.spinner {
			
			spinner.stopAnimating()
			spinner.removeFromSuperview()
		}
		//Reset
		self.spinner = nil
	}
	
	
	/****************************************************/
	//MARK: - Zoom functionality
	
	func zoom(imageView:UIImageView) -> Void {
		
		if imageView.image == nil {
			return  //No image loaded return
		}
		if imageAlreadyZoomed {
			return  //We already have a zoomed image
		} else {
			imageAlreadyZoomed = true
		}
		
		
		backgroundView = UIView()
		
		//Clip subviews for image view
		imageView.clipsToBounds = true;
		
		let orientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
		
		var screenBounds:CGRect = UIScreen.main.bounds// portrait bounds
		
		
		if (UIDevice.current.systemVersion as NSString).floatValue < 8 {           //If iOS<8 bounds always gives you the portrait width/height and we have to convert them
			
			if orientation.isLandscape {
				screenBounds = CGRect(x: 0, y: 0, width: screenBounds.size.height, height: screenBounds.size.width)
			}
		}
		
		
		let image:UIImage = imageView.image!
		var window:UIWindow = UIApplication.shared.keyWindow!
		
		window = UIApplication.shared.windows[0]
		
		backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenBounds.size.width, height: screenBounds.size.height))
		
		oldFrame = imageView.convert(imageView.bounds, to:window)
		
		
		backgroundView!.backgroundColor=UIColor.black
		backgroundView!.alpha=0;
		
		let imgV:UIImageView = UIImageView(frame:oldFrame)
		imgV.image=image;
		imgV.tag=1
		
		backgroundView!.addSubview(imgV)
		
		window.subviews[0].addSubview(backgroundView!)
		
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(LazyImage.zoomOutImageView(_:)))
		backgroundView!.addGestureRecognizer(tap)
		
		UIView.animate(withDuration: 0.3, animations: {
			imgV.frame=CGRect(x: 0,y: (screenBounds.size.height-image.size.height*screenBounds.size.width/image.size.width)/2, width: screenBounds.size.width, height: image.size.height*screenBounds.size.width/image.size.width)
			self.backgroundView!.alpha=1;
		},
					   completion: {(value: Bool) in
						UIApplication.shared.isStatusBarHidden = true
						
						//Track when device is rotated so we can remove the zoomed view
						NotificationCenter.default.addObserver(self, selector:#selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		})
	}
	
	
	
	@objc func zoomOutImageView(_ tap:UITapGestureRecognizer) -> Void {
		
		UIApplication.shared.isStatusBarHidden = false
		
		let imgV:UIImageView = tap.view?.viewWithTag(1) as! UIImageView
		
		UIView.animate(withDuration: 0.3, animations: {
			imgV.frame = self.oldFrame
			self.backgroundView!.alpha=0
		},
					   completion: {(value: Bool) in
						self.backgroundView!.removeFromSuperview()
						self.backgroundView = nil
						self.imageAlreadyZoomed = false  //No more zoomed view
		})
	}
	
	
	
	@objc func rotated()
	{
		self.removeZoomedImageView()
		
		if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
		{
			//println("landscape")
		}
		
		if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
		{
			//println("Portrait")
		}
		
	}
	
	
	func removeZoomedImageView() -> Void {
		
		UIApplication.shared.isStatusBarHidden = false
		
		if let bgView = self.backgroundView {
			
			UIView.animate(withDuration: 0.3, animations: {
				bgView.alpha=0
			},
						   completion: {(value: Bool) in
							bgView.removeFromSuperview()
							self.backgroundView = nil
							self.imageAlreadyZoomed = false
			})
		}
	}
	
	
	/****************************************************/
	//MARK: - Resize image
	
	
	func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
		
		let horizontalRatio:CGFloat = targetSize.width / image.size.width
		let verticalRatio:CGFloat = targetSize.height / image.size.height
		
		let ratio = max(horizontalRatio, verticalRatio)
		let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
		UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
		image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
	
	
	/****************************************************/
	//MARK: - Blur
	
	func blur(imageView:UIImageView, style:UIBlurEffectStyle) -> UIVisualEffectView? {
		
		if imageView.image == nil {
			return nil  //No image loaded return
		}
		
		//Clip subviews for image view
		imageView.clipsToBounds = true;
		
		let blurEffect = UIBlurEffect(style:style)              //UIBlurEffectStyle.Dark etc..
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.frame = imageView.bounds
		blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		imageView.addSubview(blurView)
		return blurView
	}
	
}

