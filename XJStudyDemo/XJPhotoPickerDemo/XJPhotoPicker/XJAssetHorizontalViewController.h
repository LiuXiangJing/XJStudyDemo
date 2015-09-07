//
//  XJAssetHorizontalViewController.h
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/8/20.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJAssetHorizontalViewController : UIViewController
/**
 *  图片资源
 */
@property(nonatomic,strong)NSArray * assetsArray;
@property(nonatomic,strong)NSMutableOrderedSet * assetSelectArray;

/**
 *  当前显示的第几张
 */
@property(nonatomic,strong)NSIndexPath * currentIndex;

/**
 *  是否设置了最多选中张数
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

/**
 *  最大选中张数
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@end
