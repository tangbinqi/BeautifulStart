//
//  ImageKeyboard.h
//  TextEdit
//
//  Created by dqjk dqjk on 11-12-22.
//  Copyright (c) 2011年 fl. All rights reserved.
//

#import <UIKit/UIKit.h>



#define ImageKeyboardChangeBtnKey 1354

@interface KeyboardHelper : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>{    
    UIView*            pSysKeyboardView;  //键盘最底层的view。
    UIView*            pSysKeyView;       // 常用键盘的view。
    
    UIView *editItem;
}

@property BOOL removeFlag;//移除放大效果标志
@property (nonatomic,retain) NSMutableArray *editViewTags;//在父视图中所有要编辑的项目的tag
@property (nonatomic,retain) UIView *pSysKeyboardView;//当前找到的系统最底层的键盘视图
@property (nonatomic,retain) NSMutableArray *otherButtonToAdd;//其他要加入到键盘层的按钮或者 UiView;

-(void)findFirstResponder;//寻找当前view中的键盘聚集按钮
-(BOOL)findAndResignFirstResponder:(UIView*)pView;//寻找当前view中的键盘聚焦文本框
-(void)keyboardDidShow:(NSNotification *)notif;//键盘显示出的通知


@end



