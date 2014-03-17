//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTable.h"
#import "Extension.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation PullRefreshTable

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner,moreLabel,moreSpinner,moreFooterView,textMore,PullTableDelegate=_pullTableDelegate;

//@synthesize pageID;

@synthesize isMore,isRefresh;

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if (self) {
        [self loadTable];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadTable];
}

- (void)loadTable
{
    textPull = [[NSString alloc] initWithString:@"下拉刷新"];
    textRelease = [[NSString alloc] initWithString:@"松开刷新"];
    textLoading = [[NSString alloc] initWithString:@"获取数据"];
    textMore = [[NSString alloc] initWithString:@"获取更多"];
    textisLoading=[[NSString alloc] initWithString:@"正在刷新"];
    textisLoadingMore=[[NSString alloc] initWithString:@"获取更多"];
    self.pageID=1;
    self.useAutoLayMore=YES;
    [self addPullToRefreshHeader];
    [self addPullToMoreFooter];
}

- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.text = textPull;
    refreshLabel.numberOfLines=2;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_common_droparrow.png"]];
    refreshArrow.frame = CGRectMake(110,
                                    (REFRESH_HEADER_HEIGHT - 50) / 2+13,
                                    25, 25);
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(110, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    [refreshSpinner stopAnimating];
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self addSubview:refreshHeaderView];
    isRefresh = YES;
}

