//
//  XJPickerViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJPickerViewController.h"

@interface XJPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end
#import "XJSinglePickerView.h"
@implementation XJPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIPickerView * pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 355)];
    pickerView.delegate =self;
    pickerView.dataSource =self;
    [self.view addSubview:pickerView];
    
    
  
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return @"这是";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showSinglePickerView:(id)sender {
    XJSinglePickerView * pickerViewww =[[XJSinglePickerView alloc]initWithDataArray:@[@"第一行",@"第二行",@"第三行",@"第四行",@"第五行"]];
    [pickerViewww showSinglePickerWithPickerSelect:^(NSString *selectStr, BOOL isFinal) {
        NSLog(@"selectStr=%@",selectStr);
    }];
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
