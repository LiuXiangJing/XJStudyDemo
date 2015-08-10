//
//  XJSearchBarViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/5.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJSearchBarViewController.h"
#import "XJSearchBar.h"

@interface XJSearchBarViewController ()<UISearchBarDelegate,XJSearchBarDelegate>

@end
@implementation XJSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"SearchBar";
     self.view.backgroundColor =[UIColor colorWithRed:135.0/255 green:137.0/255 blue:235.0/255 alpha:1];
    
    // Do any additional setup after loading the view from its nib.
    UISearchBar * searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(20, 80,kScreenWidth-40 , 60)];//高度貌似没用
    searchBar.searchBarStyle =UISearchBarStyleDefault;
//    searchBar.barStyle =UIBarStyleBlack;
    [searchBar setBackgroundImage:[UIImage new]];//背景边框，注释此句可查看默认效果
//    [searchBar setScopeBarBackgroundImage:[UIImage new]];//背景上下边框，，此句与上一句交替可查看默认效果
//    searchBar.prompt =@"好吧，搜索";//在搜索中间 一直显示 不知道啥意思。
    searchBar.placeholder =@"好吧，搜索";
    searchBar.text =@"haoba";
//    searchBar.delegate =self;//代理这里就不做介绍了，没多大意思
    searchBar.tintColor =[UIColor redColor];//搜索光标的颜色，以及取消按钮的颜色
//    searchBar.barTintColor =[UIColor yellowColor];//母鸡啊
//    searchBar.scopeButtonTitles =@[@"好多额",@"不好呢"];//在搜索栏下面有一个选择栏，UISegmentedControl 我也不知道能干啥
//    searchBar.showsScopeBar =YES;//在搜索栏下面有一个选择栏，是否显示
    searchBar.showsCancelButton =YES;//是否显示取消按钮、、取消按钮看系统语言，中文显示取消，英文显示Cancle
//    searchBar.showsBookmarkButton =YES;//显示书名书；与下一句不共存
//    searchBar.showsSearchResultsButton =YES;//搜索结果按钮 与上面不共存
    searchBar.keyboardType =UIKeyboardTypeDefault;//键盘类型。。。不做介绍
    [self.view addSubview:searchBar];
    
    UITapGestureRecognizer * tapGes =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleFirstRespond)];
    [self.view addGestureRecognizer:tapGes];
    
    XJSearchBar * _searchBar =[[XJSearchBar alloc]initWithFrame:CGRectMake(20, 200, kScreenWidth-40, 30)];
    _searchBar.delegate=self;
    _searchBar.placeholder =@"好吧，搜搜";
    _searchBar.placeholderAlignmentLeft =NO;
    _searchBar.showsCancelButton =YES;
//    _searchBar.text =@"haoden";
    [self.view addSubview:_searchBar];
 
}
-(void)searchBarCancelButtonClicked:(XJSearchBar *)searchBar{
    NSLog(@"取消按钮点击");
}
-(void)searchBar:(XJSearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText==%@",searchText);
}
-(void)cancleFirstRespond{
    [self.view endEditing:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
