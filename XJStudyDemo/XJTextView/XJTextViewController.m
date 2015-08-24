//
//  XJTextViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/21.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTextViewController.h"
#import "XJTextView.h"
@interface XJTextViewController ()

@end

@implementation XJTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"XJTextView";
    // Do any additional setup after loading the view from its nib.
   
    XJTextView * textView2 =[[XJTextView alloc]initWithFrame:CGRectMake(0, 64, 200, 200)];
    textView2.backgroundColor =[UIColor blueColor];
    textView2.placeholder =@"亲，写点什么吧，您的评价对其他童鞋有很大的帮助喔";
    [self.view addSubview:textView2];
    
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
