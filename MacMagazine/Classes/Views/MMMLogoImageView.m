#import "MMMLogoImageView.h"

@implementation MMMLogoImageView

- (instancetype)init {
    if (self = [super init]) {
		[self setFrame:CGRectMake(0, 0, 34, 34)];
		[self setBackgroundColor:[UIColor clearColor]];

		UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm_logo"]];
		[titleImageView setFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
		[titleImageView setContentMode:UIViewContentModeScaleAspectFit];
		[self addSubview:titleImageView];
		titleImageView = nil;
    }

    return self;
}

@end
