//
//  AppDelegate.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-21.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "AppDelegate.h"
#import <FYX/FYX.h>
#import "ProximityServiceManager.h"
#import "ShopperOutOfRangeViewController.h"
#import "ShopperNavigationController.h"
#import "DeepLinkHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIViewController *rootViewController = [[ShopperOutOfRangeViewController alloc] init];
    ShopperNavigationController *navigationController = [[ShopperNavigationController alloc] initWithRootViewController:rootViewController];

    
    [self.window setRootViewController:navigationController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //NURUN DEV ACCOUNT
//    [FYX setAppId:@"4f53a393ed869b1b0acfc159e177a77b34eccd7313e6c429dbbd6be4c9b589d2" appSecret:@"77a08eda0ea7ac891b359e926f9e28d9dda9aaea12094bdbf4999ba459b098d4" callbackUrl:@"initialnuruntest://"];
    
    //EMMANUEL DEV ACCOUNT
    [FYX setAppId:@"7ff749aebafb25ed94422b2a45e234c1668ba8f76186dab5fe3915b926800afc" appSecret:@"1ddeab96ce80ab5729fb752f598dd918a7ad50e031206ffa88dfd2d4738ba6f0" callbackUrl:@"initialnuruntest://authcode"];

    
    [ProximityServiceManager sharedManager];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Local Notification" message:notification.alertBody delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alertView show];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [FYX handleOpenURL:url];
    [DeepLinkHelper handleDeepLinkURL:url];
    return YES;
}



@end
