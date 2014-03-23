//
//  BS_dapter_iOS7.m
//  tangbinqi
//
//  Created by tangbinqi on 13-10-21.
//
//
//  之前讨论如何适配这种变量的改变，大家讨论意见有直接用0、1、2。。数字，因为他们的排列都一样，但是这样看起来不是很舒服；
//  也有讨论使用宏定义的，大家偏向于这种方式，但是使用时发现这种方式实现很难
//  最后我还是使用全局变量，通过判断当前版本，决定赋值
//  定义宏时，我将iOS6之前的定义放到上面，iOS7的定义放到下面，最为对比使用，为了以后兼容，所以就用iOS7的变量名作为模板
//


#import "BS_dapter_iOS7.h"

@implementation BS_dapter_iOS7

//
//
//
+ (void)setLineBreakMode
{
#if 0
    
    // Deprecated: use NSLineBreakMode instead (we will be adding deprecation tags soon!)
    typedef NS_ENUM(NSInteger, UILineBreakMode) {
        UILineBreakModeWordWrap = 0,            // Wrap at word boundaries
        UILineBreakModeCharacterWrap,           // Wrap at character boundaries
        UILineBreakModeClip,                    // Simply clip when it hits the end of the rect
        UILineBreakModeHeadTruncation,          // Truncate at head of line: "...wxyz". Will truncate multiline text on first line
        UILineBreakModeTailTruncation,          // Truncate at tail of line: "abcd...". Will truncate multiline text on last line
        UILineBreakModeMiddleTruncation,        // Truncate middle of line:  "ab...yz". Will truncate multiline text in the middle
    } NS_DEPRECATED_IOS(2_0,6_0);
    
    // NSParagraphStyle
    typedef NS_ENUM(NSInteger, NSLineBreakMode) {		/* What to do with long lines */
        NSLineBreakByWordWrapping = 0,     	/* Wrap at word boundaries, default */
        NSLineBreakByCharWrapping,		/* Wrap at character boundaries */
        NSLineBreakByClipping,		/* Simply clip */
        NSLineBreakByTruncatingHead,	/* Truncate at head of line: "...wxyz" */
        NSLineBreakByTruncatingTail,	/* Truncate at tail of line: "abcd..." */
        NSLineBreakByTruncatingMiddle	/* Truncate middle of line:  "ab...yz" */
    } NS_ENUM_AVAILABLE_IOS(6_0);
    
#endif
    
    // 开始适配
    if (IsIOS6Lower) // iOS6以下
    {
        g_LineBreakByWordWrapping       = 0;//UILineBreakModeWordWrap;
        g_LineBreakByCharWrapping       = 1;//UILineBreakModeCharacterWrap;
        g_LineBreakByClipping           = 2;//UILineBreakModeClip;
        g_LineBreakByTruncatingHead     = 3;//UILineBreakModeHeadTruncation;
        g_LineBreakByTruncatingTail     = 4;//UILineBreakModeTailTruncation;
        g_LineBreakByTruncatingMiddle   = 5;//UILineBreakModeMiddleTruncation;
    }
    else // iOS6以上
    {
        g_LineBreakByWordWrapping       = 0;//NSLineBreakByWordWrapping;
        g_LineBreakByCharWrapping       = 1;//NSLineBreakByCharWrapping;
        g_LineBreakByClipping           = 2;//NSLineBreakByClipping;
        g_LineBreakByTruncatingHead     = 3;//NSLineBreakByTruncatingHead;
        g_LineBreakByTruncatingTail     = 4;//NSLineBreakByTruncatingTail;
        g_LineBreakByTruncatingMiddle   = 5;//NSLineBreakByTruncatingMiddle;
    }
    

}


//
//
//
+ (void)setTextAlignment
{

#if 0

// Deprecated: use NSTextAlignment enum in UIKit/NSText.h
typedef NS_ENUM(NSInteger, UITextAlignment) {
    UITextAlignmentLeft = 0,
    UITextAlignmentCenter,
    UITextAlignmentRight,                   // could add justified in future
} NS_DEPRECATED_IOS(2_0,6_0);

/* Values for NSTextAlignment */
typedef NS_ENUM(NSInteger, NSTextAlignment) {
    NSTextAlignmentLeft      = 0,    // Visually left aligned
#if TARGET_OS_IPHONE
    NSTextAlignmentCenter    = 1,    // Visually centered
    NSTextAlignmentRight     = 2,    // Visually right aligned
#else /* !TARGET_OS_IPHONE */
    NSTextAlignmentRight     = 1,    // Visually right aligned
    NSTextAlignmentCenter    = 2,    // Visually centered
#endif
    NSTextAlignmentJustified = 3,    // Fully-justified. The last line in a paragraph is natural-aligned.
    NSTextAlignmentNatural   = 4,    // Indicates the default alignment for script
} NS_ENUM_AVAILABLE_IOS(6_0);

#endif
    
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
//    g_TextAlignmentLeft = NSTextAlignmentLeft;
//    g_TextAlignmentCenter = NSTextAlignmentCenter;
//    g_TextAlignmentRight = NSTextAlignmentRight;
//    g_TextAlignmentJustified = NSTextAlignmentJustified;
//    g_TextAlignmentNatural = NSTextAlignmentNatural;
//    
//#else
//    g_TextAlignmentLeft = UITextAlignmentLeft;
//    g_TextAlignmentCenter = UITextAlignmentCenter;
//    g_TextAlignmentRight = UITextAlignmentRight;
//    
//    g_TextAlignmentJustified = UITextAlignmentLeft; // iOS6之前使用默认属性
//    g_TextAlignmentNatural = UITextAlignmentLeft; // iOS6之前使用默认属性
//    
//#endif
    
    // 开始适配
    if (IsIOS6Lower) // iOS6以下
    {
        g_TextAlignmentLeft = 0;//UITextAlignmentLeft;
        g_TextAlignmentCenter = 1;//UITextAlignmentCenter;
        g_TextAlignmentRight = 2;//UITextAlignmentRight;
        
        g_TextAlignmentJustified = 0;//UITextAlignmentLeft; // iOS6之前使用默认属性
        g_TextAlignmentNatural = 0;//UITextAlignmentLeft; // iOS6之前使用默认属性
    }
    else // iOS6以上
    {
        g_TextAlignmentLeft = 0;//NSTextAlignmentLeft;
        g_TextAlignmentCenter = 1;//NSTextAlignmentCenter;
        g_TextAlignmentRight = 2;//NSTextAlignmentRight;
        g_TextAlignmentJustified = 0;//NSTextAlignmentJustified;
        g_TextAlignmentNatural = 0;//NSTextAlignmentNatural;
    }
}


@end
