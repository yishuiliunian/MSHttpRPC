//
//  MSTokenManager.m
//  MoShang
//
//  Created by stonedong on 15/2/4.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import "MSTokenManager.h"
#import <DZSingletonFactory.h>
#import "MSTokenRequest.h"
#import "MSSyncCenter.h"
@implementation MSTokenManager
+ (MSTokenManager*) shareManager {
    return DZSingleForClass([self class]);
}

- (BOOL) isTokenVaild
{
    if (!_token) {
        return NO;
    }
    if (!_token.token || !_token.account) {
        return NO;
    }
    if (_token.experiedDate) {
        if ([_token.experiedDate timeIntervalSinceNow] < 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) revarifyCacheToken:(NSError *__autoreleasing *)error
{
    if ([self isTokenVaild]) {
        return YES;
    }
    
    MSTokenRequest* req = [MSDefaultSyncCenter.tokenRefreshClass new];
    if (!req) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.ms.http" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"没有实现获取token的类"}];
        }
        return NO;
    }
    if (![req doRequst]) {
        if (error != NULL) {
            *error = req.lastError;
        }
        return NO;
    }
    _token = [[MSToken alloc] initWithToken:req.token account:req.accountID];
    return YES;
}
@end
