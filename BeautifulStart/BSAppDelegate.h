//
//  BSAppDelegate.h
//  BeautifulStart
//
//  Created by tangbinqi on 13-11-14.
//  Copyright (c) 2013年 tangbinqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRootViewController.h"

@interface BSAppDelegate : UIResponder <UIApplicationDelegate, NGTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (strong, nonatomic) BSRootViewController *rootViewController;

@end
