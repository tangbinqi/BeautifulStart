//
//  SBNavigatetionView.h
//  GomeEShop
//
//  Created by Qixin on 13-12-4.
//  Copyright (c) 2013年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SBNavigationBarView : UIView
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UIButton *leftButton;//左边按钮
@property (strong, nonatomic) UIButton *rightButton;//右边按钮
- (id)initWithTitle:(NSString*)title;//初始化并设置title,如无title则可以传"",之后由属性赋值
- (void)createLeftButtonWithTitle:(NSString*)title;//初始化左边按钮
- (void)createRightButtonWithTitle:(NSString*)title;//初始化右边按钮
@end
