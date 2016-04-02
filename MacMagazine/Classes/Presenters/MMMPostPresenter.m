//
//  MMMPostPresenter.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MMMFeaturedPostTableViewCell.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTMLSafe.h"
#import "MMMPost.h"
#import "MMMPostPresenter.h"
#import "MMMPostTableViewCell.h"

@interface MMMPostPresenter ()

- (MMMPost *)post;

@end

#pragma mark PostPresenter

@implementation MMMPostPresenter

#pragma mark - Instance Methods

- (MMMPost *)post {
    return self.object;
}

- (void)setupFeaturedTableViewCell:(MMMFeaturedPostTableViewCell *)cell {
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
    cell.thumbnailImageView.alpha = 0;
    
    NSURL *imageURL = [self thumbnailURLForImageView:cell.thumbnailImageView];
    [cell.thumbnailImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:cacheType != SDImageCacheTypeMemory ? 0.25 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.thumbnailImageView.alpha = 1;
        } completion:nil];
    }];
}

- (void)setupTableViewCell:(MMMPostTableViewCell *)cell {
    cell.imageVisible = self.post.thumbnail.length > 0;
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
    cell.thumbnailImageView.alpha = 0;
    
    NSURL *imageURL = [self thumbnailURLForImageView:cell.thumbnailImageView];
    [cell.thumbnailImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:cacheType != SDImageCacheTypeMemory ? 0.25 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.thumbnailImageView.alpha = 1;
        } completion:nil];
    }];
}

- (SEL)selectorForViewOfClass:(Class)viewClass {
    if ([viewClass isSubclassOfClass:[MMMPostTableViewCell class]]) {
        return @selector(setupTableViewCell:);
    } else if ([viewClass isSubclassOfClass:[MMMFeaturedPostTableViewCell class]]) {
        return @selector(setupFeaturedTableViewCell:);
    }
    
    return [super selectorForViewOfClass:viewClass];
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
