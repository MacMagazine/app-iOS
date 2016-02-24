//
//  PostDetailViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/24/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "PostDetailViewController.h"
#import "MacintoshScene.h"
#import "Post.h"

#import <AVFoundation/AVFoundation.h>
#import <PureLayout/PureLayout.h>
#import <SpriteKit/SpriteKit.h>

@interface PostDetailViewController () <UIWebViewDelegate>

@property (nonatomic, weak) SKView *animationView;

@end

#pragma mark PostDetailViewController

@implementation PostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

#pragma mark - Actions

#pragma mark - Instance Methods

- (void)removeAnimation {
    [UIView animateWithDuration:0.2f delay:1.6f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.animationView.alpha = 0.0f;
    } completion:nil];
    
    [UIView animateWithDuration:0.2f delay:1.6f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.webView.alpha = 1.0f;
    } completion:nil];
    
    // setting this inside the completion block was causing undesired behaviour
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.animationView removeFromSuperview];
    });
}

- (void)prepareMacintoshAnimation {
    // Macintosh animation
    // Create and configure the scene.
    SKScene *scene = [MacintoshScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    SKView *animationView = [[SKView alloc] init];
    [self.view insertSubview:animationView atIndex:0];
    self.animationView = animationView;
    [self.animationView autoPinEdgesToSuperviewEdges];
    
    [self.animationView presentScene:scene];
}

#pragma mark - Protocols

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : @"MacMagazine"}];
    [[NSURLCache sharedURLCache] setMemoryCapacity:10 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:50 * 1024 * 1024];
    
    self.navigationController.hidesBarsOnSwipe = YES;
    
    self.showLoadingBar = YES;
    self.showPageTitles = NO;
    self.showUrlWhileLoading = NO;
    
    [self prepareMacintoshAnimation];
    
    __weak typeof(self) weakSelf = self;
    [self setDidFinishLoadHandler:^(UIWebView *webView) {
        [weakSelf removeAnimation];
    }];
    
    self.webView.alpha = 0.0f;
    
    NSURL *URL = [NSURL URLWithString:self.post.link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    self.urlRequest = request;
    self.url = URL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

@end
