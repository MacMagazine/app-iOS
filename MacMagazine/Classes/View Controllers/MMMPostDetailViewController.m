//
//  MMMPostDetailViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/24/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <PureLayout/PureLayout.h>
#import <SafariServices/SafariServices.h>
#import <SpriteKit/SpriteKit.h>
#import <TOWebViewController/TOActivityChrome.h>
#import <TOWebViewController/TOActivitySafari.h>
#import <Tweaks/FBTweakInline.h>

#import "MMMPostDetailViewController.h"
#import "MMMMacintoshScene.h"
#import "MMMPost.h"

static NSString * const MMMBaseURL = @"macmagazine.com.br";

typedef NS_ENUM(NSUInteger, MMMLinkClickType) {
    MMMLinkClickTypeInternal,
    MMMLinkClickTypeExternal,
};

@interface MMMPostDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) MMMPost *nextPost;
@property (nonatomic, strong) MMMPost *previousPost;

@property (nonatomic, weak) SKView *animationView;
@property (nonatomic) BOOL isLoading;

@end

#pragma mark MMMPostDetailViewController

@implementation MMMPostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

#pragma mark - Actions

- (BOOL)respondToLoadRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Semi-hack sollution to capture URL selection when there's a javascript redirect.
    // http://tech.vg.no/2013/09/13/dissecting-javascript-clicks-in-uiwebview/
    NSString *URLString = request.URL.absoluteString;

    // First page load, don't move away
    if ([URLString isEqualToString:self.post.link]) {
        return YES;
    }

    MMMLinkClickType linkClickType = ([request.URL.absoluteString containsString:MMMBaseURL]) ? MMMLinkClickTypeInternal : MMMLinkClickTypeExternal;
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self performActionForLinkClickWithType:linkClickType URL:request.URL];

        return NO;
    } else if (navigationType == UIWebViewNavigationTypeOther) {
        // For javascript-triggered links
        NSString *documentURL = [[request mainDocumentURL] absoluteString];

        // If they are the same this is a javascript href click
        if ([URLString isEqualToString:documentURL]) {
            if (!self.isLoading) {
                [self performActionForLinkClickWithType:linkClickType URL:request.URL];

                return NO;
            }
        }
    }

    return YES;
}

- (void)pushToNewDetailViewControllerWithURL:(NSURL *)URL {
    MMMPostDetailViewController *destinationViewController = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    destinationViewController.postURL = URL;
    destinationViewController.post = nil;
    destinationViewController.posts = nil;
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (void)pushToSFSafariViewControllerWithURL:(NSURL *)URL {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:URL];
    [self presentViewController:safariViewController animated:YES completion:nil];
}

#pragma mark - Button Actions

- (void)actionButtonTapped:(id)sender {
    // Do nothing if there is no url for action
    if (!self.url) {
        return;
    }

    if (![sender isKindOfClass:[UIBarButtonItem class]]) {
        return;
    }

    UIBarButtonItem *actionItem = (UIBarButtonItem *)sender;
    NSArray *browserActivities = @[[TOActivitySafari new], [TOActivityChrome new]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:browserActivities];
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    activityViewController.popoverPresentationController.barButtonItem = actionItem;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)refreshButtonTapped:(id)sender {
    [self.webView stopLoading];
    //In certain cases, if the connection drops out preload or midload,
    //it nullifies webView.request, which causes [webView reload] to stop working.
    //This checks to see if the webView request URL is nullified, and if so, tries to load
    //off our stored self.url property instead
    if (self.webView.request.URL.absoluteString.length == 0 && self.url) {
        [self.webView loadRequest:self.urlRequest];
    } else {
        [self.webView reload];
    }
}

- (void)nextPostButtonTapped:(id)sender {
    [self reloadViewControllerWithPost:self.nextPost];
}

- (void)previousPostButtonTapped:(id)sender {
    [self reloadViewControllerWithPost:self.previousPost];
}

#pragma mark - Instance Methods

- (void)reloadViewControllerWithPost:(MMMPost *)post {
    [self.webView stopLoading];

    self.post = post;
    self.nextPost = nil;
    self.previousPost = nil;
    self.postURL = nil;
    self.url = nil;

    [self setupWebView];
    [self setupLoadingAnimation];
    [self setupToolbar];
}

- (void)removeLoadingAnimation {
    if (!self.webView.hidden) {
        return;
    }

    self.webView.hidden = NO;
    self.webView.alpha = 0.0f;

    if (FBTweakValue(@"Animations", @"Macintosh", @"Enabled", NO)) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.animationView.alpha = 0.0f;
        } completion:nil];

        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.webView.alpha = 1.0f;
        } completion:nil];

        // setting this inside the completion block was causing undesired behaviour
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.animationView removeFromSuperview];
        });
    } else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.webView.alpha = 1.0f;
        } completion:nil];
    }
}

