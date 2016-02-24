//
//  MMTableViewHeaderView.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "MMTableViewHeaderView.h"

#pragma mark MMTableViewHeaderView

@implementation MMTableViewHeaderView

#pragma mark - Class Methods

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (CGFloat)height {
    CGFloat height = [@"TODAY" boundingRectWithSize:CGSizeMake(300, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont mm_fontForTextStyle:UIFontTextStyleCaption1]} context:nil].size.height;
    return height + 10;
}

#pragma mark - Instance Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    _titleLabel = [MMLabel new];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textStyle = UIFontTextStyleCaption1;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.topSeparatorView.frame = CGRectMake(0, -0.5, self.contentView.frame.size.width, 0.5);
    self.bottomSeparatorView.frame = CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, 0.5);
}

@end
