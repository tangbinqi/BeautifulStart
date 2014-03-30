//
//  BSRootViewController.m
//  BeautifulStart
//
//  Created by tangbinqi on 14-3-22.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSRootViewController.h"
#import "BSHomeViewController.h"
#import "BSGoodsViewController.h"
#import "BSSearchViewController.h"
#import "BSShareViewController.h"
#import "BSQuestionListViewController.h"
#import "BSUserCenterViewController.h"


@interface BSRootViewController ()

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation BSRootViewController

- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.animation = NGTabBarControllerAnimationMoveAndScale;
        self.view.backgroundColor = [UIColor lightGrayColor];
        self.tabBar.tintColor = [UIColor colorWithRed:255.f/255.f green:0.f/255.f blue:128.f/255.f alpha:1.f];
        self.tabBar.itemPadding = 0.f;
//        self.tabBar.position = NGTabBarPositionBottom;
        [self setupForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
        
        [self initSubViewControllers];
        
    }
    return self;
}

/**
 *  初始化各个tab的viewController
 */
- (void)initSubViewControllers
{
    BSHomeViewController *homeVC = [[BSHomeViewController alloc] initWithNibName:@"BSHomeViewController"
                                                                          bundle:[NSBundle mainBundle]];
    BSShareViewController *shareVC = [[BSShareViewController alloc] initWithNibName:@"BSShareViewController"
                                                                             bundle:[NSBundle mainBundle]];
    BSQuestionListViewController *questionListVC = [[BSQuestionListViewController alloc] initWithNibName:@"BSQuestionListViewController"
                                                                                                  bundle:[NSBundle mainBundle]];
    BSGoodsViewController *goosListVC = [[BSGoodsViewController alloc] initWithNibName:@"BSGoodsViewController"
                                                                                bundle:[NSBundle mainBundle]];
    BSUserCenterViewController *userCenter = [[BSUserCenterViewController alloc] initWithNibName:@"BSUserCenterViewController"
                                                                                          bundle:[NSBundle mainBundle]];

    homeVC.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"首页" image:IMG(@"icon_tab_home")];
    shareVC.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"美妆分享" image:IMG(@"icon_tab_share")];
    questionListVC.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"美妆疑问" image:IMG(@"icon_tab_question")];
    goosListVC.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"美妆商品" image:IMG(@"icon_tab_goods")];
    userCenter.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"个人中心" image:IMG(@"icon_tab_usercenter")];
    
    
    NSArray *controllers = [NSArray arrayWithObjects:homeVC, shareVC, questionListVC, goosListVC, userCenter, nil];
    for (UIViewController *vc in controllers) {
        vc.ng_tabBarItem.selectedTitleColor = [UIColor yellowColor];
        vc.ng_tabBarItem.selectedImageTintColor = [UIColor yellowColor];
    }
    
    self.viewControllers = controllers;
    

}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

// 禁止界面旋转
- (BOOL)shouldAutorotate

{
    
    return NO;
    
}


////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.tabBarPosition = NGTabBarPositionBottom;
        self.tabBar.showsItemHighlight = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyCentered;
    } else {
        self.tabBarPosition = NGTabBarPositionLeft;
        self.tabBar.showsItemHighlight = YES;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
