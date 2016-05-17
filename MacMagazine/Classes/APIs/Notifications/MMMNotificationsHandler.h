@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Handles push notifications.
 */
@interface MMMNotificationsHandler : NSObject

/**
 *  Navigation controller presenting notification content.
 */
@property (nonatomic, strong, readonly) __kindof UINavigationController *navigationController;

/**
 *  Initialization for notifications handler.
 *
 *  @param navigationController Navigation controller that will be used to present notification content.
 *
 *  @return Notifications handler object.
 */
- (instancetype)initWithNavigationController:(__kindof UINavigationController *)navigationController;
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Tells the handler that a remote notification arrived. This will fetch content & may display content to user using `navigationController`.
 *
 *  @param userInfo          A dictionary that contains information related to the remote notification.
 *  @param completionHandler The block to execute when the download operation is complete.
 */
- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler;

@end

NS_ASSUME_NONNULL_END
