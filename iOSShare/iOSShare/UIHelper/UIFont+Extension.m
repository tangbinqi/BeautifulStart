//
//  UIFont+Extension.m
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+(id)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica" size:size];
}

+(id)fontBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}
@end
