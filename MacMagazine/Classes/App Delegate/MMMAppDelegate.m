#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Keys/MacmagazineKeys.h>
#import <Tweaks/FBTweakShakeWindow.h>

#import "MMMAppDelegate.h"
#import "MMMNotificationsAPI.h"
#import "SUNCoreDataStore.h"

@interface MMMAppDelegate ()

@property (nonatomic, strong) MMMNotificationsAPI *notificationsAPI;

@end

#pragma mark MMMAppDelegate

@implementation MMMAppDelegate

#pragma mark - Getter/Setters

- (UIWindow *)window {
    if (!_window) {
#ifdef DEBUG
        _window = [[FBTweakShakeWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#else
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#endif
    }

    return _window;
}

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MacMagazine" withExtension:@"momd"];
    [SUNCoreDataStore setupDefaultStoreWithModelURL:modelURL persistentStoreURL:nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

#ifndef DEBUG
    MacmagazineKeys *keys = [[MacmagazineKeys alloc] init];
    self.notificationsAPI = [[MMMNotificationsAPI alloc] initWithAPIKey:keys.mMMNotificationsAPIKey];
#endif

    self.window.tintColor = [UIColor colorWithRed:0.25 green:0.66 blue:0.96 alpha:1];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self.notificationsAPI registerToken:deviceToken notificationPeferences:MMMNotificationsPreferencesAllPosts];
}

@end
