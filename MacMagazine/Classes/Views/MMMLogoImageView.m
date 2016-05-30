#import "MMMLogoImageView.h"

@implementation MMMLogoImageView

- (instancetype)init {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"mm_logo"];
        self.frame = CGRectMake(0, 0, 34, 34);
        self.contentMode = UIViewContentModeScaleAspectFit;
    }

    return self;
}

@end
