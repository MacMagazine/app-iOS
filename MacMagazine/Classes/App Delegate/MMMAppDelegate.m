//
//  MMMAppDelegate.m
//  MacMagazine
//
//  Created by Fernando Saragoca on 6/14/15.
//  Copyright (c) 2015 made@sampa. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Tweaks/FBTweakShakeWindow.h>

#import "MMMAppDelegate.h"
#import "SUNCoreDataStore.h"

#pragma mark MMMAppDelegate

@implementation MMMAppDelegate

#pragma mark - Getter/Setters

- (UIWindow *)window {
    if (!_window) {
#ifdef DEBUG
        _window = [[FBTweakShakeWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#else
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#endif
    }

    return _window;
}

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MacMagazine" withExtension:@"momd"];
    [SUNCoreDataStore setupDefaultStoreWithModelURL:modelURL persistentStoreURL:nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    self.window.tintColor = [UIColor colorWithRed:0.25 green:0.66 blue:0.96 alpha:1];
    
    return YES;
}

#pragma mark FBTweaks UI Override


@end
