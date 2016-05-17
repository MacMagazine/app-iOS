@import CoreData;
@import Foundation;

@interface NSSet (SUNCoreDataStoreAddons)

- (nonnull NSSet *)sun_objectsInContext:(NSManagedObjectContext * __nonnull)context;

@end
