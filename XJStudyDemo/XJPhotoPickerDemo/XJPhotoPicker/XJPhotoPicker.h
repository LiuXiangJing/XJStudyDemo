//
//  XJPhotoPicker.h
//  XJPhotoPickerAPI
//
//  Created by 刘向晶 on 15/8/25.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJPhotoPickerTypes.h"

/**
 *  选取图片相册回调
 *
 *  @param imageArray 如果不需要编辑则返回的是ALAsset的数组。！！！！！！！！！！！！！！！！！！
 *  @param isSuccess  是否获取成功
 */
typedef void (^PhotoSelectFinish)(NSArray * imageArray,BOOL isSuccess);
/**
 *  相册选取器：需要添加info.plist文件设置  Localized resources can be mixed 为YES （显现中文）
 *  添加库文件:AssetsLibrary.framework
 */
@interface XJPhotoPicker : NSObject
/**
 *  是否需要编辑 （仅当单选一张图片的时候有效）默认不需要
 */
@property(nonatomic,assign)BOOL isNeedEdit;
/**
 *  是否允许多选 默认不多选
 */
@property(nonatomic,assign)BOOL allowsMultipleSelection;
/**
 *  最多选择个数 （只有在允许多选 allowsMultipleSelection =YES 才有效) 默认是不限制
 */
@property(nonatomic,assign)NSInteger maxNumberOfSelection;
/**
 *  初始化imagePicker
 *
 *  @param pickerType 设定选取类型
 *
 *  @return self
 */
-(instancetype)initWithPickerType:(XJImageVideoPickerType)pickerType;
/**
 *  直接调用本地相册相册
 *
 *  @param controller 从哪个controller出发
 */
-(void)showPhotoPickerFromViewController:(UIViewController *)controller complete:(PhotoSelectFinish)complete;
/**
 *  调用相册和相机
 */
- (void)showPhotoPickerActionSheetFromViewController:(UIViewController *)controller Complete:(PhotoSelectFinish)complete;
@end
