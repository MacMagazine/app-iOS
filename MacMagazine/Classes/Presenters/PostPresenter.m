//
//  PostPresenter.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

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
    cell.thumbnailWidthConstant = 0;
    cell.thumbnailTrailingConstant = 0;
    cell.headlineLabel.text = self.post.title;
    cell.subheadlineLabel.text = self.descriptionText;
}

- (SEL)selectorForViewOfClass:(Class)viewClass {
    if ([viewClass isSubclassOfClass:[PostTableViewCell class]]) {
        return @selector(setupTableViewCell:);
    }
    
    return [super selectorForViewOfClass:viewClass];
}

#pragma mark - Attributes

- (NSString *)descriptionText {
    NSString *text = [self.post.descriptionText copy];
    NSRange range;
    while (text.length > 0) {
        range = [text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            break;
        }
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    return text;
}

@end
