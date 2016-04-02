//
//  MMMFeaturedPostTableViewCell.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMMFeaturedPostTableViewCell.h"

@interface MMMFeaturedPostTableViewCell ()

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *headlineTopSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *headlineBottomSpaceConstraint;

@end

#pragma mark MMMFeaturedPostTableViewCell

@implementation MMMFeaturedPostTableViewCell

#pragma mark - Instance Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headlineTopSpaceConstant = self.headlineTopSpaceConstraint.constant;
    _headlineBottomSpaceConstant = self.headlineBottomSpaceConstraint.constant;
    
    self.thumbnailImageView.image = nil;
    self.headlineLabel.text = @"";
    self.subheadlineLabel.text = @"";
}

- (void)layoutIfNeeded {
    CGFloat textWidth = self.layoutWidth;
    textWidth -= self.trailingSpaceConstraint.constant;
    textWidth -= self.leadingSpaceConstraint.constant;
    textWidth -= self.layoutMargins.left;
    textWidth -= self.layoutMargins.right;
    
    self.headlineLabel.preferredMaxLayoutWidth = textWidth;
    self.subheadlineLabel.preferredMaxLayoutWidth = self.headlineLabel.preferredMaxLayoutWidth;
    
    [super layoutIfNeeded];
}

@end
