# CATLog
[![Pod Version](https://github.com/CatchZeng/CATLog/blob/master/pod.png)](http://cocoadocs.org/docsets/CATLog/)


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
- Auto delete old log file
- Custom log macro easily
- Colorizing debugger console outp 
- Clickable links in your Xcode console, so you never wonder which class logged the message.

## Effect 
![effect](https://github.com/CatchZeng/CATLog/blob/master/color.jpg)

Clickable links in your Xcode console,like this.
![effect](https://github.com/CatchZeng/CATLog/blob/master/jump.gif)

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

##### Init log && Set exceptionHandler

	```objective-c
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    //Set ExceptionHandler
	    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	    
	    //Init log
	    [CATLog initLog];
	}
	
	void uncaughtExceptionHandler(NSException *exception){
    [CATLog logCrash:exception];
    }
	```
	
##### Set log level

	```objective-c
    [CATLog setLogLevel:CATLevelE];
    ```

##### Set number of days to delete log file

	```objective-c
	[CATLog setNumberOfDaysToDelete:3];
    ```
##### If you do not like default log color,you can set color for each level.

	```objective-c
	[CATLog setR:200 G:200 B:200 forLevel:CATLevelE];
    ```
    
##### If you do not like use CLog,you can custom log macro you need.

	```objective-c
	#define YouLogI(fmt, ...) [CATLog logI:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
	
	
	YouLogI(@"ReDefine Log by yourself");
	
    ```    




# CATLog
[![Pod Version](https://github.com/CatchZeng/CATLog/blob/master/pod.png)](http://cocoadocs.org/docsets/CATLog/)

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
- 自动删除旧的日志文件
- 方便地自定义日志宏
- 支持颜色打印日志
- 支持点击日志信息跳转到代码中，方便定位错误信息。

## 效果 
![effect](https://github.com/CatchZeng/CATLog/blob/master/color.jpg)

点击日志信息跳转到代码中的效果如下。
![effect](https://github.com/CatchZeng/CATLog/blob/master/jump.gif)

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

##### 初始化 && 设置异常捕获

	```objective-c
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    //Set ExceptionHandler
	    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	    
	    //Init log
	    [CATLog initLog];
	}
	
	void uncaughtExceptionHandler(NSException *exception){
    [CATLog logCrash:exception];
    }
	```
	
##### 设置日志级别

	```objective-c
    [CATLog setLogLevel:CATLevelE];
    ```

##### 设置删除几天前的日志文件

	```objective-c
	[CATLog setNumberOfDaysToDelete:3];
    ```
##### 如果不喜欢默认的日志输出颜色，可以为每个级别设置自定义的颜色

	```objective-c
	[CATLog setR:200 G:200 B:200 forLevel:CATLevelE];
    ```
    
##### 如果不喜欢用CLog作为日志宏，可以自定义

	```objective-c
	#define YouLogI(fmt, ...) [CATLog logI:[NSString stringWithFormat:@"[%@:%d] %s %@",[NSString stringWithFormat:@"%s",__FILE__].lastPathComponent,__LINE__,__func__,fmt],##__VA_ARGS__,@""];
	
	
	YouLogI(@"ReDefine Log by yourself");
	
    ```    
