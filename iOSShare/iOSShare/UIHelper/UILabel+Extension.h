//
//  UILabel+Extension.h
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)


+(UILabel*)whiteLabelWithSize:(CGFloat) size Frame:(CGRect)rect;

//将此文本标签垂直居中
-(void)verticalAlignmentCerter;

//将此文本标签垂直居上
-(void)verticalAlignmentTop;

-(void)verticalAlignmentBottom;
 //tittleView
+(UILabel *)tittleViewLabelWithFrame:(CGRect)frame Text:(NSString *)text;

/*
 让此文本标签显示一个字串，但是仅显示指定的时候
 */
-(void)setText:(NSString *)text ForTime:(NSTimeInterval)interval;
@end
