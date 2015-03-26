//
//  MSHttpLog.m
//  Pods
//
//  Created by stonedong on 15/3/26.
//
//

#import "MSHttpLog.h"
#import <DDLog.h>
#import <DDFileLogger.h>
#import <DDASLLogger.h>
#import <DDTTYLogger.h>

void MSHttpLogSetup()
{
#ifdef DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
#endif
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}