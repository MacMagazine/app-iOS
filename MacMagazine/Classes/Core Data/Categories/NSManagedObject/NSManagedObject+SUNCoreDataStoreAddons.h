@import CoreData;

@interface NSManagedObject (SUNCoreDataStoreAddons)

- (nullable instancetype)sun_objectInContext:(NSManagedObjectContext * __nonnull)context;

@end
