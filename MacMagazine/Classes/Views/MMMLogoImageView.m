//
//  MMMLogoImageView.m
//  MacMagazine
//
//  Created by Cesar Barscevicius on 5/30/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

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
