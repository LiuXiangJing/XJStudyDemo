//
//  XJTextRequestViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTextRequestViewController.h"
#import "XJTestDataSource.h"
@interface XJTextRequestViewController ()
{
    XJTestDataSource * _dataSource;
}
@end

@implementation XJTextRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource =[XJTestDataSource dataSource];
    // Do any additional setup after loading the view from its nib.

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络错误，请稍后再试试吧~";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor lightGrayColor];
    hud.cornerRadius = 2;
    [hud hide:YES afterDelay:10];

}
- (IBAction)sendARequestAction:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Some message...";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor lightGrayColor];
    hud.cornerRadius = 2;
    [_dataSource testRequest:^(BOOL success, NSString *errorMsg, NSArray *results) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [hud hide:YES];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
