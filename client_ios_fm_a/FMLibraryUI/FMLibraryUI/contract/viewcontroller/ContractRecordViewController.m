//
//  ContractRecordViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractRecordViewController.h"
#import "FMUtilsPackages.h"
#import "ContractDetailEntity.h"
#import "ContractRecordTableViewCell.h"
#import "AttachmentViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface ContractRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *recordArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation ContractRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_record_detail_title" inTable:nil]];
    [self setBackAble:YES];
}

- (void)initLayout {
    CGRect mFrame = [self getContentFrame];
    _realWidth = CGRectGetWidth(mFrame);
    _realHeight = CGRectGetHeight(mFrame);
    
    if (!_recordArray) {
        _recordArray = [NSMutableArray new];
    }
    
    _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    [_mainContainerView addSubview:self.tableView];
    
    [self.view addSubview:_mainContainerView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_tableView registerClass:[ContractRecordTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

- (void)setRecordDataArray:(NSMutableArray *)dataArray {
    if (!_recordArray) {
        _recordArray = [NSMutableArray new];
    }
    [_recordArray addObjectsFromArray:dataArray];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _recordArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    ContractOperationRecord *record = _recordArray[position];
    height = [ContractRecordTableViewCell calculateHeightByDesc:record.operation andAttachmentCount:record.attachment.count];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ContractRecordTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    ContractOperationRecord *record = _recordArray[position];
    __weak typeof(self) weakSelf = self;
    cell.actionBlock = ^(id object){
        ContractAttachment *attachment = (ContractAttachment *)object;
        [weakSelf gotoAttachment:attachment];
    };
    if (position == _recordArray.count-1) {
        [cell setSeperatorGapped:NO];
    } else {
        [cell setSeperatorGapped:YES];
    }
    [cell setPortraitWithImageId:record.photoId];
    [cell setInfoWithName:record.handler
                     desc:record.operation
                     time:record.time
                   status:record.type
               attachment:record.attachment];
}

#pragma mark - pushEvent
- (void)gotoAttachment:(ContractAttachment *)attachment {
    NSURL *attachmentURL = [FMUtils getUrlOfAttachmentById:attachment.fileId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentURL];
    [attachmentVC setTitleByFileName:attachment.fileName];
    [self gotoViewController:attachmentVC];
}

@end
