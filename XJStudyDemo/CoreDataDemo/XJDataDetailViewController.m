//
//  XJDataDetailViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJDataDetailViewController.h"

@interface XJDataDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *avaterTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@end
#import "UserDetailInfo.h"
@implementation XJDataDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self configureView];
}
-(void)setUserInfo:(UserInfo *)userInfo{
    if (_userInfo != userInfo) {
        _userInfo= userInfo;
        [self configureView];
    }
}
-(void)configureView{
     self.userNameTF.text =_userInfo.userName;
     self.avaterTF.text =_userInfo.detailInfo.avatar;
     self.phoneTf.text =_userInfo.detailInfo.phoneNumber;
     self.emailTF.text =_userInfo.detailInfo.email;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
