@import WebKit;

#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "MMMNotificationsPreferences.h"

@interface MMMNotificationsPreferencesTests : XCTestCase

@end

@implementation MMMNotificationsPreferencesTests

- (void)testNotificationPreferenceUserAllPosts {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"all_posts_pushes"];
    expect(NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferencesUser)).to.equal(@"all_posts");
}

- (void)testNotificationPreferenceUserFeaturedPosts {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"all_posts_pushes"];
    expect(NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferencesUser)).to.equal(@"featured_posts");
}

- (void)testNotificationPreferenceAllPosts {
    expect(NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferencesAllPosts)).to.equal(@"all_posts");
}

- (void)testNotificationPreferenceFeaturedPosts {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"all_posts_pushes"];
    expect(NSStringFromMMMNotificationsPreferences(MMMNotificationsPreferencesFeaturedPosts)).to.equal(@"featured_posts");
}

@end
