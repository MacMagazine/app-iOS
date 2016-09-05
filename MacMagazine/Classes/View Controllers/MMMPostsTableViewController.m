#import <PureLayout/PureLayout.h>
#import <TSMessages/TSMessage.h>

#import "MMMPostsTableViewController.h"
#import "MMMFeaturedPostTableViewCell.h"
#import "MMMLabel.h"
#import "MMMLogoImageView.h"
#import "MMMPost.h"
#import "MMMPostDetailViewController.h"
#import "MMMPostPresenter.h"
#import "MMMPostTableViewCell.h"
#import "MMMTableViewHeaderView.h"
#import "NSDate+Formatters.h"
#import "SUNCoreDataStore.h"
#import "UIViewController+ShareActivity.h"

#pragma mark MMMPostsTableViewController

@implementation MMMPostsTableViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SUNCoreDataStore defaultStore].mainQueueContext sectionNameKeyPath:@"date" cacheName:nil];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - Instance Methods

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
}

- (void)reloadData {
    if (!self.refreshControl.isRefreshing && self.fetchedResultsController.fetchedObjects.count == 0) {
        [self.refreshControl beginRefreshing];
    }
    
    [MMMPost getWithPage:1 success:^(NSArray *response) {
        self.numberOfResponseObjectsPerRequest = response.count;
        self.nextPage = 2;
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        MMMPostDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.post = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    }

    [super prepareForSegue:segue sender:sender];
}

- (void)applyRefreshControlFix {
    if (!self.refreshControl.isRefreshing) {
        [self.tableView sendSubviewToBack:self.refreshControl];
    }
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

    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segueIdentifier = NSStringFromClass([MMMPostDetailViewController class]);
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger numberOfSections = [tableView numberOfSections];
    if (indexPath.section + 1 != numberOfSections) {
        return;
    }
    
    NSUInteger numberOfRemainingCells = labs(indexPath.row - [tableView numberOfRowsInSection:indexPath.section]);
    if (numberOfRemainingCells <= 10) {
        [self fetchMoreData];
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

#pragma mark - Long press gesture

- (void)enableLongPressGesture
{
    SEL selector = @selector(handleLongPress:);
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:selector];
    [self.tableView addGestureRecognizer:longPressGesture];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint gesturePoint = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:gesturePoint];
        if (indexPath == nil) return;

        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSURL *postURL = [NSURL URLWithString:post.link];
        if (!postURL) {
            return;
        }

        NSMutableArray *activityItems = [[NSMutableArray alloc] init];
        if (post) {
            [activityItems addObject:post.title];
        }
        [activityItems addObject:postURL];

        [self mmm_shareActivityItems:activityItems completion:^(NSString * _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}


#pragma mark - NSFetchedResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

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

    [self.tableView registerNib:[MMMPostTableViewCell nib] forCellReuseIdentifier:[MMMPostTableViewCell identifier]];
    [self.tableView registerNib:[MMMFeaturedPostTableViewCell nib] forCellReuseIdentifier:[MMMFeaturedPostTableViewCell identifier]];
    [self.tableView registerClass:[MMMTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:[MMMTableViewHeaderView identifier]];
    
    self.tableView.estimatedRowHeight = 100;
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

    [self enableLongPressGesture];

    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:animated];
    }

    [self.navigationController setToolbarHidden:YES animated:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
