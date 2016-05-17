#import "MMMPresenter.h"

#pragma mark MMMPresenter

@implementation MMMPresenter

#pragma mark - Instance Methods

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

- (void)setupView:(__kindof UIView *)view {
    NSString *selectorString = [NSString stringWithFormat:@"setup%@:", NSStringFromClass(view.class)];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:view];
#pragma clang diagnostic pop
    }
}

@end
