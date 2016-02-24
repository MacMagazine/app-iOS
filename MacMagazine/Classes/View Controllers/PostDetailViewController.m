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
#import "MacintoshScene.h"
#import <UIKit/UIWebView.h>
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PostDetailViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet SKView *animationView;
@property (nonatomic, weak) IBOutlet UIView *backgroundAnimationView;

@end

#pragma mark PostDetailViewController

@implementation PostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

#pragma mark - Actions

#pragma mark - Instance Methods

#pragma mark - Protocols

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.2f delay:1.6f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.animationView.alpha = 0.0f;
        self.backgroundAnimationView.alpha = 0.0f;
    } completion:nil];
    
    [UIView animateWithDuration:0.2f delay:1.6f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.webView.alpha = 1.0f;
    } completion:nil];
    
    // setting this inside the completion block was causing undesired behaviour
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.animationView removeFromSuperview];
        [strongSelf.backgroundAnimationView removeFromSuperview];
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self webViewDidFinishLoad:webView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : @"MacMagazine"}];
    [[NSURLCache sharedURLCache] setMemoryCapacity:10 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:50 * 1024 * 1024];
    
    // Macintosh animation
    // Create and configure the scene.
    SKScene *scene = [MacintoshScene sceneWithSize:self.animationView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.animationView presentScene:scene];
    
    self.webView = [UIWebView new];
    [self.view insertSubview:self.webView belowSubview:self.animationView];
    [self.webView autoPinEdgesToSuperviewEdges];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 0, 0, 0)];
    self.webView.alpha = 0.0f;
    self.webView.delegate = self;
    
    NSURL *URL = [NSURL URLWithString:self.post.link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.webView loadRequest:request];
    
}

@end
