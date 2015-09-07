//
//  XJPhotoPickerTypes.h
//  XJPhotoPickerAPI
//
//  Created by 刘向晶 on 15/8/25.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

/**
 *  选择器类型
 */
typedef NS_ENUM(NSInteger, XJImageVideoPickerType){
    /**
     *  只选择图片
     */
    XJPickerTypeImage = 0,
    /**
     *  只选择视频
     */
    XJPickerTypeVideo = 1,
    /**
     *  视频和图片都可以选择
     */
    XJPickerTypeBoth = 2
};

