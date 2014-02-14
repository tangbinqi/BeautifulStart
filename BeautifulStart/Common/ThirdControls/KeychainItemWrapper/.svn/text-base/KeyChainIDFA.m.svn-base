//
//  KeyChainIDFA.m
//  GomeEShop
//
//  Created by Qixin on 13-9-25.
//  Copyright (c) 2013年 zywx. All rights reserved.
//

#import "KeyChainIDFA.h"
#import <AdSupport/AdSupport.h>
#import "KeychainItemWrapper.h"
@implementation KeyChainIDFA

+ (NSString*)getIdfaString
{
    KeychainItemWrapper *item = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.gome.idfa" accessGroup:nil];
    //[item resetKeychainItem];
    NSString *idfaStr = [item objectForKey:(__bridge id)kSecValueData];
    if (idfaStr && ![idfaStr isEqualToString:@""])
    {
        return idfaStr;
    }
    else
    {
        NSAssert([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0, @"<KeyChainIDFA>iOS6以下版本不能获取IDFA");
        idfaStr = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString];
        if (idfaStr)
        {
            [item setObject:idfaStr forKey:(__bridge id)kSecValueData];
            return idfaStr;
        }
        else
        {
            NSString *uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
            [item setObject:idfaStr forKey:(__bridge id)kSecValueData];
            return uuid;
        }
    }
}
@end
