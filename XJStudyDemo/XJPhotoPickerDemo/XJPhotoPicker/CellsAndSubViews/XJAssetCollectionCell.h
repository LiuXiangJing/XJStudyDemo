//
//  XJAssetCollectionCell.h
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XJAssetCollectionCellDelegate;
#import "XJAssetCellModel.h"
@interface XJAssetCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectMarkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (retain,nonatomic)XJAssetCellModel * cellModel;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,assign)id<XJAssetCollectionCellDelegate>delegate;
@end
@protocol XJAssetCollectionCellDelegate <NSObject>

- (void)selectAssetAction:(NSIndexPath * )indexPath;

@end