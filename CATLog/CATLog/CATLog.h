//
//  CATLog.h
//  CATLog
//
//  Created by zengcatch on 16/4/18.
//  Copyright © 2016年 cacth. All rights reserved.
//

#import <Foundation/Foundation.h>

//Verbose
#define CLogV(fmt, ...) [CATLog logV:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

//Debug
#define CLogD(fmt, ...) [CATLog logD:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

//Info
#define CLogI(fmt, ...) [CATLog logI:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

//Warning
#define CLogW(fmt, ...) [CATLog logW:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

//Error
#define CLogE(fmt, ...) [CATLog logE:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];

//log Level
typedef NS_ENUM(NSInteger, CATLogLevel) {
    CATLevelV = 0,  //Verbose
    CATLevelD = 1,  //Debug
    CATLevelI = 2,  //Info
    CATLevelW = 3,  //Warning
    CATLevelE = 4,  //Error
    CATLevelN = 5,  //Close All
};

@interface CATLog : NSObject

/**
 *  init log
 */
+(void)initWithNumberOfDaysToDelete:(NSInteger)number;

/**
 *  set remote log enable
 *
 *  @param enable : BOOL
 */
+(void)setRemoteLogEnable:(BOOL)enable;

/**
 *  set catlog server ip &port
 *
 *  @param ip   : server ip
 *  @param port : server port
 */
+(void)setRemoteIp:(NSString *)ip port:(NSInteger)port;

/**
 *  set colorful log enable
 *
 *  @param enable   : BOOL
 */
+(void)setColorEnable:(BOOL)enable;

/**
 *  set color for level
 *
 *  @param R        : Red
 *  @param G        : Green
 *  @param B        : Blue
 *  @param level    : Log level
 */
+(void)setR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B forLevel:(CATLogLevel)level;

/**
 *  set bg color for level
 *
 *  @param R        : Red
 *  @param G        : Green
 *  @param B        : Blue
 *  @param level    : Log level
 */
+(void)setBgR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B forLevel:(CATLogLevel)level;

/**
 *  log exception
 *
 *  @param exception
 */
+ (void)logCrash:(NSException *)exception;

/**
 *  set log level
 *
 *  @param level    : log level
 */
+ (void)setLogLevel:(CATLogLevel)level;

/**
 *  show today log file
 */
+(void)showTodayLogFile;

/**
 *  show all log file
 */
+(void)showAllLogFile;

/**
 *  log
 *
 *  @param level    : log level
 *  @param format   : format log message
 */
+ (void)logLevel:(CATLogLevel)level logInfo:(NSString *)format, ...NS_FORMAT_FUNCTION(2,3);

/**
 *  log error
 *
 *  @param format   : format log message
 */
+ (void)logE:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

/**
 *  log warning
 *
 *  @param format   : format log message
 */
+ (void)logW:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

/**
 *  log info
 *
 *  @param format   : format log message
 */
+ (void)logI:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

/**
 *  log debug
 *
 *  @param format   : format log message
 */
+ (void)logD:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

/**
 *  log verbose
 *
 *  @param format   : format log message
 */
+ (void)logV:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);

@end