//
//  BSRootViewController.m
//  BeautifulStart
//
//  Created by tangbinqi on 14-7-13.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSRootViewController.h"

@interface BSRootViewController ()

@end

@implementation BSRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    NSArray *controllerArray = [NSArray arrayWithObjects:
                                @"BSHomeViewController",
                                @"BSShareViewController",
                                @"BSQuestionListViewController",
                                @"BSGoodsViewController",
                                @"BSUserCenterViewController",nil];//类名数组
    NSArray *titleArray = [NSArray arrayWithObjects:
                           @"首页",
                           @"美妆分享",
                           @"美妆疑问",
                           @"美妆商品",
                           @"个人中心",nil];//item标题数组
    NSArray *normalImageArray = [NSArray arrayWithObjects:
                                 @"icon_tab_home.png",
                                 @"icon_tab_share.png",
                                 @"icon_tab_question.png",
                                 @"icon_tab_goods.png",
                                 @"icon_tab_usercenter.png",nil];//item 正常状态下的背景图片
    NSArray *selectedImageArray = [NSArray arrayWithObjects:
                                   @"icon_tab_home_hl.png",
                                   @"icon_tab_share_hl.png",
                                   @"icon_tab_question_hl.png",
                                   @"icon_tab_goods_hl.png",
                                   @"icon_tab_usercenter_hl.png",nil];//item被选中时的图片名称
    
    for (int i = 0; i< controllerArray.count; i++) {
        
        MALTabBarItemModel *itemModel = [[MALTabBarItemModel alloc] init];
        itemModel.controllerName = controllerArray[i];
        itemModel.itemTitle = titleArray[i];
        itemModel.itemImageName = normalImageArray[i];
        itemModel.selectedItemImageName = selectedImageArray[i];
        [itemsArray addObject:itemModel];
    }

    self = [super initWithItemModels:itemsArray defaultSelectedIndex:0];
    if (self)
    {
        
    }
    [self setTabBarBgImage:@"tabbar_background_os7@2x.png"];//设置tabBar的背景图片
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
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
