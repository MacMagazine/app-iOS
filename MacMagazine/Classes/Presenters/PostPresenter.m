//
//  PostPresenter.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+HTMLSafe.h"
#import "Post.h"
#import "PostPresenter.h"
#import "PostTableViewCell.h"

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
    cell.thumbnailImageView.image = nil;
    
    NSURL *imageURL = [self thumbnailURLForImageView:cell.thumbnailImageView];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [cell.thumbnailImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.thumbnailImageView.alpha = 0;
        cell.thumbnailImageView.image = image;
        [UIView animateWithDuration:request ? 0.25 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.thumbnailImageView.alpha = 1;
        } completion:nil];
    } failure:nil];
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
    
    thumbnail = [thumbnail stringByAppendingFormat:@"?w=%.f", size.width * scale];
    return [NSURL URLWithString:thumbnail];
}

@end
