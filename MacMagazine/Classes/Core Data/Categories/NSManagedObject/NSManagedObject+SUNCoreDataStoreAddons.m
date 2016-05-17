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
