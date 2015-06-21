//
//  NSManagedObjectContext+SUNCoreDataStoreAddons.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSManagedObjectContext+SUNCoreDataStoreAddons.h"
#import "NSSet+SUNCoreDataStoreAddons.h"

#pragma mark NSManagedObjectContext (SUNCoreDataStoreAddons)

@implementation NSManagedObjectContext (SUNCoreDataStoreAddons)

#pragma mark - Instance Methods

- (void)sun_deleteObjects:(NSSet *)objects {
    [[objects sun_objectsInContext:self] enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [self deleteObject:obj];
    }];
}

- (void)sun_save {
    NSError *error = nil;
    if (self.hasChanges && ![self save:&error]) {
        NSLog(@"%@ - %@", error.localizedDescription, error.userInfo);
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[error localizedFailureReason] userInfo:@{NSUnderlyingErrorKey: error}];
    }
}

@end
