//
//  SDWebImageManager+Resize.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SDWebImageManager+Resize.h"
#import "UIImage+Resize.h"

@interface SDWebImageResizeOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *resizedImageCacheOperation;
@property (strong, nonatomic) NSOperation *fullImageCacheOperation;
@property (strong, nonatomic) NSOperation *downloadOperation;

@end

#pragma mark SDWebImageManager (Resize)

@implementation SDWebImageManager (Resize)

#pragma mark - Instance Methods

- (NSString *)cacheKeyForURL:(NSURL *)url withSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    NSString *key = [self cacheKeyForURL:url];
    NSString *resizedImageKey = [key stringByAppendingFormat:@"_%@_%.fx%.f", @(contentMode).stringValue, size.width, size.height];
    return resizedImageKey;
}

- (id<SDWebImageOperation>)downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionWithFinishedBlock)completedBlock {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return [self downloadImageWithURL:url options:options progress:progressBlock completed:completedBlock];
    }
    
    if (contentMode != UIViewContentModeScaleAspectFill && contentMode != UIViewContentModeScaleAspectFit) {
        [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode"];
    }
    
    NSString *key = [self cacheKeyForURL:url];
    NSString *resizedImageKey = [self cacheKeyForURL:url withSize:size contentMode:contentMode];
    
    __block SDWebImageResizeOperation *operation = [SDWebImageResizeOperation new];
    
    operation.resizedImageCacheOperation = [self.imageCache queryDiskCacheForKey:resizedImageKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if (operation.isCancelled) {
            return;
        }
        
        if (image) {
            if (completedBlock) completedBlock(image, nil, cacheType, YES, url);
            return;
        }
        
        operation.fullImageCacheOperation = [self.imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
            if (operation.isCancelled) {
                return;
            }
            
            UIImage *(^processImage)(UIImage *image) = ^UIImage *(UIImage *image) {
                if (image.size.width < size.width || image.size.height < size.height) {
                    return image;
                }
                
                UIImage *scaledImage = [image resizedImageWithContentMode:contentMode bounds:size interpolationQuality:kCGInterpolationDefault];
                BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                [self.imageCache storeImage:scaledImage forKey:resizedImageKey toDisk:cacheOnDisk];
                [self.imageCache removeImageForKey:key fromDisk:NO];
                return scaledImage;
            };

            if (image) {
                UIImage *scaledImage = processImage(image);
                if (completedBlock) completedBlock(scaledImage, nil, cacheType, YES, url);
                return;
            }
            
            operation.downloadOperation = [self downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    UIImage *scaledImage = processImage(image);
                    [self.imageCache removeImageForKey:key fromDisk:NO];
                    if (completedBlock) completedBlock(scaledImage, nil, cacheType, YES, url);
                } else {
                    if (completedBlock) completedBlock(nil, error, cacheType, finished, url);
                }
            }];
        }];
    }];
    
    return operation;
}

@end

@implementation SDWebImageResizeOperation

- (void)setCancelBlock:(SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    
    if (self.resizedImageCacheOperation) {
        [self.resizedImageCacheOperation cancel];
        self.resizedImageCacheOperation = nil;
    }
    
    if (self.fullImageCacheOperation) {
        [self.fullImageCacheOperation cancel];
        self.fullImageCacheOperation = nil;
    }
    
    if (self.downloadOperation) {
        [self.downloadOperation cancel];
        self.downloadOperation = nil;
    }
    
    if (self.cancelBlock) {
        self.cancelBlock();
        _cancelBlock = nil;
    }
}

@end
