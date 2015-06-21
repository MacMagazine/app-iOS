//
//  PostTableViewCell.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "PostTableViewCell.h"

@interface PostTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailTrailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headlineBottomSpaceConstraint;

@end

#pragma mark PostTableViewCell

@implementation PostTableViewCell

#pragma mark - Getters/Setters

- (void)setThumbnailTrailingConstant:(CGFloat)thumbnailTrailingConstant {
    _thumbnailWidthConstant = thumbnailTrailingConstant;
    self.thumbnailTrailingSpaceConstraint.constant = thumbnailTrailingConstant;
}

- (void)setThumbnailWidthConstant:(CGFloat)thumbnailWidthConstant {
    _thumbnailWidthConstant = thumbnailWidthConstant;
    self.thumbnailWidthConstraint.constant = thumbnailWidthConstant;
}

- (void)setHeadlineBottomSpaceConstant:(CGFloat)headlineBottomSpaceConstant {
    _headlineBottomSpaceConstant = headlineBottomSpaceConstant;
    self.headlineBottomSpaceConstraint.constant = headlineBottomSpaceConstant;
}

#pragma mark - Instance Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _thumbnailTrailingConstant = self.thumbnailTrailingSpaceConstraint.constant;
    _thumbnailWidthConstant = self.thumbnailWidthConstraint.constant;
    _headlineBottomSpaceConstant = self.headlineBottomSpaceConstraint.constant;
    
    self.thumbnailImageView.image = nil;
    self.headlineLabel.text = @"";
    self.subheadlineLabel.text = @"";
}

- (void)layoutIfNeeded {
    CGFloat textWidth = self.layoutWidth;
    textWidth -= self.thumbnailWidthConstant;
    textWidth -= self.thumbnailTrailingConstant;
    textWidth -= self.trailingSpaceConstraint.constant;
    textWidth -= self.leadingSpaceConstraint.constant;
    textWidth -= self.layoutMargins.left;
    textWidth -= self.layoutMargins.right;
    
    self.headlineLabel.preferredMaxLayoutWidth = textWidth;
    self.subheadlineLabel.preferredMaxLayoutWidth = self.headlineLabel.preferredMaxLayoutWidth;
    
    [super layoutIfNeeded];
}

@end
