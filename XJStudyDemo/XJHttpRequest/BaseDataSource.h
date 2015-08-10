//
//  BaseDataSource.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestService.h"
@interface BaseDataSource : NSObject
@property(nonatomic,strong,readonly)BaseRequestService * netWorkService;

+(instancetype)dataSource;

@end
