@import UIKit;

@class MMMPost;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostDetailViewController : UIViewController

@property (nonatomic, strong, nullable) MMMPost *post;
@property (nonatomic) NSInteger currentTableViewIndexPathRow;
// In case the detail view controller is loaded from a link click
@property (nonatomic, strong, nullable) NSURL *postURL;

@end

NS_ASSUME_NONNULL_END
