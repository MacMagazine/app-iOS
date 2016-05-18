@import WebKit;

#import <SDWebImage/SDImageCache.h>

#import "MMMCacheManager.h"

static NSString * const MMMClearCachePreferenceKey = @"clear_cache";

@implementation MMMCacheManager

+ (void)clearCacheIfNeeded {
    BOOL clearCache = [[NSUserDefaults standardUserDefaults] boolForKey:MMMClearCachePreferenceKey];
    if (clearCache) {
        [[SDImageCache sharedImageCache] clearDisk];

        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MMMClearCachePreferenceKey];
        }];
    }
}

@end
