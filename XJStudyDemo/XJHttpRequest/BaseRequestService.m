//
//  BaseRequestService.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "BaseRequestService.h"
/**
 *  请求方式 其key值有：POST GET 等
 */
NSString * const BaseRequestMethod              = @"XJ_BASE_CLIENT_REQUEST_METHOD";
/**
 *  请求的sub RUL  其kay值一般是一个string
 */
NSString * const BaseRequestPath                = @"XJ_BASE_CLIENT_REQUEST_PATH";
/**
 *  请求参数，其key值一般是一个字典
 */
NSString * const BaseRequestParameter           = @"XJ_BASE_CLIENT_REQUEST_PARAMETER";
/**
 *  要映射的类 ，一般其key值是一个mdol class
 */
NSString * const BaseRequestModelMapping        = @"XJ_BASE_CLIENT_REQUEST_MODEL_MAPPING";

NSString * const BaseRequestModleAnalysisKey    = @"XJ_BASE_CLIENT_REQUEST_MODEL_ANALYSIS_KEY";

NSString * const BaseRequestLoading             = @"XJ_BASE_CLIENT_REQUEST_Loading";
#define IS_IOS7 (([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) ? YES : NO)

@interface BaseRequestService ()
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong) AFHTTPSessionManager * sessionManager NS_AVAILABLE_IOS(7_0);
@end
#import <Mantle.h>
@implementation BaseRequestService
#pragma mark - 私有方法
- (instancetype)initWithBaseURL:(NSURL *)baseURL{
    self =[super init];
    if (self) {
        _sessionManager  = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        
        
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    }
    return self;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer{
    if (requestSerializer) {
        _manager.requestSerializer = requestSerializer;
    }else{
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}

- (id)sendRequest:(NSDictionary *)requestInfo complicate:(RequestHandle)complicate{
    BOOL isShowLoading =requestInfo[BaseRequestLoading];
    if (isShowLoading) {
        
    }
    if (IS_IOS7) {
        return [self sendRequestInfo:requestInfo constructingBodyWithBlock:nil complicate:[self handleRequestResult:requestInfo complicate:complicate]];
    }else{
        return [self sendRequestWithRequest:[self URLRequestWithRequestInfo:requestInfo] complicate:[self handleRequestResult:requestInfo complicate:complicate]];
    }
    return nil;
}

- (id)upload:(NSDictionary *)requestInfo appenddata:(void (^)(id<AFMultipartFormData>))block complicate:(RequestHandle)complicate{
    
    return [self sendRequestWithRequest:[self URLRequest:requestInfo appenddata:block] complicate:[self handleRequestResult:requestInfo complicate:complicate]];
}

#pragma mark - iOS 7 之前的NSURLRequest

- (id)sendRequestWithRequest:(NSURLRequest *)request complicate:(RequestHandle)complicate{
    AFHTTPRequestOperation *operation = [self.manager
                                         HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             complicate(YES,@"",@[responseObject]);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             complicate(NO,error.domain,@[error]);
                                         }];
    [self.manager.operationQueue addOperation:operation];
    return operation;
}

- (NSURLRequest *)URLRequestWithRequestInfo:(NSDictionary *)requestInfo{
    
    assert(requestInfo[BaseRequestMethod] &&
           requestInfo[BaseRequestPath] );
    
    NSError *error;
    NSString *path = ({
        NSString *path;
        if (self.manager.baseURL) {
            path = [[self.manager.baseURL URLByAppendingPathComponent:requestInfo[BaseRequestPath]] absoluteString];
        }else{
            path = requestInfo[BaseRequestPath];
        }
        path;
    }) ;
    NSURLRequest *request = [self.manager.requestSerializer requestWithMethod:requestInfo[BaseRequestMethod]
                                                                    URLString:path
                                                                   parameters:requestInfo[BaseRequestParameter]
                                                                        error:&error];
    if (!error) {
        return request;
    }else{
        NSLog(@"request serialize failed with error : %@",error);
        return nil;
    }
}
//@param method The HTTP method for the request. This parameter must not be `GET` or `HEAD`, or `nil`.

- (NSURLRequest *)URLRequest:(NSDictionary*)requestInfo appenddata:(void (^)(id <AFMultipartFormData> formData))block{
    
    assert(requestInfo[BaseRequestPath] );
    
    NSError *error;
    
    NSString *path = ({
        NSString *path;
        if (self.manager.baseURL) {
            path = [[self.manager.baseURL URLByAppendingPathComponent:requestInfo[BaseRequestPath]] absoluteString];
        }else{
            path = requestInfo[BaseRequestPath];
        }
        path;
    }) ;
    
    NSURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:requestInfo[BaseRequestMethod] URLString:path parameters:requestInfo[BaseRequestParameter] constructingBodyWithBlock:block error:&error];
    
    
    if (!error) {
        return request;
    }else{
        NSLog(@"request serialize failed with error : %@",error);
        return nil;
    }
}

