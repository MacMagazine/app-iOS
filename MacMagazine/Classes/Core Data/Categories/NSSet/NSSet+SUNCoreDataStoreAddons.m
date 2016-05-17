#import "NSSet+SUNCoreDataStoreAddons.h"
#import "NSManagedObject+SUNCoreDataStoreAddons.h"

#pragma mark NSSet (SUNCoreDataStoreAddons)

@implementation NSSet (SUNCoreDataStoreAddons)

#pragma mark - Instance Methods

- (NSSet *)sun_objectsInContext:(NSManagedObjectContext *)context {
    __block NSMutableSet *result = [[NSMutableSet alloc] initWithCapacity:self.count];
    [context performBlockAndWait:^{
        [self enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
            [result addObject:[object sun_objectInContext:context]];
        }];
    }];
    return [NSSet setWithSet:result];
}

@end
