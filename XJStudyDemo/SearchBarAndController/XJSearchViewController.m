//
//  XJSearchViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJSearchViewController.h"

@interface XJSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray * _totleArray;
    NSArray *filterData;
    UISearchDisplayController * _searchDisplayController;
}
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totleArray =[NSMutableArray arrayWithArray:@[@"asdd",@"asdsd",@"awewe",@"asdsafd",@"axads",@"bdbdf",@"btrbr",@"bytyt",@"byjt",@"bbyte",@"bwew",@"cljqw",@"sadew",@"fsdsf",@"regtr",@"ytjyt",@"uyj",@"ertw",@"fdsfw",@"wewd",@"sadw",@"ghrth5",@"yhtr",@"ewr32",@"ewdw",@"wqqwwd",@"ddw",@"fergt",@"wqdwwe",@"fergtr",@"hrhy",@"cwew",@"dawew",@"gtrhyt",@"dsregtre",@"ytju5",@"hthyt",@"wfwfew",@"sdf34g",@"nyjuy"]];
    // Do any additional setup after loading the view from its nib.
    _searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.tableView.tableHeaderView = _searchBar;
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate=self;
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.tableView) {
        return [_totleArray count];
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_totleArray filteredArrayUsingPredicate:predicate]];
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
        cell.textLabel.text = _totleArray[indexPath.row];
    }else{
        cell.textLabel.text = filterData[indexPath.row];
    }
    
    return cell;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSLog(@"searchString++%@",searchString);
    return YES;
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
