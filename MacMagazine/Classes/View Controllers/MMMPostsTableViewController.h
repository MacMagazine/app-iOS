//
//  MMMPostsTableViewController.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SUNKit/SUNTableViewController.h>

@interface MMMPostsTableViewController : SUNTableViewController

@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) NSUInteger nextPage;
@property (nonatomic) NSUInteger numberOfResponseObjectsPerRequest;

- (BOOL)canFetchMoreData;
- (void)fetchMoreData;
- (void)handleError:(NSError *)error;
- (void)reloadData;

@end
