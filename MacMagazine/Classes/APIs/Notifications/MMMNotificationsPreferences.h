@import Foundation;

typedef NS_ENUM(NSUInteger, MMMNotificationsPreferences) {
    MMMNotificationsPreferencesFeaturedPosts = 0,
    MMMNotificationsPreferencesAllPosts = 1,
    MMMNotificationsPreferencesUser = 2, // Uses the user defined value from the Settings bundle
};

FOUNDATION_EXPORT NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences);
