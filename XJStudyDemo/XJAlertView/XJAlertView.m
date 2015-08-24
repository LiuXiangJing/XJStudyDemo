//
//  XJAlertView.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/24.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJAlertView.h"
#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
@implementation XJAlertView
- (instancetype)init {
    self =[super init];
     [self configView];
    return self;
}
- (instancetype)initWtihCustomView:(UIView *)customView {
    self =[super init];
    if (self) {
        
        [self configView];
        [self addSubview:customView];
        customView.center = self.center;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title conent:(NSString *)content {
    self =[super init];
    if (self) {
         [self configView];
    }
    return self;
}
- (void)configView {
    self.backgroundColor =[UIColor colorWithWhite:1 alpha:0.2];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

#pragma mark 显示动画
-(void)showAlertView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden =NO;
        self.alpha = 0;
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1;
        }];
    });
}
#pragma mark 消失动画
- (void)dismissAlertView{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self setAlpha:0.0f];
            self.hidden=YES;
            [self removeFromSuperview];
            
        }
    }];
}

@end
