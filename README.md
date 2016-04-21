# CATLog
[![Pod Version](https://github.com/CatchZeng/CATLog/blob/1.0.1/pod.png)](http://cocoadocs.org/docsets/CATLog/)

A Open source Log System for Objective-C.

## Requirements
This library requires a deployment target of iOS 6.0 or greater.

## Features

### CATLog is Simple:
It takes as little as a single line of code to configure CATLog when your application launches.Then replace your NSLog statements with CATLog[X] statements and that's about it.

## Adding CATLog to your project

Include CATLog wherever you need it with `#import "CATLog.h"` .

### Source files

Alternatively you can directly add the `CATLog.h`& `CATLog.m`  source files to your project.

OR  USE POD

`pod 'CATLog'`

## Usage

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Set ExceptionHandler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //Init log
    [CATLog initLog];
    
    //Log normal string
    CLogE(@"test normal string");
    
    NSString* normalStt = [NSString stringWithFormat:@"Normal String"];
    CLogE(normalStt);
    
    //Log format string
    CLogD(@"string1,%@,%@",@"string2",@"string3");
    
    UIImageView* imgView = [[UIImageView alloc]init];
    CLogD(@"format string %@",imgView);
    
    return YES;
    }
    void uncaughtExceptionHandler(NSException *exception){
    [CATLog logCrash:exception];
	}
	
