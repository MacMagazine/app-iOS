//
//  MMLabel.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMLabel.h"

#pragma mark MMLabel

@implementation MMLabel

#pragma mark - Instance Methods

- (void)updateFont {
    if (self.textStyle) {
        self.font = [UIFont fontWithName:[UIFont mm_fontForTextStyle:self.textStyle].fontName size:[UIFont preferredFontForTextStyle:self.textStyle].pointSize * self.multiplier.floatValue];
    }
}

@end

#pragma mark - UIFont (AvenirLabel)

@implementation UIFont (AvenirLabel)

#pragma mark - Class Methods

+ (UIFont *)mm_fontForTextStyle:(NSString *)textStyle {
    NSString *fontName = @"SFUIDisplay-Regular";
    
    if ([textStyle isEqualToString:UIFontTextStyleBody]) {
        fontName = @"SFUIDisplay-Regular";
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption1]) {
        fontName = @"SFUIDisplay-Light";
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption2]) {
        fontName = @"SFUIDisplay-Light";
    } else if ([textStyle isEqualToString:UIFontTextStyleFootnote]) {
        fontName = @"SFUIDisplay-Light";
    } else if ([textStyle isEqualToString:UIFontTextStyleHeadline]) {
        fontName = @"SFUIDisplay-Medium";
    } else if ([textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        fontName = @"SFUIDisplay-Light";
    }
    
    return [UIFont fontWithName:fontName size:[UIFont preferredFontForTextStyle:textStyle].pointSize];
}

@end
