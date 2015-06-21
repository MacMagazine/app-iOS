//
//  UIImageView+SDWebImageResizeManager.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import UIKit;
#import "SDWebImageManager+Resize.h"

@interface UIImageView (SDWebImageResizeManager)

/**
 * Get the current image size using screen scale.
 */
- (CGSize)desiredImageSize;

/**
 * Get the current image URL.
 *
 * Note that because of the limitations of categories this property can get out of sync
 * if you use sdr_setImage: directly.
 */
- (NSURL *)sdr_imageURL;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 */
- (void)sdr_setImageWithURL:(NSURL *)url size:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)sdr_setImageWithURL:(NSURL *)url size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param size           The size that the image should be cropped.
 * @param cotentMode     The content mode to be used when cropping image. Supports only `UIViewContentModeScaleAspectFit` and `UIViewContentModeScaleAspectFill`.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)sdr_cancelCurrentImageLoad;

@end
