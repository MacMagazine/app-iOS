@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Formatters)

- (NSString *)mmm_stringFromTemplate:(NSString *)templateString;
- (NSString *)mmm_stringWithDateStyle:(NSDateFormatterStyle)dateStyle;

@end

NS_ASSUME_NONNULL_END
