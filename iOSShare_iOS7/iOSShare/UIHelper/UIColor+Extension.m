//
//  UIColor+Extension.m
//  iTrends
//
//  Created by wujin on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(UIColor*)color102
{
    return [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
}

+(UIColor*)color153_9//rgb 153 153 153 .9
{
    return [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:.9];
}

+(UIColor *)color242//rgb 242 242 242
{
    return [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
}
+ (UIColor *) colorWithHexString: (NSString *) hexString {
    if ([hexString hasPrefix:@"["]&&[hexString hasSuffix:@"]"]) {
        SEL selector = NSSelectorFromString(@"objectFromJSONString");
        if ([hexString respondsToSelector:selector]==NO) {
            NSLog(@"need jsonkit!");
            return [UIColor clearColor];
        }
        NSArray *array=[hexString performSelector:selector];
        if (array==nil||array.count!=4) {
            NSLog(@"error string:%@",hexString);
            return [UIColor clearColor];
        }
        return RGBAColor([array[0] integerValue], [array[1] integerValue], [array[2] integerValue], [array[3] floatValue]*255);
    }
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1 Case:1];
            green = [self colorComponentFrom: colorString start: 1 length: 1 Case:2];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1 Case:3];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 3 length: 1 Case:0];
            red   = [self colorComponentFrom: colorString start: 1 length: 1 Case:1];
            green = [self colorComponentFrom: colorString start: 2 length: 1 Case:2];
            blue  = [self colorComponentFrom: colorString start: 0 length: 1 Case:3];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2 Case:1];
            green = [self colorComponentFrom: colorString start: 2 length: 2 Case:2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2 Case:3];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 6 length: 2 Case:0];
            red   = [self colorComponentFrom: colorString start: 2 length: 2 Case:1];
            green = [self colorComponentFrom: colorString start: 4 length: 2 Case:2];
            blue  = [self colorComponentFrom: colorString start: 0 length: 2 Case:3];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+(NSString*)stringWithColor:(UIColor *)color
{
    if (color==nil) {
        return @"";
    }
    
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    //rgba
    return [NSString stringWithFormat:@"[%d,%d,%d,%f]",(int)(r*255),(int)(g*255),(int)(b*255),a];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length Case:(int) ARGB{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    switch (ARGB) {
        case 0://alpha
            return hexComponent / 255.0;

            break;
        case 1://red
           
            return ( hexComponent )/ 255.0;

            break;
        case 2://green
            return (hexComponent)/ 255.0;
 
            break;
        case 3://blue
            return (hexComponent) / 255.0;
 
            break;
        default:
            break;
    }
    return 0;
}
@end
