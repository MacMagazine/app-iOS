//
//  NSDate+Formatters.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSDate+Formatters.h"
#import "NSDateFormatter+Addons.h"

#pragma mark NSDate (Formatters)

@implementation NSDate (Formatters)

#pragma mark - Instance Methods

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle {
    return [[NSDateFormatter formatterWithDateStyle:dateStyle timeStyle:NSDateFormatterNoStyle] stringFromDate:self];
}

- (NSString *)stringFromTemplate:(NSString *)templateString {
    return [[NSDateFormatter formatterWithTemplate:templateString] stringFromDate:self];
}

@end
