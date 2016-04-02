//
//  NSDate+Formatters.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Formatters)

- (NSString *)mmm_stringFromTemplate:(NSString *)templateString;
- (NSString *)mmm_stringWithDateStyle:(NSDateFormatterStyle)dateStyle;

@end

NS_ASSUME_NONNULL_END
