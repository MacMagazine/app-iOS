//
//  MMMPresenter.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 4/2/16.
//  Copyright © 2016 made@sampa. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPresenter : NSObject

@property (nonatomic, strong, readonly) id object;

- (instancetype)initWithObject:(id)object;
- (void)setupView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END
