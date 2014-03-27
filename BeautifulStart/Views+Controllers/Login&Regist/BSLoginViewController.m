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
@property (weak, nonatomic) IBOutlet UITextField *loginNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

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
    BSRegistViewController *registVC = [[BSRegistViewController alloc] initWithNibName:@"BSRegistViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - Performance function
- (BOOL)checkNameAndPassword{
    BOOL isRight = YES;
    if (self.loginNameTF.text.length == 0) {
        [self.loginNameTF shake];
        return isRight = NO;
    }
    
    if (self.passwordTF.text.length == 0) {
        [self.passwordTF shake];
        return isRight = NO;
    }
    
    if (![self.loginNameTF.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请输入正确的邮箱地址"];
        return isRight = NO;
    }
    
    if ((self.passwordTF.text.length < 6) || (self.passwordTF.text.length > 20)) {
        [BSComUtil showAlertWithTitle:nil message:@"密码位数不能小于6位，也不能超过 20位"];
        return isRight = NO;
    }
    
    if (![self.passwordTF.text isMatchedByRegex:@"^[a-zA-Z0-9%#!~`=,/_.+\\-]+$"]) {
        [BSComUtil showAlertWithTitle:nil message:@"请输入正确格式的密码"];
        return  isRight = NO;
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
        [self setEditing:NO];
        [self loginAction:nil];
    }
    
    return isReturn;
}

@end
