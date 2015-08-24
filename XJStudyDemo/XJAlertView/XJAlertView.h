//
//  XJAlertView.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/24.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJAlertView : UIView

- (instancetype)initWtihCustomView:(UIView *)customView;

- (instancetype)initWithTitle:(NSString * )title conent:(NSString *)content;

- (void)showAlertView;
@end
