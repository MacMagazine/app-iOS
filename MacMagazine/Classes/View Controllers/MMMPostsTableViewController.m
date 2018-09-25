#import <PureLayout/PureLayout.h>
#import <StoreKit/StoreKit.h>
#import <TSMessages/TSMessage.h>

#import "MMMPostsTableViewController.h"
#import "HexColor.h"
#import "MMMFeaturedPostTableViewCell.h"
#import "MMMLabel.h"
#import "MMMLogoImageView.h"
#import "MMMNavigationBar.h"
#import "MMMPost.h"
#import "MMMPostDetailViewController.h"
#import "MMMPostPresenter.h"
#import "MMMPostTableViewCell.h"
#import "MMMTableViewHeaderView.h"
#import "NSDate+Formatters.h"
#import "SUNCoreDataStore.h"
#import "UIViewController+ShareActivity.h"

static NSString * const MMMReloadTableViewsNotification = @"com.macmagazine.notification.tableview.reload";

@interface MMMPostsTableViewController ()

@property (nonatomic, weak) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) NSIndexPath *selectedPostIndexPath;
@property (nonatomic) int variableControlForFetchedResults;
@property (nonatomic) BOOL isRunningInFullScreen;
@property (nonatomic) BOOL isTableViewCellSelected;

@end

#pragma mark MMMPostsTableViewController

@implementation MMMPostsTableViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize callbackBlock;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MMMPost entityName]];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO],
									 [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO],
									 [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"visible = %@", @YES];
	fetchRequest.returnsObjectsAsFaults = NO;
	
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SUNCoreDataStore defaultStore].mainQueueContext sectionNameKeyPath:@"date" cacheName:@"MMMCache"];
	_fetchedResultsController.delegate = self;
	
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

	return _fetchedResultsController;
}

#pragma mark - Actions

- (IBAction)settingsAction:(id)sender {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleLight)];
    [generator prepare];
    [generator impactOccurred];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

#pragma mark - Instance Methods

- (void)popUpRatingAppView {
    NSInteger appNumberOfCalls = [[NSUserDefaults standardUserDefaults] integerForKey:@"appNumberOfCalls"];
    if(appNumberOfCalls % 50 == 0) {
        [SKStoreReviewController requestReview];
    }
}

- (void)previousPost:(MMCallbackBlock)block {
	self.callbackBlock = block;
	
	NSInteger currentIndexPathRow = self.selectedIndexPath.row;
	NSInteger currentIndexPathSection = self.selectedIndexPath.section;
	
	NSInteger totalofRowsRowInPrevSection = [self.tableView numberOfRowsInSection:self.selectedIndexPath.section] - 1;
	if (self.selectedIndexPath.section > 0) {
		totalofRowsRowInPrevSection = [self.tableView numberOfRowsInSection:self.selectedIndexPath.section - 1] - 1;
	}
	
	NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.selectedIndexPath.row == 0) {
		if (self.selectedIndexPath.section > 0) {
			index = [NSIndexPath indexPathForRow:totalofRowsRowInPrevSection inSection:--currentIndexPathSection];
		}
	} else {
		index = [NSIndexPath indexPathForRow:--currentIndexPathRow inSection:currentIndexPathSection];
	}
	
	self.selectedIndexPath = index;
	MMMPost *post = [self.fetchedResultsController objectAtIndexPath:index];
	self.callbackBlock(@{@"post": post, @"index": index});
}

- (void)nextPost:(MMCallbackBlock)block {
	self.callbackBlock = block;

	NSInteger currentIndexPathRow = self.selectedIndexPath.row;
	NSInteger currentIndexPathSection = self.selectedIndexPath.section;
	NSInteger totalofRowsRowInSection = [self.tableView numberOfRowsInSection:self.selectedIndexPath.section] - 1;

	NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.selectedIndexPath.row == totalofRowsRowInSection) {
		index = [NSIndexPath indexPathForRow:0 inSection:++currentIndexPathSection];
	} else {
		index = [NSIndexPath indexPathForRow:++currentIndexPathRow inSection:currentIndexPathSection];
	}

	self.selectedIndexPath = index;
	MMMPost *post = [self.fetchedResultsController objectAtIndexPath:index];
	self.callbackBlock(@{@"post": post, @"index": index});
}

