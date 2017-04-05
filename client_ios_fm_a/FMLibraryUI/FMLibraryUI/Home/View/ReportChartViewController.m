//
//  ReportChartViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ReportChartViewController.h"
#import "ProgressChartView.h"
#import "SingleLineChartView.h"
#import "TotalCountView.h"
#import "SingleBarChartView.h"

#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"

@interface ReportChartViewController ()

@property (readwrite, nonatomic, strong) UIScrollView * mainContainView;
@property (readwrite, nonatomic, strong) ProgressChartView * todayWorkOverView;      //三个饼状图(今日工单概况)
@property (readwrite, nonatomic, strong) SingleLineChartView * recentlyDaysOverView; //线图（近七日工单完成情况）
@property (readwrite, nonatomic, strong) TotalCountView * totallyOrderView;          //数字显示(数字显示总数和未完成数)；
@property (readwrite, nonatomic, strong) SingleBarChartView * monthlyWorkOverView;   //柱状图（每月工单数）

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@end

@implementation ReportChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_chart" inTable:nil]];
    [self setBackAble:YES];
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    
    //主容器
    _mainContainView = [[UIScrollView alloc] initWithFrame:frame];
    _mainContainView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    //三个饼状图(今日工单概况)
    CGFloat todayOverViewHeight = [ProgressChartView calculateHeightByWidht:_realWidth];
    _todayWorkOverView = [[ProgressChartView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, todayOverViewHeight)];
    originY += todayOverViewHeight;
    
    
    //线图（近七日工单完成情况）
    CGFloat recentlyOverViewHeight = [SingleLineChartView calculateHeightByWidth:_realWidth];
    _recentlyDaysOverView = [[SingleLineChartView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, recentlyOverViewHeight)];
    _recentlyDaysOverView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    originY += recentlyOverViewHeight;
    
    
    //数字显示(数字显示总数和未完成数)；
    CGFloat totallyOverViewHeight = [TotalCountView calculateHeightByWidth:_realWidth];
    _totallyOrderView = [[TotalCountView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, totallyOverViewHeight)];
    _totallyOrderView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    originY += totallyOverViewHeight;
    
    
    //柱状图（每月工单数）
    CGFloat monthlyWorkOverViewHeight = [SingleBarChartView calculateHeightByWidth:_realWidth];
    _monthlyWorkOverView = [[SingleBarChartView alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, monthlyWorkOverViewHeight)];
    _monthlyWorkOverView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    originY += monthlyWorkOverViewHeight;
    
    
    _mainContainView.contentSize = CGSizeMake(_realWidth, originY);
    
    [_mainContainView addSubview:_todayWorkOverView];
    [_mainContainView addSubview:_recentlyDaysOverView];
    [_mainContainView addSubview:_totallyOrderView];
    [_mainContainView addSubview:_monthlyWorkOverView];
    
    [self.view addSubview:_mainContainView];
}

- (void) updateInfo {
    
    NSMutableArray * tmpArray = [[NSMutableArray alloc] initWithObjects:
                                 [NSNumber numberWithInteger:5],
                                 [NSNumber numberWithInteger:6],
                                 [NSNumber numberWithInteger:7],nil];
    
    NSMutableArray * tmpArray2 = [[NSMutableArray alloc] initWithObjects:
                                 [NSNumber numberWithInteger:5],
                                 [NSNumber numberWithInteger:8],
                                 [NSNumber numberWithInteger:10],nil];
    
    NSMutableArray * yValueArrays = [[NSMutableArray alloc] init];  //barchart演示数据
    [yValueArrays addObject:[NSNumber numberWithInteger:1]];
    [yValueArrays addObject:[NSNumber numberWithInteger:1]];
    [yValueArrays addObject:[NSNumber numberWithInteger:0]];
    [yValueArrays addObject:[NSNumber numberWithInteger:2]];
    [yValueArrays addObject:[NSNumber numberWithInteger:3]];
    [yValueArrays addObject:[NSNumber numberWithInteger:0]];
    [yValueArrays addObject:[NSNumber numberWithInteger:0]];
    [yValueArrays addObject:[NSNumber numberWithInteger:0]];
    [yValueArrays addObject:[NSNumber numberWithInteger:0]];
    
    NSMutableArray * allArray = [[NSMutableArray alloc] init];
    NSMutableArray * finishArray = [[NSMutableArray alloc] init];
    
    [allArray addObject:[NSNumber numberWithInteger:2]];
    [allArray addObject:[NSNumber numberWithInteger:4]];
    [allArray addObject:[NSNumber numberWithInteger:6]];
    [allArray addObject:[NSNumber numberWithInteger:8]];
    [allArray addObject:[NSNumber numberWithInteger:10]];
    [allArray addObject:[NSNumber numberWithInteger:8]];
    [allArray addObject:[NSNumber numberWithInteger:6]];
    
    [finishArray addObject:[NSNumber numberWithInteger:1]];
    [finishArray addObject:[NSNumber numberWithInteger:3]];
    [finishArray addObject:[NSNumber numberWithInteger:5]];
    [finishArray addObject:[NSNumber numberWithInteger:7]];
    [finishArray addObject:[NSNumber numberWithInteger:9]];
    [finishArray addObject:[NSNumber numberWithInteger:7]];
    [finishArray addObject:[NSNumber numberWithInteger:5]];
    
    
    //今日工单概况
    [_todayWorkOverView setInfoWidthFinishenArray:tmpArray andAllArray:tmpArray2];
    
    //近七日工单
    [_recentlyDaysOverView setChartDataWithAllInfo:allArray andFinishedInfo:finishArray];
    
    //工单总数（完成未完成）
    [_totallyOrderView setInfoWithFinished:212 andAll:220];
    
    //每月工单
    [_monthlyWorkOverView setMonthlyWorkOrderCountInfoWith:yValueArrays];
    
//    _todayWorkOverView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
//    _recentlyDaysOverView.backgroundColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//    _totallyOrderView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//    _monthlyWorkOverView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
}


@end





