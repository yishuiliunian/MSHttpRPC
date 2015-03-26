//
//  MSHttpLog.h
//  Pods
//
//  Created by stonedong on 15/3/26.
//
//

#import <Foundation/Foundation.h>
#import <DDLog.h>
#import <UIKit/UIKit.h>
#ifdef DEBUG
static  int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static  int ddLogLevel =  DDLogLevelError;
#endif

FOUNDATION_EXTERN void MSHttpLogSetup();