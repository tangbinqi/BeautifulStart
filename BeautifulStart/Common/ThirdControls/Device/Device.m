//
//  Device.m
//  Queue
//
//  Created by 亓鑫 on 12-12-24.
//  Copyright (c) 2012年 亓鑫. All rights reserved.
//

#import "Device.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#include "OpenUDID.h"


#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#import "Reachability.h"
#import "KeyChainIDFA.h"



//私有方法不要打开,否则无法通过审核
//extern NSString *CTSettingCopyMyPhoneNumber();
@implementation Device

/*
#pragma mark - 获得UDID
+ (NSString*)getUDID
{
    NSString *openUDID = [OpenUDID value];
    [DevelperTools userDefaultsSetObj:openUDID key:UDID];
    return openUDID;
}
 */

/*
#pragma mark - 获得deviceToken
+ (NSString*)getDeviceToken
{
    return [DevelperTools getuserDefaultsObjForKey:DEVICETOKEN];
}
 */

#pragma mark - 获取设备唯一标示
+ (NSString*)getDeviceID
{
    if ([Device getSystemVersion]>=7.0)
    {
        return [KeyChainIDFA getIdfaString]; //获取IDFA唯一标示
    }
    else
    {
        return [Device getMacAddress];   //mac地址
    }

}

#pragma mark - 获得IMEI(私有)
+ (NSString*)getIMEI
{
    return nil;
}


#pragma mark - 获得机型
+(NSString*)getModel
{
    return [[UIDevice currentDevice] model];
}

#pragma mark - 获得分别率
+(NSString*)getResolution
{
    CGSize size_screen = [[UIScreen mainScreen] currentMode].size;
    return [NSString stringWithFormat:@"%.0fx%.0f",size_screen.width,size_screen.height];
}

#pragma mark - 获得屏幕宽
+(NSString*)getScreenWidth
{
    CGSize size_screen = [[UIScreen mainScreen] currentMode].size;
    return [NSString stringWithFormat:@"%.0f",size_screen.width];
}

#pragma mark - 获得屏幕高
+(NSString*)getScreenHeight
{
    CGSize size_screen = [[UIScreen mainScreen] currentMode].size;
    return [NSString stringWithFormat:@"%.0f",size_screen.height];
}


#pragma mark - 获取系统类型
+(NSString*)getSystem
{
    return [[UIDevice currentDevice] systemName];
}

#pragma mark - 获取系统版本
+(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - 获取app应用版本号
+(NSString*)getAppVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleVersion"];
    return version;
}

/*
#pragma mark - 获取渠道号
//获得渠道号
+(NSString*)getChannelNumber
{
    return kPushCerType;
}
*/

/*
#pragma mark - 获取手机号
+ (NSString*)getPhoneNumber
{
    return CTSettingCopyMyPhoneNumber();
}
*/

#pragma mark - 获取运营商名字
+ (NSString*)getOperators
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.carrierName;
}

#pragma mark - Mobile Country Code
+ (NSString*)getMCC
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.mobileCountryCode;
}

#pragma mark - mobileNetworkCode
+ (NSString*)getMNC
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.mobileNetworkCode;
}

#pragma mark - isoCountryCode
+ (NSString*)getICC
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.isoCountryCode;
}

#pragma mark - allowsVOIP
+ (BOOL)getIsAllowsVOIP
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.allowsVOIP;
}

#pragma mark - MAC地址iOS7以下使用
+ (NSString*)getMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}



#pragma mark - 获取网络类型
+ (NSString*)getNetConType
{
    NSString *netType;
    NSInteger status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (status == ReachableViaWiFi)
    {
        netType = @"WIFI";
    }
    else if (status == kReachableViaWWAN)
    {
        netType = @"GPRS";
    }
    else
    {
        netType = @"";
    }
    return netType;
}

#pragma mark - 检查是否有网络
+ (BOOL)isConnected
{
	//创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;

	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;

	//获得连接的标志
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);

	//如果不能获取连接标志，则不能连接网络，直接返回
	if (!didRetrieveFlags)
	{
		return NO;
	}

	//根据获得的连接标志进行判断
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}



#pragma mark - 是否第一次安装启动,对于升级后第一次启动也有效果
+ (BOOL)isFirstInstall
{
    NSString *appVer = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstInstall"];
    if (appVer)
    {
        NSComparisonResult b = [appVer compare:APP_VERSION];
        if (b == NSOrderedAscending) //appVer < APP_VERSION
        {
            return YES;
        }
        return NO;
    }
    else
    {
        return YES;
    }
}




@end
