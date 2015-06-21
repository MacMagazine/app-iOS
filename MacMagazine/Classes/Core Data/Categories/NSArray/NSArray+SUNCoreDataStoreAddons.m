//
//  NSArray+SUNCoreDataStoreAddons.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import "NSArray+SUNCoreDataStoreAddons.h"
#import "NSManagedObject+SUNCoreDataStoreAddons.h"

#pragma mark NSArray (SUNCoreDataStoreAddons)

@implementation NSArray (SUNCoreDataStoreAddons)

#pragma mark - Instance Methods

- (NSArray *)sun_objectsInContext:(NSManagedObjectContext *)context {
    __block NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    [context performBlockAndWait:^{
        [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            [result addObject:[object sun_objectInContext:context]];
        }];
    }];
    return [NSArray arrayWithArray:result];
}

@end
