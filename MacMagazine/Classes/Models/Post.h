//
//  Post.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/14/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "_Post.h"

@interface Post : _Post

+ (void)getWithPage:(NSUInteger)page success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (NSArray *)categoriesArray;
- (NSArray *)imagesArray;
- (BOOL)isFeatured;
- (BOOL)isVisible;
- (NSString *)thumbnail;

@end
