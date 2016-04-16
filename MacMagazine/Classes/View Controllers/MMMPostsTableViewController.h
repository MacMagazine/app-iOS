@import CoreData;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak, nullable) UIView *footerView;
@property (nonatomic, weak, nullable) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) NSUInteger nextPage;
@property (nonatomic) NSUInteger numberOfResponseObjectsPerRequest;

- (BOOL)canFetchMoreData;
- (void)fetchMoreData;
- (void)handleError:(NSError *)error;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
