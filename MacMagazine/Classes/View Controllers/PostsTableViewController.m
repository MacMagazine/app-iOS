//
//  PostsTableViewController.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSDate+Formatters.h"
#import "Post.h"
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
        self.nextPage = (self.fetchedResultsController.fetchedObjects.count / self.numberOfResponseObjectsPerRequest) + 1;
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

#pragma mark - UITableView delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:self.tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    Post *post = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:post.pubDate]) {
        return NSLocalizedString(@"Today", @"");
    } else if ([calendar isDateInYesterday:post.pubDate]) {
        return NSLocalizedString(@"Yesterday", @"");
    } else {
        return [post.pubDate stringFromTemplate:@"EEEEddMMMM"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger numberOfRemainingCells = labs(indexPath.row - [tableView numberOfRowsInSection:indexPath.section]);
    if (numberOfRemainingCells <= 10) {
        [self fetchMoreData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MacMagazine";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = self.footerView;
    self.dequeueReusableCellIdentifier = [PostTableViewCell identifier];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self reloadData];
}

@end
