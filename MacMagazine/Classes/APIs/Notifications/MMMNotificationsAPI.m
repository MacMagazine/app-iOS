//
//  MMMNotificationsAPI.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/9/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "MMMNotificationsAPI.h"

@interface MMMNotificationsAPI ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

#pragma mark MMMNotificationsAPI

@implementation MMMNotificationsAPI

static NSString * const MMMNotificationsAPIBaseURLPath = @"https://macmagazine-ios-notifications.herokuapp.com/api/v1";

#pragma mark - Getters/Setters

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURL *baseURL = [NSURL URLWithString:MMMNotificationsAPIBaseURLPath];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }

    return _sessionManager;
}

#pragma mark - Instance Methods

- (instancetype)initWithAPIKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        _apiKey = [apiKey copy];
    }
    return self;
}

- (void)registerToken:(NSData *)tokenData notificationPeferences:(MMMNotificationsPreferences)notificationPeferences {
    NSString *token = tokenData.description;
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *path = [@"devices" stringByAppendingPathComponent:token];

    NSDictionary *parameters = @{@"api_key" : self.apiKey,
                                 @"notification_preferences" : NSStringFromMMMNotificationsPreferences(notificationPeferences),
                                 @"badge" : @0};
    
    [self.sessionManager PUT:path parameters:parameters success:nil failure:nil];
}

@end
