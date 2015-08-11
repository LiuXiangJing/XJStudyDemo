//
//  XJStatus.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJUser.h"
@interface XJStatus : NSObject
/**
 *  微博文本内容
 */
@property (copy, nonatomic) NSString *text;

/**
 *  微博作者
 */
@property (strong, nonatomic) XJUser *user;

/**
 *  转发的微博
 */
@property (strong, nonatomic) XJStatus *retweetedStatus;
@end
