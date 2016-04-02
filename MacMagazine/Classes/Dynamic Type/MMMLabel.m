//
//  MMMLabel.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/21/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMMLabel.h"

#pragma mark MMMLabel

@implementation MMMLabel

#pragma mark - Getters/Setters

- (void)setTextStyle:(NSString *)textStyle {
    _textStyle = [textStyle copy];

    [self reloadFont];
}

#pragma mark - Instance Methods

- (void)commonInitialization {
    self.textStyle = self.font.fontDescriptor.fontAttributes[@"NSCTFontUIUsageAttribute"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFont) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)reloadFont {
    if (self.textStyle) {
        UIFont *font = [UIFont preferredFontForTextStyle:self.textStyle];
        self.font = font;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
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
