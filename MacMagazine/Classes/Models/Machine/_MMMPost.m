// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MMMPost.m instead.

#import "_MMMPost.h"

@implementation MMMPostID
@end

@implementation _MMMPost

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MMMPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MMMPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MMMPost" inManagedObjectContext:moc_];
}

- (MMMPostID*)objectID {
	return (MMMPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"featuredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"featured"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"visibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"visible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic author;

@dynamic categories;

@dynamic content;

@dynamic date;

@dynamic descriptionText;

@dynamic featured;

- (BOOL)featuredValue {
	NSNumber *result = [self featured];
	return [result boolValue];
}

- (void)setFeaturedValue:(BOOL)value_ {
	[self setFeatured:@(value_)];
}

- (BOOL)primitiveFeaturedValue {
	NSNumber *result = [self primitiveFeatured];
	return [result boolValue];
}

- (void)setPrimitiveFeaturedValue:(BOOL)value_ {
	[self setPrimitiveFeatured:@(value_)];
}

@dynamic guid;

@dynamic images;

@dynamic link;

@dynamic pubDate;

@dynamic title;

@dynamic visible;

- (BOOL)visibleValue {
	NSNumber *result = [self visible];
	return [result boolValue];
}

- (void)setVisibleValue:(BOOL)value_ {
	[self setVisible:@(value_)];
}

- (BOOL)primitiveVisibleValue {
	NSNumber *result = [self primitiveVisible];
	return [result boolValue];
}

- (void)setPrimitiveVisibleValue:(BOOL)value_ {
	[self setPrimitiveVisible:@(value_)];
}

@end

@implementation MMMPostAttributes 
+ (NSString *)author {
	return @"author";
}
+ (NSString *)categories {
	return @"categories";
}
+ (NSString *)content {
	return @"content";
}
+ (NSString *)date {
	return @"date";
}
+ (NSString *)descriptionText {
	return @"descriptionText";
}
+ (NSString *)featured {
	return @"featured";
}
+ (NSString *)guid {
	return @"guid";
}
+ (NSString *)images {
	return @"images";
}
+ (NSString *)link {
	return @"link";
}
+ (NSString *)pubDate {
	return @"pubDate";
}
+ (NSString *)title {
	return @"title";
}
+ (NSString *)visible {
	return @"visible";
}
@end

