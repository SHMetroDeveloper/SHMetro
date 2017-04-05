//
//  PieChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//

#import "PieChartViewController.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMColor.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "BasePieChartView.h"
#import "QrCodeViewController.h"
#import "NewReportViewController.h"
#import "BaseCountView.h"
#import "SingleCountView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "SinglePieChartView.h"
#import "BaseLineChartView.h"
#import "FMUtils.h"
#import "MarkedListHeaderView.h"
#import "ChartEventView.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "WorkOrderDetailViewController.h"
#import "PatrolDBHelper.h"
#import "PatrolSpotViewController.h"
#import "ProgressCountView.h"
#import "BaseBarChartView.h"
#import "MaintenanceDetailViewController.h"
#import "EquipmentDetailViewController.h"


@interface PieChartViewController () <ChartViewDelegate>

@property (readwrite, nonatomic, strong) UIView * todayCountView;     //
@property (readwrite, nonatomic, strong) UILabel * todayCountTitleLbl;     //今日概况
@property (readwrite, nonatomic, strong) ProgressCountView * todayOrderCountView;   //今日工单
@property (readwrite, nonatomic, strong) ProgressCountView * todaycomplaintCountView;  //今日投诉
@property (readwrite, nonatomic, strong) ProgressCountView * todayPatrolCountView;  //今日巡检

@property (readwrite, nonatomic, strong) SeperatorView * todayCountBottomSeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orderTodaySeperatorView;
@property (readwrite, nonatomic, strong) SeperatorView * orderCurrentlySeperatorView;

@property (readwrite, nonatomic, strong) SinglePieChartView * orderTodayChartView;

@property (readwrite, nonatomic, strong) BaseLineChartView * orderCurrentlyChartView;

@property (readwrite, nonatomic, strong) BaseBarChartView * requirementAnalysisView;    //需求分析

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) NSArray * months;
@property (readwrite, nonatomic, strong) NSArray * parties;


@property (readwrite, nonatomic, assign) CGFloat todayCountHeight;  //今日统计高度
@property (readwrite, nonatomic, assign) CGFloat complaintCountHeight;  //投诉高度

@property (readwrite, nonatomic, assign) CGFloat pieChartHeight;    //饼状图高度
@property (readwrite, nonatomic, assign) CGFloat chartSepHeight;    //图表之间的间隔高度

@property (readwrite, nonatomic, assign) CGFloat realWidth;    //实际宽度
@property (readwrite, nonatomic, assign) CGFloat realHeight;    //实际高度

@property (readwrite, nonatomic, strong) NSString* qrcodeResult;    //二维码扫描结果
@property (readwrite, nonatomic, assign) BOOL isBackFromQrCode;     //是否从二维码扫描结果返回

@property (readwrite, nonatomic, strong) HomeChartEntity * chartData;
@end

@implementation PieChartViewController

- (instancetype) init {
    self = [super init];
    return self;
}


- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_chart" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(_isBackFromQrCode) {
        _isBackFromQrCode = NO;
        [self gotoHandleSpot];
    } else {
        [self requestChartData];
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        _todayCountHeight = 160;
        _complaintCountHeight = 80;
        
        _pieChartHeight = 240;
        _chartSepHeight = 0;
        
        
        _mainContainerView = [[UIScrollView alloc] init];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _todayCountView = [[UIView alloc] init];
        _todayCountView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _todayCountTitleLbl = [[UILabel alloc] init];
        [_todayCountTitleLbl setText:[[BaseBundle getInstance] getStringByKey:@"chart_order_today" inTable:nil]];
        
        _todayCountTitleLbl.textColor = [FMColor getInstance].chartTitleColor;
        [_todayCountTitleLbl setFont:[FMFont getInstance].defaultFontLevel2];
        [_todayCountView addSubview:_todayCountTitleLbl];
        
        _todayOrderCountView = [[ProgressCountView alloc] init];
        _todayPatrolCountView = [[ProgressCountView alloc] init];
        _todaycomplaintCountView = [[ProgressCountView alloc] init];
        
        [_todayOrderCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_order" inTable:nil] andDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        
        [_todaycomplaintCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_complain" inTable:nil] andDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        [_todayPatrolCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_inspection" inTable:nil] andDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        [_todayOrderCountView setProgressColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        [_todaycomplaintCountView setProgressColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_todayPatrolCountView setProgressColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        [_mainContainerView addSubview:_todayCountView];
        [_mainContainerView addSubview:_todayOrderCountView];
        [_mainContainerView addSubview:_todaycomplaintCountView];
        [_mainContainerView addSubview:_todayPatrolCountView];
        
        _todayCountBottomSeperatorView = [[SeperatorView alloc] init];
        [_mainContainerView addSubview:_todayCountBottomSeperatorView];
        
        
        _orderTodayChartView = [[SinglePieChartView alloc] init];
        [_mainContainerView addSubview:_orderTodayChartView];
        
        
        _orderTodaySeperatorView = [[SeperatorView alloc] init];
        [_mainContainerView addSubview:_orderTodaySeperatorView];
        
        
        _orderCurrentlyChartView = [[BaseLineChartView alloc] init];
        _orderCurrentlyChartView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_orderCurrentlyChartView setShowColorDesc:YES];
        [_mainContainerView addSubview:_orderCurrentlyChartView];
        
        _orderCurrentlySeperatorView = [[SeperatorView alloc] init];
        [_mainContainerView addSubview:_orderCurrentlySeperatorView];
        
        _requirementAnalysisView = [[BaseBarChartView alloc] init];
        _requirementAnalysisView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_requirementAnalysisView setColorType:BASE_BAR_CHART_COLOR_EACH_ONE_DIFFERENT];
        [_requirementAnalysisView setShowColorDesc:NO];
        [_mainContainerView addSubview:_requirementAnalysisView];
        
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void) updateLayout {
    CGFloat originY = 0;
    CGFloat originX = 0;
    CGFloat seperatorSize = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGRect frame  = [self getContentFrame];
    
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    if(_realWidth <= 0 || _realHeight <= 0) {
        return;
    }
    frame.size.height = _realHeight;
    [_mainContainerView setFrame:frame];
    
    itemHeight = 30;
    [_todayCountView setFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
    [_todayCountTitleLbl setFrame:CGRectMake(padding, 0, _realWidth-padding*2, itemHeight)];
    originY += itemHeight;
    
    CGFloat countWidth = _realWidth/3;
    
    [_todayOrderCountView setFrame:CGRectMake(originX, originY, countWidth, _todayCountHeight)];
    originX += countWidth;
    [_todaycomplaintCountView setFrame:CGRectMake(originX, originY, countWidth, _todayCountHeight)];
    originX += countWidth;
    [_todayPatrolCountView setFrame:CGRectMake(originX, originY, countWidth, _todayCountHeight)];
    originY += _todayCountHeight;
    
    _todayOrderCountView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    _todaycomplaintCountView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    _todayPatrolCountView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_VOILET];
    
    
    [_todayCountBottomSeperatorView setFrame:CGRectMake(0, originY, _realWidth, seperatorSize)];
    originY += seperatorSize + _chartSepHeight;
    
    [_orderCurrentlyChartView setFrame:CGRectMake(0, originY, _realWidth, _pieChartHeight)];
    originY += _pieChartHeight;
    
    [_orderCurrentlySeperatorView setFrame:CGRectMake(0, originY, _realWidth, seperatorSize)];
    originY += seperatorSize + _chartSepHeight;
    
    [_orderTodayChartView setFrame:CGRectMake(0, originY, _realWidth, _pieChartHeight)];
//    [_currentLineChartView setFrame:CGRectMake(0, originY, _realWidth, _pieChartHeight)];    
    originY += _pieChartHeight;
    
    [_orderTodaySeperatorView setFrame:CGRectMake(0, originY, _realWidth, seperatorSize)];
    originY += seperatorSize + _chartSepHeight;
    
    [_requirementAnalysisView setFrame:CGRectMake(0, originY, _realWidth, _pieChartHeight)];
    originY += _pieChartHeight + _chartSepHeight;

    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
    
    [self updateCharts];
}

//获取要放在首页展示的 紧急事件
- (EmergencyOrderEntity *) getEmergencyForShow {
    EmergencyOrderEntity * res;
    if(_chartData && _chartData.emergency && [_chartData.emergency count] > 0) {
        res = _chartData.emergency[0];
    }
    return res;
}

//获取要放在首页展示的提醒事件
- (NoticeEntity *) getNoticeForShow {
    NoticeEntity * res;
    if(_chartData && _chartData.notice && [_chartData.notice count] > 0) {
        res = _chartData.notice[0];
    }
    return res;
}

- (void) initTodayCount {
    if(_chartData) {
        for(TodayCountEntity * todayCount in _chartData.countOfToday) {
            switch(todayCount.type) {
                case TODAY_COUNT_TYPE_ORDER:
                    [_todayOrderCountView setInfoWithCountFinished:todayCount.count2-todayCount.count1 all:todayCount.count2];
                    break;
                case TODAY_COUNT_TYPE_COMPLAINT:
                    [_todaycomplaintCountView setInfoWithCountFinished:todayCount.count2-todayCount.count1 all:todayCount.count2];
                    break;
                case TODAY_COUNT_TYPE_PATROL:
                    [_todayPatrolCountView setInfoWithCountFinished:todayCount.count1 all:todayCount.count2];
                    break;
            }
        }
    } else {
//        [_todayOrderCountView setInfoWithName:@"今日工单" count1:0 count2:0];
//        [_complaintUnfinishedCountView setInfoWithName:@"未处理投诉" count:0];
//        [_complaintCountView setInfoWithName:@"投诉总数" count:0];
//        [_todayPatrolCountView setInfoWithName:@"今日巡检" count1:0 count2:0];
    }
}

- (void) initOrderToday {
    NSMutableArray * nameArray = [[NSMutableArray alloc] init];
    NSMutableArray * valueArray = [[NSMutableArray alloc] init];
    NSString * otherType;
    if(_chartData && _chartData.workOrderToday && [_chartData.workOrderToday count] > 0) {
        
        for(WorkOrderItemTodayEntity * item in _chartData.workOrderToday) {
            if(item.amount && item.amount > 0) {
                [nameArray addObject:item.orderType];
                [valueArray addObject:[NSNumber numberWithInteger:item.amount]];
            } else {
                otherType = [[BaseBundle getInstance] getStringByKey:@"chart_type_other" inTable:nil];
                
            }
        }
        if(otherType && [nameArray count] > 0) {
            [nameArray addObject:otherType];
            [valueArray addObject:[NSNumber numberWithInteger:0]];
        }
    }
    if(!nameArray || [nameArray count] < 2) {
        [nameArray addObject:[[BaseBundle getInstance] getStringByKey:@"chart_type_report" inTable:nil]];
        [nameArray addObject:[[BaseBundle getInstance] getStringByKey:@"chart_type_complain" inTable:nil]];
        [valueArray addObject:[NSNumber numberWithInteger:1]];
        [valueArray addObject:[NSNumber numberWithInteger:0]];
    }
    [_orderTodayChartView setInfoWithTitle:[[BaseBundle getInstance] getStringByKey:@"chart_order_today_title" inTable:nil] andKeys:nameArray andValues:valueArray];
}

- (void) initOrderCurrently {
    NSMutableArray* dateArray = [[NSMutableArray alloc] init];
    NSMutableArray * valueArray1 = [[NSMutableArray alloc] init];
    NSMutableArray * valueArray2 = [[NSMutableArray alloc] init];
    NSInteger count = 7;
    NSInteger index;
    if(_chartData) {
        count = [_chartData.workOrderCurrently count];
        for(index=0;index<count;index++) {
            WorkOrderCurrentlyEntity * item = _chartData.workOrderCurrently[count-1-index];
//            NSDate * date = [FMUtils timeLongToDate:item.date];
            [dateArray addObject:[FMUtils getDateTimeDescriptionBy:item.date format:@"MM/dd"]];
            [valueArray1 addObject:[NSNumber numberWithInteger:item.finishedAmount]];
            [valueArray2 addObject:[NSNumber numberWithInteger:item.newAmount]];
        }
    } else {
        count = 7;
        NSNumber * today = [FMUtils getTimeLongNow];
        NSInteger secondsOfOneDay = 60 * 60 * 24 * 1000;
        for(index = 0; index < count;index++) {
            NSNumber * tmp = [NSNumber numberWithLongLong:(today.longLongValue - (count - 1 - index) * secondsOfOneDay)];
            NSDate * date = [FMUtils timeLongToDate:tmp];
//            NSString * strDate = [FMUtils getDayStr:date];
            NSString * strDate = [FMUtils getDateStrMMDD:date];
            [dateArray addObject:strDate];
            [valueArray1 addObject:[NSNumber numberWithInteger:0]];
            [valueArray2 addObject:[NSNumber numberWithInteger:0]];
        }
    }
    //
    [_orderCurrentlyChartView clear];
    [_orderCurrentlyChartView setInfoWithTitle:[[BaseBundle getInstance] getStringByKey:@"chart_order_currently_title" inTable:nil] andKeys:dateArray];
    [_orderCurrentlyChartView addDataArray:valueArray1 desc:[[BaseBundle getInstance] getStringByKey:@"chart_order_finished_amount" inTable:nil]];
    [_orderCurrentlyChartView addDataArray:valueArray2 desc:[[BaseBundle getInstance] getStringByKey:@"chart_order_total_amount" inTable:nil]];
}

- (void) initRequirement {
    NSString *title = [[BaseBundle getInstance] getStringByKey:@"chart_requirement" inTable:nil];
    NSMutableArray *xArray = [[NSMutableArray alloc] initWithObjects:@"投诉", @"报障",@"咨询",@"保洁",@"维修", nil];
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:20], [NSNumber numberWithInteger:10],
                               [NSNumber numberWithInteger:22],[NSNumber numberWithInteger:26],[NSNumber numberWithInteger:18], nil];
    [_requirementAnalysisView clearAllData];
    [_requirementAnalysisView setInfoWithTitle:title andXvalues:xArray];
    [_requirementAnalysisView addDataArray:values withDesc:@""];
}


