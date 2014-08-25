//
//  BSViewController.m
//  BeautifulStart
//
//  Created by tangbinqi-gm on 14-2-14.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSViewController.h"

@interface BSViewController ()

@end

@implementation BSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 强制vc为全屏坐标,00点就是物理00点.一旦开启尽量不要使用系统的NavigationBar,否则跨版本不好控制工具栏
//    self.wantsFullScreenLayout = YES;
//    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
