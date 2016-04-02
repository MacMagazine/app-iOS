//
//  MMMTableViewCell.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/2/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

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
