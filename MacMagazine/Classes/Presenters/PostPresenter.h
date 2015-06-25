//
//  PostPresenter.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SUNPresenter.h"

@interface PostPresenter : SUNPresenter

- (NSString *)descriptionText;
- (NSURL *)thumbnailURLForImageView:(UIImageView *)imageView;

@end
