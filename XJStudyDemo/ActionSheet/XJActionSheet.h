//
//  XJActionSheet.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/4.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActionSheetHandler)(NSInteger buttonIndex);
@interface XJActionSheet : UIView
/**
 *  初始化自定义的XJActionSheet
 *
 *  @param title                  标题
 *  @param delegate               代理
 *  @param cancelButtonTitle      取消按钮的title
 *  @param destructiveButtonTitle 警告按钮
 *  @param otherButtonTitles      其他项
 *
 *  @return XJActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
/**
 *  设置标题的字体大小和颜色（默认12号 和 灰色）
 */
- (void)configureActionTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor;
/**
 *  设置警告的字体大小和颜色 （默认15号字体 和 红色）
 */
- (void)configureDestructiveButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor;
/**
 *  设置其他按钮的字体和颜色（默认15号字体 和 蓝色）
 */
- (void)configureOtherButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor;
/**
 *  设置取消按钮字体和颜色（默认15 和 蓝色）
 */
- (void)configureCancelButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor;
/**
 *  显示出ActionSheet
 */
-(void)showActionSheetWithHandle:(ActionSheetHandler)handle;
@end
