//
//  NSDateFormatter+Addons.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSDateFormatter+Addons.h"

#pragma mark NSDateFormatter (Addons)

@implementation NSDateFormatter (Addons)

#pragma mark - Class Methods

+ (NSMutableDictionary *)formatters {
    static NSMutableDictionary *formatters;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatters = [NSMutableDictionary new];
    });
    return formatters;
}

+ (instancetype)mmm_formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSString *key = [NSString stringWithFormat:@"DateStyle: %li TimeStyle: %li", (unsigned long)dateStyle, (unsigned long)timeStyle];
    NSDateFormatter *formatter = [NSDateFormatter formatters][key];
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.dateStyle = dateStyle;
        formatter.timeStyle = timeStyle;
        [NSDateFormatter formatters][key] = formatter;
    }
    return formatter;
}

+ (instancetype)mmm_formatterWithTemplate:(NSString *)templateString {
    NSDateFormatter *formatter = [NSDateFormatter formatters][templateString];
    if (!formatter) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:templateString options:0 locale:[NSLocale currentLocale]];
        [NSDateFormatter formatters][templateString] = formatter;
    }
    return formatter;
}

+ (instancetype)mmm_formatterWithKey:(NSString *)key block:(void(^)(NSDateFormatter *dateFormatter))block {
    NSString *cacheKey = [NSString stringWithFormat:@"Custom Formatter: %@", key];
    NSDateFormatter *formatter = [NSDateFormatter formatters][cacheKey];
    if (!formatter) {
        formatter = [NSDateFormatter new];
        block(formatter);
        [NSDateFormatter formatters][cacheKey] = formatter;
    }
    return formatter;
}

@end
