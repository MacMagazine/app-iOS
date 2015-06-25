//
//  MMLabel.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SUNLabel.h"

@interface MMLabel : SUNLabel

@end

@interface UIFont (MMLabel)

+ (UIFont *)mm_fontForTextStyle:(NSString *)textStyle;

@end
