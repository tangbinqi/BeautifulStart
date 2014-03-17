//
//  ImageKeyboard.m
//  TextEdit
//
//  Created by dqjk dqjk on 11-12-22.
//  Copyright (c) 2011年 fl. All rights reserved.
//

#import "KeyboardHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation KeyboardHelper


@synthesize editViewTags;
@synthesize pSysKeyboardView;
@synthesize otherButtonToAdd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithRed:124.0/255 green:133.0/255 blue:144.0/255 alpha:1];
        //添加键盘事件监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification object:nil]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) 
                                                     name:UIKeyboardDidHideNotification object:nil];
        //初始化其他要添加的按钮数组
        otherButtonToAdd =[[NSMutableArray alloc] init];
        //监听文本框输入焦点事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
        editViewTags=[[NSMutableArray alloc] init];
        
    }
    return self;
}


#pragma mark - FindFirstResponder
- (BOOL)findAndResignFirstResponder:(UIView*)pView
{
    if (pView.isFirstResponder) 
    {
        if ([editViewTags containsObject:[NSNumber numberWithInt:pView.tag]]) {
            if ([pView isKindOfClass:[UITextView class]])
            {
                editItem = pView;
            }
            else if ([pView isKindOfClass:[UITextField class]])
            {
                editItem = pView;
            }
        }
        return YES;
    }
    
    for (UIView *subView in pView.subviews) 
    {
        if ([self findAndResignFirstResponder:subView])
        {
            return YES;
        }
    }
    return NO;
}
- (void)findFirstResponder
{
    // locate keyboard view
    UIWindow* tempWindow = nil;
    int viewCount = 0;
    editItem = nil;
    
    int count = [[[UIApplication sharedApplication] windows] count];
    for (int k=0; k<count; k++)
    {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:k];
        viewCount = [tempWindow.subviews count];
        UIView* tempView = nil;
        for (int index=0; index<viewCount; index++)
        {
            tempView = [tempWindow.subviews objectAtIndex:index];
            if ([self findAndResignFirstResponder:tempView])
            {
                break;
            }
        }
        
        if (editItem)
        {
            break;
        }
    }
    if (editItem==nil) {
        if (pSysKeyboardView!=nil) {
            if ([pSysKeyboardView viewWithTag:ImageKeyboardChangeBtnKey]!=nil) {
                [[pSysKeyboardView viewWithTag:ImageKeyboardChangeBtnKey] removeFromSuperview];
            }
        }
    }else{
        [self keyboardDidShow:nil];
    }
}

-(void)textViewChanged:(NSNotification*)notif
{
    [self findFirstResponder];
}
#pragma mark keyboard Event
- (void)keyboardDidShow:(NSNotification *)notif
{
    if (pSysKeyView==nil || pSysKeyboardView==nil)
    {
        // locate keyboard view
        UIWindow* tempWindow = nil;
        UIView* keyboard = nil;
        if([[[UIApplication sharedApplication] windows] count]<2)
        {
            return;
        }            
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        if (tempWindow == nil)
        {
            return;
        }
        
        int viewCount = [tempWindow.subviews count];
        for(int i=0; i<viewCount; i++) 
        {
            keyboard = [tempWindow.subviews objectAtIndex:i];
            
            //keyboard view found; add the custom button to it
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
            {
                if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) ||(([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)))
                {
                    break;
                }
            }
            else 
            {
                if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                {
                    break;
                }
            }
        }
        
        if (keyboard!=nil && editItem!=nil)
        {
            viewCount = [keyboard.subviews count];
            if  (viewCount > 0)
            {
                pSysKeyView = [keyboard.subviews objectAtIndex:0];
            }
        }
        
        pSysKeyboardView = keyboard;
    }
    if (pSysKeyboardView!=nil) 
    {
        //添加其他view
        if (otherButtonToAdd!=nil&&otherButtonToAdd.count>0) {
            for(int i=0;i<otherButtonToAdd.count;i++)
            {
                NSObject *n=[otherButtonToAdd objectAtIndex:i];
                if ([n isKindOfClass:[UIView class]])//为uiview的子类，添加
                {
                    [pSysKeyboardView addSubview:(UIView *) n];
                    [pSysKeyboardView bringSubviewToFront:(UIView*)n];
                }
            }
        }
    }
}

- (void)keyboardDidHide:(NSNotification *)notif
{
    editItem=nil;
    for (UIView *v in otherButtonToAdd) {
        if (v.superview!=nil) {
            [v removeFromSuperview];
        }
    }
    pSysKeyboardView=nil;
    pSysKeyView=nil;
}

-(void)dealloc
{
    //移除键盘事件注册
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [otherButtonToAdd release];
    [editViewTags release];
    
    [super dealloc];
}
@end


