//
//  XJTestDataSource.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTestDataSource.h"

@implementation XJTestDataSource
- (void)testRequest:(RequestHandle)complete{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"15110252112",@"em",@"get",@"tp",@"123456",@"pw", nil];
    [self.netWorkService sendRequest:@{BaseRequestMethod:@"POST",
                                       BaseRequestPath:@"app/appuser/uinfo",
                                       BaseRequestParameter:dict
                                       } complete:complete];
}

- (void)testCacheRequest:(RequestHandle)complete {
    NSDictionary * dicr =@{
                           @"_t":@"1441520989",
                           @"kzua":@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12H141 iPhone6",
                           @"lat":@"",
                           @"lng":@"",
                           };
    
    [self.netWorkService sendRequest:@{BaseRequestMethod:@"GET",
                                       BaseRequestPath:@"app/apiv20/myhome",
                                       BaseRequestParameter:dicr,
                                       BaseRequestCacheRquestKey:@"app/apiv20/myhome"
                                       } complete:complete];
    
}


@end
