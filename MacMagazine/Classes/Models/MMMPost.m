//
//  MMMPost.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/14/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Ono/Ono.h>

#import "MMMPost.h"
#import "NSDate+Formatters.h"
#import "NSDateFormatter+Addons.h"
#import "SUNCoreDataStore.h"

static NSString * const kMMFeaturedCategoryName = @"Destaques";
static NSString * const kMMRequestUserAgent = @"Feedburner";
static NSString * const kMMRSSFeedPath = @"https://macmagazine.com.br/feed/";

#pragma mark Post

@implementation MMMPost

#pragma mark - Class Methods

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *sessionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [sessionManager.requestSerializer setValue:kMMRequestUserAgent forHTTPHeaderField:@"User-Agent"];
        [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/rss+xml", @"text/xml", nil]];
    });
    return sessionManager;
}

+ (void)getWithPage:(NSUInteger)page success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [[self sessionManager] GET:kMMRSSFeedPath parameters:@{@"paged" : @(page)} progress:nil success:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSManagedObjectContext *context = [SUNCoreDataStore defaultStore].privateQueueContext;
        [context performBlock:^{
            NSError *error;
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseData error:&error];
            if (error) {
                if (failure) failure(error);
                return;
            }
            
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"guid" ascending:YES]];
            NSArray *cache = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                if (failure) failure(error);
                return;
            }
            
            NSArray *visiblePosts = [cache filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"visible = %@", @YES]];
            NSSet *visiblePostsGuids = [NSSet setWithArray:[visiblePosts valueForKey:@"guid"]];
            
            __block BOOL cleanVisiblePosts = YES;
            NSMutableArray *responseObjects = [NSMutableArray new];
            [document enumerateElementsWithXPath:@"channel//item" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                NSString *guid = [element firstChildWithTag:@"guid"].stringValue;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid = %@", guid];
                MMMPost *post = [cache filteredArrayUsingPredicate:predicate].firstObject;
                if (!post) {
                    post = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
                    post.guid = guid;
                }
                
                NSMutableSet *categories = [NSMutableSet new];
                [element enumerateElementsWithXPath:@"category" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                    NSString *name = element.stringValue;
                    if ([name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
                        [categories addObject:name];
                    }
                }];
                
                NSMutableArray *images = [NSMutableArray new];
                ONOXMLDocument *contentDocument = [ONOXMLDocument HTMLDocumentWithString:[element firstChildWithTag:@"encoded"].stringValue encoding:NSUTF8StringEncoding error:nil];
                [contentDocument.rootElement enumerateElementsWithXPath:@"//img" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                    NSString *path = [element valueForAttribute:@"src"];
                    if ([path containsString:@"?"]) {
                        path = [path componentsSeparatedByString:@"?"].firstObject;
                    }
                    [images addObject:path];
                }];
                
                NSDateFormatter *dateFormatter = [NSDateFormatter mmm_formatterWithKey:@"Post pubDate" block:^(NSDateFormatter *dateFormatter) {
                    dateFormatter.dateFormat = @"EEE, dd MMMM yyyy HH:mm:ss Z";
                    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                }];
                
                NSDateFormatter *timeFreeFormatter = [NSDateFormatter mmm_formatterWithKey:@"Post date" block:^(NSDateFormatter *dateFormatter) {
                    dateFormatter.dateFormat = @"yyyy.MM.dd";
                    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                }];
                
                post.title = [element firstChildWithTag:@"title"].stringValue;
                post.link = [element firstChildWithTag:@"link"].stringValue;
                post.pubDate = [dateFormatter dateFromString:[element firstChildWithTag:@"pubDate"].stringValue];
                post.date = [timeFreeFormatter stringFromDate:post.pubDate];
                post.author = [element firstChildWithTag:@"creator"].stringValue;
                post.descriptionText = [element firstChildWithTag:@"description"].stringValue;
                post.content = [element firstChildWithTag:@"encoded"].stringValue;
                post.featuredValue = [categories containsObject:kMMFeaturedCategoryName];
                post.categories = categories;
                post.visible = @YES;
                post.images = images;
                [responseObjects addObject:post];
                
                if (cleanVisiblePosts) {
                    cleanVisiblePosts = ![visiblePostsGuids containsObject:post.guid];
                }
            }];
            
            if (cleanVisiblePosts && page <= 1) {
                [visiblePosts makeObjectsPerformSelector:@selector(setVisible:) withObject:@NO];
            }
            
            [context sun_save];
            
            NSArray *objects = [responseObjects sun_objectsInContext:[SUNCoreDataStore defaultStore].mainQueueContext];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(objects);
            });
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure(error);
    }];
}

#pragma mark - Instance Methods

- (NSArray *)categoriesArray {
    return self.categories;
}

- (NSArray *)imagesArray {
    return self.images;
}

- (NSString *)thumbnail {
    return self.imagesArray.firstObject;
}

@end
