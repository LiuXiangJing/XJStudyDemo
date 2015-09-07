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
/**
 *  要映射的数据的key值
 */
NSString * const BaseRequestModleAnalysisKey    = @"XJ_BASE_CLIENT_REQUEST_MODEL_ANALYSIS_KEY";
/**
 *  是否显示loading
 */
NSString * const BaseRequestLoading             = @"XJ_BASE_CLIENT_REQUEST_Loading";
/**
 *  是否缓存数据
 */
NSString * const BaseRequestCacheRquestKey         = @"XJ_BASE_CLIENT_REQUEST_CACHE_KEY";
#define IS_IOS7 (([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) ? YES : NO)

@interface BaseRequestService ()
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) AFHTTPSessionManager * sessionManager NS_AVAILABLE_IOS(7_0);

@property (nonatomic,strong) NSURLCache * requestCache;
@end
#import <Mantle.h>
#import "XJTargetStore.h"
static BOOL netWorkReachEnable = YES;
@implementation BaseRequestService
#pragma mark - 私有方法
- (instancetype)initWithBaseURL:(NSURL *)baseURL{
    self =[super init];
    if (self) {
        _sessionManager  = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        _sessionManager.requestSerializer.timeoutInterval = 10;
        
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 10;
        
        self.requestCache = [NSURLCache sharedURLCache];
        [self.requestCache setMemoryCapacity:10*1024*1024];
        [self.requestCache setDiskCapacity:1024*1024*1024];
        
        [self updateNetRequestCache];
        __weak typeof(self)WeakSelf =self;
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [WeakSelf updateNetRequestCache];
        }];
    }
    return self;
}
- (void)updateNetRequestCache {
    AFNetworkReachabilityStatus status =[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status ==1 || status == 2 ) {
        netWorkReachEnable = YES;
        _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }else{
        _sessionManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        netWorkReachEnable = NO;
    }
}
- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer{
    if (requestSerializer) {
        _manager.requestSerializer = requestSerializer;
        _sessionManager.requestSerializer = requestSerializer;
    }else{
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];

    }
}

- (id)sendRequest:(NSDictionary *)requestInfo complete:(RequestHandle)complete{
   
    if (IS_IOS7) {
        return [self sendRequestInfo:requestInfo constructingBodyWithBlock:nil complete:[self handleRequestResultWithRequestInfo:requestInfo complete:complete]];
    }else{
        return [self sendRequestWithRequest:[self URLRequestWithRequestInfo:requestInfo] complete:[self handleRequestResultWithRequestInfo:requestInfo complete:complete]];
    }
   
    return nil;
}

- (id)upload:(NSDictionary *)requestInfo appenddata:(void (^)(id<AFMultipartFormData>))block complete:(RequestHandle)complete{
    
    return [self sendRequestWithRequest:[self URLRequest:requestInfo appenddata:block] complete:[self handleRequestResultWithRequestInfo:requestInfo complete:complete]];
}

#pragma mark - iOS 7 之前的NSURLRequest

