#import "MMMNotificationsPreferences.h"

NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences) {
    switch (notificationsPreferences) {
        case MMMNotificationsPreferencesAllPosts:
            return @"all_posts";
        case MMMNotificationsPreferencesFeaturedPosts:
            return @"featured_posts";
    }
}