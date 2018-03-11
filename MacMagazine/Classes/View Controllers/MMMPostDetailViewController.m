#import <AVFoundation/AVFoundation.h>
#import <PureLayout/PureLayout.h>
#import <SafariServices/SafariServices.h>
#import <Tweaks/FBTweakInline.h>
#import <WebKit/WebKit.h>

#import "MMMPostDetailViewController.h"
#import "MMMLogoImageView.h"
#import "MMMPost.h"
#import "MMMPostsTableViewController.h"
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

@property BOOL shouldHideHomeIndicator;

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic) UIBarButtonItem *rightItem;

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
    destinationViewController.isURLOpendedInternally = YES;
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
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleLight)];
    [generator prepare];
    [generator impactOccurred];
    if (!self.webView.URL) {
        return;
    }
    
    NSURL *url = [[NSURL alloc] init];
    if([self.post thumbnail] == nil) {
        url = [NSURL URLWithString:self.webView.URL.absoluteString];
    } else {
        url = [NSURL URLWithString:[self.post thumbnail]];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *postThumbnail = [[UIImage alloc] initWithData:data];

    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    if (self.post) {
        [activityItems addObject:self.post.title];
    }
    [activityItems addObject:self.webView.URL];
    [activityItems addObject:postThumbnail];
    [self mmm_shareActivityItems:activityItems fromBarButtonItem:self.rightItem completion:nil];
}

- (void)actionNextPost:(id)sender {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleLight)];
    [generator prepare];
    [generator impactOccurred];
	
	MMMPostsTableViewController *parent = (MMMPostsTableViewController *)self.navigationController.parentViewController.childViewControllers[0];
	[parent nextPost:^(NSDictionary *response) {
		[self setPost:response[@"post"]];
		self.currentTableViewIndexPath = response[@"index"];
		[self setupWebView];
	}];

}

- (void)actionPreviousPost:(id)sender {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleLight)];
    [generator prepare];
    [generator impactOccurred];

	MMMPostsTableViewController *parent = (MMMPostsTableViewController *)self.navigationController.parentViewController.childViewControllers[0];
	[parent previousPost:^(NSDictionary *response) {
		[self setPost:response[@"post"]];
		self.currentTableViewIndexPath = response[@"index"];
		[self setupWebView];
	}];
}

#pragma mark - Preview Actions

- (NSArray<id> *)previewActionItems {
    UIPreviewAction *sharePreviewAction = [UIPreviewAction actionWithTitle:@"Compartilhar" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator prepare];
        [generator notificationOccurred:(UINotificationFeedbackTypeSuccess)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sharePost" object:nil];
    }];

    UIPreviewAction *cancelPreviewAction = [UIPreviewAction actionWithTitle:@"Cancelar" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleLight)];
        [generator prepare];
        [generator impactOccurred];
    }];

    NSArray *previewActions = @[sharePreviewAction, cancelPreviewAction];
    return previewActions;
}

#pragma mark - Instance Methods

- (void)dismissDetailView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [(UINavigationController *)self.splitViewController.viewControllers[0] popToRootViewControllerAnimated:YES];
    });
}