- (void)prepareMacintoshAnimation {
    // Create and configure the scene
    SKScene *scene = [MMMMacintoshScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene
    SKView *animationView = [[SKView alloc] init];
    [self.view insertSubview:animationView atIndex:0];
    self.animationView = animationView;
    [self.animationView autoPinEdgesToSuperviewEdges];

    [self.animationView presentScene:scene];
}

- (void)performActionForLinkClickWithType:(MMMLinkClickType)linkClickType URL:(NSURL *)URL {
    if (linkClickType == MMMLinkClickTypeInternal) {
        [self pushToNewDetailViewControllerWithURL:URL];
    } else if (linkClickType == MMMLinkClickTypeExternal) {
        [self pushToSFSafariViewControllerWithURL:URL];
    }
}

- (void)setupWebView {
    // Changes the UIWebView user agent in order to hide some CSS/HTML elements
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : @"MacMagazine"}];
    [[NSURLCache sharedURLCache] setMemoryCapacity:10 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:50 * 1024 * 1024];

    self.webView.hidden = YES;
    self.isLoading = YES;

    self.navigationButtonsHidden = YES;
    self.showLoadingBar = YES;
    self.showPageTitles = NO;
    self.showUrlWhileLoading = NO;

    __weak typeof(self) weakSelf = self;
    // Finish load handler
    [self setDidFinishLoadHandler:^(UIWebView *webView) {
        if (!webView.isLoading) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf removeLoadingAnimation];
            strongSelf.isLoading = NO;
        }
    }];

    // URLRequest handler
    [self setShouldStartLoadRequestHandler:^BOOL(NSURLRequest *request, UIWebViewNavigationType navigationType) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        return [strongSelf respondToLoadRequest:request navigationType:navigationType];
    }];

    // Loads request
    if (!self.postURL) {
        self.postURL = [NSURL URLWithString:self.post.link];
    }

    NSURL *URL = self.postURL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    self.urlRequest = request;
    self.url = URL;
}

- (void)setupLoadingAnimation {
    if (FBTweakValue(@"Animations", @"Macintosh", @"Enabled", NO)) {
        [self prepareMacintoshAnimation];
        // UIWebView is hidden and isets end up being calculated wrong
        UIEdgeInsets inset = UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 0, 0, 0);
        self.webView.scrollView.contentInset = inset;
        self.webView.scrollView.scrollIndicatorInsets = inset;
    }
}

- (void)setupToolbar {
    [self.navigationController setToolbarHidden:NO animated:YES];

    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.items = nil;

    NSMutableArray <UIBarButtonItem *> *items = [[NSMutableArray alloc] initWithCapacity:4];

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    // Previous post item
    UIBarButtonItem *previousPostItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrowup"] style:UIBarButtonItemStylePlain target:self action:@selector(previousPostButtonTapped:)];
    previousPostItem.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [items addObject:previousPostItem];
    if (![self previousPost]) {
        previousPostItem.enabled = NO;
    }

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    // Next post item
    UIBarButtonItem *nextPostItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrowdown"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPostButtonTapped:)];
    nextPostItem.imageInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [items addObject:nextPostItem];
    if (![self nextPost]) {
        nextPostItem.enabled = NO;
    }

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    // Reload item
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
    [items addObject:refreshItem];

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    // Action item
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    [items addObject:actionItem];

    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];

    [toolbar setItems:[items copy]];
}

- (MMMPost *)nextPost {
    if (!(self.posts) || !(self.post)) {
        _nextPost = nil;
        return _nextPost;
    }

    if (!_nextPost) {
        NSUInteger currentPostIndex = [self.posts indexOfObject:self.post];
        NSInteger nextPostIndex = currentPostIndex + 1;
        if (nextPostIndex <= (self.posts.count - 1)) {
            _nextPost = [self.posts objectAtIndex:currentPostIndex + 1];
        }
    }

    return _nextPost;
}

- (MMMPost *)previousPost {
    if (!(self.posts) || !(self.post)) {
        _previousPost = nil;
        return _previousPost;
    }

    if (!_previousPost) {
        NSUInteger currentPostIndex = [self.posts indexOfObject:self.post];
        NSInteger previousPostIndex = currentPostIndex - 1;
        if (previousPostIndex >= 0) {
            _previousPost = [self.posts objectAtIndex:currentPostIndex - 1];
        }
    }

    return _previousPost;
}

#pragma mark - Protocols

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupWebView];
    [self setupLoadingAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setupToolbar];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

@end
