//
//  BaseDataSource.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "BaseDataSource.h"
@interface BaseDataSource ()

@end

#define BaseRequestURL  @"http://www.kezhanwang.cn/"

@implementation BaseDataSource
@synthesize netWorkService = _netWorkService;
+(instancetype)dataSource{
    id dataSource  = [[[self class] alloc] init];
    return dataSource;
}

-(id)init{
    self = [super init];
    if (self) {
        _netWorkService = [[BaseRequestService alloc] initWithBaseURL:[NSURL URLWithString:BaseRequestURL]];
    }
    return self;
}
@end
