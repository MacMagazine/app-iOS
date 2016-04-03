//
//  MMMPostPresenter.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMMPresenter.h"

@class MMMPost;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostPresenter : MMMPresenter

@property (nonatomic, strong, readonly) MMMPost *post;

- (nullable NSString *)descriptionText;
- (nullable NSURL *)thumbnailURLForImageView:(UIImageView *)imageView;
- (nullable NSString *)sectionTitle;

@end

NS_ASSUME_NONNULL_END
