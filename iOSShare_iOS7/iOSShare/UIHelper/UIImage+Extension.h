//
//  UIImage+Extension.h
//  iTrends
//
//  Created by wujin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//取得指定名称的图片
#define IMG(name) [UIImage imageNamed:name]

//返回可以变形的图片
#define IMG_ST(name,x,y) [IMG(name) stretchableImageWithLeftCapWidth:x topCapHeight:y]
//取得指定名称的图片
#define IMG2(name) [UIImage imageNamed2:name]

@interface UIImage (Extension)
+(UIImage *)imageNamed2:(NSString *)name;
//占位图
+(UIImage *)tempImage;
//头像占位图
+(UIImage *)tempImageHead;
//获取指定大小的占位图
+(UIImage *)tempImageWithSize:(CGSize)size;
//调整大小后的图像
-(UIImage*)sizedImage:(CGSize)size;
//旋转图片
+(UIImage *)rotateImage:(UIImage *)aImage;
//获取旋转后的图片
-(UIImage *)rotatedImage;
//news feed和个人主面用的占位图
+(UIImage *)tempImageNewsFeed;
//获取图片根据大小生成的地址
//+(UIImage *)imageNamed:(NSString *)name Size:(CGSize)size;

//+(UIImage *)image
//指定图片的大小
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

-(UIImage *)scaleToSize:(CGSize)size;
@end
