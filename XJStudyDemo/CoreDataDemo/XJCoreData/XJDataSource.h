//
//  XJDataSource.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
@interface XJDataSource : NSObject
/**
 *  关联数据库与tableView
 *
 *  @param tableView  数据显示的列表
 *  @param entityName 数据库表名
 *  @param sortKey    根据某字段排序(可选)
 *
 *  @return self
 */
-(instancetype)initWithTableView:(UITableView *)tableView entityName:(NSString *)entityName sortKey:(NSString*)sortKey;
/**
 *  组数
 */
-(NSInteger)numberOfSections;
/**
 *  每组行数
 *
 *  @param section 所在组
 *
 *  @return 行数
 */
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
/**
 *  对应cell的Model
 *
 *  @param indexPath 所在位置
 *
 *  @return mdoel
 */
-(NSManagedObject *)cellModelAtIndex:(NSIndexPath *)indexPath;


/**
 *  删除某行
 *
 *  @param indexPath 位置
 */
-(void)deleteCellAtIndex:(NSIndexPath *)indexPath;
/**
 *  移动cell从某位置到某位置
 *
 *  @param oldIndexPath 原位置
 *  @param newIndexPath 新位置
 */
-(void)moveCellFromIndex:(NSIndexPath *)oldIndexPath toIndex:(NSIndexPath *)newIndexPath;
@end
