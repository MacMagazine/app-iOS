@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPresenter : NSObject

@property (nonatomic, strong, readonly) id object;

- (instancetype)initWithObject:(id)object;
- (void)setupView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END
