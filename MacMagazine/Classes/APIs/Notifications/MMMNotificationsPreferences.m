//
//  MMMNotificationsPreferences.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/9/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

#import "MMMNotificationsPreferences.h"

NSString * NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferences notificationsPreferences) {
    switch (notificationsPreferences) {
        case MMMNotificationsPreferencesAllPosts:
            return @"all_posts";
        case MMMNotificationsPreferencesFeaturedPosts:
            return @"featured_posts";
    }
}