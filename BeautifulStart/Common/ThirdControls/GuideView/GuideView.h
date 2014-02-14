//
//  GuideView.h
//  Market
//
//  Created by 亓鑫 on 13-3-22.
//  Copyright (c) 2013年 亓鑫. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GuideViewDelegate;
@interface GuideView : UIView
@property (assign,nonatomic) id<GuideViewDelegate>guideDelegate;
@end

@protocol GuideViewDelegate <NSObject>
- (void)startAppClick:(GuideView*)guideView;
@end