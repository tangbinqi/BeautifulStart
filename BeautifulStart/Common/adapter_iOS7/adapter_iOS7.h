//
//  adapter_iOS7.h
//  GomeEShop
//
//  Created by 苏 循波 on 13-9-26.
//  Copyright (c) 2013年 zywx. All rights reserved.
//
//  之前讨论如何适配这种变量的改变，大家讨论意见有直接用0、1、2。。数字，因为他们的排列都一样，但是这样看起来不是很舒服；
//  页有使用宏定义的，大家偏向于这种方式
//
//  定义宏时，我将iOS6之前的定义放到上面，iOS7的定义放到下面，最为对比使用，为了以后兼容，所以就用iOS7作为模板
//


#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// ------------------------------------------ LineBreakMode ------------------------------------------ //

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

#define LineBreakByWordWrapping 0
#define LineBreakByCharWrapping 1
#define LineBreakByClipping 2
#define LineBreakByTruncatingHead 3
#define LineBreakByTruncatingTail 4
#define LineBreakByTruncatingMiddle 5
// ------------------------------------------ LineBreakMode ------------------------------------------ //
/////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////
// ------------------------------------------ TextAlignment ------------------------------------------ //

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

#define TextAlignmentLeft 0
#define TextAlignmentCenter 1
#define TextAlignmentRight 2
// ------------------------------------------ LineBreakMode ------------------------------------------ //
/////////////////////////////////////////////////////////////////////////////////////////////////////////


























