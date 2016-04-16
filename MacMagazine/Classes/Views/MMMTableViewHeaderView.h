@import UIKit;

#import "MMMLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) MMMLabel *titleLabel;

+ (NSString *)identifier;
+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
