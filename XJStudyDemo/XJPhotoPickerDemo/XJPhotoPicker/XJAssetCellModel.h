//
//  XJAssetCellModel.h
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface XJAssetCellModel : NSObject
@property(nonatomic,retain)ALAsset * asset;
@property(assign,nonatomic)BOOL isSelectd;

-(instancetype)initWithALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect;
@end
