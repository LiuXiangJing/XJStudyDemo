//
//  BaseRequestService.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/*
 type For RequestMethod
 `GET`, `POST`, `PUT`, or `DELETE`
 */
extern NSString * const BaseRequestMethod;

extern NSString * const BaseRequestPath;

extern NSString * const BaseRequestParameter;

//extern NSString * const BaseRequestLoading;//是否显示加载中

//如果不传，返回的结果 会是未解析的字典
extern NSString * const BaseRequestModelMapping;//如果需要解析  传入需要被解析的model类型对应的string

extern NSString * const BaseRequestModleAnalysisKey;//如果解析字段 result里面还有一层字典或者数组，传入该modle对应的字段key

extern NSString * const BaseRequestCacheRquestKey;//缓存数据。如果为空则不缓存

typedef void(^RequestHandle)(BOOL success,NSString * errorMsg,NSArray * results);

@interface BaseRequestService : NSObject

- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer;

- (id)sendRequest:(NSDictionary *)requestInfo complete:(RequestHandle)complete;

- (id)upload:(NSDictionary*)requestInfo appenddata:(void (^)(id <AFMultipartFormData> formData))block complete:(RequestHandle)complete;
- (void)cancelAllRequest;
@end
