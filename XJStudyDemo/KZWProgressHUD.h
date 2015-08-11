//
//  KZWProgressHUD.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KZWProgressHUD : NSObject

+ (void)showTipsInView:(UIView *)view OnlyString:(NSString *)tipsString;
+ (void)showLoadingInView:(UIView *)superView showOrHidden:(BOOL)isShow;

@end
