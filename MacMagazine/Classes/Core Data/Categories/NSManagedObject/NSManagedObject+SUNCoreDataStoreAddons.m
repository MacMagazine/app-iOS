//
//  NSManagedObject+SUNCoreDataStoreAddons.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSManagedObject+SUNCoreDataStoreAddons.h"

#pragma mark NSManagedObject (SUNCoreDataStoreAddons)

@implementation NSManagedObject (SUNCoreDataStoreAddons)

#pragma mark - Instance Methods

- (instancetype)sun_objectInContext:(NSManagedObjectContext *)context {
    if (self.managedObjectContext == context) {
        return self;
    }
    
    __block NSManagedObject *object;
    [context performBlockAndWait:^{
        object = [context objectWithID:self.objectID];
    }];
    return object;
}

@end
