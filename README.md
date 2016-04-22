# CATLog
![pod](https://github.com/CatchZeng/CATLog/blob/master/pod.png)

An open source log system for Objective-C based on [Xcodecolors](https://github.com/robbiehanson/XcodeColors) and [KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole).

中文请下翻

## Requirements
This library requires a deployment target of iOS 6.0 or greater.

## Features

### CATLog is Simple:

It takes as little as a single line of code to configure CATLog when your application launches.Then replace your NSLog statements with CLog[X] statements and that's about it.

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
	

# CATLog
![effect](https://github.com/CatchZeng/CATLog/blob/master/pod.png)

一个基于[Xcodecolors](https://github.com/robbiehanson/XcodeColors)和[KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole)的oc开源日志工具

## Requirements
iOS6或以上

## 特性

### CATLog 使用简单:
只需加入几行代码就可配置完毕。然后将NSLog换成CLog[X] 就可以了。

### CATLog 功能强大:
- 支持设置日志级别
- 支持日志输出到文件
- 支持日志记录Crash信息
- 支持颜色打印日志
- 支持点击日志信息跳转到代码中，方便定位错误信息。

## 效果 
![effect](https://github.com/CatchZeng/CATLog/blob/master/color.jpg)

点击日志信息跳转到代码中的效果如下。
![](https://github.com/krzysztofzablocki/KZLinkedConsole/raw/master/logs.gif?raw=true)

## 将CATLog加入工程

### 使用Pod

`pod 'CATLog'`

### 使用源码

直接拖拽 `CATLog.h`& `CATLog.m` 到工程中即可。

## 使用说明

#### 1.先通过[Alcatraz](https://github.com/alcatraz/Alcatraz)安装[Xcodecolors](https://github.com/robbiehanson/XcodeColors) 
![Xcodecolors](https://github.com/CatchZeng/CATLog/blob/master/xcodecolors.jpg)

#### 2.再安装 [KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole)
![KZLinkedConsole](https://github.com/CatchZeng/CATLog/blob/master/kzlinkedconsole.jpg)

#### 3.编码

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
	
