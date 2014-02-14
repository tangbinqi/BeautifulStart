//
//  Device.h
//  Queue
//
//  Created by 亓鑫 on 12-12-24.
//  Copyright (c) 2012年 亓鑫. All rights reserved.

/**********************************
  1.关于设备信息的轻封装类
  2.主要用来获取统计用的设备信息
  3.其中大量方法并未全部暴露,按需暴露,酌情添加
 **********************************/

#import <Foundation/Foundation.h>

@interface Device : NSObject

//+(NSString*)getUDID;//UDID,暂时不用
//+(NSString*)getChannelNumber;//渠道号

+ (NSString*)getDeviceID;//获取设备唯一标示,7=idfa,7以下mac地址
+ (float)getSystemVersion;//获取系统版本
+ (NSString*)getScreenWidth;//屏幕宽
+ (NSString*)getScreenHeight;//屏幕高
+ (NSString*)getMacAddress;//MAC地址
+ (NSString*)getNetConType;//获取设备当前网络类型
+ (BOOL)isConnected;//检查是否有网络
+ (BOOL)isFirstInstall;//是否第一次启动

@end
