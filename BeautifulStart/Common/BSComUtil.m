//
//  BSAppDelegate.h
//  BSComUtil
//
//  Created by tangbinqi on 13-11-14.
//  Copyright (c) 2013年 tangbinqi. All rights reserved.
//

#import "BSComUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "MBProgressHUD.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "BSAppDelegate.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "KeyChainIDFA.h"
#import <AdSupport/AdSupport.h>

@implementation BSComUtil

+ (UIColor *)getCellDefColor{
    return [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
}
+ (float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+ (UIColor *)getTextGrayColor{
    return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
}
+ (UIColor *)getTextRushGrayColor{
    return [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
}
+ (UIColor *)getTextLightGrayColor{
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
}
+ (UIColor *)getRedDefTextColor{
    return [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0];
}
+ (UIColor *)getBlackDefTextColor{
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}
+ (UIColor *)getBlueDefTextColor{
    return [UIColor colorWithRed:0/255.0 green:102/255.0 blue:204/255.0 alpha:1.0];
}
+ (UIColor *)getTableViewSelectColor{
    return [UIColor colorWithRed:1.0 green:233/255.0 blue:219/255.0 alpha:1.0];
}
+ (UIColor*)getBbcColor {
    return [UIColor colorWithWhite:0 alpha:0.2];
}
+ (UIColor*)getBackgroundColor {
	return [UIColor colorWithPatternImage:[BSComUtil getImageWithFileName:@"bg"]];
}
+ (UIFont*)getTableDescTextFont {
    return [UIFont systemFontOfSize:15];
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg tag:(NSInteger)tag delete:(id)aDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:aDelete cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = tag;
    [alert show];
    
}

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
	Byte iv[] = {1,2,3,4,5,6,7,8};
	NSString *ciphertext = nil;
	const char *textBytes = [plainText UTF8String];
	NSUInteger dataLength = [plainText length];
	unsigned char buffer[1024];
	memset(buffer, 0, sizeof(char));
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
										  kCCOptionPKCS7Padding,
										  [key UTF8String], kCCKeySizeDES,
										  iv,
										  textBytes, dataLength,
										  buffer, 1024,
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
		ciphertext = [data base64Encoding];
	}
	return ciphertext;
}

+ (NSString *) encryptNoBase64UseDES:(NSString *)plainText key:(NSString *)key
{
	Byte *iv=(Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
	NSString *ciphertext = nil;
	const char *textBytes = [plainText UTF8String];
	NSUInteger dataLength = [plainText length];
	unsigned char buffer[1024];
	memset(buffer, 0, sizeof(char));
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
										  kCCOptionPKCS7Padding,
										  [key UTF8String], kCCKeySizeDES,
										  iv,
										  textBytes, dataLength,
										  buffer, 1024,
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
		ciphertext = [[NSString tokenString:data] uppercaseString];
	}
	return ciphertext;
}


+ (NSString *) macaddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            msgBuffer =(char*) malloc(length) ;
            if ((msgBuffer) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        //  DLog(@"Error: %@", errorFlag);
        // 2013 1206 1441 suxunbo 返回失败即可
        return nil;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    // DLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

//+ (NSString *)getIDFA
//{
//    // 2013-12-06 14:22 suxunbo 由于后台发现获取MAC地址偶尔会发生错误，所以更改逻辑
//    NSString *IDFAStr = [KeyChainIDFA getIdfaString]; //获取IDFA唯一标示
//    
//    if ([IDFAStr isKindOfClass:[NSString class]] && ([IDFAStr length]>0)) // 以前保存过
//    {
//        // 由于之前偶尔获取MAC出问题，这里只能将所有失败信息都判断一下，嗨，罪过啊
//        if (([IDFAStr isEqualToString:@"if_nametoindex failure"])
//            || ([IDFAStr isEqualToString:@"sysctl mgmtInfoBase failure"])
//            || ([IDFAStr isEqualToString:@"buffer allocation failure"])
//            || ([IDFAStr isEqualToString:@"sysctl msgBuffer failure"]))
//        {
//            // 失败的话就用，并重新保存一下
//            if ([GMComUtil systemVersion]>=6.0)
//            {
//                IDFAStr = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString];
//            }
//            else
//            {
//                IDFAStr = [GMComUtil getUUID];
//            }
//            
//            [KeyChainIDFA setIdfaString:IDFAStr];
//        }
//    }
//    else // 之前没有保存过，生成一个
//    {
//        if ([GMComUtil systemVersion]>=7.0) // iOS7，采用IDFA
//        {
//            //iOS7第一测试模拟器      9c85968d-27c6-4b7d-8996-149e2ec1ca7f
//            //删除app后运行          9c85968d-27c6-4b7d-8996-149e2ec1ca7f
//            IDFAStr = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString];
//        }
//        else // iOS7一下，取MAC
//        {
//            // 根据后台反馈，有时拿不到MAC地址，所以要加一个保护
//            NSString *tempMAC = [GMComUtil macaddress];   //mac地址
//            if (([tempMAC length] > 0) && ([tempMAC length] == 17)) // mac地址OK
//            {
//                IDFAStr = tempMAC;   //mac地址
//            }
//            else // 如果获取不到MAC，就用IDFA或UUID
//            {
//                if ([GMComUtil systemVersion]>=6.0) // iOS6取IDFA
//                {
//                    IDFAStr = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString];
//                }
//                else // iOS6一下取UUID
//                {
//                    IDFAStr = [GMComUtil getUUID];
//                }
//            }            
//        }
//        
//        [KeyChainIDFA setIdfaString:IDFAStr];
//    }
//    
//    return IDFAStr;
//}

+ (NSString *)getUUID {
    NSString *storeUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    if (!storeUUID) {
        CFUUIDRef uuid_ref = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuid_string_ref= CFUUIDCreateString(kCFAllocatorDefault, uuid_ref);
        
        CFRelease(uuid_ref);
        NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        if (!uuid) {
            uuid = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CFRelease(uuid_string_ref);
        return uuid;
    }
    return storeUUID;
}

//+ (NSString *)getOpenUDID
//{
//    NSString *openUDID = [OpenUDID value];
//    return openUDID;
//}
//+ (BOOL)isFirstUse {
//	if ([GMSqlite queryInstallInfo]) {
//		return NO;
//	}
//	else {
//		return YES;
//	}
//	return NO;
//}
+ (BOOL)isFirstInstall {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstInstall"]) {
        return NO;
    }
    return YES;
}
+ (NSString*)getDeviceVer{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
+ (BOOL)isIpad {	
	if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			return YES;
		}
	}
	if ([[[self getDeviceVer] substringToIndex:4] isEqualToString:@"iPad"]) {
		return YES;
	}
	return NO;
}
+ (BOOL)isRetina {
	return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, iPhone5?1136:960), [[UIScreen mainScreen] currentMode].size) : NO;
}
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
+ (NSString *)getTransImageUrlWithURL:(NSString *)urlStr scale:(int)size{
    if (![urlStr isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSString *nameStr = [[urlStr lastPathComponent] stringByDeletingPathExtension];
    NSRange range = [nameStr rangeOfString:@"_" options:NSBackwardsSearch];
    if (range.length == 0) {
        return urlStr;
    }
    NSString *sizeStr = [nameStr substringFromIndex:range.location+1];
    
    if ([sizeStr intValue]==size) {
        return urlStr;
    }else {
        NSString *aStr = [urlStr stringByDeletingLastPathComponent];
        if (aStr.length > 6) {
            //hu 0801添加，经过上面的操作后，发现http://变成了http:/，需添加一个“/”
            if (![[aStr substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"/"]) {
                aStr = [NSString stringWithFormat:@"%@/%@",[aStr substringToIndex:6],[aStr substringFromIndex:6]];
            }
        }
        NSString *bStr = [nameStr substringToIndex:range.location];
        NSString *rStr = [NSString stringWithFormat:@"%@/%@_%d.%@",aStr,bStr,size,[urlStr pathExtension]];
        return rStr;
    }    
}
+ (NSString *)getTransImageUrlWithURL:(NSString *)urlStr size:(NSString*)size {
    if (![urlStr isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSString *nameStr = [[urlStr lastPathComponent] stringByDeletingPathExtension];//提取路径的最后一个组成部分并从文件的最后一部分删除扩展名
    NSRange range = [nameStr rangeOfString:@"_" options:NSBackwardsSearch];
    if (range.length == 0) {
        return urlStr;
    }    
    NSString *aStr = [urlStr stringByDeletingLastPathComponent];//删除路径的最后一个组成部分
    NSString *bStr = [nameStr substringToIndex:range.location];
    NSString *rStr = [NSString stringWithFormat:@"%@/%@_%@.%@",aStr,bStr,size,[urlStr pathExtension]];
    return rStr;    
}
+ (UILabel *)getCellCommonLabelWithSize:(CGRect)frame textColor:(UIColor *)color fontSize:(float)fontSize text:(NSString *)text {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    [lab setText:text];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:color];
    [lab setTextAlignment:g_TextAlignmentLeft];
    [lab setNumberOfLines:0];
    [lab setLineBreakMode:g_LineBreakByCharWrapping];
    [lab setFont:[UIFont systemFontOfSize:fontSize]];
    return lab;

}
//+ (UILabel *)getCellCommonLabelWithSize:(CGRect)frame textColor:(UIColor *)color fontSize:(float)fontSize text:(NSString *)text isBbc:(NSString*)isBbc {
//    if (isBbc && [isBbc isEqual:@"Y"]) {
//        CustomLabel *lab = [[CustomLabel alloc] initWithFrame:frame];
//        lab.firstText = text;
//        lab.font = [UIFont systemFontOfSize:fontSize];
//        lab.firstColor = color;
//        lab.isBbc = YES;
//        return lab;
//    }
//    else {
//        UILabel *lab = [[UILabel alloc] initWithFrame:frame];
//        [lab setText:text];
//        [lab setBackgroundColor:[UIColor clearColor]];
//        [lab setTextColor:color];
//        [lab setTextAlignment:g_TextAlignmentLeft];
//        [lab setNumberOfLines:0];
//        [lab setLineBreakMode:g_LineBreakByCharWrapping];
//        [lab setFont:[UIFont systemFontOfSize:fontSize]];
//        return lab;
//    }
//    return nil;
//}
//+ (UIButton*)getBackButton:(NSString*)title {
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14]];
//    int width = size.width + 20;
//    if (width<50) {
//        width = 50;
//    }
//    if (width>78) {
//        width = 78;
//    }
//    UIImage *image = [[GMComUtil getImageWithFileName:@"back"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
//    UIImage *image1 = [[GMComUtil getImageWithFileName:@"back_hov"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setExclusiveTouch:YES];
//    [backBtn setFrame:CGRectMake(0, 0, width ,30)];
//    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, width-20, 30)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:14];
//    label.text = title;
////    label.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0];
//    label.textColor = [UIColor whiteColor];
//    label.lineBreakMode = g_LineBreakByTruncatingMiddle;
//    label.textAlignment = g_TextAlignmentCenter;    
//    label.shadowOffset = CGSizeMake(0, -1);
//    label.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
//    [backBtn addSubview:label];
//    
//    return backBtn;
//}
//+ (UIButton*)getRightButton:(NSString*)title {
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14]];
//    UIImage *image = [[GMComUtil getImageWithFileName:@"com_button"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//    UIImage *image1 = [[GMComUtil getImageWithFileName:@"com_button_hov"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setExclusiveTouch:YES];
//    [button setFrame:CGRectMake(0, 0, size.width+20 ,30)];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:image1 forState:UIControlStateHighlighted];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];    
//    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    button.titleLabel.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [button setTitleColor:[UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
//    return button;
//}
//
//+ (UIButton*)getFilterButton:(NSString*)title
//{
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14]];
//    UIImage *image = [[GMComUtil getImageWithFileName:@"com_button1"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//    UIImage *image1 = [[GMComUtil getImageWithFileName:@"com_button1"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
//    [button setFrame:CGRectMake(0, 0, size.width+20 ,30)];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:image1 forState:UIControlStateHighlighted];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setExclusiveTouch:YES];
//    return button;
//}