- (void)shortCutAction {
    if(self.isTableViewCellSelected == YES) {
        if(self.selectedIndexPath.row != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissDetailView" object:self];
            [self selectTableViewCellAtIndexPath:0 andTheCurrentIndexPathSection:0];
        }
    } else {
        [self selectTableViewCellAtIndexPath:0 andTheCurrentIndexPathSection:0];
    }
}

- (void)selectTableViewCellAtIndexPath:(NSInteger)indexPathRow andTheCurrentIndexPathSection:(NSInteger)indexPathSection {
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForRow:indexPathRow inSection:indexPathSection];
            [self.tableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
        });
    });
}

- (void)sharePost {
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:self.selectedPostIndexPath];
    NSURL *postURL = [NSURL URLWithString:post.link];
    if (!postURL) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[post thumbnail]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *postThumbnail = [[UIImage alloc] initWithData:data];
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    [activityItems addObject:post.title];
    [activityItems addObject:postURL];
    [activityItems addObject:postThumbnail];
    [self mmm_shareActivityItems:activityItems completion:nil];
}

- (BOOL)canFetchMoreData {
    if (self.activityIndicatorView.isAnimating) {
        return NO;
    }
    
    if (self.nextPage <= 1) {
        return NO;
    }
    
    return YES;
}

- (void)configureCell:(__kindof MMMTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.layoutMargins = self.tableView.layoutMargins;
    cell.layoutWidth = CGRectGetWidth(self.tableView.bounds);
    
    NSUInteger numberOfRows = [self.tableView numberOfRowsInSection:indexPath.section];
    cell.separatorView.hidden = (indexPath.row + 1 == numberOfRows);
    
    MMMPostPresenter *presenter = [[MMMPostPresenter alloc] initWithObject:post];
    [presenter setupView:cell];
}

- (void)fetchMoreData {
    if (!self.canFetchMoreData) {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    [MMMPost getWithPage:self.nextPage success:^(id response) {
        [self.activityIndicatorView stopAnimating];
        self.nextPage += 1;
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.activityIndicatorView stopAnimating];
    }];
}

- (void)handleError:(NSError *)error {
    [TSMessage showNotificationWithTitle:error.localizedDescription
                                subtitle:error.localizedFailureReason
                                    type:TSMessageNotificationTypeError];
    
    // Hide error message after 0.6s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [TSMessage dismissActiveNotification];
    });
}

