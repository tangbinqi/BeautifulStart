//
//  BSLoginViewController.m
//  BeautifulStart
//
//  Created by tangbinqi-gm on 14-2-15.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSLoginViewController.h"
#import "BSRegistViewController.h"

@interface BSLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;

@end

@implementation BSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Action Event

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"登录界面返回");
    }];
}
- (IBAction)loginAction:(UIButton *)sender {
    if ([self checkNameAndPassword]) {
        NSLog(@"开始调用登录接口");
    }
}

- (IBAction)goRegistAction:(UIButton *)sender {
    BSRegistViewController *registVC = [[BSRegistViewController alloc] initWithNibName:@"GMLoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - Performance function
- (BOOL)checkNameAndPassword{
    BOOL isRight = YES;
    if (self.loginNameTextF.text.length == 0) {
        [self.loginNameTextF shake];
        return isRight = NO;
    }
    
    if (self.passwordTextF.text.length == 0) {
        [self.passwordTextF shake];
        return isRight = NO;
    }
    
    if (![self.loginNameTextF.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请输入正确的邮箱地址"];
        return isRight = NO;
    }
    
    if ((self.passwordTextF.text.length < 6) || (self.passwordTextF.text.length > 20)) {
        [BSComUtil showAlertWithTitle:nil message:@"密码位数不能小于6位，也不能超过 20位"];
        return isRight = NO;
    }
    
    if (![self.passwordTextF.text isMatchedByRegex:@"^w+$"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请输入正确格式的密码"];
        return  isRight = NO;
    }
    
    return isRight;
}











@end
