//
//  XJBaseModel.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@interface XJBaseModel : NSManagedObject
@property(nonatomic,readonly)NSString *primaryKey;
+(NSString *)primaryKey;
/**
 *  根据主键查找NSManagedObject,如果存在则返回，如果不存在则插入新的
 *
 *  @param primaryValue 主键的值
 *
 *  @return NSManagedObject
 */
+(instancetype)initObjectWithPrimaryValue:(NSString *)primaryValue;
/**
 *  直接插入新的object
 *
 *  @return NSManagedObject
 */
+(instancetype)initObject;
/**
 *  保存
 */
-(void)saveObject;
@end