- (void)reloadData {
    if (!self.refreshControl.isRefreshing && self.fetchedResultsController.fetchedObjects.count == 0) {
        [self.refreshControl beginRefreshing];
    }
    
    [MMMPost getWithPage:1 success:^(NSArray *response) {
        self.numberOfResponseObjectsPerRequest = response.count;
        self.nextPage = 2;
        [self.refreshControl endRefreshing];
		
		if ([self.tableView numberOfSections] > 0 && [self.tableView numberOfRowsInSection:0] > 0) {
			NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if (![[segue identifier] isEqualToString:@"settingsSegue"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		MMMPostDetailViewController *detailViewController = (MMMPostDetailViewController *) navigationController.topViewController;
		NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
		detailViewController.currentTableViewIndexPath = selectedIndexPath;
		detailViewController.isURLOpendedInternally = NO;
		
		if (self.postID) {
			detailViewController.postURL = [NSURL URLWithString:self.postID];
		} else {
			if (selectedIndexPath) {
				detailViewController.post = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
			}
		}
	}
	
    [super prepareForSegue:segue sender:sender];
}

- (void)applyRefreshControlFix {
    if (!self.refreshControl.isRefreshing) {
        [self.tableView sendSubviewToBack:self.refreshControl];
    }
}

- (void)selectFirstTableViewCell {
    // check if the device is an iPad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && self.fetchedResultsController.fetchedObjects.count > 0) {
        if(self.isRunningInFullScreen == YES) {
            NSUInteger row = 0;
            NSUInteger section = 0;
            
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSelection"];
            if (dict) {
                NSDate *date = dict[@"date"];
                // Verify if the last selected post is greater than 12 hours
                NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
                int numberOfHours = secondsBetween / 3600;
                if (numberOfHours < 12) {
                    row = [dict[@"selectedCellIndexPathRow"] integerValue];
                    section = [dict[@"selectedCellIndexPathSection"] integerValue];
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                if (section > [self.tableView numberOfSections] || row > [self.tableView numberOfRowsInSection:section]) {
                    selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
				[self.tableView scrollToRowAtIndexPath:selectedCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                [self.tableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
            });
            self.variableControlForFetchedResults++;
        }
    }
}

- (void)reloadTableViewsNotificationReceived:(NSNotification *)notification {
	[self setMode];
	
	[NSFetchedResultsController deleteCacheWithName:@"MMMCache"];
	_fetchedResultsController = nil;
	self.variableControlForFetchedResults = 0;
	[self.tableView reloadData];

	[UIView animateWithDuration:0.4f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^(){
						 self.tableView.alpha = 0;
					 }
					 completion:^(BOOL finished){
						 [UIView animateWithDuration:0.4f
											   delay:0.2f
											 options:UIViewAnimationOptionCurveEaseInOut
										  animations:^(){
											  self.tableView.alpha = 1;
										  }
										  completion:^(BOOL finished){
											  [self reloadData];
										  }];

					 }];


}

#pragma mark - Protocols

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *identifier = [MMMPostTableViewCell identifier];
    if (post.featuredValue) {
        identifier = [MMMFeaturedPostTableViewCell identifier];
    }
    
    __kindof MMMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    [cell layoutIfNeeded];
    
    if (CGRectGetWidth(cell.frame) != CGRectGetWidth(tableView.frame)) {
        cell.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(cell.frame));
        [cell layoutIfNeeded];
        [cell layoutSubviews];
    }
	
	UIView *selectedBackgroundView = [[UIView alloc] init];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		selectedBackgroundView.backgroundColor = [UIColor grayColor];
	} else {
		selectedBackgroundView.backgroundColor = [UIColor colorWithRed:((float)0/(float)255) green:((float)138/(float)255) blue:((float)202/(float)255) alpha:0.3];
	}
	cell.selectedBackgroundView = selectedBackgroundView;

    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Used only when received a push notification
    self.postID = nil;
    self.isTableViewCellSelected = YES;
    
    // check if the cell is already selected
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone || self.selectedIndexPath != indexPath) {
        [[NSUserDefaults standardUserDefaults] setObject:@{@"selectedCellIndexPathRow": @(indexPath.row), @"selectedCellIndexPathSection": @(indexPath.section), @"date": [NSDate date]} forKey:@"lastSelection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *segueIdentifier = NSStringFromClass([MMMPostDetailViewController class]);
        [self performSegueWithIdentifier:segueIdentifier sender:nil];
    }
    
    self.selectedIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MMMTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	cell.separatorView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		cell.separatorView.backgroundColor = [UIColor colorWithHexString:@"#2d2d2d"];
	}

    NSUInteger numberOfSections = [tableView numberOfSections];
    if (indexPath.section + 1 != numberOfSections) {
        return;
    }
    
    NSUInteger numberOfRemainingCells = labs(indexPath.row - [tableView numberOfRowsInSection:indexPath.section]);
    if (numberOfRemainingCells <= 10) {
        [self fetchMoreData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull MMMTableViewHeaderView *)view forSection:(NSInteger)section {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		view.titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		view.contentView.backgroundColor = [UIColor blackColor];
	} else {
		view.titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		view.contentView.backgroundColor = [UIColor clearColor];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MMMTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MMMTableViewHeaderView identifier]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MMMPostPresenter *presenter = [[MMMPostPresenter alloc] initWithObject:post];
    headerView.titleLabel.text = presenter.sectionTitle;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:post.pubDate]) {
        return 0;
    }
    
    return [MMMTableViewHeaderView height];
}

#pragma mark - UISplitViewDelegate delegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location {
    // check if viewController is not already displayed in the preview controller
    if ([self.presentedViewController isKindOfClass:[MMMPostDetailViewController class]]) {
        return nil;
    }
    
    CGPoint cellPosition = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cellPosition];
    
    if (indexPath) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MMMPostDetailViewController *previewViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MMMPostDetailViewController class])];
        
        // Used only to share post through preview action
        self.selectedPostIndexPath = indexPath;
        
        // send data to previewViewController
        previewViewController.post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        return previewViewController;
    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.isRunningInFullScreen = CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
    
    if ([self isForceTouchAvailable]) {
        if (!self.previewingContext) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    } else {
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
        }
    }
}

