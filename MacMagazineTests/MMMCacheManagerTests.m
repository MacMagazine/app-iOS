@import WebKit;

#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <SDWebImage/SDImageCache.h>
#import <XCTest/XCTest.h>

#import "MMMCacheManager.h"

@interface MMMCacheManagerTests : XCTestCase

@end

@implementation MMMCacheManagerTests

- (void)testCacheClear {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"clear_cache"];

    id imageCache = OCMClassMock([SDImageCache class]);
    id webCache = OCMClassMock([WKWebsiteDataStore class]);
    id defaults = OCMClassMock([NSUserDefaults class]);

    [MMMCacheManager clearCacheIfNeeded];

    OCMVerify([[imageCache sharedImageCache] clearDisk]);
    OCMVerify([[webCache defaultDataStore] removeDataOfTypes:[OCMArg any] modifiedSince:[OCMArg any] completionHandler:[OCMArg any]]);
    OCMVerify([[defaults standardUserDefaults] setBool:NO forKey:[OCMArg any]]);
}

- (void)testCacheMaintain {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clear_cache"];

    id imageCache = OCMClassMock([SDImageCache class]);
    id webCache = OCMClassMock([WKWebsiteDataStore class]);

    OCMReject([[imageCache sharedImageCache] clearDisk]);
    OCMReject([[webCache defaultDataStore] removeDataOfTypes:[OCMArg any] modifiedSince:[OCMArg any] completionHandler:[OCMArg any]]);

    [MMMCacheManager clearCacheIfNeeded];
}

@end
