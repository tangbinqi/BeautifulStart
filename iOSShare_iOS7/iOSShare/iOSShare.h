//
//  iOSShare.h
//  iOSShare
//
//  Created by tangbinqi-gm on 14-2-18.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "Extension.h"
#import "ModelBase.h"

/**
 标识DDLog的日志级别
 如果要使用自已的标识，请注释此变量
 */
static int const ddLogLevel = 1111;

/**
 事件处理签名
 @param sender:事件的产生者
 */
typedef void(^EventHandler)(id sender);

/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithOneArg(block,arg)  if(block){block(arg);}
/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithTwoArg(block,arg1,arg2) if(block){block(arg1,arg2);}
/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithThreeArg(block,arg1,arg2,arg3) if(block){block(arg1,arg2,arg3);}