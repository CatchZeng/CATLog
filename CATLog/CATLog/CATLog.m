//
//  CATLog.m
//  CATLog
//
//  Created by zengcatch on 16/4/18.
//  Copyright © 2016年 cacth. All rights reserved.
//

#import "CATLog.h"
#import <UIKit/UIKit.h>
#import "CATLogTransfer.h"
#import "CATLogReviewController.h"
#import "CATLogFilesViewController.h"

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

static NSMutableDictionary* colorDic = nil;
static NSMutableDictionary* bgColorDic = nil;

//log file
static NSString *logFilePath = nil;
static NSString *logDic      = nil;
static NSString *crashDic    = nil;

//log queue
static dispatch_once_t logQueueCreatOnce;
static dispatch_queue_t logOperationQueue;

//remote log
static CATLogTransfer *udpSocket;
static BOOL remoteLogEnable;
static NSString* remoteIp;
static NSInteger remotePort;
static long tag;

@implementation CATLog


#pragma mark --
#pragma mark -- public methods

+(void)initWithNumberOfDaysToDelete:(NSInteger)numberOfDaysToDelete{
    numberOfDaysToDelete = numberOfDaysToDelete < 0 ? 0 :numberOfDaysToDelete;
    [self setRemoteLogEnable:NO];
    [self setColorEnable:YES];
    [self _initColors];
    [self _initFileWithNumberOfDaysToDelete:numberOfDaysToDelete];
    dispatch_once(&logQueueCreatOnce, ^{
        logOperationQueue =  dispatch_queue_create("com.catlog.app.operationqueue", DISPATCH_QUEUE_SERIAL);
    });
}

+(void)setRemoteLogEnable:(BOOL)enable{
    remoteLogEnable = enable;
    if (enable) {
        [self _setupSocket];
    }
}

+(void)_setupSocket{
    if (!udpSocket) {
        udpSocket = [[CATLogTransfer alloc] initWithDelegate:nil delegateQueue:dispatch_get_main_queue()];
    }
    NSError *error = nil;
    if (![udpSocket bindToPort:0 error:&error]){
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![udpSocket beginReceiving:&error]){
        NSLog(@"Error receiving: %@", error);
        return;
    }
}

+(void)setRemoteIp:(NSString *)ip port:(NSInteger)port{
    remoteIp = ip;
    remotePort = port;
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
    if (colorDic) {
        [colorDic setObject:rgbStr forKey:@(level)];
    }else{
        NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,rgbStr,@"You should call [CATLog initLog] before use it!");
    }
}

+(void)setBgR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B forLevel:(CATLogLevel)level{
    NSString* rgbStr = [NSString stringWithFormat:@"%ld,%ld,%ld",(long)R,(long)G,(long)B];
    if (!bgColorDic) {
        bgColorDic = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    [bgColorDic setObject:rgbStr forKey:@(level)];
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

+ (void)logLevel:(CATLogLevel)level logInfo:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:level format:format vaList:args];
    va_end(args);
}

+ (void)logV:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelV format:format vaList:args];
    va_end(args);
}

+ (void)logD:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelD format:format vaList:args];
    va_end(args);
}

+ (void)logI:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelI format:format vaList:args];
    va_end(args);
}

+ (void)logW:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelW format:format vaList:args];
    va_end(args);
}

+ (void)logE:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    [self _logvLevel:CATLevelE format:format vaList:args];
    va_end(args);
}


#pragma mark --
#pragma mark -- private methods

+(void)_initColors{
    NSString *color4LogE    = @"255,0,0";
    NSString *color4LogW    = @"204,113,62";
    NSString *color4LogI    = @"73,176,249";
    NSString *color4LogD    = @"205,74,162";
    NSString *color4LogV    = @"115,205,102";
    colorDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:color4LogV,@(0),color4LogD,@(1),color4LogI,@(2),color4LogW,@(3),color4LogE,@(4),nil];
}

+(void)_initFileWithNumberOfDaysToDelete:(NSInteger)numberOfDaysToDelete{
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
        NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*numberOfDaysToDelete];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:prevDate];
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

+(void)_logvLevel:(CATLogLevel)level format:(NSString *)format vaList:(va_list)args{
    __block NSString *formatTmp = format;
    formatTmp = [[self _logFormatPrefix:level] stringByAppendingString:formatTmp];
    NSString *contentStr = [[NSString alloc] initWithFormat:formatTmp arguments:args];
    NSString *contentN = [contentStr stringByAppendingString:@"\n"];
    NSString *content = [NSString stringWithFormat:@"%@ %@",[self _getCurrentTime], contentN];
    
    if (logOperationQueue) {
        dispatch_async(logOperationQueue, ^{
            if (level >= LogLevel){
                NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
                [file seekToEndOfFile];
                [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
                [file closeFile];
#ifdef DEBUG
                NSString* color = [colorDic objectForKey:@(level)];
                NSString* bgColor = [bgColorDic objectForKey:@(level)];
                if (bgColor) {
                    NSLog(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_ESCAPE @"bg%@;" @"%@" XCODE_COLORS_RESET,color,bgColor,content);
                }else{
                    NSLog(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET,color,contentN);
                }
                
                if (remoteLogEnable) {
                    NSString* dataStr = [NSString stringWithFormat:@"%@;%@;%@",color,bgColor,content];
                    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                    [udpSocket sendData:data toHost:remoteIp port:remotePort withTimeout:-1 tag:tag];
                    tag++;
                }
#endif
                formatTmp = nil;
            }
        });
    }else{
        NSString* color = [colorDic objectForKey:@(level)];
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

+(void)showTodayLogFile{
    CATLogReviewController* viewCtrl = [[CATLogReviewController alloc]initWithLogFilePath:logFilePath];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow* keyWindow = application.keyWindow;
    if (keyWindow.rootViewController) {
        [keyWindow.rootViewController presentViewController:navigationController animated:YES completion:NULL];
    }
}

+(void)showAllLogFile{
    CATLogFilesViewController* viewCtrl = [[CATLogFilesViewController alloc]initWithLogDir:logDic];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow* keyWindow = application.keyWindow;
    if (keyWindow.rootViewController) {
        [keyWindow.rootViewController presentViewController:navigationController animated:YES completion:NULL];
    }
}

@end