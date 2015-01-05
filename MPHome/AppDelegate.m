//
//  AppDelegate.m
//  MPHome
//
//  Created by oasis on 12/8/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "AppDelegate.h"
#import "MPBrowseViewController.h"
#import "UIColor+ThemeColors.h"
#import "MPPortaitNavigationController.h"

#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"SKAMXdtfD893Zkm7YyN2gbSouWFMJdjLtIJifw1c"
                  clientKey:@"UXpvzE96IrtMTOin9YISbfj2gdxGB3SUsSdEl0Qk"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MPBrowseViewController *browseViewController = [MPBrowseViewController new];
    
    self.window.rootViewController = [[MPPortaitNavigationController alloc]initWithRootViewController:browseViewController];
    
    // Set navigation bar color
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];

    // Set status bar text to white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // first run detection
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        NSLog(@"App has launched before");
    }
    else {
        NSLog(@"App first launch");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
