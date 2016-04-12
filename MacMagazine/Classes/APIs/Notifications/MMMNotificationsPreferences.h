//
//  MMMNotificationsPreferences.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/9/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, MMMNotificationsPreferences) {
    MMMNotificationsPreferencesFeaturedPosts = 0,
    MMMNotificationsPreferencesAllPosts = 1
};

FOUNDATION_EXPORT NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences);
