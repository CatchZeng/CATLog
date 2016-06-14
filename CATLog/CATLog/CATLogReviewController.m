//
//  CATLogReviewController.m
//  CATLog
//
//  Created by catch on 16/6/14.
//  Copyright © 2016年 zengcatch. All rights reserved.
//

#import "CATLogReviewController.h"
#import <MessageUI/MessageUI.h>

@interface CATLogReviewController ()<MFMailComposeViewControllerDelegate, UIWebViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *filePath;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CATLogReviewController

-(instancetype)initWithLogFilePath:(NSString *)filePath{
    self = [super init];
    if (self) {
        _filePath = filePath;
        self.title = [_filePath lastPathComponent];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_filePath]]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(_emailButtonCliked)];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.isBeingPresented) {//pop
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(_bakcButtonClicked)];
    }
}

#pragma mark - private methods

-(void)_bakcButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_emailButtonCliked{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *processName = [NSProcessInfo processInfo].processName;
        [mailController setSubject:[NSString stringWithFormat:@"%@ Log Report <AppVersion %@ AppBuild %@>", processName, appVersion, appBuild]];
        [mailController setMailComposeDelegate:self];
        
        NSData *logData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_filePath]];
        [mailController addAttachmentData:logData mimeType:@"com.apple.log" fileName:_filePath.lastPathComponent];
        
        [self presentViewController:mailController animated:YES completion:NULL];
    } else {
        NSLog(@"You should set your email account in settngs first!");
    }
}

#pragma mark - delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGSize webviewContentSize = webView.scrollView.contentSize;
    [webView.scrollView scrollRectToVisible:CGRectMake(0, webviewContentSize.height - webView.bounds.size.height, webView.bounds.size.width, webView.bounds.size.height) animated:NO];
}

@end