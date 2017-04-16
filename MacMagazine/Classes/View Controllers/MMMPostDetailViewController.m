#import <AVFoundation/AVFoundation.h>
#import <PureLayout/PureLayout.h>
#import <SafariServices/SafariServices.h>
#import <Tweaks/FBTweakInline.h>
#import <WebKit/WebKit.h>

#import "MMMPostDetailViewController.h"
#import "MMMLogoImageView.h"
#import "MMMPost.h"
#import "UIViewController+ShareActivity.h"

static NSString * const MMMBaseURL = @"macmagazine.com.br";
static NSString * const MMMDisqusBaseURL = @"disqus.com";
static NSString * const MMMUserAgent = @"MacMagazine";
static NSString * const MMMReloadWebViewsNotification = @"com.macmagazine.notification.webview.reload";

typedef NS_ENUM(NSUInteger, MMMLinkClickType) {
    MMMLinkClickTypeInternal,
    MMMLinkClickTypeExternal,
};

@interface MMMPostDetailViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) WKWebView *webView;

@end

#pragma mark MMMPostDetailViewController

@implementation MMMPostDetailViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

- (void)setPost:(MMMPost *)post {
    _post = post;

    if (post.link.length > 0) {
        self.postURL = [NSURL URLWithString:self.post.link];
    }
}

#pragma mark - Actions

- (void)pushToNewDetailViewControllerWithURL:(NSURL *)URL {
    MMMPostDetailViewController *destinationViewController = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    destinationViewController.postURL = URL;
    destinationViewController.post = nil;
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (void)pushToSFSafariViewControllerWithURL:(NSURL *)URL {
    if ([@[@"http", @"https"] containsObject:URL.scheme.lowercaseString]) {
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:URL];
        [self presentViewController:safariViewController animated:YES completion:nil];
    }
}

#pragma mark - Button Actions

- (void)actionButtonTapped:(id)sender {
    if (!self.webView.URL) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[self.post thumbnail]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *postThumbnail = [[UIImage alloc] initWithData:data];

    UIBarButtonItem *actionItem = (UIBarButtonItem *)sender;
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    if (self.post) {
        [activityItems addObject:self.post.title];
    }
    [activityItems addObject:self.webView.URL];
    [activityItems addObject:postThumbnail];
    [self mmm_shareActivityItems:activityItems fromBarButtonItem:actionItem completion:nil];
}

#pragma mark - Instance Methods

- (void)setupWebView {
    if (self.webView) {
        [self.webView stopLoading];
    } else {
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;

        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        webViewConfiguration.preferences = preferences;

        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfiguration];
        [self.view addSubview:webView];
        self.webView = webView;
        [self.webView autoPinEdgesToSuperviewEdges];

        // Changes the WKWebView user agent in order to hide some CSS/HTML elements
        self.webView.customUserAgent = MMMUserAgent;
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;

        // Observer to check that loading has completelly finished for the WebView
        [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.postURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.webView loadRequest:request];

    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    UIView *titleView = nil;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    [activityView startAnimating];
    titleView = activityView;
    self.navigationItem.titleView = titleView;
    
    if (self.post || self.postURL) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                   target:self
                                                                                   action:@selector(actionButtonTapped:)];
        [rightItem setTintColor:[UIColor colorWithRed:0.00 green:0.55 blue:0.80 alpha:1.0]];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if (self.webView.isLoading) {
        [activityView startAnimating];
        titleView = activityView;
        self.navigationItem.titleView = titleView;
    } else {
        [activityView stopAnimating];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            // check if the device is an iPhone
            titleView = [[MMMLogoImageView alloc] init];
            self.navigationItem.titleView = titleView;
        }
    }
}

- (void)performActionForLinkClickWithType:(MMMLinkClickType)linkClickType URL:(NSURL *)URL {
    if (linkClickType == MMMLinkClickTypeInternal) {
        [self pushToNewDetailViewControllerWithURL:URL];
    } else if (linkClickType == MMMLinkClickTypeExternal) {
        [self pushToSFSafariViewControllerWithURL:URL];
    }
}

#pragma mark - Protocols

#pragma mark - WKWebView KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"] && object == self.webView) {
        // Update the right item on the navbar acordingly
        [self setupNavigationBar];
    }
}

#pragma mark - NSNotifications

- (void)reloadWebViewsNotificationReceived:(NSNotification *)notification {
    [self.webView reload];
}

#pragma mark - WKNavigationDelegate Delegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSURL *targetURL = navigationAction.request.URL;

    //http://stackoverflow.com/questions/25713069/why-is-wkwebview-not-opening-links-with-target-blank
    if (!navigationAction.targetFrame.isMainFrame) {
        MMMLinkClickType linkClickType = ([targetURL.absoluteString containsString:MMMBaseURL] || [targetURL.absoluteString containsString:MMMDisqusBaseURL]) ? MMMLinkClickTypeInternal : MMMLinkClickTypeExternal;
        [self performActionForLinkClickWithType:linkClickType URL:targetURL];
    }
    
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    NSURL *targetURL = navigationAction.request.URL;

    MMMLinkClickType linkClickType = ([targetURL.absoluteString containsString:MMMBaseURL]) ? MMMLinkClickTypeInternal : MMMLinkClickTypeExternal;

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [self performActionForLinkClickWithType:linkClickType URL:targetURL];

        actionPolicy = WKNavigationActionPolicyCancel;
    } else if (navigationAction.navigationType == WKNavigationTypeOther) {
        // Semi-hack sollution to capture URL selection when there's a javascript redirect.
        // http://tech.vg.no/2013/09/13/dissecting-javascript-clicks-in-uiwebview/

        // For javascript-triggered links
        NSString *documentURL = navigationAction.request.mainDocumentURL.absoluteString;

        // If they are the same this is a javascript href click
        if ([targetURL.absoluteString isEqualToString:documentURL]) {
            if (!self.webView.isLoading) {
                [self performActionForLinkClickWithType:linkClickType URL:targetURL];

                actionPolicy = WKNavigationActionPolicyCancel;
            }
        }
    }

    decisionHandler(actionPolicy);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupWebView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebViewsNotificationReceived:) name:MMMReloadWebViewsNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // hack to reload the post if logging in to disqus
    if ([self.webView.URL.absoluteString containsString:MMMDisqusBaseURL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MMMReloadWebViewsNotification object:nil];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"loading"];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
