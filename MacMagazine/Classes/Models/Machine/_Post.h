// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

@import CoreData;

extern const struct PostAttributes {
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *categories;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *featured;
	__unsafe_unretained NSString *guid;
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *link;
	__unsafe_unretained NSString *pubDate;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *visible;
} PostAttributes;

@class NSObject;

@class NSObject;

@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PostID* objectID;

@property (nonatomic, strong) NSString* author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id categories;

//- (BOOL)validateCategories:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* descriptionText;

//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* featured;

@property (atomic) BOOL featuredValue;
- (BOOL)featuredValue;
- (void)setFeaturedValue:(BOOL)value_;

//- (BOOL)validateFeatured:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* guid;

//- (BOOL)validateGuid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id images;

//- (BOOL)validateImages:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* link;

//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* pubDate;

//- (BOOL)validatePubDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* visible;

@property (atomic) BOOL visibleValue;
- (BOOL)visibleValue;
- (void)setVisibleValue:(BOOL)value_;

//- (BOOL)validateVisible:(id*)value_ error:(NSError**)error_;

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)

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
