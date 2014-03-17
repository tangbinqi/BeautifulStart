//
//  NSDictionary+Extension.m
//  Cloud
//
//  Created by wujin on 12-11-8.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

-(NSArray*)allKeysSorted
{
    NSEnumerator *enumerator=[self keyEnumerator];
    NSMutableArray *keys=[NSMutableArray array];
    id akey=enumerator.nextObject;
    if (![akey isKindOfClass:[NSString class]]) {
        return self.allKeys;
    }
    while (akey) {
        [keys addObject:akey];
        akey=enumerator.nextObject;
    }
    
    [keys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSScanner *scan=[NSScanner scannerWithString:obj1];
        
        int value_int1=0;
        int value_int2=0;
        if ([scan scanInt:&value_int1]&&[scan scanInt:&value_int2]) {
            if (value_int1>value_int2) {
                return NSOrderedAscending;
            }else if(value_int1<value_int2){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
        }else{//有一个不是数字，数字大于字符串
            if ([scan scanInt:&value_int1]) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }
        
    }];
    
    return keys;
}

-(NSArray*)allValuesSorted
{
    NSEnumerator *enumerator=[self keyEnumerator];
    NSMutableArray *values=[NSMutableArray array];
    id avalue=[enumerator nextObject];
    while (avalue) {
        [values addObject:[self valueForKey:avalue]];
        avalue=[enumerator nextObject];
    }
    return values;
}

-(id)keyForValue:(id)value
{
    return [[self allKeysForObject:value] lastObject];
}
@end

@implementation SortedDictionary

-(id)init
{
    self=[super init];
    if (self) {
        keyArray=[[NSMutableArray alloc] init];
    }
    return self;
}

+(id)dictionary
{
    return [[[SortedDictionary alloc] init] autorelease];
}

-(BOOL)isKeyExist:(NSString*)key
{
    
    for (NSString *onekey in keyArray) {
        if ([onekey isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if (key!=nil&&![key isEqualToString:@""]) {
        if (![self isKeyExist:key]) {//如果key不存在，保存key
            [keyArray addObject:key];
        }
    }
    [super setValue:value forKey:key];
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    NSString *key=nil;
    
    key=[aKey copyWithZone:NULL];
    
    if (![key isKindOfClass:[NSString class]]) {
        [key release];
        key =nil;
    }
    
    if (key!=nil&&![key isEqualToString:@""]) {
        if (![self isKeyExist:key]) {//如果key不存在，保存key
            [keyArray addObject:key];
        }
    }
    [key release];
    
    [super setObject:anObject forKey:aKey];
}

-(NSArray*)allKeys
{
    return keyArray;
}

-(NSArray*)allValues
{
    NSMutableArray *values=[NSMutableArray array];
    for (NSString *key in keyArray) {
        [values addObject:[self objectForKey:key]];
    }
    return values;
}
@end

@implementation NSMutableDictionary(Extension)

/**
 将一个int给字典赋值
 将会将int转换为字符串
 @param value 值
 @param key 键
 */
-(void)setInt:(int)value ForKey:(NSString*)key
{
    [self setObject:[NSString stringWithFormat:@"%d",value] forKey:key];
}
/**
 将一个float给字典赋值
 将会将float转换为字符串
 @param value 值
 @param key 键
 */
-(void)setFloat:(float)value ForKey:(NSString*)key
{
    [self setObject:[NSString stringWithFormat:@"%f",value] forKey:key];
}

@end
