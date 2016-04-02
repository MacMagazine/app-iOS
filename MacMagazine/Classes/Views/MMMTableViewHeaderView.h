//
//  MMMTableViewHeaderView.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import UIKit;

#import "MMMLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) MMMLabel *titleLabel;

+ (NSString *)identifier;
+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
