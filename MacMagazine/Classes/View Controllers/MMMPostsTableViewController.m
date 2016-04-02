//
//  MMMPostsTableViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "MMMPostsTableViewController.h"
#import "MMMFeaturedPostTableViewCell.h"
#import "MMMLabel.h"
#import "MMMPost.h"
#import "MMMPostDetailViewController.h"
#import "MMMPostPresenter.h"
#import "MMMPostTableViewCell.h"
#import "MMMTableViewHeaderView.h"
#import "NSDate+Formatters.h"
#import "SUNCoreDataStore.h"

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

- (void)configureCell:(MMMPostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                             message:error.localizedFailureReason
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)reloadData {
    if (!self.refreshControl.isRefreshing && self.fetchedResultsController.fetchedObjects.count == 0) {
        [self.refreshControl beginRefreshing];
    }
    
    [MMMPost getWithPage:1 success:^(NSArray *response) {
        self.numberOfResponseObjectsPerRequest = response.count;
        self.nextPage = (self.fetchedResultsController.fetchedObjects.count / MAX(1, self.numberOfResponseObjectsPerRequest)) + 1;
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Protocols

#pragma mark - UITableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *identifier = [MMMPostTableViewCell identifier];
    if (post.featuredValue) {
        identifier = [MMMFeaturedPostTableViewCell identifier];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell layoutIfNeeded];
    if (cell.frame.size.width != tableView.frame.size.width) {
        cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
        [cell layoutIfNeeded];
        [cell layoutSubviews];
    }
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MMMPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:NSStringFromClass([MMMPostDetailViewController class]) preparationBlock:^(UIStoryboardSegue *segue, MMMPostDetailViewController *destinationViewController) {
        destinationViewController.post = post;
        destinationViewController.posts = self.fetchedResultsController.fetchedObjects;
    }];
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
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:post.pubDate]) {
        headerView.titleLabel.text = NSLocalizedString(@"Today", @"");
    } else if ([calendar isDateInYesterday:post.pubDate]) {
        headerView.titleLabel.text = NSLocalizedString(@"Yesterday", @"");
    } else {
        headerView.titleLabel.text = [post.pubDate mmm_stringFromTemplate:@"EEEEddMMMM"].uppercaseString;
    }
    
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

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];

    for (NSString *cellIdentifier in @[[MMMPostTableViewCell identifier], [MMMFeaturedPostTableViewCell identifier]]) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    [self.tableView registerClass:[MMMTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:[MMMTableViewHeaderView identifier]];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navigationBar.frame), CGRectGetWidth(navigationBar.frame), 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    separatorView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navigationBar addSubview:separatorView];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm_logo"]];
    logoImageView.frame = CGRectMake(0, 0, 34, 34);
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoImageView;

    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

@end
