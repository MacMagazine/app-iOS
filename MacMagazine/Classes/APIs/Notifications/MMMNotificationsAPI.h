//
//  MMMNotificationsAPI.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/9/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

@import Foundation;

#import "MMMNotificationsPreferences.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMNotificationsAPI : NSObject

/**
 *  API key for authenticating request.
 */
@property (nonatomic, copy, readonly) NSString *apiKey;

/**
 *  Initialize notifications API with API key.
 *
 *  @param apiKey API key for authenticating request.
 *
 *  @return Notifications API object.
 */
- (instancetype)initWithAPIKey:(NSString *)apiKey NS_DESIGNATED_INITIALIZER;

/**
 *  Register device in server to receive notifications.
 *
 *  @param tokenData Token provided by application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *  @param notificationPeferences Notification preferences for device being registered.
 */
- (void)registerToken:(NSData *)tokenData notificationPeferences:(MMMNotificationsPreferences)notificationPeferences;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
