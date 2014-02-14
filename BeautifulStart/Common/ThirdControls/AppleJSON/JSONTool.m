//
//  JSONTool.m
//  GomeOnlineHD
//
//  Created by Qixin on 13-11-8.
//  Copyright (c) 2013年 Gome. All rights reserved.
//  苹果官方的json解析,5.0以上使用,shit

#import "JSONTool.h"

@implementation JSONTool

#pragma mark - JSON字符串转对象
+ (id)jsonObjectWithString:(NSString *)string
{
    return [JSONTool jsonObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - JSON流转对象
+ (id)jsonObjectWithData:(NSData*)data
{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                               error:&error];
    if (obj && !error)
    {
        return obj;
    }
    else
    {
        NSLog(@"<JSONTool>JSON解析失败 Error=%@",[error description]);
        return nil;
    }
}

#pragma mark - 对象转JSON流
+ (NSData*)dataWithJSONObject:(id)obj
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (data && !error)
    {
        return data;
    }
    else
    {
        NSLog(@"<JSONTool>转成JSON失败 Error=%@",[error description]);
        return nil;
    }
}

#pragma mark - 对象转JSON字符串
+(NSString*)stringWithJSONObject:(id)obj
{
    NSData *data = [JSONTool dataWithJSONObject:obj];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
