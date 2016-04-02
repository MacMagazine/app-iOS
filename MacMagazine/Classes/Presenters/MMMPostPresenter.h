//
//  MMMPostPresenter.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SUNPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostPresenter : SUNPresenter

- (nullable NSString *)descriptionText;
- (nullable NSURL *)thumbnailURLForImageView:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
