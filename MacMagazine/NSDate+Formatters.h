//
//  NSDate+Formatters.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import Foundation;

@interface NSDate (Formatters)

- (NSString *)stringFromTemplate:(NSString *)templateString;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle;

@end
