// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MMMPost.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class NSObject;

@class NSObject;

@interface MMMPostID : NSManagedObjectID {}
@end

@interface _MMMPost : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MMMPostID*objectID;

@property (nonatomic, strong, nullable) NSString* author;

@property (nonatomic, strong, nullable) id categories;

@property (nonatomic, strong, nullable) NSString* content;

@property (nonatomic, strong) NSString* date;

@property (nonatomic, strong, nullable) NSString* descriptionText;

@property (nonatomic, strong) NSNumber* featured;

@property (atomic) BOOL featuredValue;
- (BOOL)featuredValue;
- (void)setFeaturedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* guid;

@property (nonatomic, strong, nullable) id images;

@property (nonatomic, strong, nullable) NSString* link;

@property (nonatomic, strong) NSDate* pubDate;

@property (nonatomic, strong, nullable) NSString* title;

@property (nonatomic, strong) NSNumber* visible;

@property (atomic) BOOL visibleValue;
- (BOOL)visibleValue;
- (void)setVisibleValue:(BOOL)value_;

@end

@interface _MMMPost (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAuthor;
- (void)setPrimitiveAuthor:(NSString*)value;

- (id)primitiveCategories;
- (void)setPrimitiveCategories:(id)value;

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSString*)primitiveDate;
- (void)setPrimitiveDate:(NSString*)value;

- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;

- (NSNumber*)primitiveFeatured;
- (void)setPrimitiveFeatured:(NSNumber*)value;

- (BOOL)primitiveFeaturedValue;
- (void)setPrimitiveFeaturedValue:(BOOL)value_;

- (NSString*)primitiveGuid;
- (void)setPrimitiveGuid:(NSString*)value;

- (id)primitiveImages;
- (void)setPrimitiveImages:(id)value;

- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;

- (NSDate*)primitivePubDate;
- (void)setPrimitivePubDate:(NSDate*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveVisible;
- (void)setPrimitiveVisible:(NSNumber*)value;

- (BOOL)primitiveVisibleValue;
- (void)setPrimitiveVisibleValue:(BOOL)value_;

@end

@interface MMMPostAttributes: NSObject 
+ (NSString *)author;
+ (NSString *)categories;
+ (NSString *)content;
+ (NSString *)date;
+ (NSString *)descriptionText;
+ (NSString *)featured;
+ (NSString *)guid;
+ (NSString *)images;
+ (NSString *)link;
+ (NSString *)pubDate;
+ (NSString *)title;
+ (NSString *)visible;
@end

NS_ASSUME_NONNULL_END
