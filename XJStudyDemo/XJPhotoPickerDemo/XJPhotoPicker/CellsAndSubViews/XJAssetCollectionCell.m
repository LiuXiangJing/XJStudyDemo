//
//  XJAssetCollectionCell.m
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import "XJAssetCollectionCell.h"

@implementation XJAssetCollectionCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCellModel:(XJAssetCellModel *)cellModel{
    _cellModel = cellModel;
    [self updateCellUI];
}
-(void)updateCellUI{
    self.selectMarkBtn.selected =_cellModel.isSelectd;
//    self.selectMarkView.hidden =!_cellModel.isSelectd;
//    if (_cellModel.isSelectd) {
//        self.imageView.image =[self tintedThumbnail];
//    }else{
        self.imageView.image =[self thumbnail];
//    }
    if ([[_cellModel.asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
        self.videoImageView.hidden =NO;
    }else{
        self.videoImageView.hidden =YES;
    }
}
- (IBAction)selectButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssetAction:)]) {
        [self.delegate selectAssetAction:self.indexPath];
    }
}
- (UIImage *)thumbnail
{
    return [UIImage imageWithCGImage:[self.cellModel.asset thumbnail]];
}
- (UIImage *)tintedThumbnail
{
    UIImage *thumbnail = [self thumbnail];
    
    UIGraphicsBeginImageContext(thumbnail.size);
    
    CGRect rect = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height);
    [thumbnail drawInRect:rect];
    
    [[UIColor colorWithWhite:1 alpha:0.5] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    
    UIImage *tintedThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedThumbnail;
}
@end
