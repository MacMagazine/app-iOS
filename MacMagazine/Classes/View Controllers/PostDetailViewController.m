//
//  PostDetailViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/24/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "Post.h"
#import "PostDetailViewController.h"

@interface PostDetailViewController ()

@end

#pragma mark PostDetailViewController

@implementation PostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

#pragma mark - Actions

#pragma mark - Instance Methods

#pragma mark - Protocols

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [WKWebView new];
    [self.view addSubview:self.webView];
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    NSURL *URL = [NSURL URLWithString:self.post.link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.webView loadRequest:request];
}

@end