- (void)addPullToMoreFooter
{
    moreFooterView = [[UIView alloc] init];
    moreFooterView.backgroundColor = [UIColor clearColor];
    
    moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(85,0,150,REFRESH_HEADER_HEIGHT)];
    moreLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    moreLabel.backgroundColor = [UIColor clearColor];
    moreLabel.textAlignment = UITextAlignmentCenter;
    moreLabel.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    
    moreSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    moreSpinner.frame = CGRectMake(110 , (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    moreSpinner.hidesWhenStopped = YES;
    
    moreArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_common_droparrow2.png"]];
    moreArrow.frame=CGRectMake(110,(REFRESH_HEADER_HEIGHT - 20) / 2,20, 20);
    
    [moreFooterView addSubview:moreLabel];
    [moreFooterView addSubview:moreSpinner];
    [moreFooterView addSubview:moreArrow];
    
    [self addSubview:moreFooterView];
    //默认第一次不显示更多，在进行一次reload data后再显示更多
    moreFooterView.hidden=YES;
}

-(void)reloadData
{
    [super reloadData];
    //    if ([self.dataSource tableView:self numberOfRowsInSection:0]>0) {
    
    if (self.useAutoLayMore) {
        CGFloat moreLabelHeight = 0;
        moreLabelHeight = self.contentSize.height>self.height ? self.contentSize.height:self.height;
        if ([self numberOfRowsInSection:0]>0) {
            [self setMorelabelWithheight:moreLabelHeight];
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (isLoading) {

        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
        {
            if(scrollView.contentOffset.y >= (scrollView.contentSize.height - self.frame.size.height))
            {
                if (isMore) 
                    self.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
            }
            else
                self.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            if (isRefresh) 
                self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } 
    else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                refreshLabel.text=textRelease;

                refreshLabel.text = textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header

            refreshLabel.text = textPull;

            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }else if(isDragging && scrollView.contentOffset.y >= (scrollView.contentSize.height-self.frame.size.height))
    {
        [UIView beginAnimations:nil context:nil];
        if (scrollView.contentOffset.y>(scrollView.contentSize.height+REFRESH_HEADER_HEIGHT-self.frame.size.height)) {
            moreLabel.text=self.textLoading;
            [moreArrow layer].transform=CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }else{
            moreLabel.text=self.textMore;
            [moreArrow layer].transform=CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
//    NSLog(@"%f",scrollView.contentSize.height);
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        if (isRefresh) 
            [self startLoading];
    }
    else if(scrollView.contentOffset.y >= (scrollView.contentSize.height + REFRESH_HEADER_HEIGHT - self.frame.size.height) && (scrollView.contentSize.height > self.frame.size.height))
    {
        if(isMore)
        {
            [self startLoading_More];
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return !self.hidden;
}


- (void)startLoading {
    isLoading = YES;

    //更新时间
    if (self.tableID!=nil) {
        NSUserDefaults *info=[NSUserDefaults standardUserDefaults];
        [info setObject:[NSDate date] forKey:[NSString stringWithFormat:@"refreshTime_%@",self.tableID]];
    }
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = textisLoading;
    refreshArrow.hidden = YES;
    refreshSpinner.hidden=NO;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];

    if (self.PullTableDelegate&&[self.PullTableDelegate respondsToSelector:@selector(refresh)])
        [self.PullTableDelegate refresh];
    else
        [self refresh];
}

- (void)stopLoading {
    isLoading = NO;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    refreshArrow.hidden = NO;
    refreshSpinner.hidden=YES;
    self.contentInset = UIEdgeInsetsZero;
    self.contentOffset = CGPointZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    
    [refreshSpinner stopAnimating];
    refreshSpinner.hidden = YES;
    refreshLabel.text = textPull;
    // Hide the header
    self.contentInset = UIEdgeInsetsZero;
    
    //检查行数和section数，如果都为0，添加emptyview
    int sectioncount=0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectioncount=[self.dataSource numberOfSectionsInTableView:self];
    }
    int rowcount=0;
    if([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
        rowcount=[self.dataSource tableView:self numberOfRowsInSection:0];
    }
    if (sectioncount==0&&rowcount==0) {
        self.viewEmptyData.frame=self.frame;
        [self.superview insertSubview:self.viewEmptyData aboveSubview:self];
    }else{
        [self.viewEmptyData removeFromSuperview];
    }
}

- (void)startLoading_More
{
    isLoading = YES;
    
    // Show the header

    self.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
    [moreSpinner startAnimating];
    moreArrow.hidden=YES;
    moreSpinner.hidden=NO;
    moreLabel.text=textisLoadingMore;
    
    if (self.PullTableDelegate&&[self.PullTableDelegate respondsToSelector:@selector(more)])
        [self.PullTableDelegate more];
    else
        [self more];
}

- (void)stopLoading_More
{
    isLoading = NO;
    

    moreLabel.text=textMore;
    moreSpinner.hidden = YES;
    moreArrow.hidden=NO;
    [moreSpinner stopAnimating];
    self.contentInset = UIEdgeInsetsZero;
    
    if (self.useAutoLayMore) {
        //设置高度
        CGFloat height=0;
        int sectioncount=1;
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sectioncount=[self.dataSource numberOfSectionsInTableView:self];
        }
        for (int i=0; i<sectioncount; i++) {
            int row=[self.dataSource tableView:self numberOfRowsInSection:i];
            
            for (int j=0; j<row; j++) {
                NSIndexPath *indexpath=[NSIndexPath indexPathForRow:j inSection:i];
                height+=[self.delegate tableView:self heightForRowAtIndexPath:indexpath];
            }
        }
        //加上footerview和headerview的高度
        height+=self.tableHeaderView.size.height;
        height+=self.tableFooterView.size.height;
        if (height<self.frame.size.height) {
            height=self.frame.size.height;
        }
        
        [self setMorelabelWithheight:height];
    }
    
}

- (void)more
{
    
}

- (void)setMorelabelWithheight:(CGFloat)_height
{
    [self bringSubviewToFront:moreFooterView];

    if (isnan(_height)) {
        return;
    }
    moreFooterView.hidden=NO;
//    _height=_height-self.frame.size.height;
    moreFooterView.frame = CGRectMake(0,_height, 320, REFRESH_HEADER_HEIGHT);

    isMore = YES;
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    refreshSpinner.hidden=YES;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)hiddenRefresh
{
    isRefresh = NO;
    refreshHeaderView.hidden = YES;
}

-(void)hiddenMore
{
    isMore = NO;
    moreFooterView.hidden = YES;
}

- (void)dealloc {
    
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    
    [textPull release];
    [textRelease release];
    [textLoading release];
    [textisLoadingMore release];
    [textisLoading release];
    [moreFooterView release];
    [textMore release];
    [moreLabel release];
    [moreArrow release];
    [moreSpinner release];
    self.viewEmptyData=nil;
    
    self.tableID=nil;
    
    [super dealloc];
}

-(int)pageID
{
    return pageID;
}
-(void)setPageID:(int)pageid
{
    pageID=pageid;
}

-(id<PulltableDelegate>)PullTableDelegate
{
    return _pullTableDelegate;
}

-(void)setPullTableDelegate:(id<PulltableDelegate>)pd
{
    _pullTableDelegate=pd;
}
@end


