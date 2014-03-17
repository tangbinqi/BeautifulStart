//
//  Extension.h
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef iTrends_Extension_h
#define iTrends_Extension_h

#pragma mark -UIKit
#import "UILabel+Extension.h"
#import "UIFont+Extension.h"
#import "UIColor+Extension.h"
#import "UIGestureRecognizer+Extension.h"
#import "DQJKAlertView.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"
#import "UIImage+Extension.h"
#import "NSObject+Extention.h"
#import "UIView+Extension.h"
#import "UIButton+Extension.h"
#import "NSData+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSURL+Extension.h"
#import "UIDevice+Extension.h"
#import "NSArray+Extension.h"

#pragma mark -Views
#import "PullRefreshTable.h"

#pragma mark -CoreLocation
#import "CLLocation+Extension.h"


#import "ModelList.h"


///////////////////////
//ddlog
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
////////////////////////

//提供一种在dealloc中release使用的方法，防止过度release
#define Release(obj) \
if (obj==nil) {\
NSLog(@"Release an nil object");\
}\
if (obj.retainCount==0) {\
NSLog(@"Release more than once ! check");\
}\
[obj release];\
obj = nil;
//是否为iPad界面
#define IsIpad [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad
//是否为iPhone界面
#define IsIphone [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone


#define DEVICE_LATER_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 1136.0f), [[UIScreen mainScreen] currentMode].size) : NO)


#define DEVICE_5_DIFFERENCE (88.0f)
#endif
