//
//  FeaturedPostTableViewCell.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SUNKit/SUNTableViewCell.h>
#import "MMLabel.h"

@interface FeaturedPostTableViewCell : SUNTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet MMLabel *headlineLabel;
@property (weak, nonatomic) IBOutlet MMLabel *subheadlineLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpaceConstraint;

@property (assign, nonatomic) CGFloat headlineTopSpaceConstant;
@property (assign, nonatomic) CGFloat headlineBottomSpaceConstant;
@property (assign, nonatomic) CGFloat layoutWidth;

@end
