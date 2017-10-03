@import UIKit;

@class MMMPost;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostDetailViewController : UIViewController

@property (nonatomic, strong, nullable) MMMPost *post;
@property (nonatomic) NSIndexPath *currentTableViewIndexPath;
@property (nonatomic) BOOL isURLOpendedInternally;

// In case the detail view controller is loaded from a link click
@property (nonatomic, strong, nullable) NSURL *postURL;

@end

NS_ASSUME_NONNULL_END
