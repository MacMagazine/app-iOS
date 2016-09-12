#import <ARChromeActivity/ARChromeActivity.h>
#import <TUSafariActivity/TUSafariActivity.h>

#import "UIViewController+ShareActivity.h"

@implementation UIViewController (ShareActivity)

- (void)mmm_shareActivityItems:(nullable NSArray *)activityItems
                    completion:(nullable UIActivityViewControllerCompletionWithItemsHandler)completion {
    [self mmm_shareActivityItems:activityItems fromBarButtonItem:nil completion:completion];
}

- (void)mmm_shareActivityItems:(nullable NSArray *)activityItems
             fromBarButtonItem:(nullable UIBarButtonItem *)actionItem
                    completion:(nullable UIActivityViewControllerCompletionWithItemsHandler)completion {
    if (!activityItems || activityItems.count == 0) return;

    NSMutableArray<__kindof UIActivity *> *browserActivities = [[NSMutableArray alloc] init];
    [browserActivities addObject:[[TUSafariActivity alloc] init]];

    NSURL *chromeURLScheme = [NSURL URLWithString:@"googlechrome-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:chromeURLScheme]) {
        ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
        chromeActivity.activityTitle = NSLocalizedString(@"Post.Sharing.OpenInChrome", @"");
        [browserActivities addObject:chromeActivity];
    }

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:browserActivities];
    if (actionItem) {
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        activityViewController.popoverPresentationController.barButtonItem = actionItem;
    }

    [activityViewController setCompletionWithItemsHandler:completion];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