#pragma mark - Long press gesture

- (void)enableLongPressGesture {
    // check if the device is an iPhone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && self.fetchedResultsController.fetchedObjects.count > 0) {
        SEL selector = @selector(handleLongPress:);
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:selector];
        [self.tableView addGestureRecognizer:longPressGesture];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint gesturePoint = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:gesturePoint];
        if (indexPath == nil) return;
        
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSURL *postURL = [NSURL URLWithString:post.link];
        if (!postURL) {
            return;
        }
        
        NSURL *url = [NSURL URLWithString:[post thumbnail]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *postThumbnail = [[UIImage alloc] initWithData:data];
        
        NSMutableArray *activityItems = [[NSMutableArray alloc] init];
        if (post) {
            [activityItems addObject:post.title];
        }
        [activityItems addObject:postURL];
        [activityItems addObject:postThumbnail];
        
        [self mmm_shareActivityItems:activityItems completion:^(NSString * _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}

#pragma mark - NSFetchedResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    if (self.variableControlForFetchedResults == 0) {
        [self selectFirstTableViewCell];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate delegate

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (void)setMode {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dark_mode"]) {
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
		self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
		self.tableView.backgroundColor = [UIColor colorWithHexString:@"#181818"];
		
		[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor blackColor]];

		MMMNavigationBar *navBar = (MMMNavigationBar *)self.navigationController.navigationBar;
		navBar.separatorView.backgroundColor = [UIColor colorWithHexString:@"#4c4c4c"];

	} else {
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#0097d4"];
		self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#0097d4"];
		self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithHexString:@"#0097d4"];
		UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
		self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
		[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];

		MMMNavigationBar *navBar = (MMMNavigationBar *)self.navigationController.navigationBar;
		navBar.separatorView.backgroundColor = [UIColor colorWithRed:0.78 green:0.80 blue:0.84 alpha:0.80];
	}

}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setMode];

    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    self.splitViewController.delegate = self;
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shortCutAction)
                                                 name:@"shortCutAction"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sharePost)
                                                 name:@"sharePost"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyRefreshControlFix)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushReceived:)
                                                 name:@"pushReceived"
                                               object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reloadTableViewsNotificationReceived:) name:MMMReloadTableViewsNotification
											   object:nil];

    [self.tableView registerNib:[MMMPostTableViewCell nib] forCellReuseIdentifier:[MMMPostTableViewCell identifier]];
    [self.tableView registerNib:[MMMFeaturedPostTableViewCell nib] forCellReuseIdentifier:[MMMFeaturedPostTableViewCell identifier]];
    [self.tableView registerClass:[MMMTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:[MMMTableViewHeaderView identifier]];
    
    self.tableView.estimatedRowHeight = 100;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 60)];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [footerView addSubview:activityIndicatorView];
    [activityIndicatorView autoCenterInSuperviewMargins];
    self.activityIndicatorView = activityIndicatorView;
    self.tableView.tableFooterView = footerView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
	
	self.navigationItem.titleView = [[MMMLogoImageView alloc] init];
    self.variableControlForFetchedResults = 0;
    self.isTableViewCellSelected = NO;
    [self enableLongPressGesture];
    [self popUpRatingAppView];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.33f;
    
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:animated];
    }
    
    self.isTableViewCellSelected = NO;
    
    [self.navigationController setToolbarHidden:YES animated:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pushReceived:(NSNotification *)notification {
    self.postID = [notification object];
    
    NSString *segueIdentifier = NSStringFromClass([MMMPostDetailViewController class]);
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
}

@end
