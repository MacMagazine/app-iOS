//
//  NSManagedObject+SUNCoreDataStoreAddons.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import CoreData;

@interface NSManagedObject (SUNCoreDataStoreAddons)

- (nullable instancetype)sun_objectInContext:(NSManagedObjectContext * __nonnull)context;

@end
