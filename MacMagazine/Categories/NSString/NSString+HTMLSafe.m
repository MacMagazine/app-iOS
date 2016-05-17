#import "NSString+HTMLSafe.h"

#pragma mark NSString (HTMLSafe)

@implementation NSString (HTMLSafe)

#pragma mark - Instance Methods

- (NSString *)mmm_htmlSafe {
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
