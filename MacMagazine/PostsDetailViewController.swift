import UIKit
import WebKit

// MARK: - PostsDetailViewController -

class PostsDetailViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties -
    
	@IBOutlet weak var detailDescriptionLabel: UILabel!
    var webView: WKWebView!
    var postUrl: String = ""
    var titleView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var detailItem: Posts?

    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
		super.viewDidLoad()
        self.setUpWebView()
        self.setupNavigationBar()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

    // MARK: - Class Methods -
    
    private func setUpWebView() {
        let requestUrl = NSURL(string: self.postUrl)
        let request = NSURLRequest(url: requestUrl! as URL)
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.webView.navigationDelegate = self
        self.webView.load(request as URLRequest)
        self.view.addSubview(self.webView)
        self.view.sendSubview(toBack: self.webView)
    }
    
    private func setupNavigationBar() {
        self.titleView = UIView()
        self.activityIndicator.color = UIColor(hex: "008aca", alpha: 1)
        
        if self.webView.isLoading {
            self.activityIndicator.startAnimating()
            self.navigationItem.titleView = self.activityIndicator
        } else {
            self.activityIndicator.stopAnimating()

            if UIDevice.current.userInterfaceIdiom == .phone {
                let logoImage: UIImage = UIImage(named: "logo")!
                let logoImageView = UIImageView(image: logoImage)
                logoImageView.frame = CGRect(x: -16.9, y: -16.3, width: 33, height: 33)
                logoImageView.contentMode = .scaleAspectFit
                self.titleView.addSubview(logoImageView)
                self.navigationItem.titleView = self.titleView
            }
        }
    }
    
    // MARK: - WKNavigation Delegate -
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Starting to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.setupNavigationBar()
    }
}
