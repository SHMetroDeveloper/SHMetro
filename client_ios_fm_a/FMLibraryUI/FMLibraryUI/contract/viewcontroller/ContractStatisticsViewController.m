//
//  ContractStatisticsViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractStatisticsViewController.h"
#import "FMTheme.h"
#import "FMUtilsPackages.h"
#import "ContractStatusBarChartView.h"
#import "ContractBusiness.h"

@interface ContractStatisticsViewController ()

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) ContractStatusBarChartView * statusBarChartView;

@property (readwrite, nonatomic, assign) CGFloat statusBarChartItemHeight;

@property (readwrite, nonatomic, strong) ContractStatisticsEntity * entity;

@property (readwrite, nonatomic, strong) ContractBusiness * business;

@end

@implementation ContractStatisticsViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_contract_statistics" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [ContractBusiness getInstance];
        _statusBarChartItemHeight = 200;
    
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        
        CGFloat originY = 0;
        CGFloat padding = 0;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        originY = 10;
        _statusBarChartView = [[ContractStatusBarChartView alloc] initWithFrame:CGRectMake(padding, originY, realWidth-padding * 2, _statusBarChartItemHeight)];
        originY += _statusBarChartItemHeight;
        
        [_mainContainerView addSubview:_statusBarChartView];
        
        _mainContainerView.contentSize = CGSizeMake(realWidth, originY);
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updateChartInfo {
    if(_entity) {
        [_statusBarChartView setContracts:_entity.amount];
    }
}

#pragma mark - 网络请求
- (void) requestData {
    [self showLoadingDialog];
    [_business getContractStatisticsSuccess:^(NSInteger key, id object) {
        _entity = object;
        [self updateChartInfo];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"contract_statistics_request_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self updateChartInfo];
    }];
}

@end
