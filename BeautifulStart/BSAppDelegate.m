//
//  BSAppDelegate.m
//  BeautifulStart
//
//  Created by tangbinqi on 13-11-14.
//  Copyright (c) 2013年 tangbinqi. All rights reserved.
//
#import "BSAppDelegate.h"
//#import "ModelBase.h"
#import <iOSShare/ModelBase.h>

@implementation BSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.rootViewController = [[BSRootViewController alloc] initWithDelegate:self];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
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

////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(150.f, 60.f);
    } else {
        return CGSizeMake(64.f, 49.f);
    }
}

- (void)tabBarController:(NGTabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
                 atIndex:(NSUInteger)index
{
//    if (index == 3) {
//        [tabBarController setTabBarHidden:YES animated:YES];
//    }
//    if (index == 4) {
//        tabBarController.tabBarHidden = NO;
//    }
}




@end
