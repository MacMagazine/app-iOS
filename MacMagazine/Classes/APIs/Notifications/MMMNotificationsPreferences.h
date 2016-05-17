@import Foundation;

typedef NS_ENUM(NSUInteger, MMMNotificationsPreferences) {
    MMMNotificationsPreferencesFeaturedPosts = 0,
    MMMNotificationsPreferencesAllPosts = 1
};

FOUNDATION_EXPORT NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences);
