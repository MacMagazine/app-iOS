//
//  NSDateFormatter+Addons.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import Foundation;

@interface NSDateFormatter (Addons)

+ (instancetype)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
+ (instancetype)formatterWithTemplate:(NSString *)templateString;
+ (instancetype)formatterWithKey:(NSString *)key block:(void(^)(NSDateFormatter *dateFormatter))block;

@end
