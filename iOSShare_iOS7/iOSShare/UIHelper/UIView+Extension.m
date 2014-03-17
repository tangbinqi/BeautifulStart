//
//  UIView+Extension.m
//  iTrends
//
//  Created by wujin on 12-9-3.
//
//

#import "UIView+Extension.h"

@class ViewToast;
@interface ViewToast : UIView{
    UILabel *lb_toast;
}

/**
 用来显示文字的label
 */
@property (nonatomic,readonly) UILabel *toastLabe;

@end

@implementation UIView (Extension)
-(CGFloat)height
{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height
{
    [self setHeight:height Animated:NO];
}
-(void)setHeight:(CGFloat)height Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.size.height=height;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }
}
-(void)addHeight:(CGFloat)height
{
    [self setHeight:[self height]+height ];
}


-(CGFloat)width
{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width
{
    [self setWidth:width Animated:NO];
}
-(void)setWidth:(CGFloat)width Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.size.width=width;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }

}
-(void)addWidth:(CGFloat)width
{
    [self setWidth:[self width]+width Animated:NO];
}

-(CGFloat)originX
{
    return self.frame.origin.x;
}
-(void)setOriginX:(CGFloat)x
{
    [self setOriginX:x Animated:NO];
}
-(void)setOriginX:(CGFloat)x Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.origin.x=x;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }

}
-(void)addOriginX:(CGFloat)x
{
    [self setOriginX:[self originX]+x];
}

-(CGFloat)originY
{
    return self.frame.origin.y;
}
-(void)setOriginY:(CGFloat)y
{
    [self setOriginY:y Animated:NO];
}
-(void)setOriginY:(CGFloat)y Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.origin.y=y;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }

}
-(void)addOriginY:(CGFloat)y
{
    [self setOriginY:[self originY]+y];
}

-(CGSize)size
{
    return self.frame.size;
}
-(void)setSize:(CGSize)size
{
    [self setSize:size Animated:NO];
}
-(void)setSize:(CGSize)size Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.size=size;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }
}

-(CGPoint)origin
{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)point
{
    [self setOrigin:point Animated:NO];
}
-(void)setOrigin:(CGPoint)point Animated:(BOOL)animate
{
    CGRect frame=self.frame;
    frame.origin=point;
    if (animate) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame=frame;
        }];
    }else{
        self.frame=frame;
    }

}


-(CGPoint)originTopRight
{
    return CGPointMake(self.origin.x+self.width, self.origin.y);
}

-(CGPoint)originBottomLeft
{
    return CGPointMake(self.originX, self.originY+self.height);
}

-(CGPoint)originBottomRight
{
    return CGPointMake(self.originX+self.width, self.originY+self.height);
}
-(CGRect)rectForAddViewTop:(CGFloat)height//返回在该view上面添加一个视图时的frame
{
    CGRect frame=self.frame;
    frame.size.height=height;
    frame.origin.y=frame.origin.y-height;
    
    return frame;
}
-(CGRect)rectForAddViewBottom:(CGFloat)height//返回在该view下面添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.origin.y=frame.origin.y+frame.size.height;
    frame.size.height=height;
    return frame;
}
-(CGRect)rectForAddViewLeft:(CGFloat)width//返回在该view左边添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.size.width=width;
    frame.origin.x=frame.origin.x-width;
    return frame;
}
-(CGRect)rectForAddViewRight:(CGFloat)width//返回在该view右边添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.size.width=width;
    frame.origin.x=frame.origin.x+width;
    return frame;
}

-(CGRect)rectForAddViewTop:(CGFloat)height Offset:(CGFloat)offset//返回在该view上面添加一个视图时的frame
{
    CGRect frame=self.frame;
    frame.size.height=height;
    frame.origin.y=frame.origin.y-height-offset;
    return frame;

}
-(CGRect)rectForAddViewBottom:(CGFloat)height Offset:(CGFloat)offset//返回在该view下面添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.origin.y=frame.origin.y+frame.size.height+offset;
    frame.size.height=height;
    return frame;

}
-(CGRect)rectForAddViewLeft:(CGFloat)width Offset:(CGFloat)offset//返回在该view左边添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.size.width=width;
    frame.origin.x=frame.origin.x-width-offset;
    return frame;

}
-(CGRect)rectForAddViewRight:(CGFloat)width Offset:(CGFloat)offset//返回在该view右边添加一个视图的时候的frame
{
    CGRect frame=self.frame;
    frame.size.width=width;
    frame.origin.x=frame.origin.x+width+offset;
    return frame;
}

