//
//  XJAssetHorizontalViewController.m
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/8/20.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import "XJAssetHorizontalViewController.h"

@interface XJAssetHorizontalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isShowToolBar;
    UIView * _topView;
    UIButton * _rightMarkBtn;
    
    UIButton * _makeSureBtn;
    UIView * _bottomView;
    
    NSInteger _currentShowIndex;
    
    BOOL isFirstLoadView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *assetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
@end
#import "XJAssetHorizontalViewCell.h"
static NSString * cellInditifier = @"XJAssetHorizontalViewCell";
static NSString * onSelectAssetChangedNotification = @"onSelectAssetChangedNotification";
static NSString * onSelectAssetMakeSureNotification =@"onSelectAssetMakeSureNotification";
@implementation XJAssetHorizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
     CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.collectionLayout.itemSize =screenSize;
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.collectionLayout setMinimumLineSpacing:0];
    [self.collectionLayout setMinimumInteritemSpacing:0];
    
    [self.assetCollectionView registerNib:[UINib nibWithNibName:@"XJAssetHorizontalViewCell" bundle:nil] forCellWithReuseIdentifier:cellInditifier];
    [self configTopView];
    [self configBottomView];
    isFirstLoadView = YES;
    UITapGestureRecognizer * tapselfView =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidesBarsOnTapView)];
    [self.view addGestureRecognizer:tapselfView];
}

- (void)viewWillLayoutSubviews {
    if (isFirstLoadView) {
        isFirstLoadView = NO;
    }
    [self.assetCollectionView scrollToItemAtIndexPath:self.currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:self.currentIndex.row];
    [_rightMarkBtn setSelected:assetModel.isSelectd];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configTopView {
    isShowToolBar = YES;
    _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topView.backgroundColor =[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    //R_G_B_A_COLOR(51, 51, 51, 1)
    //    _topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_topView];
    
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 20, 50, 44);
    [backBtn setImage:[UIImage imageNamed:@"image_picker_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backBtn];
   
  
    _rightMarkBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _rightMarkBtn.frame = CGRectMake(kScreenWidth-50, 20, 50, 44);
    [_rightMarkBtn setImage:[UIImage imageNamed:@"image_picker_normal"] forState:UIControlStateNormal];
    [_rightMarkBtn setImage:[UIImage imageNamed:@"image_picker_select"] forState:UIControlStateSelected];
    [_rightMarkBtn addTarget:self action:@selector(selectImageAssetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_rightMarkBtn];
}

- (void)configBottomView {
    _bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    _bottomView.backgroundColor =[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    [self.view addSubview:_bottomView];
    _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _makeSureBtn.frame =_bottomView.bounds;
    [_makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_makeSureBtn setTitle:@"完成(0)" forState:UIControlStateDisabled];
    _makeSureBtn.titleLabel.font =[UIFont systemFontOfSize:16];
    [_makeSureBtn addTarget:self action:@selector(makeSureSelectAsset:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_makeSureBtn];
   [self refashMakeSureBtn];
}

- (void)hidesBarsOnTapView {
    isShowToolBar =!isShowToolBar;
    [UIView animateWithDuration:0.2 animations:^{
        if (isShowToolBar) {
            _topView.frame =CGRectMake(0, 0, kScreenWidth, 64);
            _bottomView.frame = CGRectMake(0, kScreenHeight-44, kScreenWidth, 44);
        }else{
            _topView.frame = CGRectMake(0, -64, kScreenWidth, 64);
            _bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        }
    }];
}

#pragma mark - 返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 右上角-选择-取消选择按钮点击
- (void)selectImageAssetAction:(UIButton *)sender {
    if (sender.selected == NO) {
        if (self.allowsMultipleSelection) {
            NSInteger countSelect =self.assetSelectArray.count;
            if (countSelect < self.maximumNumberOfSelection) {
                _rightMarkBtn.selected = !_rightMarkBtn.selected;
                XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:_currentShowIndex];
                assetModel.isSelectd =_rightMarkBtn.selected;
                if (_rightMarkBtn.selected) {
                    [self.assetSelectArray addObject:assetModel];
                }else{
                    if ([self.assetSelectArray containsObject:assetModel]) {
                        [self.assetSelectArray removeObject:assetModel];
                    }
                }
                [self refashMakeSureBtn];
                [[NSNotificationCenter defaultCenter]postNotificationName:onSelectAssetChangedNotification object:nil userInfo:@{@"assetModel":assetModel}];
            }else{
                UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"你最多只能选择%ld张照片" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }else{
            _rightMarkBtn.selected = !_rightMarkBtn.selected;
            XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:_currentShowIndex];
            assetModel.isSelectd =_rightMarkBtn.selected;
            if (_rightMarkBtn.selected) {
                [self.assetSelectArray addObject:assetModel];
            }else{
                if ([self.assetSelectArray containsObject:assetModel]) {
                    [self.assetSelectArray removeObject:assetModel];
                }
            }
            [self refashMakeSureBtn];
            [self makeSureSelectAsset:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:onSelectAssetChangedNotification object:nil userInfo:@{@"assetModel":assetModel}];
        }
    }else{
        _rightMarkBtn.selected = !_rightMarkBtn.selected;
        XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:_currentShowIndex];
        assetModel.isSelectd =_rightMarkBtn.selected;
        if (_rightMarkBtn.selected) {
            [self.assetSelectArray addObject:assetModel];
        }else{
            if ([self.assetSelectArray containsObject:assetModel]) {
                [self.assetSelectArray removeObject:assetModel];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:onSelectAssetChangedNotification object:nil userInfo:@{@"assetModel":assetModel}];
        [self refashMakeSureBtn];
    }

}
#pragma mark - 刷新确定按钮
- (void)refashMakeSureBtn {
    if ([self.assetSelectArray count]>0) {
        [self setMakeSureBtnEnable:YES];
    }else{
        [self setMakeSureBtnEnable:NO];
    }
}
#pragma mark 确定按钮改变
- (void)setMakeSureBtnEnable:(BOOL)enable {
    [_makeSureBtn setEnabled:enable];
    if (enable) {
        NSString * titleStr =[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.assetSelectArray.count];
        [_makeSureBtn setTitle:titleStr forState:UIControlStateNormal];
        [_makeSureBtn setBackgroundColor:[UIColor colorWithRed:32/250.0 green:171/250.0 blue:244/250.0 alpha:1]];
    }else{
        [_makeSureBtn setBackgroundColor:[UIColor clearColor]];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJAssetHorizontalViewCell* cell = [collectionView2 dequeueReusableCellWithReuseIdentifier:cellInditifier forIndexPath:indexPath];
    XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:indexPath.row];
    cell.cellModel = assetModel;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {    
    _currentShowIndex = scrollView.contentOffset.x/kScreenWidth;
    XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assetsArray objectAtIndex:_currentShowIndex];
    [_rightMarkBtn setSelected:assetModel.isSelectd];
}

- (void)makeSureSelectAsset:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:onSelectAssetMakeSureNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
