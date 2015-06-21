//
//  PostsTableViewController.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <SUNKit/SUNTableViewController.h>

@interface PostsTableViewController : SUNTableViewController

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (assign, nonatomic) NSUInteger nextPage;
@property (assign, nonatomic) NSUInteger numberOfResponseObjectsPerRequest;

- (BOOL)canFetchMoreData;
- (void)fetchMoreData;
- (void)handleError:(NSError *)error;
- (void)reloadData;

@end
