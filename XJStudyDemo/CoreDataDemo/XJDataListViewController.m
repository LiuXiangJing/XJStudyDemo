//
//  XJDataListViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/29.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJDataListViewController.h"
#import "XJDataSource.h"
@interface XJDataListViewController ()
@property(strong,nonatomic)XJDataSource * dataSource;
@end
static NSString * cellReuseIdentifier =@"cellIdentifier";
#import "UserInfo.h"
#import "XJAddDataViewController.h"
#import "XJDataDetailViewController.h"
@implementation XJDataListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"XJCoreData";
    self.dataSource =[[XJDataSource alloc]initWithTableView:self.tableView entityName:[[UserInfo class] description]sortKey:[UserInfo primaryKey]];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMoreObject)];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem,self.editButtonItem];//self.editButtonItem;
}
-(void)addMoreObject{
    XJAddDataViewController * addDataVC =[[XJAddDataViewController alloc]init];
    [self.navigationController pushViewController:addDataVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    UserInfo * userInfo =(UserInfo *)[self.dataSource cellModelAtIndex:indexPath];
    cell.textLabel.text =userInfo.userName;    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }  
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    XJDataDetailViewController *detailViewController = [[XJDataDetailViewController alloc] initWithNibName:@"XJDataDetailViewController" bundle:nil];
    detailViewController.userInfo =(UserInfo *)[self.dataSource cellModelAtIndex:indexPath];
    [self.navigationController pushViewController:detailViewController animated:YES];
}



@end
