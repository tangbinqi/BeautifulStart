//
//  SBNavigatetionView.m
//  GomeEShop
//
//  Created by Qixin on 13-12-4.
//  Copyright (c) 2013年 zywx. All rights reserved.
//

#import "SBNavigationBarView.h"
#define kBarWidth 320
#define kBarButtonWidth 60
#define kBarButtonHeight 44

@implementation SBNavigationBarView



- (id)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, screenW, kNavBarHeight);
        self.backgroundColor = [UIColor colorWithRed:199/225.0 green:0/255.0 blue:0/255.0 alpha:1.0];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        self.titleLabel.center = CGPointMake(screenW/2, kNavBarHeight/2+10);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = g_TextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:self.titleLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight-0.5, screenW, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self addSubview:line];
    }
    return self;
}

- (void)createLeftButtonWithTitle:(NSString*)title
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftButton.frame = CGRectMake(8, 20, kBarButtonWidth, kBarButtonHeight);
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_jiantou_back.png"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.leftButton setExclusiveTouch:YES];
    [self.leftButton setTag:kBarLeftButton_Tag];
    [self addSubview:self.leftButton];
}

- (void)createRightButtonWithTitle:(NSString*)title
{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.backgroundColor = [UIColor clearColor];
    self.rightButton.frame = CGRectMake(screenW-kBarButtonWidth-8, 20, kBarButtonWidth, kBarButtonHeight);
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.rightButton setExclusiveTouch:YES];
    [self.rightButton setTag:kBarRightButton_Tag];
    [self addSubview:self.rightButton];
}


@end
