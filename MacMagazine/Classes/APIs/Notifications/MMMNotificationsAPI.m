#import <AFNetworking/AFNetworking.h>

#import "MMMNotificationsAPI.h"

@interface MMMNotificationsAPI ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

#pragma mark MMMNotificationsAPI

@implementation MMMNotificationsAPI

static NSString * const MMMNotificationsAPIBaseURLPath = @"https://macmagazine-ios-notifications.herokuapp.com/api/v1";

NSString * MMMNotificationsNormalizedAPNSTokenWithData(NSData *data) {
    const unsigned *tokenBytes = [data bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return hexToken;
}

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
    NSString *token = MMMNotificationsNormalizedAPNSTokenWithData(tokenData);
    NSString *path = [@"devices" stringByAppendingPathComponent:token];

    NSDictionary *parameters = @{@"api_key" : self.apiKey,
                                 @"badge" : @0,
                                 @"notification_preferences" : NSStringFromMMMNotificationsPreferences(notificationPeferences)};
    
    [self.sessionManager PUT:path parameters:parameters success:nil failure:nil];
}

@end
