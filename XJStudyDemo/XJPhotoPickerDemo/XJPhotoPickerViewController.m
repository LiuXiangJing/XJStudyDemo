//
//  XJPhotoPickerViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/26.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJPhotoPickerViewController.h"
#import "XJPhotoPicker.h"
@interface XJPhotoPickerViewController ()
{
    XJPhotoPicker * _photoPicker;
}
@end

@implementation XJPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _photoPicker =[[XJPhotoPicker alloc]initWithPickerType:XJPickerTypeImage];
    _photoPicker.allowsMultipleSelection = YES;
    _photoPicker.maxNumberOfSelection = 10;
}
- (IBAction)selectFromLibrary:(id)sender {
    [_photoPicker showPhotoPickerFromViewController:self complete:^(NSArray *imageArray, BOOL isSuccess) {
        
    }];
}
- (IBAction)showSelecrActionSheet:(id)sender {
    [_photoPicker showPhotoPickerActionSheetFromViewController:self Complete:^(NSArray *imageArray, BOOL isSuccess) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
