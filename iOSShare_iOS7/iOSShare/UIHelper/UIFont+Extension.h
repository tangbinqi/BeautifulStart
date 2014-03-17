//
//  UIFont+Extension.h
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 返回指定大小的系统字体
 */
#define F_S(size) [UIFont systemFontOfSize:size]

@interface UIFont (Extension)
//只指定大小，用默认字体
+(id)fontWithSize:(CGFloat)size;

/**
 加粗的字体
 */
+(id)fontBoldWithSize:(CGFloat)size;
@end
