//
//  BSComMacro.h
//  BeautifulStart
//
//  Created by tangbinqi-gm on 13-11-15.
//  Copyright (c) 2013年 tangbinqi. All rights reserved.
//  存放一些公共的宏定义
//


#ifndef BeautifulStart_BSComMacro_h
#define BeautifulStart_BSComMacro_h

// 201310291050 suxunbo 加入版本控制宏定义
#define IsIOS7Lower ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) // iOS7以下
#define IsIOS6Lower ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0) // iOS6以下
#define IsIOS5Lower ([[[UIDevice currentDevice] systemVersion] floatValue]<5.0) // iOS5以下
#define IsIOS4_3Lower ([[[UIDevice currentDevice] systemVersion] floatValue]<4.3) // iOS4.3以下






// 去Log，与iPad保持一致
#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif






// 系统版本号
#pragma mark - 系统的版本号
#define APP_VERSION         @"0.1.0"

#pragma mark - 发版本的时间
#define APP_VERSION_TIME    @"0917_1211"

#pragma mark - 当前版本的说明
#define APP_VERSION_DESC    @"适配iOS7"




// 使用银联手机支付，UPPay，由于目前是否上不确定，先加一个宏定义开关
#define USE_UPPAY




#pragma mark - 以前的需求，是否显示图片
#define LoadImageKey @"UnLoadImage"


#pragma mark - 打印LOG使用，能打印LOG所在的文件，函数名等细节
//
#define FUNCNAME [NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]
#define FUNCNAME_TBQ [NSString stringWithFormat:@"...tbq...%@...", \
[NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]]









#pragma mark - 网络提示语
//
#define NO_NET_DESC         @"网络不给力，请检查您的网络设置"
#define NO_MORE_DATA_DESC   @"无更多信息"


//#pragma mark 判断设备是否Retina屏幕
//// 通用，适合iPad和iPhone
//#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1536,2048), [[UIScreen mainScreen] currentMode].size) : NO)

//判断设备是否IPHONE5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



#pragma mark 屏幕的高和宽
//
#define screenH   [UIScreen mainScreen].bounds.size.height
#define screenW   [UIScreen mainScreen].bounds.size.width

//配置自定义nav的高度
#define kNavBarHeight (64)
// 适配ios7之后，自定义导航栏的左右button的tag
#define kBarLeftButton_Tag    99901
#define kBarRightButton_Tag   99902


#pragma mark - 字体格式
// 全角，用于显示中文
#define FONT_QUAN_JIAO_SIZE(fontSize)   [UIFont systemFontOfSize:(fontSize)]
// 半角，用于显示数字和英文
#define FONT_BAN_JIAO_SIZE(fontSize)    [UIFont fontWithName:@"Arial" size:(fontSize)]
// 字体加粗
#define BOLD_FONT_SIZE(fontSize)        [UIFont boldSystemFontOfSize:(fontSize)]
// 黑体
#define FONT_HEITI_SIZE(fontSize)       [UIFont fontWithName:@"Heiti SC" size:(fontSize)]


#pragma mark - 字体大小
//
#define SYSTEM_FONT_12   12
#define SYSTEM_FONT_13   13
#define SYSTEM_FONT_14   14
#define SYSTEM_FONT_15   15
#define SYSTEM_FONT_16   16

#define CELL_CONTENT_WIDTH 300
#define CELL_CONTENT_MARGIN 10
#define CELL_DEFAULT_HEIGHT 45


#define MAIN_COLOR   [UIColor colorWithRed:255.0/255.0 green:0/255 blue:128.0/255.0 alpha:1]

#endif