//
//  MSRequest.m
//  MoShang
//
//  Created by stonedong on 15/2/4.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSRequest.h"
#import "MSRouter.h"
#import "MSSyncCenter.h"
#import <NSString+URLEncode.h>

@interface MSRequest ()

@end
@implementation MSRequest
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _paramters = [NSMutableDictionary new];
    return self;
}

- (NSDictionary*)allParamters
{
    return [_paramters copy];
}

- (void) addParamter:(id)paramter forKey:(NSString*)key
{
    if (!paramter || !key) {
        return;
    }
    if ([paramter isKindOfClass:[NSString class]]) {
        paramter = [(NSString*)paramter URLEncode];
    }
    _paramters[key] = paramter;
}
- (BOOL) addCommonParamters:(NSError *__autoreleasing *)error {
    MSDefaultSyncCenter.commonParametersSetBlock(_paramters);
    return YES;
}

- (BOOL) loadParamters:(NSError *__autoreleasing *)error
{
    return YES;
}
- (void) onError:(NSError*)error {
    [self doUIOnError:error];
}

- (void) onSuccess:(id)retObject {
    
}

- (NSString*) requestParamtersAppendingURL
{
    NSMutableString* str = [NSMutableString new];
    NSArray* allKeys = [_paramters allKeys];
    for (int i = 0 ; i < allKeys.count; i++) {
        if (i != 0) {
            [str appendString:@"&"];
        }
        [str appendFormat:@"%@=%@", allKeys[i], _paramters[allKeys[i]]];
    }
    return str;
}
- (BOOL) doRequst
{
    NSError* error= nil;
    [self addCommonParamters:&error];
    MSRequestOnErrorAndReturn(error);
    [self loadParamters:&error];
    MSRequestOnErrorAndReturn(error);
    
    NSString* baseURL = MSDefaultServerURL;
   
    NSURLRequest* request = MSDefaultSyncCenter.configureParametersBlock(baseURL, self.method, _paramters);
    NSURLResponse* response ;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    MSRequestOnErrorAndReturn(error);
    if (!data || data.length == 0) {
        error = [NSError errorWithDomain:@"com.ms.error" code:-931 userInfo:@{NSLocalizedDescriptionKey:@"服务器跑路了，返回了空数据"}];
        MSRequestOnErrorAndReturn(error);
    }
 
    NSObject* object = MSDefaultSyncCenter.decodeBlock(data, &error);
    if (error) {
        MSRequestOnErrorAndReturn(error);
    }
    [self onSuccess:object];
    return YES;
}

- (void) doUIOnSuccced:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.uidelegate respondsToSelector:@selector(request:onSucced:)]) {
            [self.uidelegate request:self onSucced:object];
        }
    });
}

- (void) doUIOnError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.uidelegate respondsToSelector:@selector(request:onError:)]) {
            [self.uidelegate request:self onError:error];
        }
    });
}
@end
