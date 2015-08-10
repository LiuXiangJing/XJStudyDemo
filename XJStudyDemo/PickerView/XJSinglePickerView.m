//
//  XJSinglePickerView.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJSinglePickerView.h"
@interface XJSinglePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView * _pickerViewBgView;
    UIPickerView *_pickerView;
    NSArray * _contentArray;
    NSInteger currentRow;
}
@property(nonatomic,copy)DataPickerBlock pickerBlcok;
@end
#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])

#define datePickerHeight 256
#define barViewHeight 45
#define btnSpacing 0
@implementation XJSinglePickerView

-(instancetype)initWithDataArray:(NSArray *)dataArray
{
    self =[super init];
    if (self) {
        self.frame =[[UIScreen mainScreen]bounds];
        self.alpha = 0;
        //        [self setWindowLevel:UIWindowLevelAlert + 1];//
        _contentArray =[[NSArray alloc]initWithArray:dataArray];
        currentRow = 0;
        self.backgroundColor =[UIColor clearColor];
        [self confitUI];
    }
    return self;
    
}
-(void)confitUI{
    //添加时间选择器背景
    _pickerViewBgView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, datePickerHeight)];
    _pickerViewBgView.backgroundColor =[UIColor whiteColor];
    [self addSubview:_pickerViewBgView];
    //添加工具栏
    UIView * barView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, barViewHeight)];
    barView.backgroundColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
    [_pickerViewBgView addSubview:barView];
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:33.0/255 green:171.0/255 blue:242.0/255 alpha:1] forState:UIControlStateNormal];//R_G_B_A_COLOR(33, 171, 242, 1)
    leftBtn.frame =CGRectMake(btnSpacing, 0,58 , barViewHeight);
    leftBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [leftBtn addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:leftBtn];
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:10.0/255 green:170.0/255 blue:245.0/255 alpha:1] forState:UIControlStateNormal];//R_G_B_A_COLOR(10.0/255, 170.0/255, 245.0/255, 1)
    rightBtn.frame =CGRectMake(kScreenWidth-58-btnSpacing, 0, 58, barViewHeight);
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [rightBtn addTarget:self action:@selector(onMakeSureDate) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightBtn];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, barViewHeight-0.5, kScreenWidth, 0.5f)];
    lineView.backgroundColor=[UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1];//R_G_B_A_COLOR(225, 225, 225, 1);
    [barView addSubview:lineView];
    
    _pickerView= [[UIPickerView alloc]initWithFrame:CGRectMake(0.0,barViewHeight,0.0,0.0)];
    _pickerView.delegate=self;
    _pickerView.dataSource =self;
    [_pickerView  setTintColor:[UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1]];//R_G_B_A_COLOR(80, 80, 80, 1)];
    [_pickerViewBgView addSubview:_pickerView];
    
    UITapGestureRecognizer * tapGes =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenDatePicker:)];
    [self addGestureRecognizer:tapGes];
    
}

#pragma mark - methods
#pragma mark 现实pickView并时时返回当前选中的行
-(void)showSinglePickerWithPickerSelect:(DataPickerBlock)complete
{
    self.pickerBlcok = complete;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        self.alpha = 0;
        self.hidden =NO;
        
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            _pickerViewBgView.frame = CGRectMake(0, kScreenHeight-datePickerHeight, kScreenWidth, datePickerHeight);
        }];
    });
}
#pragma mark 隐藏pickView
-(void)dismissPickerView{
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, datePickerHeight);
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            
            [self setAlpha:0.0f];
            self.hidden=YES;
            [self removeFromSuperview];
            
        }
    }];
}
-(void)hiddenDatePicker:(UITapGestureRecognizer *)tapGes
{
    if ([tapGes locationInView:self].y<(kScreenHeight-datePickerHeight)) {
        [self dismissPickerView];
    }
}
#pragma mark 确定pickerView选择
-(void)onMakeSureDate{
    if ([_contentArray count]>currentRow) {
        
        NSString * selectStr =[_contentArray objectAtIndex:currentRow];
        self.pickerBlcok(selectStr,YES);
        
    }else{
        self.pickerBlcok(@"",YES);
    }
    [self dismissPickerView];
}

#pragma mark - UIPickerViewDelegate-UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_contentArray count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_contentArray objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentRow= row;
    if ([_contentArray count]>row) {
        NSString * selectStr =[_contentArray objectAtIndex:row];
        self.pickerBlcok(selectStr,NO);
    }else{
        self.pickerBlcok(nil,NO);
    }
}

@end
