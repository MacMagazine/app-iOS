@import CoreData;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class MMMPost;

@interface MMMPostsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak, nullable) UIView *footerView;
@property (nonatomic, weak, nullable) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) NSUInteger nextPage;
@property (nonatomic) NSUInteger numberOfResponseObjectsPerRequest;
@property (nonatomic, strong) id previewingContext;

@property (nonatomic, strong, nullable) NSString *postID;

- (BOOL)canFetchMoreData;
- (void)fetchMoreData;
- (void)handleError:(NSError *)error;
- (void)reloadData;

typedef void (^MMCallbackBlock)(NSDictionary *);
@property (nonatomic, copy) MMCallbackBlock callbackBlock;
- (void)previousPost:(MMCallbackBlock)block;
- (void)nextPost:(MMCallbackBlock)block;

@end

NS_ASSUME_NONNULL_END
