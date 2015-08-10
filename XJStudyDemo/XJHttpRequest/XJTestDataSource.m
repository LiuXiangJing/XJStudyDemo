//
//  XJTestDataSource.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTestDataSource.h"

@implementation XJTestDataSource
-(void)testRequest:(RequestHandle)complete{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"15110252112",@"em",@"get",@"tp",@"123456",@"pw", nil];

    [self.netWorkService sendRequest:@{BaseRequestMethod:@"POST",
                                       BaseRequestPath:@"app/appuser/uinfo",
                                       BaseRequestParameter:dict
                                       } complicate:complete];
}



@end