+ (UIButton*)getBlackBackButton:(NSString*)title
{
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14]];
    int width = size.width + 20;
    if (width<50) {
        width = 50;
    }
    if (width>78) {
        width = 78;
    }
    UIImage *image = [[BSComUtil getImageWithFileName:@"shaixuan-fahui"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
    //    UIImage *image1 = [[GMComUtil getImageWithFileName:@"back_hov"] stretchableImageWithLeftCapWidth:30 topCapHeight:10];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setExclusiveTouch:YES];
    [backBtn setFrame:CGRectMake(0, 0, width ,30)];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, width-20, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = title;
    //    label.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = g_LineBreakByTruncatingMiddle;
    label.textAlignment = g_TextAlignmentCenter;
    label.shadowOffset = CGSizeMake(0, -1);
    label.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    [backBtn addSubview:label];
    
    return backBtn;
}

//+ (BOOL)isBottomViewHidden {
//    GMAppDelegate *app = (GMAppDelegate*)[[UIApplication sharedApplication]delegate];
//    return [app isBottomViewHidden];
//}
//+ (void)showBottomView:(BOOL)show animation:(BOOL)animation {
//    GMAppDelegate *app = (GMAppDelegate*)[[UIApplication sharedApplication]delegate];
//    [app showBottomView:show animation:animation];
//}
//+ (void)showBottomView:(BOOL)show {
//    [GMComUtil showBottomView:show animation:YES];
//}
+ (void)cell:(UITableViewCell*)cell setSelectedBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows {
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}
//+ (void)smallBorderCell:(UITableViewCell*)cell setBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows {
//    BOOL oneRow = rows==1?YES:NO;
//    int position = 0;
//    if (!oneRow) {
//        if (indexPath.row == 0) {
//            position = 0;
//        }
//        else if (indexPath.row == rows-1) {
//            position = 2;
//        }
//        else {
//            position = 1;
//        }
//    }
//    CellBackGroundView *imgview = [[CellBackGroundView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
//	imgview.oneRow = oneRow;
//	imgview.position = position;
//    imgview.cornerRadius = 2;
//    cell.backgroundView = imgview;
//}
//+ (void)smallBorderCell:(UITableViewCell*)cell setSelectedBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows {
//    BOOL oneRow = rows==1?YES:NO;
//    int position = 0;
//    if (!oneRow) {
//        if (indexPath.row == 0) {
//            position = 0;
//        }
//        else if (indexPath.row == rows-1) {
//            position = 2;
//        }
//        else {
//            position = 1;
//        }
//    }
//    CellSelectedView *imgview = [[CellSelectedView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
//	imgview.oneRow = oneRow;
//	imgview.position = position;
//    imgview.cornerRadius = 2;
//    cell.selectedBackgroundView = imgview;
//}
+ (MBProgressHUD*)showHud:(UIView*)rootView text:(NSString*)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
    HUD.labelText = text;
    //HUD.color = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:0.9];
    HUD.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:HUD];
    return HUD;
}
+ (UIImage*)getImageWithFileName:(NSString*)name {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]];
}
+ (UIImage*)getImageWithFileNameJPG:(NSString*)name {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"jpg"]];
}
+ (NSString *)getPicPath:(NSString*)fileName {
	return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/imageCache/%@",fileName]];
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	// String should be 6 or 8 characters
	if ([cString length] < 6) 
		return [UIColor blackColor];
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"])
		cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) 
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6)
		return [UIColor blackColor];
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}
+ (CGSize)size:(CGSize)size onstrainedToSize:(CGSize)orignSize {    
    float horizontalRadio = size.width*1.0/orignSize.width;
    float verticalRadio = size.height*1.0/orignSize.height; 
    
    float radio = 1;
    if(verticalRadio<1 && horizontalRadio<1)
    {
        radio = verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio; 
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? 1/horizontalRadio : 1/verticalRadio;  
    }
    
    return CGSizeMake(size.width*radio, size.height*radio);
}



