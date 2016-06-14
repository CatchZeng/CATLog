//
//  AppDelegate.m
//  CATLog
//
//  Created by zengcatch on 16/4/20.
//  Copyright © 2016年 zengcatch. All rights reserved.
//

#import "AppDelegate.h"
#import "CATLog.h"

#define YouLogI(fmt, ...) [CATLog logI:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Set ExceptionHandler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //Init log
    [CATLog initWithNumberOfDaysToDelete:3];
    
    //Remote Log
    [CATLog setRemoteLogEnable:YES];
    [CATLog setRemoteIp:@"192.168.1.100" port:1111];
    
    //Set log level
    [CATLog setLogLevel:CATLevelV];
    
    //Set Color
    [CATLog setR:200 G:0 B:0 forLevel:CATLevelE];
    [CATLog setBgR:255 G:255 B:255 forLevel:CATLevelE];
    
    //Redefine log
    YouLogI(@"ReDefine Log by yourself");
    
    //Log normal string
    CLogE(@"Normal string");
    
    NSString* normalStt = [NSString stringWithFormat:@"Normal String"];
    CLogE(normalStt);
    
    //Log format string
    CLogD(@"Format String:string1,%@,%@",@"string2",@"string3");
    
    UIImageView* imgView = [[UIImageView alloc]init];
    CLogD(@"Format String %@",imgView);
    
    //Log Color
    CLogE(@"I am error log. Do you like my color?");
    CLogW(@"I am warning log. Do you like my color?");
    CLogI(@"I am info log. Do you like my color?");
    CLogD(@"I am debug log. Do you like my color?");
    CLogV(@"I am verbose log. Do you like my color?");
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception){
    [CATLog logCrash:exception];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
