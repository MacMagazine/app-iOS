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
#import <SafariServices/SafariServices.h>
#import <SpriteKit/SpriteKit.h>
#import <Tweaks/FBTweakInline.h>

static NSString * const MMBaseURL = @"macmagazine.com.br";

typedef NS_ENUM(NSUInteger, MMLinkClickType) {
    MMLinkClickTypeInternal,
    MMLinkClickTypeExternal,
};

@interface PostDetailViewController () <UIWebViewDelegate>

@property (nonatomic, weak) SKView *animationView;
@property (nonatomic) BOOL isLoading;

@end

#pragma mark PostDetailViewController

@implementation PostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

#pragma mark - Actions

- (void)pushToNewDetailViewControllerWithURL:(NSURL *)URL {
    PostDetailViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    viewController.URL = URL;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToSFSafariViewControllerWithURL:(NSURL *)URL {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:URL];
    [self presentViewController:safariViewController animated:YES completion:nil];
}

#pragma mark - Instance Methods

- (void)removeAnimation {
    if (!self.animationView.superview) {
        return;
    }
    
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

- (void)dealWithLinkClickWithType:(MMLinkClickType)linkClickType URL:(NSURL *)URL {
    if (linkClickType == MMLinkClickTypeInternal) {
        [self pushToNewDetailViewControllerWithURL:URL];
    } else if (linkClickType == MMLinkClickTypeExternal) {
        [self pushToSFSafariViewControllerWithURL:URL];
    }
}

#pragma mark - Protocols

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : @"MacMagazine"}];
    [[NSURLCache sharedURLCache] setMemoryCapacity:10 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:50 * 1024 * 1024];
    
    // Must fix content inset before turning ON
    self.navigationController.hidesBarsOnSwipe = NO;
    
    self.showLoadingBar = YES;
    self.showPageTitles = NO;
    self.showUrlWhileLoading = NO;
    
    if (FBTweakValue(@"Animations", @"Macintosh", @"Enabled", NO)) {
        [self prepareMacintoshAnimation];
    }
    
    self.isLoading = YES;
    __weak typeof(self) weakSelf = self;
    [self setDidFinishLoadHandler:^(UIWebView *webView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeAnimation];
        strongSelf.isLoading = NO;
    }];
    
    [self setShouldStartLoadRequestHandler:^BOOL(NSURLRequest *request, UIWebViewNavigationType navigationType) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // Semi-hack sollution to capture URL selection when there's a javascript redirect.
        // http://tech.vg.no/2013/09/13/dissecting-javascript-clicks-in-uiwebview/
        NSString *URLString = request.URL.absoluteString;
        
        // first page load, don't move away
        if ([URLString isEqualToString:strongSelf.URL.absoluteString]) {
            return YES;
        }
        
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            if ([request.URL.absoluteString containsString:MMBaseURL]) {
                [strongSelf pushToNewDetailViewControllerWithURL:request.URL];
            } else {
                [strongSelf pushToSFSafariViewControllerWithURL:request.URL];
            }
            return NO;
        } else if (navigationType == UIWebViewNavigationTypeOther) {
            //push our own javascript-triggered links as well
            NSString* documentURL = [[request mainDocumentURL] absoluteString];
            //if they are the same this is a javascript href click
            if ([URLString isEqualToString:documentURL]) {
                if (!strongSelf.isLoading) {
                    if ([request.URL.absoluteString containsString:MMBaseURL]) {
                        [strongSelf pushToNewDetailViewControllerWithURL:request.URL];
                    } else {
                        [strongSelf pushToSFSafariViewControllerWithURL:request.URL];
                    }
                    return NO;
                }
            }
        }
        return YES;
    }];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 0, 0, 0);
    self.webView.scrollView.contentInset = inset;
    self.webView.scrollView.scrollIndicatorInsets = inset;
    self.webView.alpha = 0.0f;
    
    NSURL *URL = self.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    self.urlRequest = request;
    self.url = URL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

@end
