//
//  BSRegistViewController.m
//  BeautifulStart
//
//  Created by tangbinqi-gm on 14-2-15.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSRegistViewController.h"

@interface BSRegistViewController ()
@property (strong, nonatomic) IBOutlet UITextField *loginNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *rePasswordTF;

@end

@implementation BSRegistViewController

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

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registBtnAction:(UIButton *)sender {
    if ([self checkNameAndPassword]) {
        // 发起注册请求
    }
}


#pragma mark - Performance function
- (BOOL)checkNameAndPassword{
    NSString *loginName = self.loginNameTF.text;
    NSString *password = self.passwordTF.text;
    NSString *rePassword = self.rePasswordTF.text;
    
    BOOL isRight = YES;
    if (loginName.length == 0) {
        [self.loginNameTF shake];
        return isRight = NO;
    }
    
    if (password.length == 0) {
        [self.passwordTF shake];
        return isRight = NO;
    }
    
    if (rePassword.length == 0) {
        [self.rePasswordTF shake];
        return isRight = NO;
    }

    if (![loginName isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\\b"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请输入正确的邮箱地址"];
        return isRight = NO;
    }
    
    if (password.length < 6 || password.length > 20) {
        [BSComUtil showAlertWithTitle:nil message:@"密码位数不能小于6位，也不能超过 20位"];
        return isRight = NO;
    }
    
    if (![password isMatchedByRegex:@"^[a-zA-Z0-9%#!~`=,/_.+\\-]+$"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请安装规定格式输入密码"];
    }
    
    if (![password isEqualToString:rePassword]) {
        [BSComUtil showAlertWithTitle:nil message:@"两次输入的密码不一致"];
    }
    
    return isRight;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL isReturn = YES;;
    if ([textField isEqual:self.loginNameTF]) {
        [self.loginNameTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
        isReturn = NO;
    }
    
    if ([textField isEqual:self.passwordTF]) {
        [self.passwordTF resignFirstResponder];
        [self.rePasswordTF becomeFirstResponder];
        isReturn = NO;
    }
    
    if ([textField isEqual:self.rePasswordTF]) {
        [self setEditing:NO];
        [self registBtnAction:nil];
    }
    
    return isReturn;
}

@end
