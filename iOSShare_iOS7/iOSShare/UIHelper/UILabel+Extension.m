//
//  UILabel+Extension.m
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UILabel+Extension.h"
#import "UIFont+Extension.h"
#import "NSString+Extension.h"

@implementation UILabel (Extension)


+(UILabel*)whiteLabelWithSize:(CGFloat) size Frame:(CGRect)rect
{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.font=[UIFont fontWithSize:size];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    return [label autorelease];
}

//将此文本标签垂直居中
-(void)verticalAlignmentCerter
{
    CGFloat height=[NSString heightForString:self.text Size:CGSizeMake(self.frame.size.width, 333333) Font:self.font Lines:self.numberOfLines].size.height;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(void)verticalAlignmentTop
{
    CGFloat height=[NSString heightForString:self.text Size:CGSizeMake(self.frame.size.width, 333333) Font:self.font Lines:self.numberOfLines].size.height;
    CGRect rect=self.frame;
    if (rect.size.height>height) {
        rect.size.height=height;
    }
    self.frame=rect;
}

-(void)verticalAlignmentBottom
{
    CGFloat height=[NSString heightForString:self.text Size:CGSizeMake(self.frame.size.width, 333333) Font:self.font Lines:self.numberOfLines].size.height;
    CGRect rect=self.frame;
    if (rect.size.height>height) {
        rect.origin.y+=(rect.size.height-height);
        rect.size.height=height;
    }
    self.frame=rect;
}
//tittleViewLabel
+(UILabel *)tittleViewLabelWithFrame:(CGRect)frame Text:(NSString *)text{
    UILabel *tittleLabel = [[UILabel alloc]initWithFrame:frame];
    tittleLabel.text = text;
    tittleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    tittleLabel.backgroundColor = [UIColor clearColor];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    tittleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];//设置粗体
    tittleLabel.shadowColor = [UIColor blackColor];//设置阴影
    tittleLabel.shadowOffset = CGSizeMake(0, -1);
    return [tittleLabel autorelease];
}

//标记是否需要还原
static bool needRevert=NO;
//还原text值
-(void)revertText:(NSString*)text
{
    self.text=text;
    needRevert=NO;
}

-(void)setText:(NSString *)text ForTime:(NSTimeInterval)interval
{
    static NSString *ortext;
    //如果本身已经需要还原，先还原
    if (needRevert) {
        //取消计划设置的
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(revertText:) object:ortext];
        [self revertText:ortext];
    }
    
    needRevert=YES;
    if (ortext!=nil) {
        [ortext release];
    }
    ortext=[self.text retain];
    [self performSelector:@selector(revertText:) withObject:self.text afterDelay:interval];
    self.text=text;
}
@end
