//
//  NSString+HTMLSafe.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSString+HTMLSafe.h"

#pragma mark NSString (HTMLSafe)

@implementation NSString (HTMLSafe)

#pragma mark - Instance Methods

- (NSString *)htmlSafe {
    static NSRegularExpression *regexp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:kNilOptions error:nil];
    });
    NSString *result = [regexp stringByReplacingMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) withTemplate:@""];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

@end
