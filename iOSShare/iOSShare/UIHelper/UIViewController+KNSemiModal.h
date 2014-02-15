//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalAnimationDuration   0.5

@interface UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc;
-(void)presentSemiView:(UIView*)vc;
-(void)dismissSemiModalView;

//设置控制器的左边 按钮为返回按钮
-(void)setLeftNavBackButton;
//设置控制器的标题
-(void)setTitleNavString:(NSString*)str;

@end


@interface UIViewController (Extension)

-(UIBarButtonItem*)buttonItemWithImage:(NSString*)imgName Selector:(SEL)selector;

-(UIBarButtonItem*)buttonItemWithText:(NSString*)text Selector:(SEL)selector;
-(UIBarButtonItem*)buttonBlueBackItemWithTitle:(NSString*)title Selector:(SEL)selector;

/*
 返回按钮 
 @selector:单击事件
 @longPress:长按事件
 */
-(UIBarButtonItem*)buttonBackLongPressItemWithTouchSelector:(SEL)selector LongPressSelector:(SEL)longPress;
-(UIBarButtonItem*)buttonBackLongPressItemWithTouchSelector:(SEL)selector;
-(UIBarButtonItem*)buttonBackLongPressItem;


/**
 按钮
 @title 标题
 @selector 响应按钮
 */
-(UIBarButtonItem*)buttonGreenItemWithTitle:(NSString*)title Selector:(SEL)selector;

-(UIBarButtonItem*)buttonGreenItemWithImageName:(NSString *)imgName Selector:(SEL)selector;

-(UIBarButtonItem*)buttonBlueItemWithTitle:(NSString*)title Selector:(SEL)selector;

-(UIBarButtonItem*)buttonBlueItemWithImageName:(NSString *)imgName Selector:(SEL)selector;

/**
 一个等待视图，一直转圈圈
 
 请在协议调用开始的时候替换成此项，结束后再替换回原来的项
 */
-(UIBarButtonItem*)buttonWaitItem;
/**
 设置标题
 
 @param title 要设置的标题
 */
-(UIView*)titleViewWithTitle:(NSString*)title;


/**
 用于推出视图的导航
 */
-(IBAction)btBack_PopNav:(id)sender;
/**
 用于消除模态视图的导航
 */
-(IBAction)btBack_DisModal:(id)sender;
/**
 执行自定义过程的导航
 */
-(IBAction)btBack_Block:(dispatch_block_t)block;

/**
 取消当前控制器中所有的异步图片下载
 
 此方法会遍历所有的子视图（递归遍历）
 */
-(void)cancelCurrentAllImageDownload;
@end