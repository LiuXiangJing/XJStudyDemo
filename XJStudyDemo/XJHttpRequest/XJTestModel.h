//
//  XJTestModel.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJStatus.h"
#import "MJExtension.h"
@interface XJTestModel : NSObject
@property(nonatomic,strong)NSMutableArray * statuses;
/**
 *  总数
 */
@property (assign, nonatomic) NSNumber *totalNumber;

/**
 *  上一页的游标
 */
@property (assign, nonatomic) long long previousCursor;

/**
 *  下一页的游标
 */
@property (assign, nonatomic) long long nextCursor;
/**
 *  微博作者
 */
@property (strong, nonatomic) XJStatus *statusabc;
@end
