//
//  SUNCoreDataStore.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "SUNCoreDataStore.h"

@interface SUNCoreDataStore ()

@end

#pragma mark SUNCoreDataStore

@implementation SUNCoreDataStore

static SUNCoreDataStore *_defaultStore;

#pragma mark - Class Methods

+ (void)setupDefaultStoreWithModelURL:(NSURL * __nonnull)modelURL persistentStoreURL:(NSURL * __nullable)persistentStoreURL {
    _defaultStore = [[self alloc] initWithModelURL:modelURL persistentStoreURL:persistentStoreURL];
}

+ (instancetype)defaultStore {
    return _defaultStore;
}

#pragma mark - Getters/Setters

@synthesize mainQueueContext = _mainQueueContext;
@synthesize privateQueueContext = _privateQueueContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize modelURL = _modelURL;
@synthesize persistentStoreURL = _persistentStoreURL;

- (NSManagedObjectContext *)mainQueueContext {
    if (_mainQueueContext) {
        return _mainQueueContext;
    }
    
    _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    _mainQueueContext.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSOverwriteMergePolicyType];
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext {
    if (_privateQueueContext) {
        return _privateQueueContext;
    }
    
    _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _privateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    _privateQueueContext.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSOverwriteMergePolicyType];
    
    return _privateQueueContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel || !self.modelURL) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];

    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:nil]) {
        [[NSFileManager defaultManager] removeItemAtURL:[self persistentStoreURL] error:nil];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:nil]) {
            NSLog(@"Error adding persistent store. %@, %@", error, error.userInfo);
        } else {
            NSLog(@"Generated new sqlite file.");
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)persistentStoreURL {
    if (_persistentStoreURL) {
        return _persistentStoreURL;
    }
    
    NSURL *fileDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    _persistentStoreURL = [fileDirectory URLByAppendingPathComponent:@"Database.sqlite"];
    
    return _persistentStoreURL;
}

#pragma mark - Instance Methods

- (instancetype)initWithModelURL:(NSURL * __nonnull)modelURL persistentStoreURL:(NSURL * __nullable)persistentStoreURL {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _persistentStoreURL = persistentStoreURL;
    _modelURL = modelURL;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:)name:NSManagedObjectContextDidSaveNotification object:self.privateQueueContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:self.mainQueueContext];
    
    return self;
}

- (NSDictionary *)persistentStoreOptions {
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.mainQueueContext performBlock:^{
            [self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.privateQueueContext performBlock:^{
            [self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

@end
