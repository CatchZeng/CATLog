//
//  CATLogReviewController.h
//  CATLog
//
//  Created by catch on 16/6/14.
//  Copyright © 2016年 zengcatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATLogReviewController : UIViewController

/**
 *  init
 *
 *  @param filePath :log file path
 *
 *  @return CATLogReviewController
 */
-(instancetype)initWithLogFilePath:(NSString *)filePath;

@end
