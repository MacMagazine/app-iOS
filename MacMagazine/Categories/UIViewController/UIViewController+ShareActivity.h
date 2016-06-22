#import <UIKit/UIKit.h>

@interface UIViewController (ShareActivity)

- (void)shareActivityItems:(NSArray *)activityItems
                completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;

- (void)shareActivityItems:(NSArray *)activityItems
         fromBarButtonItem:(UIBarButtonItem *)actionItem
                completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;

@end