/**
 *	@brief	更新（保存）长登录需要的参数JSESSIONID、DYN_USER_ID、DYN_USER_CONFIRM
 *          目前的做法是先 从cookie里面取出来相关参数，保存在NSUserDefaults中，请求的时候再从NSUserDefaults取出，上传
 *	@param 	dict 	暂时不用
 */
+ (void)setSessionId:(NSDictionary*)dict
 {

	if ([dict isKindOfClass:[NSDictionary class]]) {
		NSString *sessionId = [dict objectForKey:@"jsessionId"];
		if ([sessionId isKindOfClass:[NSString class]]) {
			[[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"sessionID"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSString *sessionId = cookie.value;
        if ([cookie.name isEqualToString:@"BIGipServerpool_atgmobile"] && sessionId.length>1) {
            [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"BIGipServerpool_atgmobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        
    }
}

/**
 *	@brief	更新（保存）长登录需要的参数JSESSIONID、DYN_USER_ID、DYN_USER_CONFIRM
 *          目前的做法是先 从cookie里面取出来相关参数，保存在NSUserDefaults中，请求的时候再从NSUserDefaults取出，上传
 */
+ (void)saveCookiesForUserDefaults
{
    // tangbinqi 2014-01-24  长登录  保存cookie里面的相关参数/////////////////////////////////////////
//    g_isSelectedAutoLogin = NO;    // 登录、注册成功后，为了提高代码效率，在cookie未过期/没有注销登录时，只保存一次cookie
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        NSString *value = cookie.value;
        if ([cookie.name isEqualToString:@"JSESSIONID"] && value.length>1)
        {
            NSDictionary *jssessionID = cookie.properties;
            NSMutableDictionary *m_jssessionID = [NSMutableDictionary dictionaryWithDictionary:jssessionID];
            [[NSUserDefaults standardUserDefaults] setObject:m_jssessionID forKey:@"jsessionIDCookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        
        if ([cookie.name isEqualToString:@"DYN_USER_ID"] && value.length>1)
        {
            NSDictionary *dyn_userID = cookie.properties;
            NSMutableDictionary *m_dyn_userID = [NSMutableDictionary dictionaryWithDictionary:dyn_userID];
            [[NSUserDefaults standardUserDefaults] setObject:m_dyn_userID forKey:@"dyn_userIDCookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if ([cookie.name isEqualToString:@"DYN_USER_CONFIRM"] && value.length>1)
        {
            NSDictionary *dyn_user_confirm = cookie.properties;
            NSMutableDictionary *m_dyn_user_confirm = [NSMutableDictionary dictionaryWithDictionary:dyn_user_confirm];
            [[NSUserDefaults standardUserDefaults] setObject:m_dyn_user_confirm forKey:@"dyn_user_confirmCookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        
        if ([cookie.name isEqualToString:@"BIGipServerpool_atgmobile"] && value.length >1) {
            NSDictionary *bigipServerpool_atgmobile = cookie.properties;
            NSMutableDictionary *m_bigipServerpool_atgmobile = [NSMutableDictionary dictionaryWithDictionary:bigipServerpool_atgmobile];
            [[NSUserDefaults standardUserDefaults] setObject:m_bigipServerpool_atgmobile forKey:@"bigipServerpool_atgmobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
    // tangbinqi 2014-01-24  长登录  保存cookie里面的相关参数/////////////////////////////////////////
}


+ (void)cleanCookie {
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"jsessionIDCookie"];
    // tangbinqi 2014-01-24  长登录  删除之前保存的cookie里面的相关参数/////////////////////////////////////////
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dyn_userIDCookie"];
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dyn_user_confirmCookie"];
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"bigipServerpool_atgmobile"];
    // tangbinqi 2014-01-24  长登录  删除之前保存的cookie里面的相关参数/////////////////////////////////////////
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSArray *array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([array isKindOfClass:[NSArray class]] && array.count>0) {
        NSArray *temp = [NSArray arrayWithArray:array];
        for (NSHTTPCookie *cookie in temp) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
        }
    }
}

+ (BOOL)shouldShowImage {
	NSString *unShow = [[NSUserDefaults standardUserDefaults] objectForKey:LoadImageKey];
	if (unShow) {
		return NO;
	}
	return YES;
}

+ (void)setServerTime:(NSString*)serverTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    g_serverTime = [dateFormatter dateFromString:serverTime];
}

+ (BOOL)isNewDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger desiredComponents = (NSDayCalendarUnit | NSMonthCalendarUnit);
    NSDateComponents *firstComponents = [calendar components:desiredComponents fromDate:g_serverTime];
    NSDateComponents *secondComponents = [calendar components:desiredComponents fromDate:nowDate];
    NSDate *firstWOYear = [calendar dateFromComponents:firstComponents];
    NSDate *SecondWOYear = [calendar dateFromComponents:secondComponents];
    NSComparisonResult result = [firstWOYear compare:SecondWOYear];
        
    g_serverTime = [NSDate date];
    if (result == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

//+ (BOOL)controllerIsFirstResponder:(UIViewController*)controller
//{
//    GMAppDelegate *app = (GMAppDelegate*)[UIApplication sharedApplication].delegate;
//    if ([controller isEqual:[app currentController]]) {
//        return YES;
//    }
//    return NO;
//}
//
//
// 检查电话号码是否正确
//
+ (BOOL)checkPhoneNumber:(NSString *)string
{
    if ([string isMatchedByRegex:@"(1)[0-9]{10}$"])
    {
        return YES;
    }
    return NO;
}

//
// 检查姓名格式是否正确
//
+ (BOOL)checkName:(NSString *)string
{
    if ([[string substringToIndex:1] isEqualToString:@"•"]
        || [[string substringToIndex:1] isEqualToString:@"·"]
        || [[string substringFromIndex:string.length-1] isEqualToString:@"•"]
        || [[string substringFromIndex:string.length-1] isEqualToString:@"·"])
    {
        return NO;
    }
    if (![string isMatchedByRegex:@"^[a-zA-Z\u4e00-\u9fa5•·]+$"])
    {
        return NO;
    }
    
    return YES;
}

//+ (UIImageView *)getNavigationControllerView
//{
//    // 背景图
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [GMComUtil getImageWithFileName:@"header"];
//    [imageView setFrame:CGRectMake(0, 0, screenW, 44)];
//    [imageView setUserInteractionEnabled:YES];
//    return imageView;
//}



/**
 *	@brief	手机号码正则判断
 *
 *	@param 	aPhoneNumber 	一个手机号码字符串
 *
 *	@return	YES 符合正则，NO 不符合
 */
+ (BOOL)isRightFormantByRegexPhoneNumber:(NSString *)aPhoneNumber
{
    return [aPhoneNumber isMatchedByRegex:@"^[1][0-9]\\d{9}$"];    
}

//
// 去掉HTML中< & >内所有的内容，不过如果文本也包含 <> 也会被移除
//
+ (NSString *)transHTMLString:(NSString *)htmlStr
{
    NSString *string = [NSString stringWithString:htmlStr];
    
    // 去掉HTML中< & >内所有的内容，不过如果文本也包含 <> 也会被移除
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    }
    return string;
}

//
// 给手机号加密，将中间的数字设置为*号
// 158****8888
//
+ (NSString *)encryptPhoneNum:(NSString *)phoneNumStr
{
    if ([phoneNumStr isKindOfClass:[NSString class]])
    {
        NSInteger length = [phoneNumStr length];
        // 此处没有安装11位手机号判断，这样的话当是固定电话时，也能用，呵呵。。。
        if (length >= 8)
        {
            NSString *tempString =  [phoneNumStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            return tempString;
        }
    }
    
    // 如果不正确，原路返回
    return phoneNumStr;
}

//
// 判断字符串是否有空格
//
+ (BOOL)checkWhitespace:(NSString *)_string
{
    if (_string && ([_string length] > 0))
    {
        NSInteger length = [_string length];
        for (NSInteger i=0; i<length; i++)
        {
            NSString *tempStr = [_string substringFromIndex:i];
            if ([tempStr isEqualToString:@" "])
            {
                return YES;
            }
        }
        return YES;
    }
    return NO;
}

//
// 往本地打印LOG
//
+ (void)printLogToDevice:(NSString *)log
{
    // 正式版要去掉
    return;
    
    if ([log isKindOfClass:[NSString class]] && ([log length] > 0))
    {        
        NSString *newLog = [NSString stringWithString:log];
        
        //创建目录
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/exceptionLog"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path])
        {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 创建log日志文件
        NSString* exceptionFilePath = [path stringByAppendingString:@"/suLog.txt"];
        
        NSString *oldLog = [NSString stringWithContentsOfFile:exceptionFilePath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *finishLog = [NSString stringWithFormat:@"%@\n%@", newLog, oldLog];
        
        if(![finishLog writeToFile:exceptionFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil])
        {
            NSLog(@"失败了");
        }
        
        NSLog(@"%@", finishLog);        
    }
}


@end
