#import "MMMNotificationsHandler.h"
#import "MMMPost.h"
#import "MMMPostDetailViewController.h"

#pragma mark MMMNotificationsHandler

@implementation MMMNotificationsHandler

#pragma mark - Instance Methods

- (instancetype)initWithNavigationController:(__kindof UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *postGuid = userInfo[@"custom"][@"a"][@"guid"];
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;

    // Inactive state = "The app is transitioning to or from the background"
    if (applicationState == UIApplicationStateInactive && postGuid.length > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"pushReceived" object:postGuid];
    }

    [MMMPost getWithPage:1 success:^(NSArray *response) {
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    } failure:^(NSError *error) {
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
}

@end
