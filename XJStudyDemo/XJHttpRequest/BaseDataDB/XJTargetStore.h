//
//  XJTargetStore.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/9/6.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XJTargetStore : NSObject
/**
 *  保存请求数据到数据库
 *
 *  @param requestRespond 请求的数据
 *  @param key            保存的key
 */
+ (void)cacheRequestDataWithData:(id)requestData forKey:(NSString *)key;
/**
 *  读取数据
 *
 *  @param key key
 */
+ (id)getRequestDataWithKey:(NSString *)key;
/**
 *  清除数据
 */
+ (void)clearRequestData;

+ (NSString *)appendAllKeyStringFromArray:(NSArray *)stringArray;
@end
