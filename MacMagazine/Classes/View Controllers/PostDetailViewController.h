//
//  PostDetailViewController.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/24/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SUNViewController.h"

@class Post;

@interface PostDetailViewController : SUNViewController

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) UIWebView *webView;

@end
