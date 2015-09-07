//
//  XJPickeViewController.m
//  XJPhotoPicker
//
//  Created by 刘向晶 on 15/8/24.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJPickeViewController.h"

#import "XJAssetCollectionViewController.h"
@interface XJPickeViewController ()<UITableViewDataSource,UITableViewDelegate,XJAssetCollectionViewControllerDelegate>

@property (nonatomic, assign) ALAssetsLibrary *assetsLibrary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSMutableArray * assetsGroups;
@end
static NSString * cellIdentiferStr =@"PikcerCell";
@implementation XJPickeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        /* Check sources */
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        /* Initialization */
        self.title = @"相册";
        self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.pickerType = XJPickerTypeImage;
        self.allowsMultipleSelection = NO;
        self.maxNumberOfSelection = 0;
        self.assetsGroups = [NSMutableArray array];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    }
    
    return self;
}

-(ALAssetsLibrary*)assetsLibrary{
    return [BAAssetLibrary defaultAssetsLibrary];
}

-(void)cancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidCancel:)]) {
        [self.delegate pickerViewDidCancel:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllAssets];
    self.tableView.tableFooterView =[UIView  new];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadAllAssets
{
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup) {
            switch(self.pickerType) {
                case XJPickerTypeBoth:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                    break;
                case XJPickerTypeImage:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    break;
                case XJPickerTypeVideo:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                    break;
            }
            if(assetsGroup.numberOfAssets > 0) {
                [self.assetsGroups addObject:assetsGroup];
                [self.tableView reloadData];
            }
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.assetsGroups count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentiferStr];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentiferStr];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJAssetCollectionViewController* assetVC = [[XJAssetCollectionViewController alloc] init];
    assetVC.delegate = self;
    assetVC.assetsGroup  =(ALAssetsGroup *)[self.assetsGroups objectAtIndex:indexPath.row];
    assetVC.allowsMultipleSelection =self.allowsMultipleSelection;
    assetVC.maxNumberOfSelection =self.maxNumberOfSelection;
    //    assetVC.minNumberOfSelection =self.minNumberOfSelection;
    [self.navigationController pushViewController:assetVC animated:YES];
}
-(void)assetCollectionViewController:(XJAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didFinishSelectAssets:)]) {
        [self.delegate pickerView:self didFinishSelectAssets:assets];
    }
}
-(void)assetCollectionViewControllerDidCancel:(XJAssetCollectionViewController *)assetCollectionViewController{
    [self cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
