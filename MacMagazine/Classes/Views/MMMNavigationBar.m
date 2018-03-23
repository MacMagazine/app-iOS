#import <PureLayout/PureLayout.h>

#import "MMMNavigationBar.h"
#import "HexColor.h"

#pragma mark MMMNavigationBar

@implementation MMMNavigationBar

#pragma mark - Instance Methods

- (void)commonInitialization {
    NSArray *navigationBarSubviews = self.subviews;
    UIView *firstSubview = navigationBarSubviews.firstObject;
    UIImageView *separatorImageView = firstSubview.subviews.firstObject;
    if (separatorImageView && [separatorImageView isKindOfClass:[UIImageView class]]) {
        separatorImageView.hidden = YES;
    }
    
    UIView *separatorView = [[UIView alloc] init];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		separatorView.backgroundColor = [UIColor colorWithHexString:@"#4c4c4c"];
	} else {
		separatorView.backgroundColor = [UIColor colorWithRed:0.78 green:0.80 blue:0.84 alpha:0.80];
	}
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

- (id)initWithCoder:(NSCoder *)aDecoder {
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
