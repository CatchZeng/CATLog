//
//  CATLogFilesViewController.m
//  CATLog
//
//  Created by catch on 16/6/14.
//  Copyright © 2016年 zengcatch. All rights reserved.
//

#import "CATLogFilesViewController.h"
#import "CATLogReviewController.h"

@interface CATLogFilesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *logDir;
@property (nonatomic, strong) NSArray *files;

@end

@implementation CATLogFilesViewController

-(instancetype)initWithLogDir:(NSString *)logDir{
    self = [super init];
    if (self) {
        _logDir = logDir;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All Log Files";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(_bakcButtonClicked)];
    
    _files =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_logDir error:nil];
    
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView reloadData];
}

#pragma mark - private methods

-(void)_bakcButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _files.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"CATTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_files objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* logFilePath = [_logDir stringByAppendingString:[_files objectAtIndex:indexPath.row]];
    CATLogReviewController* viewCtrl = [[CATLogReviewController alloc]initWithLogFilePath:logFilePath];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end