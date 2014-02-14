//
//  GuideView.m
//  Market
//
//  Created by 亓鑫 on 13-3-22.
//  Copyright (c) 2013年 亓鑫. All rights reserved.
//

#import "GuideView.h"

#define kGuideWitdh 1024
#define kGuideHeight 768


@interface GuideView ()
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation GuideView




+ (UIImage*)getImageWithName:(NSString*)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *imgData = [NSData dataWithContentsOfFile:path
                                             options:NSDataReadingMapped
                                               error:nil];
    return [UIImage imageWithData:imgData];
}



- (void)startApp
{
    if (_guideDelegate && [_guideDelegate respondsToSelector:@selector(startAppClick:)])
    {
        //配合[Device isFirestInstall]方法使用
        [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:@"isFirstInstall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_guideDelegate startAppClick:self];
    }
}







- (id)init
{
    self = [super init];
    if (self)
    {
        self.images = [NSMutableArray array];
        for (int i = 0; i < 4; i++)
        {
            [self.images addObject:[GuideView getImageWithName:[NSString stringWithFormat:@"guide%d.png",i]]];
        }

        //TODO: 初始化
        self.frame = CGRectMake(0, 0, kGuideWitdh, kGuideHeight);

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(kGuideWitdh*[self.images count], kGuideHeight);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];

        //TODO: 背景图
        self.backgroundColor = [UIColor colorWithPatternImage:[GuideView getImageWithName:@"guideBG.jpg"]];


        //TODO: 引导图片
        for (int i = 0; i < [self.images count]; i++)
        {
            //TODO: 暂时写死成固定大小,如需调整可以在这里改写
            UIImageView *showImg = [[UIImageView alloc] initWithFrame:CGRectMake(kGuideWitdh*i, 0, kGuideWitdh, kGuideHeight)];
            showImg.image = [self.images objectAtIndex:i];
            showImg.contentMode = UIViewContentModeScaleAspectFit;
            showImg.userInteractionEnabled = YES;
            showImg.center = CGPointMake(self.center.x+kGuideWitdh*i, self.center.y);
            [self.scrollView addSubview:showImg];

            //TODO: 如果这是最后一张
            if (i+1 == [self.images count])
            {
                UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [startBtn setTitle:@"shit! 进入APP" forState:UIControlStateNormal];
                [startBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.1 alpha:1.0]];
//                [startBtn setImage:[UIImage imageNamed:@"lijitiyan.png"] forState:UIControlStateNormal];
//                [startBtn setImage:[UIImage imageNamed:@"lijitiyan02.png"] forState:UIControlStateHighlighted];
                [startBtn setFrame:CGRectMake(80, 425, 300, 44)];
                [startBtn setCenter:CGPointMake(kGuideWitdh/2.0, kGuideHeight/2.0+200)];
                [startBtn addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
                [showImg addSubview:startBtn];
            }
        }
    }
    return self;
}


@end
