//
//  XJAssetCollectionViewController.m
//  XJMutableImageVideoPicker
//
//  Created by Tintin on 15/6/1.
//  Copyright (c) 2015年 Tintin. All rights reserved.
//

#import "XJAssetCollectionViewController.h"
#import "XJAssetCollectionCell.h"

@interface XJAssetCollectionViewController ()<XJAssetCollectionCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *assetCollectView;
@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;
@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@end
#import "XJAssetHorizontalViewController.h"
static NSString * assetReuseIdentifier =@"XJAssetCollectionCell";
static NSString * onSelectAssetChangedNotification = @"onSelectAssetChangedNotification";
static NSString * onSelectAssetMakeSureNotification =@"onSelectAssetMakeSureNotification";
@implementation XJAssetCollectionViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        
        UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAssetsSelect)];
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.assetCollectView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.assetCollectView registerNib:[UINib nibWithNibName:@"XJAssetCollectionCell" bundle:nil] forCellWithReuseIdentifier:assetReuseIdentifier];
    dispatch_time_t secont = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secont * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self secrollToEnd];
    });
    
    [self configBarButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSelectAssetChangedNotification:) name:onSelectAssetChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSelectAssetMakeSureNotification:) name:onSelectAssetMakeSureNotification object:nil];
}

- (void)configBarButton {
    self.makeSureButton.layer.cornerRadius =2.f;
    self.makeSureButton.layer.masksToBounds = YES;
    [self.makeSureButton setTitle:@"确定" forState:UIControlStateDisabled];
    [self.previewButton setTitleColor:[UIColor colorWithRed:10.0/255 green:170.0/255 blue:245.0/255 alpha:1] forState:UIControlStateNormal];
     [self.previewButton setTitleColor:[UIColor colorWithRed:161.0/255 green:161.0/255 blue:161.0/255 alpha:1] forState:UIControlStateDisabled];
    [self.previewButton setEnabled:NO];
    [self setMakeSureButtonEnable:NO];
}

- (void)setMakeSureButtonEnable:(BOOL)enable {
     [self.makeSureButton setEnabled:enable];
    if (enable) {
        [self.makeSureButton setBackgroundColor:[UIColor colorWithRed:10.0/255 green:170.0/255 blue:245.0/255 alpha:1]];
    }else{
        [self.makeSureButton setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
    }
}
#pragma mark- 滚动到底部
-(void)secrollToEnd {
    CGFloat scrollHeight =self.assetCollectView.contentSize.height-self.assetCollectView.bounds.size.height;
    if (scrollHeight < 64) {
        scrollHeight = 64;
    }
    self.assetCollectView.contentOffset = CGPointMake(0, scrollHeight);
}

-(void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    _assetsGroup = assetsGroup;
    if (!self.assets) {
        self.assets =[NSMutableArray array];
    }
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            XJAssetCellModel * cellModel =[[XJAssetCellModel alloc]initWithALAsset:result isSelect:NO];
            [self.assets addObject:cellModel];
        }
    }];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake((screenSize.width-3)/3, (screenSize.width-3)/3);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJAssetCollectionCell* cell = [collectionView2 dequeueReusableCellWithReuseIdentifier:assetReuseIdentifier forIndexPath:indexPath];
    XJAssetCellModel *assetModel =(XJAssetCellModel *)[self.assets objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.cellModel = assetModel;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XJAssetHorizontalViewController * horizonVC =[[XJAssetHorizontalViewController alloc]init];
    horizonVC.assetsArray = self.assets;
    horizonVC.assetSelectArray = self.selectedAssets;
    horizonVC.currentIndex = indexPath;
    horizonVC.maximumNumberOfSelection = self.maxNumberOfSelection;
    horizonVC.allowsMultipleSelection = self.allowsMultipleSelection;
    [self.navigationController pushViewController:horizonVC animated:YES];
}

