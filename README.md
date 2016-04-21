# CATLog
![effect](https://github.com/CatchZeng/CATLog/blob/master/pod.png)

An open source log system for Objective-C based on [Xcodecolors](https://github.com/robbiehanson/XcodeColors) and [KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole).

## Requirements
This library requires a deployment target of iOS 6.0 or greater.

## Features

### CATLog is Simple:

It takes as little as a single line of code to configure CATLog when your application launches.Then replace your NSLog statements with CATLog[X] statements and that's about it.

### CATLog is Powerful:
- Log level
- Log file
- Log crash
- Colorizing debugger console outp 
- Clickable links in your Xcode console, so you never wonder which class logged the message.

## Effect 
![effect](https://github.com/CatchZeng/CATLog/blob/master/color.jpg)

Clickable links in your Xcode console,like this.
![](https://github.com/krzysztofzablocki/KZLinkedConsole/raw/master/logs.gif?raw=true)

## Adding CATLog to your project

### Pod

`pod 'CATLog'`

### Source files

Alternatively you can directly add the `CATLog.h`& `CATLog.m`  source files to your project.

## Usage

#### 1.Install [Xcodecolors](https://github.com/robbiehanson/XcodeColors) by [Alcatraz](https://github.com/alcatraz/Alcatraz)

![Xcodecolors](https://github.com/CatchZeng/CATLog/blob/master/xcodecolors.jpg)

#### 2.Install [KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole) by [Alcatraz](https://github.com/alcatraz/Alcatraz)

![KZLinkedConsole](https://github.com/CatchZeng/CATLog/blob/master/kzlinkedconsole.jpg)

#### 3.Code

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
	
