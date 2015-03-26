//
//  MSTokenRequest.h
//  Pods
//
//  Created by stonedong on 15/3/26.
//
//

#import "MSRequest.h"

@interface MSTokenRequest : MSRequest
{
    NSString* _token;
}
@property (nonatomic, strong) NSString* accountID;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSDate* experiedDate;
@end
