//
//  SDWebImageManager+Resize.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SDWebImageManager.h"

@interface SDWebImageManager (Resize)

- (id<SDWebImageOperation>)downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options size:(CGSize)size contentMode:(UIViewContentMode)contentMode progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;
- (NSString *)cacheKeyForURL:(NSURL *)url withSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

@end
