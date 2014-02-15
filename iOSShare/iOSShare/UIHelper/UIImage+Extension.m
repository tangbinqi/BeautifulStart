//
//  UIImage+Extension.m
//  iTrends
//
//  Created by wujin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"

@implementation UIImage (Extension)

+(UIImage *)imageNamed2:(NSString *)name;
{
    NSString *ext=[name pathExtension];
    
    if (StringNotNullAndEmpty(ext)) {//有扩展名，去掉
        name=[name stringByReplacingOccurrencesOfString:ext withString:@""];
    }
    
    if ([name isContainString:@"-568h"]||[name isContainString:@"@2x"]) {//默认已经有了，不管
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height==568) {
            name=[NSString stringWithFormat:@"%@-568h@2x",name];
        }else if([UIScreen mainScreen].scale==2){
            name=[NSString stringWithFormat:@"%@@2x",name];
        }
    }
    if (StringNotNullAndEmpty(ext)) {
        name=[NSString stringWithFormat:@"%@.%@",name,ext];
    }
    return [UIImage imageNamed:name];
}

//占位图
+(UIImage *)tempImage
{
    return [UIImage imageNamed:@"logo_home"];
}
//头像占位图
+(UIImage *)tempImageHead
{
    return [UIImage imageNamed:@"tempHead"];
}

+(UIImage *)tempImageNewsFeed
{
    return [UIImage imageNamed:@"inimgbj"];
}
//获取指定大小的占位图
+(UIImage *)tempImageWithSize:(CGSize)size
{
    CGFloat width=size.width,heiht=size.height;
    UIImage *image=[UIImage imageNamed:@"logo_home"];
    UIGraphicsBeginImageContext(CGSizeMake(width, heiht));
    CGContextRef context=UIGraphicsGetCurrentContext();
    if (context==nil) {
        return nil;
    }
    UIColor *color=[UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1];
    
    //画背景色
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    //转180度
//    CGContextRotateCTM(context, 180);
    CGRect rect=CGRectMake((width-CGImageGetWidth(image.CGImage))/2,(heiht-CGImageGetHeight(image.CGImage))/2 , CGImageGetWidth(image.CGImage)/image.scale, CGImageGetHeight(image.CGImage)/image.scale);
    CGContextDrawImage(context,rect , image.CGImage);
    //画Logo    
    UIImage *retimg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retimg;
//    return IMG(@"occupy");
}

//调整大小后的图像
-(UIImage*)sizedImage:(CGSize)size
{
    return [UIImage scaleToSize:self size:size];
}
//旋转图片
+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

-(UIImage *)rotatedImage
{
    return [UIImage rotateImage:self];
}
//指定图片大小
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
-(UIImage *)scaleToSize:(CGSize)size
{
    return [UIImage scaleToSize:self size:size];
}

@end
