//
//  NSDictionary+Extension.h
//  Cloud
//
//  Created by wujin on 12-11-8.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

//返回字典中所有的key，按照原来的顺序
-(NSArray*)allKeysSorted;

//返回字典中所有的value，按照原来的顺序
-(NSArray*)allValuesSorted;

/**
 获取指定value的key
 */
-(id)keyForValue:(id)value;
@end

//有序的字典
//字典中的所有key将会按照插入的顺序进行枚举
@interface  SortedDictionary:NSMutableDictionary{
    NSMutableArray *keyArray;
}

@end

@interface NSMutableDictionary(Extension)

/**
 将一个int给字典赋值
 将会将int转换为字符串
 @param value 值
 @param key 键
 */
-(void)setInt:(int)value ForKey:(NSString*)key;
/**
 将一个float给字典赋值
 将会将float转换为字符串
 @param value 值
 @param key 键
 */
-(void)setFloat:(float)value ForKey:(NSString*)key;
@end