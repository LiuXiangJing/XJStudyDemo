//
//  XJPhotoPicker.m
//  XJPhotoPickerAPI
//
//  Created by 刘向晶 on 15/8/25.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//



#import "XJPhotoPicker.h"
#import "XJPickeViewController.h"
@interface XJPhotoPicker ()<UIActionSheetDelegate,XJPickeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,assign)XJImageVideoPickerType  type;
@property (nonatomic,copy) PhotoSelectFinish pickerComplete;
@property (nonatomic,strong)UIViewController * viewController;

@end
@implementation XJPhotoPicker
- (instancetype)initWithPickerType:(XJImageVideoPickerType)pickerType {
    self =[super init];
    if (self) {
        self.type = pickerType;
        self.allowsMultipleSelection = NO;
        self.isNeedEdit =NO;
        self.maxNumberOfSelection = 1;
    }
    return self;
}

- (void)showPhotoPickerFromViewController:(UIViewController *)controller complete:(PhotoSelectFinish)complete {
    self.pickerComplete =complete;
    self.viewController = controller;
    [self showPhotoPicker];
    
}

- (void)showPhotoPickerActionSheetFromViewController:(UIViewController *)controller Complete:(PhotoSelectFinish)complete {
    self.viewController = controller;
    self.pickerComplete = complete;
    UIActionSheet * pickerActionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [pickerActionSheet showInView:controller.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self showCamera];
    }else if(buttonIndex ==0){
        [self showPhotoPicker];
    }
}

- (void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePickerControllerSourceTypeCamera
//        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePicker.view.backgroundColor = [UIColor blackColor];
        imagePicker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
        [self.viewController presentViewController:imagePicker animated:YES completion:NULL];
        
    }else{
        UIAlertView * alerView =[[UIAlertView alloc]initWithTitle:@"相机被禁用了" message:@"请在设置中打开启用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        self.pickerComplete(@[],NO);
    }
}

- (void)showPhotoPicker {
    XJPickeViewController * pickerVC =[[XJPickeViewController alloc]init];
    pickerVC.delegate = self;
    pickerVC.pickerType =self.type;
    pickerVC.allowsMultipleSelection = self.allowsMultipleSelection;
    pickerVC.maxNumberOfSelection =self.maxNumberOfSelection;
    //    pickerVC.minNumberOfSelection =self.minNumberOfSelection;
    UINavigationController * picekerNavi =[[UINavigationController alloc]initWithRootViewController:pickerVC];
    [picekerNavi.navigationBar setBarTintColor: [UIColor colorWithRed:0/255.0 green:165/255.0 blue:240/255.0 alpha:1]];
    [picekerNavi.navigationBar setTintColor:[UIColor whiteColor]];
    [self.viewController presentViewController:picekerNavi animated:YES completion:NULL];
}

#pragma mark 本地相册选择完毕后的回调
-(void)pickerView:(XJPickeViewController *)pickerView didFinishSelectAssets:(NSArray *)assets{
    
    [pickerView dismissViewControllerAnimated:YES completion:^{
        if (self.isNeedEdit) {
            if ([assets count] > 0) {
                if ([assets count]== 1) {
//                    ALAsset * asset =[assets objectAtIndex:0];
                    //                    [self showEditViewWithImage:[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage]];
                }else{
                    self.pickerComplete(assets,YES);
                }
            }else{
                self.pickerComplete(@[],NO);
            }
        }else{
            if (self.allowsMultipleSelection) {
                self.pickerComplete(assets,YES);
            }else{
                if ([assets count]== 1) {
                    ALAsset * asset =[assets objectAtIndex:0];
                    if ([asset isKindOfClass:[ALAsset class]]) {
                        self.pickerComplete(@[[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage]],YES);
                    }else{
                        self.pickerComplete(assets,YES);
                    }
                    
                }else{
                    self.pickerComplete(assets,YES);
                }
            }
        }
    }];
}

#pragma mark 本地相册取消选择的回调
-(void)pickerViewDidCancel:(XJPickeViewController *)pickerView {
    if (self.pickerComplete) {
        self.pickerComplete(@[],NO);
    }
    [pickerView dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * temp = [info objectForKey: UIImagePickerControllerEditedImage];
    if ([temp isEqual:[NSNull null]] || !temp) {
        temp = [info objectForKey: UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.isNeedEdit) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                //                [self showEditViewWithImage:temp];
            }else{
                self.pickerComplete(@[temp],YES);
            }
        }else{
            self.pickerComplete(@[temp],YES);
        }
    }];
    
}

@end
