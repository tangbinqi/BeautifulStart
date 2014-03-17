//
//  PullRefreshTableViewController.h
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

#import <UIKit/UIKit.h>

@protocol PulltableDelegate;

@interface PullRefreshTable : UITableView {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    NSString *textMore;
    NSString *textisLoading,*textisLoadingMore;
    
    
    BOOL isRefresh;
    
    UIView *moreFooterView;
    UILabel *moreLabel;
    UIImageView *moreArrow;
    UIActivityIndicatorView *moreSpinner;
    BOOL isMore;
    
    id<PulltableDelegate> _pullTableDelegate;
    
    __block int pageID;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@property (nonatomic, retain) UIView *moreFooterView;
@property (nonatomic, retain) NSString *textMore;
@property (nonatomic, retain) UILabel *moreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *moreSpinner;
@property (nonatomic, assign) id<PulltableDelegate> PullTableDelegate;

/**
 数据为空的时候显示的一个view
 此属性会在每次reloadData的时候检查rowCount和sectionCount，如果都为0，会将此视图添加到table上（会盖住table)
 */
@property (nonatomic,retain) UIView *viewEmptyData;

@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,retain) NSString *tableID;//表格ID，用于记录上次刷新时间
@property (nonatomic,assign) BOOL useAutoLayMore;  //是否自动设置更多位置
@property (nonatomic,assign) BOOL isShowingEmptyView;   //是否正在显示空白信息

/**
 用于分页时的页面
 
 默认为1
 */
-(int)pageID;
-(void)setPageID:(int)pageid;

- (void)addPullToRefreshHeader;
- (void)addPullToMoreFooter;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

- (void)startLoading_More;
- (void)stopLoading_More;
- (void)more;

- (void)setMorelabelWithheight:(CGFloat)_height;
- (void)hiddenRefresh;
- (void)hiddenMore;
//执行一些额外的加载操作
-(void)loadTable;


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView ;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate ;
@end

#define PULLREFRESHTABLESCROLL(table) - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {if(scrollView==table){[table scrollViewWillBeginDragging:scrollView];}}\
\
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {if(scrollView==table){[table scrollViewDidScroll:scrollView];}}\
\
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {if(scrollView==table){[table scrollViewDidEndDragging:scrollView willDecelerate:decelerate];}}


@protocol PulltableDelegate <NSObject>

-(void)refresh;
-(void)more;

@end
