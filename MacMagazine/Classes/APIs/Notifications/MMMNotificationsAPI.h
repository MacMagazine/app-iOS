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

/**
 *  Convert APNS token from NSData to NSString.
 *  Using `description` from NSData might not be safe.
 *  Following instructions here: http://stackoverflow.com/questions/9372815/how-can-i-convert-my-device-token-nsdata-into-an-nsstring/9372848#9372848
 *
 *  @param data Token provided by application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *
 *  @return NSString representation.
 */
FOUNDATION_EXPORT NSString * MMMNotificationsNormalizedAPNSTokenWithData(NSData *data);

/**
 *  Notifications service, designed to register APNS token, reset device badge and update notification preferences.
 */
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
 *  Register device in server to receive notifications. Server-side device badge is set to `0` when registering.
 *
 *  @param tokenData Token provided by application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *  @param notificationPeferences Notification preferences for device being registered.
 */
- (void)registerToken:(NSData *)tokenData notificationPeferences:(MMMNotificationsPreferences)notificationPeferences;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