#pragma mark - iOS 7之后的网络请求
-(id)sendRequestInfo:(NSDictionary *)requestinfo constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block complicate:(RequestHandle)complicate  NS_AVAILABLE_IOS(7_0){
    
    return  [self requesturl:requestinfo[BaseRequestPath] method:requestinfo[BaseRequestMethod] parameters:requestinfo[BaseRequestParameter] constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        complicate(YES,@"",@[responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        complicate(NO,error.domain,@[error]);
    }];
}

- (NSURLSessionDataTask *)requesturl:(NSString *)url
                              method:(NSString *)method
                          parameters:(NSDictionary *)parameters
           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    if ([method isEqualToString:@"GET"]) {
        return [self.sessionManager GET:url parameters:parameters success:success failure:failure];
    }else if([method isEqualToString:@"POST"]&&block){
        return [self.sessionManager POST:url parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
    }else if([method isEqualToString:@"POST"]&& block == nil) {
        return [self.sessionManager POST:url parameters:parameters success:success failure:failure];
    }else if([method isEqualToString:@"PUT"]){
        return [self.sessionManager PUT:url parameters:parameters success:success failure:failure];
    }else if([method isEqualToString:@"DELETE"]){
        return [self.sessionManager DELETE:url parameters:parameters success:success failure:failure];
    }else {
        failure(nil,[NSError errorWithDomain:[NSString stringWithFormat:@"%@方法不支持",method] code:1 userInfo:nil]);
        return nil;
    }
}

#pragma mark - 处理请求的结果不分系统版本..不同应用做不同的处理。。。。
- (RequestHandle)handleRequestResult:(NSDictionary *)requestInfo complicate:(RequestHandle)complicate{
    return ^(BOOL success,NSString * errorMsg,NSArray * results){
        if (success) {
            NSDictionary * dataDic =[results lastObject];
            NSString * code =[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"code"]];
            if (![code isEqualToString:@"0"]) {
                success = NO;
                errorMsg =[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"msg"]];
                results =@[];
            }else{
                Class modelClass = requestInfo[BaseRequestModelMapping];
                if (modelClass) {//是否映射
                    [self mapeModelWithData:dataDic toModel:modelClass forKey:requestInfo[BaseRequestModleAnalysisKey] complicate:complicate];
                }else{
                    complicate(success,@"",@[dataDic]);
                }
                
            }
        }else{
            results =@[];
        }
        complicate(success,errorMsg,results);
    };
}
- (void)mapeModelWithData:(id)respondData toModel:(Class)class forKey:(NSString *)key complicate:(RequestHandle)complete{
    
    if (respondData) {
        id mappingData;
        __block NSError *error;
        if ([respondData isKindOfClass:[NSDictionary class]]) {
            if (key) {
                
                id keyData = respondData[key];
                
                if ([keyData isKindOfClass:[NSArray class]]) {
                    mappingData = [MTLJSONAdapter modelsOfClass:class fromJSONArray:keyData error:&error];
                    
                }else {
                    mappingData = [MTLJSONAdapter modelOfClass:class
                                            fromJSONDictionary:keyData
                                                         error:&error];
                }
            }else{
                
                mappingData = [MTLJSONAdapter modelOfClass:class
                                        fromJSONDictionary:respondData
                                                     error:&error];
            }
            
        }else if ([respondData isKindOfClass:[NSArray class]]){
            mappingData = [MTLJSONAdapter modelsOfClass:class fromJSONArray:respondData error:&error];
        }
        if (error) {
            complete(YES,error.domain, nil);
        }else {
            complete(YES,@"",@[mappingData]);
        }
    }
     complete(YES,@"", nil);
    
    
}
- (void)cancelAllRequest{
    [self.manager.operationQueue cancelAllOperations];
    [self.sessionManager.operationQueue cancelAllOperations];
}
@end