- (id)sendRequestWithRequest:(NSURLRequest *)request complete:(RequestHandle)complete{
    AFHTTPRequestOperation *operation = [self.manager
                                         HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             complete(YES,@"",@[responseObject]);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             complete(NO,error.localizedDescription,@[error]);
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
-(id)sendRequestInfo:(NSDictionary *)requestinfo constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block complete:(RequestHandle)complete  NS_AVAILABLE_IOS(7_0){
    
    NSString * cacheKey =requestinfo[BaseRequestCacheRquestKey];
    NSURLSessionDataTask * task =[self requesturl:requestinfo[BaseRequestPath] method:requestinfo[BaseRequestMethod] parameters:requestinfo[BaseRequestParameter] constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        if(cacheKey){
            [_requestCache cachedResponseForRequest:task.originalRequest];
        }
        complete(YES,@"",@[responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(error.code ==NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotFindHost){
            if(cacheKey){
                NSCachedURLResponse * response = [self.requestCache cachedResponseForRequest:task.originalRequest];
                if(response){
                    id respondData = [NSJSONSerialization JSONObjectWithData:response.data options:NSJSONReadingMutableLeaves error:nil];
                    if(respondData){
                        complete(YES,@"",@[respondData]);
                    }else{
                       complete(NO,error.localizedDescription,@[error]);
                    }
                }else{
                    complete(NO,error.localizedDescription,@[error]);
                }
            }else{
                complete(NO,error.localizedDescription,@[error]);
            }
        }else{
            complete(NO,error.localizedDescription,@[error]);
        }
    }];
    return task;
}
#pragma mark iOS7 请求汇合
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
- (RequestHandle)handleRequestResultWithRequestInfo:(NSDictionary *)requestInfo complete:(RequestHandle)complete{
    return ^(BOOL success,NSString * errorMsg,NSArray * results){
        if (success) {
            [self handleSuccessDataWithRequestInfo:requestInfo resultData:results complete:complete];
        }else{
            NSError * error = [results firstObject];
            if (error.code == NSURLErrorCannotDecodeContentData) {
               errorMsg = @"数据解析失败了~";
                results =@[];
                complete(success,errorMsg,results);
            }else if(error.code ==NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotFindHost){
//                NSString * cacheKey =requestInfo[BaseRequestCacheRquestKey];
//                if (cacheKey) {//是否缓存数据
//                    NSDictionary * dataDic = [XJTargetStore getRequestDataWithKey:cacheKey];
//                    if (dataDic) {
//                        [self handleSuccessDataWithRequestInfo:requestInfo resultData:@[dataDic] complete:complete];
//                    }else{
//                        errorMsg = @"没有网络哦~";
//                        results =@[];
//                        complete(success,errorMsg,results);
//                    }
//                }else{
                    errorMsg = @"没有网络哦~";
                    results =@[];
                    complete(success,errorMsg,results);
//                }
            }else if(error.code ==NSURLErrorCancelled){
                errorMsg =[NSString stringWithString:error.localizedDescription];
                results =@[];
                complete(success,errorMsg,results);
            }else if(error.code == NSURLErrorTimedOut){
               errorMsg =@"网太差了~请稍后再试";
                results =@[];
                complete(success,errorMsg,results);
            }else{
                errorMsg =@"请求失败了";
                results =@[];
                complete(success,errorMsg,results);
            }
        }
    };
}
- (void)handleSuccessDataWithRequestInfo:(NSDictionary *)requestInfo resultData:(NSArray *)results complete:(RequestHandle)complete {
    
        BOOL success = YES; NSString * errorMsg =@"";
        NSDictionary * dataDic =[results lastObject];
        NSString * cacheKey =requestInfo[BaseRequestCacheRquestKey];
        if (cacheKey) {//是否缓存数据
//            [XJTargetStore cacheRequestDataWithData:dataDic forKey:cacheKey];
        }
        NSString * code =[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"code"]];
        if (![code isEqualToString:@"0"]) {
            success = NO;
            errorMsg =[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"msg"]];
            results =@[];
            complete(success,errorMsg,results);
        }else{
            Class modelClass = requestInfo[BaseRequestModelMapping];
            if (modelClass) {//是否映射
                id respondData =[dataDic valueForKey:@"data"];
                [self mapeModelWithData:respondData toModel:modelClass forKey:requestInfo[BaseRequestModleAnalysisKey] complete:complete];
            }else{
                complete(success,errorMsg,@[dataDic]);
            }
        }
    
}
#pragma mark - 数据映射
- (void)mapeModelWithData:(id)respondData toModel:(Class)class forKey:(NSString *)key complete:(RequestHandle)complete{
    
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
    }else{
     complete(YES,@"", nil);
    }
    
}
- (void)cancelAllRequest{
    [self.manager.operationQueue cancelAllOperations];
    [self.sessionManager.operationQueue cancelAllOperations];
}
- (void)dealloc {
    [self cancelAllRequest];
}
@end
