#import <PureLayout/PureLayout.h>

#import "MMMNavigationBar.h"

#pragma mark MMMNavigationBar

@implementation MMMNavigationBar

#pragma mark - Instance Methods

- (void)commonInitialization {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self addSubview:separatorView];

    [separatorView autoSetDimension:ALDimensionHeight toSize:1.f / [UIScreen mainScreen].scale];
    [separatorView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    _separatorView = separatorView;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

@end
