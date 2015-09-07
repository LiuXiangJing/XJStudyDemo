//
//  XJAssetCollectionViewController.h
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJAssetCollectionViewController;
@protocol XJAssetCollectionViewControllerDelegate <NSObject>

@required
- (void)assetCollectionViewController:(XJAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets;

- (void)assetCollectionViewControllerDidCancel:(XJAssetCollectionViewController *)assetCollectionViewController;

@end

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@interface XJAssetCollectionViewController : UIViewController
@property(nonatomic,assign)id<XJAssetCollectionViewControllerDelegate>delegate;
/**
 *  相册
 */
@property (nonatomic, retain) ALAssetsGroup *assetsGroup;

/**
 *  是否允许多选 默认不多选
 */
@property(nonatomic,assign)BOOL allowsMultipleSelection;
/**
 *  最多选择个数 （只有在允许多选 allowsMultipleSelection =YES 才有效) 默认是不限制
 */
@property(nonatomic,assign)NSInteger maxNumberOfSelection;
/**
 *  最少选择个数（只有在允许多选 allowsMultipleSelection = YES 才有效)  默认是 0
 */
@property(nonatomic,assign)NSInteger minNumberOfSelection;

@end
