//
//  MALTabBar.h
//  TabBarControllerModel
//
//  Created by wangtian on 14-6-25.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MALTabBarItem.h"

#define MainScreenBoundsSize [UIScreen mainScreen].bounds.size
#define tabBarHeight 49 //tabBar的高度
@protocol MALTabBarDelegate <NSObject>

- (void)selectedItem:(MALTabBarItemModel *)selectedItemModel;//当item被选中时会触发该代理方法

@end

@interface MALTabBar : UIView
{
    NSMutableArray *_items;
}
@property (nonatomic, strong) NSArray *itemArray;//item 模型数组
@property (nonatomic, assign) id<MALTabBarDelegate> delegate;//代理
@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;//当前选中项
@property (nonatomic, assign, readonly) NSInteger lastSelectedIndex;//上一个选中项
@property (nonatomic, readonly) NSMutableArray *items;//item 控件数组

+ (MALTabBar *)getMALTabBarWithItemModels:(NSArray *)itemModels defaultSelectedIndex:(NSInteger)defaultSelectedIndex;
- (void)selectedItemAtIndex:(NSInteger)itemIndex;
- (void)setItemBadgeNumberWithIndex:(NSInteger)itemIndex badgeNumber:(NSInteger)badgeNumber;
@end
