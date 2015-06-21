//
//  AppDelegate.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/14/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AppDelegate.h"
#import "SUNCoreDataStore.h"

@interface AppDelegate ()

@end

#pragma mark AppDelegate

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SUNCoreDataStore setupDefaultStoreWithModelURL:[[NSBundle mainBundle] URLForResource:@"MacMagazine" withExtension:@"momd"] persistentStoreURL:nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}

@end
