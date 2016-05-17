@import CoreData;
@import Foundation;

@interface NSArray (SUNCoreDataStoreAddons)

- (nonnull NSArray *)sun_objectsInContext:(NSManagedObjectContext * __nonnull)context;

@end
