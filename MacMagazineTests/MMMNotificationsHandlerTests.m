#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "MMMNotificationsHandler.h"

@interface MMMNotificationsHandlerTests : XCTestCase

@end

@implementation MMMNotificationsHandlerTests

- (void)testNotificationWhenBackground {
    id application = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([application applicationState]).andReturn(UIApplicationStateBackground);

    MMMNotificationsHandler *notificationsHandler = [self createNotificationsHandler];
    [notificationsHandler applicationDidReceiveRemoteNotification:[self notificationPayload] fetchCompletionHandler:nil];
    expect(notificationsHandler.navigationController.viewControllers.count).to.equal(0);

    [application stopMocking];
}

- (void)testNotificationWhenInactive {
    id application = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([application applicationState]).andReturn(UIApplicationStateInactive);

    MMMNotificationsHandler *notificationsHandler = [self createNotificationsHandler];
    [notificationsHandler applicationDidReceiveRemoteNotification:[self notificationPayload] fetchCompletionHandler:nil];
    expect(notificationsHandler.navigationController.viewControllers.count).to.equal(1);

    [application stopMocking];
}

- (void)testInvalidNotificationWhenInactive {
    id application = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([application applicationState]).andReturn(UIApplicationStateInactive);

    MMMNotificationsHandler *notificationsHandler = [self createNotificationsHandler];
    [notificationsHandler applicationDidReceiveRemoteNotification:[self invalidNotificationPayload] fetchCompletionHandler:nil];
    expect(notificationsHandler.navigationController.viewControllers.count).to.equal(0);

    [application stopMocking];
}

- (void)testNotificationWhenActive {
    id application = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([application applicationState]).andReturn(UIApplicationStateActive);

    MMMNotificationsHandler *notificationsHandler = [self createNotificationsHandler];
    [notificationsHandler applicationDidReceiveRemoteNotification:[self notificationPayload] fetchCompletionHandler:nil];
    expect(notificationsHandler.navigationController.viewControllers.count).to.equal(0);

    [application stopMocking];
}

- (MMMNotificationsHandler *)createNotificationsHandler {
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    MMMNotificationsHandler *notificationsHandler = [[MMMNotificationsHandler alloc] initWithNavigationController:navigationController];
    return notificationsHandler;
}

- (NSDictionary *)notificationPayload {
    return @{@"guid" : @"https://macmagazine.uol.com.br"};
}

- (NSDictionary *)invalidNotificationPayload {
    return @{@"url" : @"https://macmagazine.uol.com.br"};
}

@end
