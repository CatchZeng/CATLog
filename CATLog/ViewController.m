//
//  ViewController.m
//  CATLog
//
//  Created by zengcatch on 16/4/20.
//  Copyright © 2016年 zengcatch. All rights reserved.
//

#import "ViewController.h"
#import "CATLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(showFile) withObject:nil afterDelay:2.0f];
}

-(void)showFile{
    [CATLog shwoAllLogFile];
    //    [CATLog showTodayLogFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
