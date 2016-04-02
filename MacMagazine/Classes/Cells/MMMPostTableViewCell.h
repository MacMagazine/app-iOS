//
//  MMMPostTableViewCell.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMMLabel.h"
#import "MMMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostTableViewCell : MMMTableViewCell

@property (nonatomic, weak, nullable) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak, nullable) IBOutlet MMMLabel *headlineLabel;
@property (nonatomic, weak, nullable) IBOutlet MMMLabel *subheadlineLabel;
@property (nonatomic, weak, nullable) IBOutlet UIView *separatorView;

@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *trailingSpaceConstraint;
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *leadingSpaceConstraint;

@property (nonatomic) CGFloat thumbnailTrailingConstant;
@property (nonatomic) CGFloat thumbnailWidthConstant;
@property (nonatomic) CGFloat headlineBottomSpaceConstant;
@property (nonatomic) CGFloat layoutWidth;
@property (nonatomic, getter=isVisible) BOOL imageVisible;

@end

NS_ASSUME_NONNULL_END
