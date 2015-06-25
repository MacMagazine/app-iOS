//
//  PostsTableViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSDate+Formatters.h"
#import "FeaturedPostTableViewCell.h"
#import "MMLabel.h"
#import "MMTableViewHeaderView.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "PostPresenter.h"
#import "PostsTableViewController.h"
#import "PostTableViewCell.h"
#import "SUNCoreDataStore.h"

@interface PostsTableViewController ()

@end

#pragma mark PostsTableViewController

@implementation PostsTableViewController

#pragma mark - Class Methods

#pragma mark - Getters/Setters

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Post entityName]];
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

- (void)configureCell:(PostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.layoutMargins = self.tableView.layoutMargins;
    cell.layoutWidth = self.tableView.bounds.size.width;
    
    NSUInteger numberOfRows = [self.tableView numberOfRowsInSection:indexPath.section];
    cell.separatorView.hidden = (indexPath.row + 1 == numberOfRows);
    
    [[PostPresenter presenter] presentObject:post inView:cell];
}

- (void)fetchMoreData {
    if (!self.canFetchMoreData) {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    [Post getWithPage:self.nextPage success:^(id response) {
        [self.activityIndicatorView stopAnimating];
        self.nextPage += 1;
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.activityIndicatorView stopAnimating];
    }];
}

- (void)handleError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)reloadData {
    if (!self.refreshControl.isRefreshing && self.fetchedResultsController.fetchedObjects.count == 0) {
        [self.refreshControl beginRefreshing];
    }
    
    [Post getWithPage:1 success:^(NSArray *response) {
        self.numberOfResponseObjectsPerRequest = response.count;
        self.nextPage = (self.fetchedResultsController.fetchedObjects.count / MAX(1, self.numberOfResponseObjectsPerRequest)) + 1;
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [self handleError:error];
        [self.refreshControl endRefreshing];
    }];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadData];
    } completion:nil];
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}

#pragma mark - Protocols

#pragma mark - UITableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *identifier = [PostTableViewCell identifier];
    if (post.isFeatured) {
        identifier = [FeaturedPostTableViewCell identifier];
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
    
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:NSStringFromClass([PostDetailViewController class]) preparationBlock:^(UIStoryboardSegue *segue, PostDetailViewController *destinationViewController) {
        destinationViewController.post = post;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger numberOfRemainingCells = labs(indexPath.row - [tableView numberOfRowsInSection:indexPath.section]);
    if (numberOfRemainingCells <= 10) {
        [self fetchMoreData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MMTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MMTableViewHeaderView identifier]];
   
    Post *post = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:post.pubDate]) {
        headerView.titleLabel.text = NSLocalizedString(@"Today", @"");
    } else if ([calendar isDateInYesterday:post.pubDate]) {
        headerView.titleLabel.text = NSLocalizedString(@"Yesterday", @"");
    } else {
        headerView.titleLabel.text = [post.pubDate stringFromTemplate:@"EEEEddMMMM"];
    }
    
    headerView.topSeparatorView.backgroundColor = self.tableView.separatorColor;
    headerView.bottomSeparatorView.backgroundColor = self.tableView.separatorColor;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    Post *post = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:post.pubDate]) {
        return 0;
    }
    
    return [MMTableViewHeaderView height];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    for (NSString *cellIdentifier in @[[PostTableViewCell identifier], [FeaturedPostTableViewCell identifier]]) {
        UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    [self.tableView registerClass:[MMTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:[MMTableViewHeaderView identifier]];
    
    self.title = @"MacMagazine";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navigationBar.frame), CGRectGetWidth(navigationBar.frame), 0.5)];
    separatorView.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
    separatorView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navigationBar addSubview:separatorView];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"SFUIDisplay-Medium" size:18]};

    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
