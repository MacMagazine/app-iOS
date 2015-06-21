//
//  NSArray+SUNCoreDataStoreAddons.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import CoreData;
@import Foundation;

@interface NSArray (SUNCoreDataStoreAddons)

- (nonnull NSArray *)sun_objectsInContext:(NSManagedObjectContext * __nonnull)context;

@end
