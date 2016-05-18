#import <SDWebImage/SDImageCache.h>

#import "MMMImageCacheManager.h"

static NSString * const MMMClearCachePreferenceKey = @"clear_image_cache";

@implementation MMMImageCacheManager

+ (void)clearImageCacheIfNeeded {
    BOOL clearCache = [[NSUserDefaults standardUserDefaults] boolForKey:MMMClearCachePreferenceKey];
    if (clearCache) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MMMClearCachePreferenceKey];
    }
}

@end
