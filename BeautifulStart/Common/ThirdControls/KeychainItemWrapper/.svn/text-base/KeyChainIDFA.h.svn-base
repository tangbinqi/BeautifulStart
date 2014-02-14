//
//  KeyChainIDFA.h
//  GomeEShop
//
//  Created by Qixin on 13-9-25.
//  Copyright (c) 2013年 zywx. All rights reserved.

// 获取IDFA唯一标示并且保存到KeyChain中,如果IDFA没有取到就取UUID,保存到KeyChain中
// 注意,此类只能在iOS6以上使用,否则获取不到IDFA
// iOS7之前通常以MAC地址为主.
// 通常情况IDFA会在用户重置或关闭/开启IDFA时改变,有可能取不到IDFA几率较小,原因请见文档
// KeyChain通常只有在用户刷机之后擦除
// Apple提供的<KeychainItemWrapper>类是MRC类,需要增加标签 "-fno-objc-arc"

#import <Foundation/Foundation.h>

@interface KeyChainIDFA : NSObject
+ (NSString*)getIdfaString;
@end
