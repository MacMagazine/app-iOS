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

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet MMMLabel *headlineLabel;
@property (weak, nonatomic) IBOutlet MMMLabel *subheadlineLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpaceConstraint;

@property (assign, nonatomic) CGFloat thumbnailTrailingConstant;
@property (assign, nonatomic) CGFloat thumbnailWidthConstant;
@property (assign, nonatomic) CGFloat headlineBottomSpaceConstant;
@property (assign, nonatomic) CGFloat layoutWidth;
@property (assign, nonatomic) BOOL imageVisible;

@end
