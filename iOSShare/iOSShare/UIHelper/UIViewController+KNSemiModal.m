//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+Extension.h"
#import "UIColor+Extension.h"
#import "UIImage+Extension.h"
#import "UIFont+Extension.h"
#import "UIView+Extension.h"

@interface UIViewController (KNSemiModalInternal)
-(UIView*)parentTarget;
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward;
@end

@implementation UIViewController (KNSemiModalInternal)

-(UIView*)parentTarget {
  // To make it work with UINav & UITabbar as well
  UIViewController * target = self;
  while (target.parentViewController != nil) {
    target = target.parentViewController;
  }
  return target.view;
}

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
  // Create animation keys, forwards and backwards
  CATransform3D t1 = CATransform3DIdentity;
  t1.m34 = 1.0/-900;
  t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
  t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);

  CATransform3D t2 = CATransform3DIdentity;
  t2.m34 = t1.m34;
  t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
  t2 = CATransform3DScale(t2, 0.8, 0.8, 1);

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.toValue = [NSValue valueWithCATransform3D:t1];
  animation.duration = kSemiModalAnimationDuration/2;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

  CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
  animation2.beginTime = animation.duration;
  animation2.duration = animation.duration;
  animation2.fillMode = kCAFillModeForwards;
  animation2.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];

  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.fillMode = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  [group setDuration:animation.duration*2];
  [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
  return group;
}
@end

@implementation UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc {
  [self presentSemiView:vc.view];
}

-(void)presentSemiView:(UIView*)vc {
  // Determine target
  UIView * target = [self parentTarget];
  
  if (![target.subviews containsObject:vc]) {
    // Calulate all frames
    CGRect sf = vc.frame;
    CGRect vf = target.frame;
    CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
    CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);

    // Add semi overlay
    UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    
    // Take screenshot and scale
    UIGraphicsBeginImageContext(target.bounds.size);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView * ss = [[UIImageView alloc] initWithImage:image];
    [overlay addSubview:ss];
    [target addSubview:overlay];

    // Dismiss button
    // Don't use UITapGestureRecognizer to avoid complex handling
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = of;
    [overlay addSubview:dismissButton];

    // Begin overlay animation
    [ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
      ss.alpha = 0.5;
    }];

    // Present view animated
    vc.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
    [target addSubview:vc];
    vc.layer.shadowColor = [[UIColor blackColor] CGColor];
    vc.layer.shadowOffset = CGSizeMake(0, -2);
    vc.layer.shadowRadius = 5.0;
    vc.layer.shadowOpacity = 0.8;
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
      vc.frame = f;
    }];
      [overlay release];
  }
}

-(void)dismissSemiModalView {
  UIView * target = [self parentTarget];
  UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
  UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
  [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
    modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
  } completion:^(BOOL finished) {
    [overlay removeFromSuperview];
    [modal removeFromSuperview];
  }];

  // Begin overlay animation
  UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
  [ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
  [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
    ss.alpha = 1;
  }];
}

-(void)setLeftNavBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_top.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnLeftTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
    [barItem release];
}

-(IBAction)btLeftTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTitleNavString:(NSString*)str
{
    self.navigationItem.titleView=[UILabel tittleViewLabelWithFrame:CGRectMake(0, 0, 44, 44) Text:str];
}
@end

@implementation UIViewController (Extension)

-(UIBarButtonItem*)buttonItemWithImage:(NSString *)imgName Selector:(SEL)selector
{
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imgName] style:UIBarButtonItemStylePlain target:self action:selector];
    item.tintColor=RGBColor(24, 24, 24);
    return [item autorelease];
}


-(UIBarButtonItem*)buttonItemWithText:(NSString *)text Selector:(SEL)selector
{
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:selector];
    item.tintColor=RGBColor(24, 24, 24);
    return [item autorelease];
}

