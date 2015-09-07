//
//  XJAssetCellModel.m
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import "XJAssetCellModel.h"

@implementation XJAssetCellModel
-(instancetype)initWithALAsset:(ALAsset *)asset isSelect:(BOOL)isSelect {
    self =[super init];
    if (self) {
        _asset =asset;
        _isSelectd =isSelect;
    }
    return self;
}
@end