-(CGRect)rectForCenterofSize:(CGSize)size
{
    CGRect rect;
    rect.size.width=size.width;
    rect.size.height=size.height;
    rect.origin.x=(self.width-size.width)/2.0;
    rect.origin.y=(self.height-size.height)/2.0;
    return rect;
}

-(NSArray*)subviewsWithClass:(Class )cls
{
    NSArray *array=[self subviews];
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:cls]) {
            return YES;
        }
        return NO;
    }]];
}

-(void)showToastAtPoint:(CGPoint)point Title:(NSString*)title
{
    //给定一个tag ,每次添加的toast都为此tag,防止重复添加
    static int toastTag=9823393;
    ViewToast *toast=(ViewToast*)[self viewWithTag:toastTag];
    if (toast==nil || ![toast isKindOfClass:[ViewToast class]]) {
        toast   =[[[ViewToast alloc] initWithFrame:CGRectMake(point.x, point.y, self.width, 40)] autorelease];
        toast.alpha=0;//默认透明度为0
        toast.tag=toastTag;
        
        [self addSubview:toast];
        [UIView animateWithDuration:.3 animations:^{
            toast.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    toast.toastLabe.text=title;
    
    
}
-(void)showToastAtTopWithTitle:(NSString*)title
{
    [self showToastAtPoint:CGPointZero Title:title];
}

-(id)viewWithTag2:(int)tag
{
    return [self viewWithTag:tag];
}

/**
 取消子视图中UIAsyncImageView与UIAsyncImageButton的图片下载请求
 此方法不会遍历子视图的视图，只会进行一次遍历
 */
-(void)cancelSubviewImageDownload
{
//    for (UIView *s_view in self.subviews) {
//        if ([s_view isKindOfClass:[UIButton class]]) {
//            [(UIButton*)s_view cancelCurrentImageLoad];
//        }else if ([s_view isKindOfClass:[UIImageView class]]){
//            [(UIImageView*)s_view cancelCurrentImageLoad];
//        }
//    }
}

/**
 取消所有子视图的异步图片下载
 */
+(void)cancelSubviewImageDownloadinView:(UIView*)view
{
    for (UIView *s_view in view.subviews) {
        [s_view cancelSubviewImageDownload];
        [UIView cancelSubviewImageDownloadinView:s_view];
    }
}
@end


@implementation ViewToast

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:.9];
        
        lb_toast=[[UILabel alloc] initWithFrame:self.bounds];
        lb_toast.backgroundColor=[UIColor clearColor];
        lb_toast.font=[UIFont boldSystemFontOfSize:14];
        lb_toast.textColor=[UIColor whiteColor];
        lb_toast.shadowOffset=CGSizeMake(0, 1);
        lb_toast.shadowColor=[UIColor blackColor];
        lb_toast.textAlignment=NSTextAlignmentCenter;
        
        [self addSubview:lb_toast];
    }
    return self;
}

-(void)dealloc
{
    [lb_toast release];
    
    [super dealloc];
}

-(UILabel*)toastLabe
{
    return lb_toast;
}

-(void)removeFromSuperview
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeFromSuperview) object:nil];
    
    [super removeFromSuperview];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

//-(void)removeFromSuperview
//{
//    __block ViewToast *block_self=self;
//    
//    [UIView animateWithDuration:.3 animations:^{
//        block_self.alpha=0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [super removeFromSuperview];
//            block_self.alpha=1;
//        }
//    }];
//    
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
    [super touchesEnded:touches withEvent:event];
}
@end

@implementation UIDebugView

-(void)setFrame:(CGRect)frame
{
    NSLog(@"set frame:%@",self.description);
    [super setFrame:frame];
}

@end

@implementation UIDebugTableView

-(void)setFrame:(CGRect)frame
{
    NSLog(@"set frame:%@",self.description);
    [super setFrame:frame];
}

@end

@implementation UIDebugScrollView

-(void)setFrame:(CGRect)frame
{
    NSLog(@"set frame:%@",self.description);
    [super setFrame:frame];
}

@end
