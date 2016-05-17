@import CoreData;

@interface NSManagedObjectContext (SUNCoreDataStoreAddons)

- (void)sun_deleteObjects:(NSSet * __nullable)objects;
- (void)sun_save;

@end
