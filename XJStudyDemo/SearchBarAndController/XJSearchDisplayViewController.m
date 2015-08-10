//
//  XJSearchDisplayViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJSearchDisplayViewController.h"

@interface XJSearchDisplayViewController ()

@end

@implementation XJSearchDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"搜索";
    data =@[@"asdd",@"asdsd",@"awewe",@"asdsafd",@"axads",@"bdbdf",@"btrbr",@"bytyt",@"byjt",@"bbyte",@"bwew",@"cljqw",@"sadew",@"fsdsf",@"regtr",@"ytjyt",@"uyj",@"ertw",@"fdsfw",@"wewd",@"sadw",@"ghrth5",@"yhtr",@"ewr32",@"ewdw",@"wqqwwd",@"ddw",@"fergt",@"wqdwwe",@"fergtr",@"hrhy",@"cwew",@"dawew",@"gtrhyt",@"dsregtre",@"ytju5",@"hthyt",@"wfwfew",@"sdf34g",@"nyjuy"];
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return data.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.text = data[indexPath.row];
    }else{
        cell.textLabel.text = filterData[indexPath.row];
    }
    
    return cell;
}


@end
