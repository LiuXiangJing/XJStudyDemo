//
//  XJTestDataSource.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "BaseDataSource.h"

@interface XJTestDataSource : BaseDataSource
- (void)testRequest:(RequestHandle)complete;

- (void)testCacheRequest:(RequestHandle)complete;
- (void)getHomeRecommentDataWithLng:(NSString *)lngStr lat:(NSString*)lat complete:(RequestHandle)complete;
@end