- (void)setupWebView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.webView.alpha = 0.0;
	[UIView commitAnimations];
	
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

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
		self.view.backgroundColor = [UIColor darkGrayColor];
		
	} else {
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		self.navigationController.navigationBar.tintColor = self.view.tintColor;
		self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
		self.view.backgroundColor = [UIColor whiteColor];
	}

	self.titleView = nil;
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView setFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    [self.activityView startAnimating];
    self.titleView = self.activityView;
    self.navigationItem.titleView = self.titleView;
	
	bool isPhone = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);

    if (self.webView.isLoading) {
        [self.activityView startAnimating];
        self.titleView = self.activityView;
        self.navigationItem.titleView = self.titleView;
    } else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		self.webView.alpha = 1.0;
		[UIView commitAnimations];

        [self.activityView stopAnimating];
        if (isPhone) {
            // check if the device is an iPhone
            self.titleView = [[MMMLogoImageView alloc] init];
            self.navigationItem.titleView = self.titleView;
        }
    }

    if (self.post && self.postURL) {

		NSMutableArray *icons = [@[] mutableCopy];

		if (isPhone) {
			CGFloat iconSize = 32.0;

			UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
			[rightButton setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
			[rightButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			
			// UIView just to handle the UIBarButtonItem position
			UIView *rightButtonView = [[UIView alloc] init];
			[rightButton setFrame:CGRectMake(0, 0, iconSize, iconSize)];
			[rightButtonView setFrame:CGRectMake(0, 0, iconSize, iconSize)];
			
			rightButtonView.bounds = CGRectOffset(rightButtonView.bounds, -10, 0);
			[rightButtonView addSubview:rightButton];
			self.rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

			[icons addObject:self.rightItem];

			UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
			[nextButton setImage:[UIImage imageNamed:@"nextPostIcon"] forState:UIControlStateNormal];
			[nextButton addTarget:self action:@selector(actionNextPost:) forControlEvents:UIControlEventTouchUpInside];
			
			// UIView just to handle the UIBarButtonItem position
			UIView *nextButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
			nextButtonView.bounds = CGRectOffset(nextButtonView.bounds, -10, -4);
			[nextButtonView addSubview:nextButton];
			
			UIBarButtonItem *nextPostRightItem = [[UIBarButtonItem alloc] initWithCustomView:nextButtonView];
			
			UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
			[previousButton setImage:[UIImage imageNamed:@"previousPostIcon"] forState:UIControlStateNormal];
			[previousButton addTarget:self action:@selector(actionPreviousPost:) forControlEvents:UIControlEventTouchUpInside];
			
			// UIView just to handle the UIBarButtonItem position
			UIView *previousButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconSize, iconSize)];
			previousButtonView.bounds = CGRectOffset(previousButtonView.bounds, -10, -4);
			[previousButtonView addSubview:previousButton];
			
			UIBarButtonItem *previousPostRightItem = [[UIBarButtonItem alloc] initWithCustomView:previousButtonView];

            if ((self.currentTableViewIndexPath.row == 0 && self.currentTableViewIndexPath.section == 0) && self.isURLOpendedInternally == NO) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [previousButton setEnabled:NO];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [previousButton setEnabled:YES];
                });
            }

			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
				nextPostRightItem.tintColor = [UIColor whiteColor];
				previousPostRightItem.tintColor = [UIColor whiteColor];
			} else {
				nextPostRightItem.tintColor = self.view.tintColor;
				previousPostRightItem.tintColor = self.view.tintColor;
			}

			[icons addObject:nextPostRightItem];
			[icons addObject:previousPostRightItem];
		} else {
			UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonTapped:)];
			
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
				share.tintColor = [UIColor whiteColor];
			} else {
				share.tintColor = self.view.tintColor;
			}

			self.rightItem = share;
			[icons addObject:self.rightItem];
		}

		self.navigationItem.rightBarButtonItems = icons;
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
			} else {
				if ([webView.URL.absoluteString isEqualToString:@"https://disqus.com/next/login-success/"]) {
					actionPolicy = WKNavigationActionPolicyCancel;
					[self.navigationController popViewControllerAnimated:YES];
				}
			}
        }
    }

    decisionHandler(actionPolicy);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	NSString *fontSize = [[NSUserDefaults standardUserDefaults] stringForKey:@"font-size-settings"];
	if (![fontSize isEqualToString:@""]) {
		NSString *cssURL = [@"https://macmagazine.com.br/wp-content/files/app/" stringByAppendingFormat:@"%@.css", fontSize];
		NSString *javascriptString = @"var fileref = document.createElement('link'); fileref.setAttribute('rel', 'stylesheet'); fileref.setAttribute('type', 'text/css'); fileref.setAttribute('href', '%@'); document.getElementsByTagName('head')[0].appendChild(fileref)";
		NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssURL];
		[webView evaluateJavaScript:javascriptWithCSSString completionHandler:nil];
	}
	fontSize = nil;

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		NSString *cssURL = @"https://macmagazine.com.br/wp-content/files/app/darmode.css";
		NSString *javascriptString = @"var fileref = document.createElement('link'); fileref.setAttribute('rel', 'stylesheet'); fileref.setAttribute('type', 'text/css'); fileref.setAttribute('href', '%@'); document.getElementsByTagName('head')[0].appendChild(fileref)";
		NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssURL];
		[webView evaluateJavaScript:javascriptWithCSSString completionHandler:nil];
	}
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.shouldHideHomeIndicator = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissDetailView)
                                                 name:@"dismissDetailView"
                                               object:nil];

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

- (BOOL)prefersStatusBarHidden {
	[self setNeedsStatusBarAppearanceUpdate];
	return NO;
}

@end

