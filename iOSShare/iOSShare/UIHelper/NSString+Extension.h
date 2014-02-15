//
//  NSString+Extension.h
//  iTrends
//
//  Created by wujin on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

//获取一个字符串转换为URL
#define URL(str) [NSURL URLWithString:str]

//判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str==nil||[str isEqualToString:@""])
//判断字符串不为空并且不为空字符串
#define StringNotNullAndEmpty(str) (str!=nil&&![str isEqualToString:@""])
//快速格式化一个字符串
#define _S(str,...) [NSString stringWithFormat:str,##__VA_ARGS__]

@class MREntitiesConverter;
@interface NSString (Extension)
-(BOOL)isNullOrEmpty;

-(BOOL)isNotNullAndEmpty;
//判断字符串是否以指定字符串开始
-(BOOL)isStartWith:(NSString*)str;
//判断字符串是否以指定字符串结束
-(BOOL)isEndWith:(NSString*)str;
//判断字符串是否包含指定字符串
-(BOOL)isContainString:(NSString*)str;
//替换HTML
-(NSString*)stringByReplaceHtml:(NSString*)str;
//获取某固定文本的显示高度
+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font;

+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font Lines:(int)lines;

-(int)lenghtForAudioUrlString;

//返回取到的token的字符串格式
+(NSString*)tokenString:(NSData*)devToken;

//获取图片名称对应的大小
+(CGSize)sizeForImageName:(NSString*)imgName;

//获取图片名称对应的大小
-(CGSize)sizeForImageName;

//根据控件size拼接url
-(NSString *)stringByAddSize:(CGSize)displaySize;

//将字符串加上高度参数
+(NSString*)stringByAddWidth:(CGFloat)width String:(NSString*)str;

//将字符串加上高度参数
-(NSString*)stringByAddWidth:(CGFloat)width;

//将字符串加上高度参数
+(NSString*)stringByAddWidth:(CGFloat)width Height:(CGFloat)height String:(NSString*)str;

//将字符串加上高度参数
-(NSString*)stringByAddWidth:(CGFloat)width Height:(CGFloat)height;

//将字符串的高度参数移除
+(NSString*)stringByRemoveWidth:(NSString*)str;

-(NSString*)stringByRemoveWidth;

//返回字符串经过md5加密后的字符
+(NSString*)stringDecodingByMD5:(NSString*)str;

-(NSString*)md5DecodingString;

//返回经base64编码过后的数据
+ (NSString*) base64Encode:(NSData *)data;
-(NSString*)base64Encode;

//返回经base64解码过后的数据
+ (NSString*) base64Decode:(NSString *)string;
-(NSString*)base64Decode;

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath;
// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath;


// 方法1：循环调用fileSizeAtPath1
+ (long long) folderSizeAtPath1:(NSString*) folderPath;
// 方法2：循环调用fileSizeAtPath2
+ (long long) folderSizeAtPath2:(NSString*) folderPath;
// 方法2：在folderSizeAtPath2基础之上，去除文件路径相关的字符串拼接工作
+ (long long) folderSizeAtPath3:(NSString*) folderPath;
@end


@interface MREntitiesConverter : NSObject<NSXMLParserDelegate> {
    NSMutableString* resultString;
}
@property (nonatomic, retain) NSMutableString* resultString;
- (NSString*)convertEntiesInString:(NSString*)s;
@end
