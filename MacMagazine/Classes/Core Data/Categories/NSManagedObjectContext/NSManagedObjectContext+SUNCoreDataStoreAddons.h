//
//  NSManagedObjectContext+SUNCoreDataStoreAddons.h
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/20/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

@import CoreData;

@interface NSManagedObjectContext (SUNCoreDataStoreAddons)

- (void)sun_deleteObjects:(NSSet * __nullable)objects;
- (void)sun_save;

@end
