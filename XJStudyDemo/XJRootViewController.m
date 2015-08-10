//
//  XJRootViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/28.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJRootViewController.h"

@interface XJRootViewController ()<UIActionSheetDelegate>
{
    NSArray * _dataSourceArray;
    NSArray * _sectionTitlesArray;
}
@end
#import "XJDataListViewController.h"
#import "XJActionSheetViewController.h"
#import "XJSearchBarViewController.h"
#import "XJPickerViewController.h"
#import "XJSearchDisplayViewController.h"
#import "XJSearchViewController.h"
#import "XJAlertViewViewController.h"
#import "XJTextRequestViewController.h"
static NSString * cellIdentifier =@"XJTableViewCell";
@implementation XJRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学习列表";
  
    _dataSourceArray =@[
                    @[@"UILabel",@"UITextField",@"UIActionSheet",@"UITextView",@"UIScrollerView",@"UITableView",@"UICollectionView",@"UISearchBar",@"UISearchDisplayController(iOS8弃用)",@"UISearchController(iOS8新增)",@"UIPickerView"],
                        @[@"CoreData"],
                        @[@"XJActionSheet",@"XJSearchBar",@"XJSinglePickerView",@"XJAlertView"],
                        @[@"XJHTTPRequest"]
                   ];
    _sectionTitlesArray =@[@"系统控件",@"系统数据",@"自我封装",@"网络请求"];
    self.tableView.tableFooterView =[UIView new];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_dataSourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[_dataSourceArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text =[[[_dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
    cell.textLabel.font =[UIFont systemFontOfSize:17];
    // Configure the cell...
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_sectionTitlesArray objectAtIndex:section] description];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     _dataSourceArray =@[
     @[@"UILabel",@"UITextField",@"UIActionSheet",@"UITextView",@"UIScrollerView",@"UITableView",@"UICollectionView"],
     @[@"CoreData"],
     @[@"XJActionSheet"]
     ];
     */
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://UILabel
                {
                    break;
                }
                case 1://UITextField
                {
                    break;
                }
                case 2://UIActionSheet
                {
                    XJActionSheetViewController * actionSheetVC =[[XJActionSheetViewController alloc]init];
                    [self.navigationController pushViewController:actionSheetVC animated:YES];
                    break;
                }
                case 3:
                {//UITextView
                    break;
                }
                case 4://UIScrollerView
                {
                    break;
                }
                case 5://UITableView
                {
                    break;
                }
                case 6:
                {//UICollectionView
                    break;
                }
                case 7:{//UISearchBar
                    XJSearchBarViewController * searchBarVC =[[XJSearchBarViewController alloc]init];
                    [self.navigationController pushViewController:searchBarVC animated:YES];
                    break;
                }
                case 8:{//UISearchDisplayController
//                1、   XJSearchDisplayViewController 2、XJSearchViewController
                    XJSearchViewController* searchVC =[[XJSearchViewController alloc]init];
                    [self.navigationController pushViewController:searchVC animated:YES];
                    break;
                }
                case 9:{//UISearchController
                    break;
                }
                case 10:{//UIPickerView
                    XJPickerViewController * pickerVC =[[XJPickerViewController alloc]init];
                    [self.navigationController pushViewController:pickerVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0://CoreData
                {
                    XJDataListViewController * dataListVC =[[XJDataListViewController alloc]init];
                    [self.navigationController pushViewController:dataListVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0://XJActionSheet
                {
                    XJActionSheetViewController * actionSheetVC =[[XJActionSheetViewController alloc]init];
                    [self.navigationController pushViewController:actionSheetVC animated:YES];
                    break;
                }
                case 1:{//XJSearchBar
                    XJSearchBarViewController * searchBarVC =[[XJSearchBarViewController alloc]init];
                    [self.navigationController pushViewController:searchBarVC animated:YES];
                    break;
                }
                case 2:{//XJSinglePickerView
                    XJPickerViewController * pickerVC =[[XJPickerViewController alloc]init];
                    [self.navigationController pushViewController:pickerVC animated:YES];
                    break;
                }
                case 3:{//XJAlertView;
                    XJAlertViewViewController * alertVC =[[XJAlertViewViewController alloc]init];
                    [self.navigationController pushViewController:alertVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:{
            switch (indexPath.row) {
                case 0://XJHTTPRequest
                {
                    XJTextRequestViewController * requestVC =[[XJTextRequestViewController alloc]init];
                    [self.navigationController pushViewController:requestVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
 
}


@end
