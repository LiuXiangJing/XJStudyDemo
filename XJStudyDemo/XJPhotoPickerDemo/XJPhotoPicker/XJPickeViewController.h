//
//  XJPickeViewController.h
//  XJPhotoPicker
//
//  Created by 刘向晶 on 15/8/24.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJPickeViewController;
@protocol XJPickeViewControllerDelegate <NSObject>

-(void)pickerView:(XJPickeViewController *)pickerView didFinishSelectAssets:(NSArray *)assets;
-(void)pickerViewDidCancel:(XJPickeViewController *)pickerView;
@end
#import "BAAssetLibrary.h"
#import "XJPhotoPickerTypes.h"
@interface XJPickeViewController : UIViewController
/**
 *  选择文件类型
 */
@property(nonatomic,assign)XJImageVideoPickerType pickerType;

@property(nonatomic,assign)id<XJPickeViewControllerDelegate>delegate;
/**
 *  是否允许多选 默认不多选
 */
@property(nonatomic,assign)BOOL allowsMultipleSelection;
/**
 *  最多选择个数 （只有在允许多选 allowsMultipleSelection =YES 才有效) 默认是不限制
 */
@property(nonatomic,assign)NSInteger maxNumberOfSelection;

@end
