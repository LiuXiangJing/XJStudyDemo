//
//  XJAddDataViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/29.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJAddDataViewController.h"

@interface XJAddDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userAvatar;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTF;

@end
#import "UserInfo.h"
@implementation XJAddDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveObjectAction)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)saveObjectAction{
    if (self.userNameTF.text.length>0) {
        UserInfo * userInfo =[[UserInfo alloc]initWithUserId:self.userNameTF.text userName:self.userNameTF.text phoneNumber:self.userPhoneTF.text avatar:self.userAvatar.text email:self.userEmailTF.text];
        [userInfo saveObject];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"用户名不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
