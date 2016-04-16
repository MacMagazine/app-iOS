@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (Addons)

+ (instancetype)mmm_formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
+ (instancetype)mmm_formatterWithTemplate:(NSString *)templateString;
+ (instancetype)mmm_formatterWithKey:(NSString *)key block:(void(^)(NSDateFormatter *dateFormatter))block;

@end

NS_ASSUME_NONNULL_END
