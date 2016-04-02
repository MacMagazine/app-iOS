//
//  MMMTableViewHeaderView.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import UIKit;
#import "MMMLabel.h"

@interface MMMTableViewHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) MMMLabel *titleLabel;

+ (NSString *)identifier;
+ (CGFloat)height;

@end
