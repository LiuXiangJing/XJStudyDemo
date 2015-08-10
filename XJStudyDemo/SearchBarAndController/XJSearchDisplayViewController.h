//
//  XJSearchDisplayViewController.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/7.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJSearchDisplayViewController : UITableViewController
{
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}
@end
