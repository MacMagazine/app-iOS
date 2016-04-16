#import "_MMMPost.h"

@interface MMMPost : _MMMPost

+ (void)getWithPage:(NSUInteger)page success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (NSArray<NSString *> *)categoriesArray;
- (NSArray<NSString *> *)imagesArray;
- (NSString *)thumbnail;

@end
