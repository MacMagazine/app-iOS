#import "MMMTableViewCell.h"

#pragma mark MMMTableViewCell

@implementation MMMTableViewCell

#pragma mark - Class Methods

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    if ([[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"]) {
        return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    }

    return nil;
}

@end
