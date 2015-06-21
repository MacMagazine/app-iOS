// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.m instead.

#import "_Post.h"

const struct PostAttributes PostAttributes = {
	.author = @"author",
	.categories = @"categories",
	.content = @"content",
	.date = @"date",
	.descriptionText = @"descriptionText",
	.featured = @"featured",
	.guid = @"guid",
	.images = @"images",
	.link = @"link",
	.pubDate = @"pubDate",
	.title = @"title",
	.visible = @"visible",
};

@implementation PostID
@end

@implementation _Post

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (PostID*)objectID {
	return (PostID*)[super objectID];
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

