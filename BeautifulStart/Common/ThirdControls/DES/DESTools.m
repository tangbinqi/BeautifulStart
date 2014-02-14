//
//  DESTools.m
//  GomeOnlineHD
//
//  Created by Qixin on 13-11-7.
//  Copyright (c) 2013年 Gome. All rights reserved.
//

#import "DESTools.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64Tool.h"



//国美登陆
static Byte iv[] = {1,2,3,4,5,6,7,8};



@implementation DESTools


#pragma mark - DES加密
+(NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [clearText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;


	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
										  kCCOptionPKCS7Padding,
										  [key UTF8String], kCCKeySizeDES,
										  iv,
										  [textData bytes], dataLength,
										  buffer, 1024,
										  &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
		ciphertext = [Base64Tool encode:data];
    }
    else
    {
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}


#pragma mark - DES解密
+ (NSString *)decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    NSData *textData = [Base64Tool decode:plainText];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;


    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSLog(@"DES解密成功");

        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

@end
