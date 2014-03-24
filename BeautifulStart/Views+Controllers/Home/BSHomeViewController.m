//
//  BSHomeViewController.m
//  BeautifulStart
//
//  Created by tangbinqi-gm on 14-2-15.
//  Copyright (c) 2014年 tangbinqi. All rights reserved.
//

#import "BSHomeViewController.h"
#import "BSLoginViewController.h"

@interface BSHomeViewController ()

@end

@implementation BSHomeViewController

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

- (IBAction)login:(id)sender {
   UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:
                                       [[BSLoginViewController alloc] initWithNibName:@"BSLoginViewController"
                                                                               bundle:[NSBundle mainBundle]]];
    loginNav.navigationBar.hidden = YES;
    [self presentViewController:loginNav animated:YES completion:^{
    }];
}
@end
