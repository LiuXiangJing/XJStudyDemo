//
//  XJAssetHorizontalViewCell.m
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/8/20.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import "XJAssetHorizontalViewCell.h"
@interface XJAssetHorizontalViewCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation XJAssetHorizontalViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setCellModel:(XJAssetCellModel *)cellModel {
    _cellModel =cellModel;
    self.imageView.image =[self getImage];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
-(UIImage *)getImage
{
    return [UIImage imageWithCGImage:[[self.cellModel.asset defaultRepresentation] fullScreenImage]];
}
@end
