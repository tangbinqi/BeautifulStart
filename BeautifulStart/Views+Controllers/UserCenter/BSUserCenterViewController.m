//
//  BSUserCenterViewController.m
//  BeautifulStart
//
//  Created by tangbinqi on 14-3-22.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSUserCenterViewController.h"

@interface BSUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tView;
    NSArray *tableArray;
}
@end

@implementation BSUserCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        tableArray = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"个人中心",@"修改密码",@"密码设置",@"修改头像",@"我的提问",@"我的分享", nil],
                      [NSArray arrayWithObjects:@"检查更新",@"意见反馈",@"关于我们", nil],
                      nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate & UITablewViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (tableArray.count >= section) {
        row = [[tableArray objectAtIndex:section] count];
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = FONT_BAN_JIAO_SIZE(14);
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 4||indexPath.row == 5) {
            cell.textLabel.textColor = [UIColor colorWithRed:255 green:0 blue:128 alpha:1];
            
        }
    }
    
    if (tableArray &&
        (tableArray.count >= indexPath.section) &&
        ([[tableArray objectAtIndex:indexPath.section] count]>= indexPath.row)) {
        cell.textLabel.text = [[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_DEFAULT_HEIGHT;
}

@end
