//
//  CATLog.m
//  CATLog
//
//  Created by zengcatch on 16/4/18.
//  Copyright © 2016年 cacth. All rights reserved.
//

#import "CATLog.h"
#import <UIKit/UIKit.h>

#ifdef DEBUG
static CATLogLevel LogLevel = CATLevelV; //Debug => DLevelV
#else
static CATLogLevel LogLevel = CATLevelE; //Release => DLevelE
#endif

//log color
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

#if 0//TARGET_OS_IPHONE
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

static NSString *color4LogE    = @"255,0,0";
static NSString *color4LogW    = @"238,180,34";
static NSString *color4LogI    = @"0,0,255";
static NSString *color4LogD    = @"209,57,168";
static NSString *color4LogV    = @"0,255,0";

//log file
static NSString *logFilePath = nil;
static NSString *logDic      = nil;
static NSString *crashDic    = nil;

//define how many days to delete log file
const int preDaysToDelLog = 2;

//log queue
static dispatch_once_t logQueueCreatOnce;
static dispatch_queue_t logOperationQueue;


@implementation CATLog


#pragma mark --
#pragma mark -- public methods

+(void)initLog{
    [self setColorEnable:YES];
    
    [self _initFile];
    
    dispatch_once(&logQueueCreatOnce, ^{
        logOperationQueue =  dispatch_queue_create("com.catlog.app.operationqueue", DISPATCH_QUEUE_SERIAL);
    });
}

+(void)setColorEnable:(BOOL)enable{
    if (enable) {
        setenv("XcodeColors", "YES", 0);
    }else{
        setenv("XcodeColors", "NO", 0);
    }
}

+(void)setR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B forLevel:(CATLogLevel)level{
    NSString* rgbStr = [NSString stringWithFormat:@"%ld,%ld,%ld",(long)R,(long)G,(long)B];
    if (level == CATLevelE) {
        color4LogE = rgbStr;
    }else if(level == CATLevelW) {
        color4LogW = rgbStr;
    }else if(level == CATLevelI) {
        color4LogI = rgbStr;
    }else if(level == CATLevelD) {
        color4LogD = rgbStr;
    }else if(level == CATLevelV) {
        color4LogV = rgbStr;
    }
}

+ (void)logCrash:(NSException *)exception{
    if (!exception) return;
    
#ifdef DEBUG
    NSLog(@"CRASH: %@",exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
#endif
    if (!crashDic) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *crashDirectory = [documentsDirectory stringByAppendingString:@"/log/"];
        crashDic = crashDirectory;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"CRASH_%@.log",[self _getCurrentTime]];
    NSString *filePath = [crashDic stringByAppendingString:fileName];
    NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *phoneLanguage = [languages objectAtIndex:0];
    
    content = [content stringByAppendingString:[NSString stringWithFormat:@"iOS Version:%@ Language:%@", [[UIDevice currentDevice] systemVersion],phoneLanguage]];
    NSError *error = nil;
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
#if DEBUG
        NSLog(@"error is %@",error);
#endif
        [self logE:@"CRASH LOG CREAT ERR INFO IS %@",error];
    }
}

+ (void)setLogLevel:(CATLogLevel)level{
    LogLevel = level;
}

+ (void)logLevel:(CATLogLevel)level LogInfo:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:level Format:format VaList:args];
    va_end(args);
}

+ (void)logV:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelV Format:format VaList:args];
    va_end(args);
}

+ (void)logD:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelD Format:format VaList:args];
    va_end(args);
}

+ (void)logI:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelI Format:format VaList:args];
    va_end(args);
}

+ (void)logW:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelW Format:format VaList:args];
    va_end(args);
}

+ (void)logE:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelE Format:format VaList:args];
    va_end(args);
}


#pragma mark --
#pragma mark -- private methods

/**
 *  log file related
 */
+(void)_initFile{
    if (!logFilePath){
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *logDirectory       = [documentsDirectory stringByAppendingString:@"/log/"];
        NSString *crashDirectory     = [documentsDirectory stringByAppendingString:@"/log/"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:crashDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:crashDirectory
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        logDic = logDirectory;
        crashDic = crashDirectory;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];;
        NSString *fileNamePrefix = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"CAT_log_%@.logtraces.txt", fileNamePrefix];
        NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
        logFilePath = filePath;
#if DEBUG
        NSLog(@"【CATLog】LogPath: %@", logFilePath);
#endif
        //create file if it doesn't exist
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        //delete previous log file
        NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*preDaysToDelLog];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:prevDate];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *delDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDic error:nil];
        for (NSString *file in logFiles){
            NSString *fileName = [file stringByReplacingOccurrencesOfString:@".logtraces.txt" withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@"CAT_log_" withString:@""];
            NSDate *fileDate = [dateFormatter dateFromString:fileName];
            if (nil == fileDate){
                continue;
            }
            if (NSOrderedAscending == [fileDate compare:delDate]){
                [[NSFileManager defaultManager] removeItemAtPath:[logDic stringByAppendingString:file] error:nil];
            }
        }
    }
}

+(void)_logvLevel:(CATLogLevel)level Format:(NSString *)format VaList:(va_list)args{
    __block NSString *formatTmp = format;
    formatTmp = [[self _logFormatPrefix:level] stringByAppendingString:formatTmp];
    NSString *contentStr = [[NSString alloc] initWithFormat:formatTmp arguments:args];
    NSString *contentN = [contentStr stringByAppendingString:@"\n"];
    NSString *content = [NSString stringWithFormat:@"%@ %@",[self _getCurrentTime], contentN];
    
    NSString* color = [self _logColorStrForLevel:level];
    
    if (logOperationQueue) {
        dispatch_async(logOperationQueue, ^{
            if (level >= LogLevel){
                NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
                [file seekToEndOfFile];
                [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
                [file closeFile];
#ifdef DEBUG
                NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,color,contentN);
#endif
                formatTmp = nil;
            }
        });
    }else{
        NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,color,@"You should call [CATLog initLog] before use it!");
    }
}

+(NSString *)_getCurrentTime{
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [format stringFromDate:nowUTC];
    
    return dateString;
}

+ (NSString*)_stringFromLogLevel:(CATLogLevel)logLevel{
    switch (logLevel){
        case CATLevelV: return @"V";
        case CATLevelD: return @"D";
        case CATLevelI: return @"I";
        case CATLevelW: return @"W";
        case CATLevelE: return @"E";
        case CATLevelN: return @"N";
    }
    return @"";
}

+ (NSString*)_logFormatPrefix:(CATLogLevel)logLevel{
    return [NSString stringWithFormat:@"[%@] ", [self _stringFromLogLevel:logLevel]];
}

+(NSString *)_logColorStrForLevel:(CATLogLevel)level{
    if (level == CATLevelE) {
        return color4LogE;
    }else if(level == CATLevelW) {
        return color4LogW;
    }else if(level == CATLevelI) {
        return color4LogI;
    }else if(level == CATLevelD) {
        return color4LogD;
    }else if(level == CATLevelV) {
        return color4LogV;
    }
    return color4LogV;
}

@end