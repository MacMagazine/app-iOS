//
//  MMMPostTableViewCell.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SUNKit/SUNTableViewCell.h>

#import "MMMLabel.h"

@interface MMMPostTableViewCell : SUNTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet MMMLabel *headlineLabel;
@property (nonatomic, weak) IBOutlet MMMLabel *subheadlineLabel;
@property (nonatomic, weak) IBOutlet UIView *separatorView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingSpaceConstraint;

@property (nonatomic) CGFloat thumbnailTrailingConstant;
@property (nonatomic) CGFloat thumbnailWidthConstant;
@property (nonatomic) CGFloat headlineBottomSpaceConstant;
@property (nonatomic) CGFloat layoutWidth;
@property (nonatomic) BOOL imageVisible;

@end
