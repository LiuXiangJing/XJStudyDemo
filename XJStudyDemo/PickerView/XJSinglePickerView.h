//
//  XJSinglePickerView.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DataPickerBlock)(NSString *selectStr,BOOL isFinal);

@interface XJSinglePickerView : UIView
/**
 *  实例化一个picker
 *  @param dataArray 数据源
 *
 *  @return picker
 */
-(instancetype)initWithDataArray:(NSArray *)dataArray;
/**
 *  显示picker
 *
 *  @param complete 回调信息
 */
-(void)showSinglePickerWithPickerSelect:(DataPickerBlock)complete;
@end
