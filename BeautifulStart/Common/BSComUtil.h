//
//  BSAppDelegate.h
//  BSComUtil
//
//  Created by tangbinqi on 13-11-14.
//  Copyright (c) 2013年 tangbinqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface BSComUtil : NSObject

+ (float)systemVersion;
+ (UIColor *)getTextGrayColor;
+ (UIColor *)getTextRushGrayColor;
+ (UIColor *)getTextLightGrayColor;
+ (UIColor *)getRedDefTextColor;
+ (UIColor *)getBlackDefTextColor;
+ (UIColor *)getBlueDefTextColor;
//+ (UIColor *)getLoginBlueDefTextColor;
//+ (UIColor *)getOrangeDefTextColor;
//+ (UIColor *)getGreenDefTextColor;
+ (UIColor *)getTableViewSelectColor;
//+ (UIColor*)getTableDescTextColor;
//+ (UIColor *)getStepTextColor;
+ (UIColor *)getCellDefColor;
+ (UIColor*)getBbcColor;
+ (UIColor*)getBackgroundColor;
+ (UIFont*)getTableDescTextFont;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg tag:(NSInteger)tag delete:(id)aDelete;
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString *) encryptNoBase64UseDES:(NSString *)plainText key:(NSString *)key;    //不使用Base64编码的 DES加密,不管是否为空（nil），都能返回加密串
+ (NSString *) macaddress;
//+ (NSString *)getIDFA;
//+ (NSString *)getUUID;
//+ (NSString *)getOpenUDID;
//+ (BOOL)isFirstUse;
+ (BOOL)isFirstInstall;
+ (BOOL) isIpad;
+ (BOOL)isRetina;
+ (NSString *)getTransImageUrlWithURL:(NSString *)urlStr scale:(int)size;
+ (NSString *)getTransImageUrlWithURL:(NSString *)urlStr size:(NSString*)size;
//+ (UILabel *)getCellCommonLabelWithSize:(CGRect)frame textColor:(UIColor *)color fontSize:(float)fontSize text:(NSString *)text;
//+ (UILabel *)getCellCommonLabelWithSize:(CGRect)frame textColor:(UIColor *)color fontSize:(float)fontSize text:(NSString *)text isBbc:(NSString*)isBbc;
//+ (UIButton*)getBackButton:(NSString*)title;
//+ (UIButton*)getRightButton:(NSString*)title;
//+ (UIButton*)getFilterButton:(NSString*)title;
+ (UIButton*)getBlackBackButton:(NSString*)title;
//+ (BOOL)isBottomViewHidden;
//+ (void)showBottomView:(BOOL)show animation:(BOOL)animation;
//+ (void)showBottomView:(BOOL)show;
+ (void)cell:(UITableViewCell*)cell setSelectedBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows;
//+ (void)smallBorderCell:(UITableViewCell*)cell setBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows;
//+ (void)smallBorderCell:(UITableViewCell*)cell setSelectedBackgroundViewAtIndexPath:(NSIndexPath*)indexPath totalRow:(int)rows;
+ (MBProgressHUD*)showHud:(UIView*)rootView text:(NSString*)text;
+ (UIImage*)getImageWithFileName:(NSString*)name;
+ (UIImage*)getImageWithFileNameJPG:(NSString*)name;
+ (NSString *)getPicPath:(NSString*)fileName;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (CGSize)size:(CGSize)size onstrainedToSize:(CGSize)orignSize;
+ (void)setSessionId:(NSDictionary*)dict;
+ (void)saveCookiesForUserDefaults;
+ (void)cleanCookie;
+ (BOOL)shouldShowImage;
+ (void)setServerTime:(NSString*)serverTime;
+ (BOOL)isNewDay;
//+ (BOOL)controllerIsFirstResponder:(UIViewController*)controller;
+ (BOOL)checkPhoneNumber:(NSString *)string;
+ (BOOL)checkName:(NSString *)string;
//+ (UIImageView *)getNavigationControllerView;
+ (BOOL)isRightFormantByRegexPhoneNumber:(NSString *)aPhoneNumber;              // 手机号正则判断（只判断第一位是否为1）
// 去掉HTML中< & >内所有的内容，不过如果文本也包含 <> 也会被移除
+ (NSString *)transHTMLString:(NSString *)htmlStr;
+ (NSString *)encryptPhoneNum:(NSString *)phoneNumStr; // 给手机号加密，将中间的数字设置为*号
+ (BOOL)checkWhitespace:(NSString *)_string; // 判断字符串是否有空格
+ (void)printLogToDevice:(NSString *)log; // 往本地打印LOG


@end
