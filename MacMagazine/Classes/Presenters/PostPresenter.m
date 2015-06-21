//
//  PostPresenter.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+HTMLSafe.h"
#import "Post.h"
#import "PostPresenter.h"
#import "PostTableViewCell.h"
#import "UIImageView+SDWebImageResizeManager.h"

@interface PostPresenter ()

- (Post *)post;

@end

#pragma mark PostPresenter

@implementation PostPresenter

#pragma mark - Instance Methods

- (Post *)post {
    return self.object;
}

- (void)setupTableViewCell:(PostTableViewCell *)cell {
    cell.imageVisible = self.post.thumbnail.length > 0;
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
    [cell.thumbnailImageView sd_setImageWithURL:[self thumbnailURLForImageView:cell.thumbnailImageView]];
}

- (SEL)selectorForViewOfClass:(Class)viewClass {
    if ([viewClass isSubclassOfClass:[PostTableViewCell class]]) {
        return @selector(setupTableViewCell:);
    }
    
    return [super selectorForViewOfClass:viewClass];
}

#pragma mark - Attributes

- (NSString *)descriptionText {
    return self.post.descriptionText.htmlSafe;
}

- (NSURL *)thumbnailURLForImageView:(UIImageView *)imageView {
    NSString *thumbnail = self.post.thumbnail;
    if (!thumbnail) {
        return nil;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(CGRectGetWidth(imageView.frame) * scale, CGRectGetHeight(imageView.frame) * scale);
    
    if (![thumbnail containsString:@"wp.com"] || CGSizeEqualToSize(size, CGSizeZero)) {
        return [NSURL URLWithString:thumbnail];
    }
    
    thumbnail = [thumbnail stringByAppendingFormat:@"?fit=%.f,%.f", size.width, size.height];
    return [NSURL URLWithString:thumbnail];
}

@end
