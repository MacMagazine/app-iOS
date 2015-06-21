//
//  UIImageView+SDWebImageResizeManager.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+SDWebImageResizeManager.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

#pragma mark UIImageView (SDWebImageResizeManager)

@implementation UIImageView (SDWebImageResizeManager)

#pragma mark - Instance Methods

- (CGSize)desiredImageSize {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    return CGSizeMake(CGRectGetWidth(self.bounds) * screenScale, CGRectGetHeight(self.bounds) * screenScale);
}

- (void)sdr_setImageWithURL:(NSURL *)url size:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    [self sdr_setImageWithURL:url placeholderImage:nil options:0 size:self.desiredImageSize contentMode:self.contentMode progress:nil completed:nil];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:0 size:size contentMode:contentMode progress:nil completed:nil];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:0 size:self.desiredImageSize contentMode:self.contentMode progress:nil completed:nil];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:options size:size contentMode:contentMode progress:nil completed:nil];
}

- (void)sdr_setImageWithURL:(NSURL *)url size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock {
    [self sdr_setImageWithURL:url placeholderImage:nil options:0 size:size contentMode:contentMode progress:nil completed:completedBlock];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:0 size:size contentMode:contentMode progress:nil completed:completedBlock];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode completed:(SDWebImageCompletionBlock)completedBlock {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:options size:size contentMode:contentMode progress:nil completed:completedBlock];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sdr_setImageWithURL:url placeholderImage:placeholder options:0 size:self.desiredImageSize contentMode:self.contentMode progress:nil completed:completedBlock];
}

- (void)sdr_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self sdr_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options size:size contentMode:contentMode progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (NSURL *)sdr_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sdr_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

@end
