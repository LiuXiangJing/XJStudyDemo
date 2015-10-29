//
//  XJTargetStore.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/9/6.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//
#import "XJTargetStore.h"
#import "YTKKeyValueStore.h"
@interface XJTargetStore ()
@property (nonatomic,strong)YTKKeyValueStore * storeManager;
@end

static NSString *const KZWDBNAME    = @"KZWDataBase.db";

static NSString *const KZWTABLENAME = @"KZWData";

@implementation XJTargetStore
+ (instancetype)shareTagetStore {
    static XJTargetStore * targetStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        targetStore =[[XJTargetStore alloc] init];
        targetStore.storeManager =[[YTKKeyValueStore alloc]initDBWithName:KZWDBNAME];
        if (![targetStore.storeManager isTableExists:KZWTABLENAME]) {
            [targetStore.storeManager createTableWithName:KZWTABLENAME];
        }
    });
    return targetStore;
}

+ (void)cacheRequestDataWithData:(id)requestData forKey:(NSString *)key {
    XJTargetStore * targetStore =[XJTargetStore shareTagetStore];
    [targetStore.storeManager putObject:requestData withId:key intoTable:KZWTABLENAME];
}

+ (id)getRequestDataWithKey:(NSString *)key {
      XJTargetStore * targetStore =[XJTargetStore shareTagetStore];
    return [targetStore.storeManager getObjectById:key fromTable:KZWTABLENAME];
}
+ (void)clearRequestDataWithKey:(NSString *)key {
    if (key) {
        [[XJTargetStore shareTagetStore].storeManager deleteObjectById:key fromTable:KZWTABLENAME];
    }else{
        
        [[XJTargetStore shareTagetStore].storeManager clearTable:KZWTABLENAME];
    }
}
+ (NSString *)appendAllKeyStringFromArray:(NSArray *)stringArray {
    NSMutableString * keyString =[[NSMutableString alloc]init];
    for (NSString * subString in stringArray) {
        if ([subString isKindOfClass:[NSString class]]) {
            [keyString appendString:subString];
        }
    }
    return keyString;
}
@end
