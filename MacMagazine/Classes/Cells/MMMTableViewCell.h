//
//  MMMTableViewCell.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/2/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MMMTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) IBOutlet UIView *separatorView;
@property (nonatomic) CGFloat layoutWidth;

+ (NSString *)identifier;
+ (nullable UINib *)nib;

@end

NS_ASSUME_NONNULL_END
