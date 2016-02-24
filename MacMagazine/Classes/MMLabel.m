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
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,0,0}]) {
        return [UIFont preferredFontForTextStyle:textStyle];
    }
    
    NSString *fontName = @"HelveticaNeueInterface-Regular";
    
    if ([textStyle isEqualToString:UIFontTextStyleBody]) {
        fontName = @"HelveticaNeueInterface-Regular";
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption1]) {
        fontName = @"HelveticaNeueInterface-Regular";
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption2]) {
        fontName = @"HelveticaNeueInterface-Regular";
    } else if ([textStyle isEqualToString:UIFontTextStyleFootnote]) {
        fontName = @"HelveticaNeueInterface-Regular";
    } else if ([textStyle isEqualToString:UIFontTextStyleHeadline]) {
        fontName = @"HelveticaNeueInterface-MediumP4";
    } else if ([textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        fontName = @"HelveticaNeueInterface-Regular";
    }
    
    return [UIFont fontWithName:fontName size:[UIFont preferredFontForTextStyle:textStyle].pointSize];
}

@end
