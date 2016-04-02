//
//  MMMPostPresenter.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "MMMPostPresenter.h"
#import "GTMNSString+HTML.h"
#import "MMMFeaturedPostTableViewCell.h"
#import "MMMPost.h"
#import "MMMPostTableViewCell.h"
#import "NSString+HTMLSafe.h"

#pragma mark MMMPostPresenter

@implementation MMMPostPresenter

#pragma mark - Gettes/Setters

- (MMMPost *)post {
    return self.object;
}

#pragma mark - Instance Methods

- (void)downloadImageForImageView:(UIImageView *)imageView {
    NSURL *URL = [self thumbnailURLForImageView:imageView];
    [imageView sd_setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSTimeInterval duration = (cacheType != SDImageCacheTypeMemory) ? 0.25 : 0;
        UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            imageView.alpha = 1;
        } completion:nil];
    }];
}

- (void)setupMMMFeaturedPostTableViewCell:(MMMFeaturedPostTableViewCell *)cell {
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
    cell.thumbnailImageView.alpha = 0;
    [self downloadImageForImageView:cell.thumbnailImageView];
}

- (void)setupMMMPostTableViewCell:(MMMPostTableViewCell *)cell {
    cell.imageVisible = (self.post.thumbnail.length > 0);
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
    cell.thumbnailImageView.alpha = 0;
    [self downloadImageForImageView:cell.thumbnailImageView];
}

#pragma mark - Attributes

- (NSString *)descriptionText {
    return [self.post.descriptionText.mmm_htmlSafe gtm_stringByUnescapingFromHTML];
}

- (NSURL *)thumbnailURLForImageView:(UIImageView *)imageView {
    NSString *thumbnail = self.post.thumbnail;
    if (!thumbnail) {
        return nil;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = CGRectGetWidth(imageView.frame) * scale;
    
    if (![thumbnail containsString:@"wp.com"] || width == 0) {
        return [NSURL URLWithString:thumbnail];
    }
    
    thumbnail = [thumbnail stringByAppendingFormat:@"?w=%.f", width * scale];
    return [NSURL URLWithString:thumbnail];
}

@end