- (void) updateCharts {
    [self initTodayCount];
    [self initOrderToday];
    [self initOrderCurrently];
    [self initRequirement];
}

- (void) requestChartData {
    [self showLoadingDialog];
    BaseDataGetChartDataParam * param = [[BaseDataGetChartDataParam alloc] init];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [netRequest request:param token:token deviceId:devId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }
        if(data) {
            if(!_chartData) {
                _chartData = [[HomeChartEntity alloc] init];
            } else {
                [_chartData clear];
            }
            NSNumber * tmpNumber;
            NSMutableDictionary * tmpDict;
            NSMutableArray * tmpArray = [data valueForKeyPath:@"countOfToday"];
            if([tmpArray isKindOfClass:[NSNull class]]) {
                tmpArray = nil;
            }
            for(NSDictionary * tmpDict in tmpArray) {
                TodayCountEntity * tcount = [[TodayCountEntity alloc] init];
                tmpNumber = [tmpDict valueForKeyPath:@"type"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                tcount.type = [tmpNumber integerValue];
                
                tmpNumber = [tmpDict valueForKeyPath:@"count1"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                tcount.count1 = [tmpNumber integerValue];
                
                tmpNumber = [tmpDict valueForKeyPath:@"count2"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                tcount.count2 = [tmpNumber integerValue];
                [_chartData.countOfToday addObject:tcount];
            }
            
            tmpArray = [data valueForKeyPath:@"workOrderCurrently"];
            if([tmpArray isKindOfClass:[NSNull class]]) {
                tmpArray = nil;
            }
            for(NSDictionary * tmpDict in tmpArray) {
                WorkOrderCurrentlyEntity * orderCurrently = [[WorkOrderCurrentlyEntity alloc] init];
                tmpNumber = [tmpDict valueForKeyPath:@"date"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                orderCurrently.date = tmpNumber;
                
                tmpNumber = [tmpDict valueForKeyPath:@"newAmount"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                orderCurrently.newAmount = [tmpNumber integerValue];
                
                tmpNumber = [tmpDict valueForKeyPath:@"count2"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                orderCurrently.finishedAmount = [tmpNumber integerValue];
                
                [_chartData.workOrderCurrently addObject:orderCurrently];
            }
            
            
            tmpArray = [data valueForKeyPath:@"workOrderToday"];
            if([tmpArray isKindOfClass:[NSNull class]]) {
                tmpArray = nil;
            }
            for(NSDictionary * tmpDict in tmpArray) {
                WorkOrderItemTodayEntity * orderItem = [[WorkOrderItemTodayEntity alloc] init];
                orderItem.orderType = [tmpDict valueForKeyPath:@"orderType"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                
                tmpNumber = [tmpDict valueForKeyPath:@"amount"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                orderItem.amount = [tmpNumber integerValue];
                
                [_chartData.workOrderToday addObject:orderItem];
            }
            
            
            tmpArray = [data valueForKeyPath:@"emergency"];
            if([tmpArray isKindOfClass:[NSNull class]]) {
                tmpArray = nil;
            }
            for(NSDictionary * tmpDict in tmpArray) {
                EmergencyOrderEntity * emergencyItem = [[EmergencyOrderEntity alloc] init];
                emergencyItem.woId = [tmpDict valueForKeyPath:@"woId"];
                if([emergencyItem.woId isKindOfClass:[NSNull class]]) {
                    emergencyItem.woId = nil;
                }
                
                tmpNumber = [tmpDict valueForKeyPath:@"status"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                emergencyItem.status = [tmpNumber integerValue];
                
                emergencyItem.content = [tmpDict valueForKeyPath:@"content"];
                if([emergencyItem.content isKindOfClass:[NSNull class]]) {
                    emergencyItem.content = nil;
                }
                
                emergencyItem.time = [tmpDict valueForKeyPath:@"time"];
                if([emergencyItem.time isKindOfClass:[NSNull class]]) {
                    emergencyItem.time = nil;
                }
                
                [_chartData.emergency addObject:emergencyItem];
            }
            
            
            tmpArray = [data valueForKeyPath:@"notice"];
            if([tmpArray isKindOfClass:[NSNull class]]) {
                tmpArray = nil;
            }
            for(NSDictionary * tmpDict in tmpArray) {
                NoticeEntity * noticeItem = [[NoticeEntity alloc] init];
                noticeItem.noticeId = [tmpDict valueForKeyPath:@"id"];
                if([noticeItem.noticeId isKindOfClass:[NSNull class]]) {
                    noticeItem.noticeId = nil;
                }
                
                tmpNumber = [tmpDict valueForKeyPath:@"type"];
                if([tmpNumber isKindOfClass:[NSNull class]]) {
                    tmpNumber = nil;
                }
                noticeItem.type = [tmpNumber integerValue];
                
                noticeItem.time = [tmpDict valueForKeyPath:@"time"];
                if([noticeItem.time isKindOfClass:[NSNull class]]) {
                    noticeItem.time = nil;
                }
                
                noticeItem.title = [tmpDict valueForKeyPath:@"title"];
                if([noticeItem.title isKindOfClass:[NSNull class]]) {
                    noticeItem.title = nil;
                }
                
                noticeItem.content = [tmpDict valueForKeyPath:@"content"];
                if([noticeItem.content isKindOfClass:[NSNull class]]) {
                    noticeItem.content = nil;
                }
                
                [_chartData.notice addObject:noticeItem];
            }
        }
        [self hideLoadingDialog];
        [self updateLayout];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
        [self updateLayout];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onMenuItemClicked:(NSInteger)position {
    switch(position) {
        case 0:
            [self goToQrCode];
            break;
        case 1:
            [self goToReport];
            break;
    }
}



- (void) handleNotification {
    PatrolTaskUnFinishedViewController * patrolVC;  //巡检
    
    WorkOrderDetailViewController * orderVC;        //工单
    WorkOrderDetailViewController * orderHistoryVC;  //历史工单详情
    NSNumber * orderId;
    WorkOrderStatus orderStatus;
    
    EquipmentDetailViewController * assetVC;  //设备
    NSNumber * assetId;
    
    MaintenanceDetailViewController * maintenanceVC;         //计划性维护
    NSNumber * maintenanceId;
    
    id tmp = [self.baseVcParam valueForKeyPath:@"type"];
    //    NSString * strTmp = [[NSString alloc] initWithFormat:@"---type:%@", self.baseVcParam];
    //    [self showAutoDismissMessageWith:@"消息" andMessage:strTmp time:DIALOG_ALIVE_TIME_LONG];
    NSNumber * tmpNumber;
    if([tmp isKindOfClass:[NSString class]]) {
        tmpNumber = [FMUtils stringToNumber:tmp];
    } else if([tmp isKindOfClass:[NSNumber class]]) {
        tmpNumber = tmp;
    }
    NotificationItemType notificationType = [tmpNumber integerValue];
    
    
    switch(notificationType) {
        case NOTIFICATION_ITEM_TYPE_PATROL:
            patrolVC = [[PatrolTaskUnFinishedViewController alloc] init];
            [self gotoViewController:patrolVC];
            break;
            
        case NOTIFICATION_ITEM_TYPE_ORDER:
            tmp = [self.baseVcParam valueForKeyPath:@"woId"];
            if([tmp isKindOfClass:[NSString class]]) {
                tmpNumber = [FMUtils stringToNumber:tmp];
            } else if([tmp isKindOfClass:[NSNumber class]]) {
                tmpNumber = tmp;
            }
            orderId = [tmpNumber copy];
            
            tmp = [self.baseVcParam valueForKeyPath:@"woStatus"];
            if([tmp isKindOfClass:[NSString class]]) {
                tmpNumber = [FMUtils stringToNumber:tmp];
            } else if([tmp isKindOfClass:[NSNumber class]]) {
                tmpNumber = tmp;
            }
            orderStatus = tmpNumber.integerValue;
            switch(orderStatus) {
                case ORDER_STATUS_TERMINATE:
                case ORDER_STATUS_FINISH:
                case ORDER_STATUS_CLOSE:
                case ORDER_STATUS_VALIDATATION:
                    orderHistoryVC = [[WorkOrderDetailViewController alloc] init];
                    [orderHistoryVC setWorkOrderWithId:orderId];
                    [orderHistoryVC setReadOnly:YES];
                    [self gotoViewController:orderHistoryVC];
                    break;
                    
                default:
                    
                    orderVC = [[WorkOrderDetailViewController alloc] init];
                    [orderVC setWorkOrderWithId:orderId];
                    [self gotoViewController:orderVC];
                    break;
            }
            break;
            //        case NOTIFICATION_ITEM_TYPE_ORDER_HISTORY:
            //            tmp = [self.baseVcParam valueForKeyPath:@"woId"];
            //            if([tmp isKindOfClass:[NSString class]]) {
            //                tmpNumber = [FMUtils stringToNumber:tmp];
            //            } else if([tmp isKindOfClass:[NSNumber class]]) {
            //                tmpNumber = tmp;
            //            }
            //            orderId = [tmpNumber copy];
            //            orderHistoryVC = [[WorkOrderHistoryDetailViewController alloc] init];
            //            [orderHistoryVC setWorkJobWidthId:orderId];
            //            [self gotoViewController:orderHistoryVC];
            //            break;
            
        case NOTIFICATION_ITEM_TYPE_ASSET:
            tmp = [self.baseVcParam valueForKeyPath:@"assetId"];
            if([tmp isKindOfClass:[NSString class]]) {
                tmpNumber = [FMUtils stringToNumber:tmp];
            } else if([tmp isKindOfClass:[NSNumber class]]) {
                tmpNumber = tmp;
            }
            assetId = [tmpNumber copy];
            assetVC = [[EquipmentDetailViewController alloc] initWithEquipmentID:assetId];
            [self gotoViewController:assetVC];
            break;
            
        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
            tmp = [self.baseVcParam valueForKeyPath:@"pmId"];
            if([tmp isKindOfClass:[NSString class]]) {
                tmpNumber = [FMUtils stringToNumber:tmp];
            } else if([tmp isKindOfClass:[NSNumber class]]) {
                tmpNumber = tmp;
            }
            maintenanceId = [tmpNumber copy];
            
            tmp = [self.baseVcParam valueForKeyPath:@"todoId"];
            if([tmp isKindOfClass:[NSString class]]) {
                tmpNumber = [FMUtils stringToNumber:tmp];
            } else if([tmp isKindOfClass:[NSNumber class]]) {
                tmpNumber = tmp;
            }
            orderId = [tmpNumber copy];
            
            maintenanceVC = [[MaintenanceDetailViewController alloc] init];
            [maintenanceVC setInfoWithPmId:maintenanceId todoId:orderId];
            [self gotoViewController:maintenanceVC];
            break;
        default:
            break;
    }
    self.baseVcType = BASE_VC_TYPE_COMMON;
    self.baseVcParam = nil;
}

#pragma --- 点击事件
- (void) onClick:(UIView *)view {
}

#pragma - 页面跳转


//报障
- (void) goToReport {
    NewReportViewController * reportVC = [[NewReportViewController alloc] init];
    [self gotoViewController:reportVC];
}
//二维码
- (void) goToQrCode {
    QrCodeViewController * qrcodeVC = [[QrCodeViewController alloc] init];
    [qrcodeVC setBackAble:YES];
    [qrcodeVC setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:qrcodeVC];
}

- (void) onQrCodeScanFinished:(NSString *)result {
    self.isBackFromQrCode = YES;
    self.qrcodeResult = result;
}

- (void) gotoHandleSpot {
    NSArray * strArray = [_qrcodeResult componentsSeparatedByString:@"|"];
    if(strArray && [strArray count] > 0) {
        NSString * spotCode  = strArray[0];
        NSNumber * userId = [SystemConfig getUserId];
        if(![FMUtils isStringEmpty:spotCode]) {
            NSMutableArray * spotArray = [[PatrolDBHelper getInstance] queryAllDBPatrolSpotsByCode:spotCode andUserId:userId];
            if(spotArray && [spotArray count] > 0) {
                DBPatrolSpot * spot = spotArray[0];
                [self gotoSpotViewController:spot];
            } else {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_no_tasks" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    
}

- (void) gotoSpotViewController:(DBPatrolSpot *) spot {
    PatrolSpotViewController * spotVC = [[PatrolSpotViewController alloc] init];
    [spotVC setPatrolSpot:spot];
    [self gotoViewController:spotVC];
}

- (void) gotoEmergencyListViewController {
}

- (void) gotoNoticeListViewController {
}



@end
