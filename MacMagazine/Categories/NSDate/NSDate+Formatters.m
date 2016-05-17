#import "NSDate+Formatters.h"
#import "NSDateFormatter+Addons.h"

#pragma mark NSDate (Formatters)

@implementation NSDate (Formatters)

#pragma mark - Instance Methods

- (NSString *)mmm_stringFromTemplate:(NSString *)templateString {
    return [[NSDateFormatter mmm_formatterWithTemplate:templateString] stringFromDate:self];
}

- (NSString *)mmm_stringWithDateStyle:(NSDateFormatterStyle)dateStyle {
    return [[NSDateFormatter mmm_formatterWithDateStyle:dateStyle timeStyle:NSDateFormatterNoStyle] stringFromDate:self];
}

@end
