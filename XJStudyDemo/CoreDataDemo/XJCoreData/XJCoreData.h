//
//  XJCoreData.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/29.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface XJCoreData : NSObject
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(XJCoreData *)shareCoreData;
/**
 *  保存一条数据
 *
 *  @param entityName        表的名字
 *  @param managedObjectinfo NSManagedObject转化成字典
 *  @param primarykey        主键
 */
-(void)saveObjectWithEntityName:(NSString *)entityName managedObjectInfo:(NSManagedObject *)managedObjectinfo primarykey:(NSString *)primarykey;
/**
 *  保存
 */
- (void)saveContext;
/**
 *  据根键值获取一条或多条数据
 *
 *  @param entityName 表名字
 *  @param key        键
 *  @param value      值
 *
 *  @return 数据数组
 */
-(NSArray*)findObjectFrom:(NSString *)entityName Key:(NSString*)key Value:(id)value;
/**
 *  获取消息
 *
 *  @param entityName 表名
 *  @param key        key
 *  @param asc        升序降序
 *  @param predicate  条件
 *
 *  @return 数据数组
 */
-(NSArray*)fetch:(NSString *)entityName
         sortKey:(NSString *)key
       ascending:(BOOL)asc
       predicate:(NSPredicate*)predicate;
/**
 *  获取一张表下的所有数据
 *
 *  @param entityName 表名
 *
 *  @return 数据数组
 */
-(NSArray *)fetchAllObjectsWithEntityName:(NSString *)entityName;
/**
 *  删除某表中所有的数据
 *
 *  @param entityName 表名
 */
-(void)deleteAllObjectsWithEntityName:(NSString *)entityName;
/**
 *  删除某条数据
 *
 *  @param oneObject NSManagedObject
 */
-(void)deleteOneObject:(NSManagedObject *)oneObject;

@end
