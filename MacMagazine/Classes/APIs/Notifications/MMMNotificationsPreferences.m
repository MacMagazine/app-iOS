#import "MMMNotificationsPreferences.h"

static NSString * const MMMNotificationPreferencesKey = @"all_posts_pushes";

NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences) {
    switch (notificationsPreferences) {
        case MMMNotificationsPreferencesAllPosts:
            return @"all_posts";
        case MMMNotificationsPreferencesFeaturedPosts:
            return @"featured_posts";
        case MMMNotificationsPreferencesUser: {
            BOOL notifyAllPosts = [[NSUserDefaults standardUserDefaults] boolForKey:MMMNotificationPreferencesKey];
            MMMNotificationsPreferences preference = notifyAllPosts ? MMMNotificationsPreferencesAllPosts : MMMNotificationsPreferencesFeaturedPosts;
            return NSStringFromMMMNotificationsPreferences(preference);
        }
    }
}