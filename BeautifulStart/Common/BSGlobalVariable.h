//
//  BSGlobalVariable.h
//  BeautifulStart
//
//  Created by tangbinqi-gm on 14-2-19.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//  1402191137 tangbinqi 存放一些全局的变量，单独列出一个文件，就是希望对一些重要的、常用的变量有一个详细的说明
//


#ifndef BeautifulStart_BSGlobalVariable_h
#define BeautifulStart_BSGlobalVariable_h

#import <Foundation/Foundation.h>

#pragma mark 适配iOS7
NSInteger g_LineBreakByWordWrapping;
NSInteger g_LineBreakByCharWrapping;
NSInteger g_LineBreakByClipping;
NSInteger g_LineBreakByTruncatingHead;
NSInteger g_LineBreakByTruncatingTail;
NSInteger g_LineBreakByTruncatingMiddle;

NSInteger g_TextAlignmentLeft;
NSInteger g_TextAlignmentCenter;
NSInteger g_TextAlignmentRight;
NSInteger g_TextAlignmentJustified; // iOS6之前使用默认属性
NSInteger g_TextAlignmentNatural; // iOS6之前使用默认属性t;



#pragma mark 设备的名字，iPad、iPhone、iPod
//
NSString *g_DeviceNameStr;


#pragma mark 设备的UDID
//
NSString *g_UDIDStr;


#pragma mark 设备的MAC地址
//
NSString *g_MACAddressStr;


#pragma mark 设备的运营商
//
NSString *g_CarrierStr;


#pragma mark 系统版本号
//
NSString *g_SystemVerStr;


#pragma mark 程序的UUID
//
NSString *g_UUIDStr;


#pragma mark 程序的渠道来源
//
NSString *g_ChannelStr;


#pragma mark 程序的网络连接类型
//
NSString *g_NetConTypeStr;


#pragma mark 所有环境的IP地址描述
//
NSArray *g_UrlNameArray;


#pragma mark 所有环境的IP地址
//
NSArray *g_UrlArray;


#pragma mark 是否登录
//
BOOL g_isLoginSuccess; // YES表示已经成功登录，否则未登录


#pragma mark 是否使用HTTPS登陆
//
NSInteger g_isSupportedHTTPS;


#pragma mark 是否使用验证码
//
BOOL g_isNeedCaptcha;


#pragma mark 是否支持自动登录
//
BOOL g_isSupportedAutoLogin;

#pragma mark 总是校验还是登陆三次失败后再校验
//
NSInteger g_isAlwaysCaptcha;


#pragma mark 是否登录超时
//
BOOL g_isSessionTimeOut;


#pragma mark 用户登录得到的数据保存为全局变量
//
NSMutableDictionary *g_userLoginMDict;


#pragma mark 三方登录列表缓存
//
NSArray *g_quickLoginArray;


#pragma mark 抢购列表缓存
//
NSMutableArray *g_rushbuyCacheDataMArray;


#pragma mark 团购列表缓存
//
NSMutableArray *g_groupCacheDataMArray;


#pragma mark 服务器时间
//
NSDate *g_serverTime;


#pragma mark 程序是否从支付宝钱包启动
//
BOOL g_isFromAlipay;


#pragma mark 当前登录是否是三方登录
//
BOOL g_isQuickLogin;


#pragma mark 当前是否登录中，主要是控制登录过程中不允许有其他网络请求
//
BOOL g_isLogining;


BOOL g_loginCancleButtonSelected;

#pragma mark xianglinlin--131107--第三方快速登录成功，跳转到首页，此时首页将要出现的时候，navigationBar要隐藏，但是不要动画效果
//
BOOL g_quickLoginSuccess;

#pragma mark xianglinlin--140207--自动登录网络请求中
BOOL g_isAutoLogining;

#pragma mark tangbinqi--140210--是否自动登录（登录时，是否选中了自动登录按钮）
BOOL g_isSelectedAutoLogin;



#endif
