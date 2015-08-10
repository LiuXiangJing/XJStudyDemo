//
//  XJActionSheetViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/4.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//
#define IS_IOS8 (([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) ? YES : NO)
#import "XJActionSheetViewController.h"

@interface XJActionSheetViewController ()<UIActionSheetDelegate>

@end
#import "DebugTools.h"
#import "XJActionSheet.h"
@implementation XJActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"ActionSheet";
}
/*
 *  猜测系统的ActionSheet 是有一个标题Label 一个TableView显示destructiveButtonTitle 和 otherButtonTitles 还有一个取消按钮组成
 *  显示UIActionSheet iOS8之后可能被UIAlertController替代
 */
- (IBAction)showUIActionSheet:(id)sender {
    
    UIActionSheet * systemActionSheet =[[UIActionSheet alloc]initWithTitle:@"标题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"红字提示" otherButtonTitles:@"其他按钮1",@"其他按钮2",@"其他按钮3",nil];
    [systemActionSheet showInView:self.view];
}
/**
 *  显示自定义的actionSheet
 */
- (IBAction)showXJActionSheet:(id)sender {
    XJActionSheet * actionSheet =[[XJActionSheet alloc]initWithTitle:@"标题" cancelButtonTitle:@"取消" destructiveButtonTitle:@"红丝提示" otherButtonTitles:@"其他按钮1",@"其他按钮1",@"其他按钮1",@"其他按钮1", nil];
    [actionSheet showActionSheetWithHandle:^(NSInteger buttonIndex) {
        NSLog(@"点中第%ld个按钮",(long)buttonIndex);
    }];
}
/**
 *  iOS8 上把UIAlertView 和 UIActionSheet 合并起来了，组成为 UIAlertController
 */
- (IBAction)showAlertController:(id)sender {
    if (!IS_IOS8) {
        return;
    }
    
    UIAlertController * alertController =[UIAlertController alertControllerWithTitle:@"提示标题" message:@"提示信息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
          NSLog(@"取消按钮点击");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         NSLog(@"确定按钮点击");
    }];
     UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"警告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
         NSLog(@"警告按钮点击");
     }];
    [alertController addAction:destructiveAction];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
