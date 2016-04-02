//
//  MMMPostDetailViewController.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/24/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <TOWebViewController/TOWebViewController.h>

@class MMMPost;

NS_ASSUME_NONNULL_BEGIN

@interface MMMPostDetailViewController : TOWebViewController

@property (nonatomic, strong, nullable) MMMPost *post;
@property (nonatomic, copy, nullable) NSArray<MMMPost *> *posts;

// In case the detail view controller is loaded from a link click
@property (nonatomic, strong, nullable) NSURL *postURL;

@end

NS_ASSUME_NONNULL_END
