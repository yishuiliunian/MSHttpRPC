//
//  MSSyncCenter.m
//  MoShang
//
//  Created by stonedong on 15/2/7.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSSyncCenter.h"
#import <DZSingletonFactory.h>
#import "MSRequest.h"
#import "MSRequestOperation.h"
#import "MSHttpLog.h"
#import "MSRouter.h"
#import "MSTokenRequest.h"
@interface MSSyncCenter ()
{
    NSOperationQueue* _operationQueue;
}
@end
@implementation MSSyncCenter
+ (MSSyncCenter*) defaultCenter
{
    return DZSingleForClass([self class]);
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _operationQueue = [[NSOperationQueue alloc] init];
    return self;
}
- (int) performRequest:(MSRequest*)request
{
    NSAssert(self.commonParametersSetBlock, @"没有注册commonParametersSetBlock");
    NSAssert(self.configureParametersBlock, @"没有注册configureParametersBlock");
    NSAssert(self.tokenRefreshClass, @"没有注册tokenRefreshClass");
    NSAssert(self.baseURL, @"没有注册baseURL");
    
    
    MSRequestOperation* operation = [[MSRequestOperation alloc] initWithRequest:request];
    [_operationQueue addOperation:operation];
    return operation.queueID;
}

- (void) registerSetCommonParametersBlock:(MSSyncCommonParametersSetBlock)block {
    _commonParametersSetBlock = block;
}
- (void) registerTokenRefreshClass:(Class)clas {
    NSAssert([clas isSubclassOfClass:[MSTokenRequest class]], @"刷新token的类，不是MSTokenRequest的子类");
    _tokenRefreshClass = clas;
}
- (void) registerConfigureParametersBlock:(MSSyncConfigureParameters)block {
    _configureParametersBlock = block;
}
- (void) registerBaseURL:(NSString*)url{
    [MSRouter shareRouter].baseURL = url;
}
@end

MSSyncDecodeResponseDataBlock MSDefaultDecodeDictionaryBlock = ^NSObject *(NSData *data, NSError *__autoreleasing *error) {
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (*error) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.ms.error" code:-931 userInfo:@{NSLocalizedDescriptionKey:@"解析数据失败"}];
        }
        return nil;
    }
    int ret = [dic[@"ret"] intValue];
    if (ret != 0) {
        NSString* message = dic[@"msg"];
        *error =[NSError errorWithDomain:@"com.ms.error" code:-931 userInfo:@{NSLocalizedDescriptionKey:@"服务器跑路了，返回了空数据"}];
        return nil;
    }
    id retData = dic[@"data"];
    return retData;
};


MSSyncConfigureParameters MSDefaultConfigureURLReqeust = ^NSURLRequest *(NSString *baseURL, NSString *method, NSDictionary *paramters) {
    NSString* urlStr = [baseURL stringByAppendingPathComponent:method] ;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:HttpMethodPOST];
    NSMutableString* str = [NSMutableString new];
    NSArray* allKeys = [paramters allKeys];
    for (int i = 0 ; i < allKeys.count; i++) {
        if (i != 0) {
            [str appendString:@"&"];
        }
        [str appendFormat:@"%@=%@", allKeys[i], paramters[allKeys[i]]];
    }
    NSString* paramterstr = str;
    NSData* paramData = [paramterstr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@([paramData length]) stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    return request;
};