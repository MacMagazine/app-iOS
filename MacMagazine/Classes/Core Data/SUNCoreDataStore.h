//
//  SUNCoreDataStore.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import CoreData;
@import Foundation;
#import "NSArray+SUNCoreDataStoreAddons.h"
#import "NSManagedObject+SUNCoreDataStoreAddons.h"
#import "NSManagedObjectContext+SUNCoreDataStoreAddons.h"
#import "NSSet+SUNCoreDataStoreAddons.h"

@interface SUNCoreDataStore : NSObject

+ (void)setupDefaultStoreWithModelURL:(NSURL * __nonnull)modelURL persistentStoreURL:(NSURL * __nullable)persistentStoreURL;
+ (nullable instancetype)defaultStore;
- (nullable instancetype)initWithModelURL:(NSURL * __nonnull)modelURL persistentStoreURL:(NSURL * __nullable)persistentStoreURL;

@property (nonatomic, strong, readonly) NSManagedObjectContext * __nonnull mainQueueContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext * __nonnull privateQueueContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator * __nonnull persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel * __nonnull managedObjectModel;
@property (nonatomic, strong, readonly) NSURL * __nonnull modelURL;
@property (nonatomic, strong, readonly) NSURL * __nonnull persistentStoreURL;

@end
