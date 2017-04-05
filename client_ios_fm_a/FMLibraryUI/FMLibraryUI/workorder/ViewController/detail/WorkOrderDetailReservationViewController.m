//
//  WorkOrderDetailReservationViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WorkOrderDetailReservationViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "NetPage.h"
#import "SeperatorView.h"
#import "ReservationEntity.h"
#import "OnItemClickListener.h"
#import "SystemConfig.h"
#import "InventoryNetRequest.h"
#import "ReservationDetailViewController.h"
#import "InventoryBusiness.h"
#import "ReservationListTableHelper.h"
#import "OnMessageHandleListener.h"
#import "MonthFilterTimeView.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "ReservationViewController.h"
#import "WorkOrderServerConfig.h"

@interface WorkOrderDetailReservationViewController () <OnMessageHandleListener, OnItemClickListener, OnClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * infoTableView;

@property (readwrite, nonatomic, strong) MonthFilterTimeView * timeFilterView;
@property (readwrite, nonatomic, assign) CGFloat timeControlHeight;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * infoArray;

@property (readwrite, nonatomic, strong) InventoryBusiness * business;
@property (readwrite, nonatomic, strong) ReservationListTableHelper * helper;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * woCode;

@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, assign) BOOL reserveAble;
@property (readwrite, nonatomic, assign) BOOL readOnly;

@property (readwrite, nonatomic, assign) WorkOrderStatus status;

@end

@implementation WorkOrderDetailReservationViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_info_select_material" inTable:nil]];
    [self setBackAble:YES];
    
    
    if(!_readOnly && _reserveAble) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_reserve" inTable:nil], nil];
        [self setMenuWithArray:menus];
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _reserveAble = NO;
        
        _business = [InventoryBusiness getInstance];
        _helper = [[ReservationListTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _noticeHeight = [FMSize getInstance].noticeHeight;
//        _timeControlHeight = [FMSize getInstance].topControlHeight;
        _timeControlHeight = 0;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeControlHeight)];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        [_timeFilterView setOnMessageHandleListener:self];
        
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _timeControlHeight, _realWidth, _realHeight-_timeControlHeight)];
        _infoTableView.dataSource = _helper;
        _infoTableView.delegate = _helper;
        
        _infoTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data_reserved" inTable:nil]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        
        _datePicker = [[BaseTimePicker alloc] init];
        [_datePicker setOnItemClickListener:self];
        
        _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_datePicker setPickerType:BASE_TIME_PICKER_MONTH];
        
        //        [_mainContainerView addSubview:_timeFilterView];
        [_mainContainerView addSubview:_infoTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initAlertView {
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


- (void) showTimeSelectDialog {
    NSDate * curDate = nil;
    NSNumber * time = [_timeFilterView getCurrentTime];
    if(![FMUtils isNumberNullOrZero:time]) {
        curDate = [FMUtils timeLongToDate:time];
    } else
    {
        curDate = [NSDate date];
    }
    
    NSNumber *tmp = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:tmp];
    
    [_alertView showType:@"time"];
    [_alertView show];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStatusChangeHandler];
    [self initAlertView];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        [self work];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self gotoReserveMaterial];
    }
}

- (void)viewDidUnload {
    [self setInfoTableView:nil];
    [super viewDidUnload];
}

- (void) setInfoWithOrderId:(NSNumber *)woId code:(NSString *) woCode {
    _woId = woId;
    _woCode = woCode;
}

- (void) setOrderStatus:(WorkOrderStatus) status {
    _status = status;
}

- (void) setReadOnly:(BOOL)readOnly {
    _readOnly = readOnly;
}

- (void) setReserveAble:(BOOL)reserveAble {
    _reserveAble = reserveAble;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
}

- (void) initStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMReservationStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) work {
    _needUpdate = NO;
    [self showLoadingDialog];
    [self requestData];
}


- (void) updateList {
    if([_helper getDataCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_infoTableView reloadData];
}

- (void) requestData {
    [_business getReservationListOfWorkOrder:_woId success:^(NSInteger key, id object) {
        _infoArray = object;
        [_helper setDataWithArray:_infoArray];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        _infoArray = nil;
        [_helper removeAllData];
        [self updateList];
        [self hideLoadingDialog];
    }];
}




#pragma mark --- 消息处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryReservationListEventType type = tmpNumber.integerValue;
            NSInteger position;
            switch(type) {
                case INVENTORY_RESERVATION_LIST_EVENT_SHOW_DETAIL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    position = tmpNumber.integerValue;
                    [self gotoInventoryDetail:position];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([MonthFilterTimeView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSInteger type = tmpNumber.integerValue;
            if(type == MONTH_FILTER_TYPE_SELECT_TIME) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showTimeSelectDialog];
                });
            } else if(type == MONTH_FILTER_TYPE_UPDATE) {
                [_helper removeAllData];
                [self updateList];
                [self work];
            }
        }
    }
}



#pragma mark --- 点击事件
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    [_timeFilterView setCurrentTime:time];
                    [_helper removeAllData];
                    [self updateList];
                    [self work];
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}

- (void) gotoInventoryDetail:(NSInteger) position{
    ReservationEntity *reservation = [_helper getDataByPosition:position];
    if(reservation) {
        ReservationDetailViewController *detailVC = [[ReservationDetailViewController alloc] init];
        [detailVC setInfoWithReservationId:reservation.activityId];
        [detailVC setReadonly:YES];
        if(_status == ORDER_STATUS_PROCESS && !_readOnly) {
            [detailVC setCanCancelReservation:YES]; //工单处于处理中状态时允许取消
        } else if(_status == ORDER_STATUS_CREATE && !_readOnly) { //待发布的工单允许编辑操作人
            [detailVC setCanEditHandler:YES];
        }
        [self gotoViewController:detailVC];
    }
}

//预定物料
- (void) gotoReserveMaterial {
    ReservationViewController * vc = [[ReservationViewController alloc] init];
    [vc setInfoWithWorkOrderId:_woId code:_woCode];
    [self gotoViewController:vc];
}

@end