-(void)btnBack_Extension_buttonBackLongPress:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnBack_LongPress_extension_buttonBackLongPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state==UIGestureRecognizerStateBegan) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(UIBarButtonItem*)buttonBackLongPressItemWithTouchSelector:(SEL)selector LongPressSelector:(SEL)longPress
{
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 50, 30);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"btn_top.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"btn_top_press.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(btnLeftTap:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture_longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:longPress];
    [leftbtn addGestureRecognizer:gesture_longPress];
    [gesture_longPress release];
    return [[[UIBarButtonItem alloc] initWithCustomView:leftbtn] autorelease];
}
-(UIBarButtonItem*)buttonBackLongPressItemWithTouchSelector:(SEL)selector
{
    return [self buttonBackLongPressItemWithTouchSelector:selector LongPressSelector:@selector(btnBack_LongPress_extension_buttonBackLongPress:)];
}
-(UIBarButtonItem*)buttonBackLongPressItem
{
    return [self buttonBackLongPressItemWithTouchSelector:@selector(btnBack_Extension_buttonBackLongPress:)];
}

/**
 按钮
 @title 标题
 @selector 响应按钮
 */
-(UIBarButtonItem*)buttonGreenItemWithTitle:(NSString*)title Selector:(SEL)selector
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 45, 30);
//    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
//    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateHighlighted];
    [setBtn setTitle:title forState:UIControlStateNormal];
    [setBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    setBtn.titleLabel.shadowColor=[UIColor blackColor];
    setBtn.titleLabel.shadowOffset=CGSizeMake(0, 1);
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-active.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateHighlighted];
    [setBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    return [rightBtnItem autorelease];
}

-(UIBarButtonItem*)buttonGreenItemWithImageName:(NSString *)imgName Selector:(SEL)selector
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 35, 30);
    [setBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];

    [setBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-active.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateHighlighted];
    [setBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    return [rightBtnItem autorelease];

}

-(UIBarButtonItem*)buttonBlueItemWithTitle:(NSString*)title Selector:(SEL)selector
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 43, 30);
    //    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
    //    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateHighlighted];
    [setBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [setBtn setTitle:title forState:UIControlStateNormal];
    setBtn.titleLabel.shadowColor=[UIColor blackColor];
    setBtn.titleLabel.shadowOffset=CGSizeMake(0, 1);
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-default.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-default-active.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateHighlighted];
    [setBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    return [rightBtnItem autorelease];

}

-(UIBarButtonItem*)buttonBlueBackItemWithTitle:(NSString*)title Selector:(SEL)selector
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 46, 30);
    //    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
    //    [setBtn setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateHighlighted];
    [setBtn setTitle:title forState:UIControlStateNormal];
    setBtn.titleLabel.shadowColor=[UIColor blackColor];
    setBtn.titleLabel.shadowOffset=CGSizeMake(0, 1);
    [setBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    [setBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-back-active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15] forState:UIControlStateHighlighted];
    [setBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    return [rightBtnItem autorelease];

}

-(UIBarButtonItem*)buttonBlueItemWithImageName:(NSString *)imgName Selector:(SEL)selector
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 36, 30);
    [setBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
    
    [setBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-default.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateNormal];
    [setBtn setBackgroundImage:[[UIImage imageNamed:@"navbar-button-green-default.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15] forState:UIControlStateHighlighted];
    [setBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    return [rightBtnItem autorelease];

}
/**
 一个等待视图，一直转圈圈
 
 请在协议调用开始的时候替换成此项，结束后再替换回原来的项
 */
-(UIBarButtonItem*)buttonWaitItem
{
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:indicator];
    [indicator startAnimating];
    [indicator release];
    return  [item autorelease];
}

-(UIView*)titleViewWithTitle:(NSString *)title
{
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    lb.backgroundColor=[UIColor clearColor];
    lb.font=[UIFont fontBoldWithSize:18];
    lb.textColor=[UIColor whiteColor];
    lb.textAlignment=UITextAlignmentCenter;
    lb.shadowColor=[UIColor blackColor];
    lb.shadowOffset=CGSizeMake(0, 1);
    lb.text=title;
    return [lb autorelease];
}

/**
 用于推出视图的导航
 */
-(IBAction)btBack_PopNav:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 用于消除模态视图的导航
 */
-(IBAction)btBack_DisModal:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
/**
 执行自定义过程的导航
 */
-(IBAction)btBack_Block:(dispatch_block_t)block
{
    block();
}

/**
 取消当前控制器中所有的异步图片下载
 
 此方法会遍历所有的子视图（递归遍历）
 */
-(void)cancelCurrentAllImageDownload
{
    [UIView cancelSubviewImageDownloadinView:self.view];
}
@end
