@import UIKit;

@interface UIViewController (ShareActivity)

- (void)mmm_shareActivityItems:(nullable NSArray *)activityItems
                completion:(nullable UIActivityViewControllerCompletionWithItemsHandler)completion;

- (void)mmm_shareActivityItems:(nullable NSArray *)activityItems
             fromBarButtonItem:(nullable UIBarButtonItem *)actionItem
                    completion:(nullable UIActivityViewControllerCompletionWithItemsHandler)completion;

@end