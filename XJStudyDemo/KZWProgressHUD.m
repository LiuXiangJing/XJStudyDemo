//
//  KZWProgressHUD.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "KZWProgressHUD.h"
#import "MBProgressHUD.h"

@interface KZWProgressHUD ()
{
    KZWProgressHUD * _loadingVew;
}
@end

@implementation KZWProgressHUD
+(void)showTipsInView:(UIView *)view OnlyString:(NSString *)tipsString{
    if (tipsString && tipsString.length>0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = tipsString;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.color = [UIColor lightGrayColor];
        hud.cornerRadius = 2;
        [hud hide:YES afterDelay:2];
    }
}
+(void)showLoadingInView:(UIView *)superView showOrHidden:(BOOL)isShow{
    if (isShow) {
        [MBProgressHUD showHUDAddedTo:superView animated:YES];
    }else{
        [MBProgressHUD hideHUDForView:superView animated:YES];
    }
}
@end
