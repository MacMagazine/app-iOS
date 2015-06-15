//
//  MasterViewController.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/14/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