- (void)selectAssetAction:(NSIndexPath *)indexPath {
    XJAssetCellModel * assetModel =(XJAssetCellModel *)[self.assets objectAtIndex:indexPath.row];
    if (self.allowsMultipleSelection) {
        if ([self.selectedAssets count] < self.maxNumberOfSelection) {
            //            NSLog(@"assetModel.asset.defaultRepresentation.size==%lld",assetModel.asset.defaultRepresentation.size);
            
            assetModel.isSelectd = !assetModel.isSelectd;
            if (assetModel.isSelectd) {
                [self.selectedAssets addObject:assetModel];
            }else{
                if ([self.selectedAssets containsObject:assetModel]) {
                    [self.selectedAssets removeObject:assetModel];
                }
            }
        }else{
            
            if (assetModel.isSelectd) {
                assetModel.isSelectd = !assetModel.isSelectd;
                if ([self.selectedAssets containsObject:assetModel]) {
                    [self.selectedAssets removeObject:assetModel];
                }
            }else{
                NSString * titleStr =[NSString stringWithFormat:@"你最多只能选择%ld张照片",(long)self.maxNumberOfSelection];
                UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:titleStr message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
        XJAssetCollectionCell * cell = (XJAssetCollectionCell*)[self.assetCollectView cellForItemAtIndexPath:indexPath];
        cell.cellModel =assetModel;
        
        [self updateMakeSureBtnStatus];
    }else{
        [self.selectedAssets addObject:assetModel];
        [self makeSureSelectAssets:nil];
    }
}

-(void)updateMakeSureBtnStatus {
    if (self.allowsMultipleSelection) {
        NSInteger currentSelectCount =[self.selectedAssets count];
        if (currentSelectCount==0) {
            [self setMakeSureButtonEnable:NO];
            [self.previewButton setEnabled:NO];
        }else{
            if (currentSelectCount >= 0 && currentSelectCount <= self.maxNumberOfSelection) {
                [self setMakeSureButtonEnable:YES];
                [self.previewButton setEnabled:YES];
                
                NSString * string =[NSString stringWithFormat:@"确定 (%ld)",currentSelectCount];//,self.maxNumberOfSelection
                [self.makeSureButton setTitle:string forState:UIControlStateNormal];
            }else{
                [self setMakeSureButtonEnable:NO];
                [self.previewButton setEnabled:NO];
            }
        }
    }else{
        [self setMakeSureButtonEnable:NO];
        [self.previewButton setEnabled:NO];
    }
}

- (IBAction)makeSureSelectAssets:(id)sender {
    NSMutableOrderedSet * orderSet =[[NSMutableOrderedSet alloc]init];
    for (XJAssetCellModel * assetModel in self.selectedAssets) {
        [orderSet addObject:assetModel.asset];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(assetCollectionViewController:didFinishPickingAssets:)]) {
        [self.delegate assetCollectionViewController:self didFinishPickingAssets:orderSet.array];
    }
}

- (IBAction)preViewAssets:(id)sender {
    XJAssetHorizontalViewController * horizonVC =[[XJAssetHorizontalViewController alloc]init];
    horizonVC.assetsArray = self.selectedAssets.array;
    horizonVC.assetSelectArray = self.selectedAssets;
    horizonVC.currentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    horizonVC.maximumNumberOfSelection = self.maxNumberOfSelection;
    horizonVC.allowsMultipleSelection = self.allowsMultipleSelection;
    [self.navigationController pushViewController:horizonVC animated:YES];
}

- (void)cancelAssetsSelect {

    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewControllerDidCancel:)]) {
        [self.delegate assetCollectionViewControllerDidCancel:self];
    }

}

- (void)onSelectAssetChangedNotification:(NSNotification *)notification {
    XJAssetCellModel * assetModel =[notification.userInfo valueForKey:@"assetModel"];
    if (assetModel.isSelectd) {
        [self.selectedAssets addObject:assetModel];
    }else{
        if ([self.selectedAssets containsObject:assetModel]) {
            [self.selectedAssets removeObject:assetModel];
        }
    }
    for (XJAssetCellModel * currentModel in self.assets) {
        if ([assetModel.asset isEqual:currentModel.asset] ) {
            currentModel.isSelectd = assetModel.isSelectd;
        }
    }
}

- (void)onSelectAssetMakeSureNotification:(NSNotification *)notice {
    [self makeSureSelectAssets:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
