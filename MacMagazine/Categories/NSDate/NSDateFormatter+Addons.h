//
//  NSDateFormatter+Addons.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (Addons)

+ (instancetype)mmm_formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
+ (instancetype)mmm_formatterWithTemplate:(NSString *)templateString;
+ (instancetype)mmm_formatterWithKey:(NSString *)key block:(void(^)(NSDateFormatter *dateFormatter))block;

@end

NS_ASSUME_NONNULL_END
