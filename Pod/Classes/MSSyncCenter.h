//
//  MSSyncCenter.h
//  MoShang
//
//  Created by stonedong on 15/2/7.
//  Copyright (c) 2015年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MSDefaultSyncCenter [MSSyncCenter defaultCenter]

typedef void(^MSSyncCommonParametersSetBlock)(NSMutableDictionary* parameters);
typedef NSURLRequest*(^MSSyncConfigureParameters)(NSString* baseURL, NSString* method, NSDictionary* paramteers);
typedef NSObject*(^MSSyncDecodeResponseDataBlock)(NSData* data, NSError* __autoreleasing* error);
@class MSRequest;
@interface MSSyncCenter : NSObject
@property (nonatomic, strong, readonly) Class tokenRefreshClass;
@property (nonatomic, strong, readonly) MSSyncCommonParametersSetBlock commonParametersSetBlock;
@property (nonatomic, strong, readonly) MSSyncConfigureParameters configureParametersBlock;
@property (nonatomic, strong, readonly) MSSyncDecodeResponseDataBlock decodeBlock;
@property (nonatomic, strong, readonly) NSString* baseURL;
+ (MSSyncCenter*) defaultCenter;
- (void) registerSetCommonParametersBlock:(MSSyncCommonParametersSetBlock)block;
- (void) registerTokenRefreshClass:(Class)clas;
- (void) registerConfigureParametersBlock:(MSSyncConfigureParameters)block;
- (void) registerBaseURL:(NSString*)url;
- (void) registerDecodeBlock:(MSSyncDecodeResponseDataBlock)block;
- (int) performRequest:(MSRequest*)request;
@end


extern MSSyncDecodeResponseDataBlock MSDefaultDecodeDictionaryBlock;
extern MSSyncConfigureParameters MSDefaultConfigureURLReqeust;