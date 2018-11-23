#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Crashlytics/Crashlytics.h>
#import <Keys/MacmagazineKeys.h>
#import <OneSignal/OneSignal.h>
#import <Tweaks/FBTweakShakeWindow.h>

#import "MMMAppDelegate.h"
#import "MMMCacheManager.h"
#import "MMMNotificationsAPI.h"
#import "MMMNotificationsHandler.h"
#import "MMMPostsTableViewController.h"
#import "SUNCoreDataStore.h"

@interface MMMAppDelegate ()

@property (nonatomic, strong) MMMNotificationsAPI *notificationsAPI;
@property (nonatomic, strong) MMMNotificationsHandler *notificationsHandler;

@property BOOL returnedFromBackground;

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
    MacMagazineKeys *keys = [[MacMagazineKeys alloc] init];
    [Crashlytics startWithAPIKey:keys.mMMCrashlyticsAPIKey];

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MacMagazine" withExtension:@"momd"];
    [SUNCoreDataStore setupDefaultStoreWithModelURL:modelURL persistentStoreURL:nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

	[OneSignal initWithLaunchOptions:launchOptions
							   appId:@"322eb3b6-acd2-415e-bdb0-b2f0f05d7f34"
			handleNotificationAction:nil
							settings:@{kOSSettingsKeyAutoPrompt: @false}];
	OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
	
	// Recommend moving the below line to prompt for push after informing the user about
	//   how your app will use them.
	[OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
		NSLog(@"User accepted notifications: %d", accepted);
	}];

#ifndef DEBUG
//    self.notificationsAPI = [[MMMNotificationsAPI alloc] initWithAPIKey:keys.mMMNotificationsAPIKey];
#endif

    NSInteger appNumberOfCalls = [[NSUserDefaults standardUserDefaults] integerForKey:@"appNumberOfCalls"];
    [[NSUserDefaults standardUserDefaults] setInteger:appNumberOfCalls+1 forKey:@"appNumberOfCalls"];
    
    self.window.tintColor = [UIColor colorWithRed:0.25 green:0.66 blue:0.96 alpha:1];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.00 green:0.55 blue:0.80 alpha:1.0]];
	
    self.notificationsHandler = [[MMMNotificationsHandler alloc] initWithNavigationController:(UINavigationController *)self.window.rootViewController];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
	
    [MMMCacheManager clearCacheIfNeeded];

	if (self.returnedFromBackground) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
			[self.window.rootViewController.childViewControllers[0].childViewControllers[0] selectFirstTableViewCell];
		});

	}
	self.returnedFromBackground = false;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	self.returnedFromBackground = true;
}

#pragma mark - Notifications

/*
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self.notificationsAPI registerToken:deviceToken notificationPeferences:MMMNotificationsPreferencesUser];
}
*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self.notificationsHandler applicationDidReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

#pragma mark - ShortCut

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if([shortcutItem.type isEqualToString:@"open.last.post"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shortCutAction" object:self];
    }
}

#pragma mark - Handle Orientation

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {

	id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
	
    // change orientation when app is playing videos
	if ((window && [className isEqualToString:@"AVFullScreenViewController"]) || ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
		return UIInterfaceOrientationMaskAll;
	}
	return UIInterfaceOrientationMaskPortrait;
}

@end
