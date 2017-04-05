//
//  AttendanceGpsDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceGpsDetailViewController.h"
#import "FMUtilsPackages.h"
#import "AttendanceGpsAddViewController.h"
#import "GpsDetailTableHelper.h"
#import "ImageItemView.h"
#import "FMTheme.h"
#import "BasePicker.h"
#import "TaskAlertView.h"
#import "AttendanceSettingEntity.h"
#import "AttendanceSettingOperateEntity.h"
#import "AttendanceBusiness.h"
#import "AttendanceDbHelper.h"
#import "SystemConfig.h"
#import "BaseBundle.h"

@interface AttendanceGpsDetailViewController ()<OnMessageHandleListener, OnClickListener, OnItemClickListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, strong) BasePicker *accuracyPicker;
@property (nonatomic, strong) TaskAlertView *alertView;

@property (nonatomic, strong) NSMutableArray *accuracyTarget;  //允许的精度范围
@property (nonatomic, assign) NSInteger accuracy;    //当前精确范围

@property (nonatomic, strong) NSMutableArray *gpsDetailArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) BOOL isInited;
@property (nonatomic, strong) GpsDetailTableHelper * helper;

@property (nonatomic, strong) AttendanceBusiness * business;
@property (nonatomic, strong) AttendanceDbHelper * dbHelper;
@end

@implementation AttendanceGpsDetailViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location" inTable:nil]];
    [self setBackAble:YES];
    if(_editable) {
        NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil]];
        [self setMenuWithArray:menuArray];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if(_editable) {
        if (position == 0) {
            [self gotoAddLocation];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    if (!_isInited) {
        _isInited = YES;
        [self updateList];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateList];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _helper = [[GpsDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        _helper.isEditable = _editable;
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
        _business = [AttendanceBusiness getInstance];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;

        _accuracyTarget = [self getAccuracyArray];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.delegate = _helper;
        _tableView.dataSource = _helper;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_no_location" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:NO];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        _accuracyPicker = [[BasePicker alloc] init];
        [_accuracyPicker setRowFont:[FMFont fontWithSize:18]];
        [_accuracyPicker setOnItemClickListener:self];
        [_accuracyPicker setDataByArray:[self getAccuracyDescriptionArray]];
        _accuracyPicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_mainContainerView addSubview:_tableView];
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
    
    [_alertView setContentView:_accuracyPicker withKey:@"accuracy" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void) updateList {
    _gpsDetailArray = [_dbHelper queryAllSignLocation];
    _accuracy = [SystemConfig getSignLocationAccurancy];
    if (_accuracy == 0 && _gpsDetailArray.count > 0) {
        _accuracy = 500;
        [self requestSaveAccuracyWithShowingLoading:NO];
    }
    
    [_helper setGpsWithArray:_gpsDetailArray];
    [_helper setAccuracy:_accuracy];
    
    [_tableView reloadData];
    [self updateNotice];
}

- (void) updateNotice {
    if([_helper getGpsCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

//从数据库中删除地理位置
- (void) deleteLocationFromDBById:(NSNumber *) locationId {

    [_dbHelper deleteSignLocationById:locationId];
}

//保存签到精准度
- (void) saveAccuracyToDB:(NSInteger) accuracy {
    [SystemConfig saveSignLocationAccurancy:accuracy];
}

//将单条地址信息存入数据库更新该条数据的状态
- (void) updateLocationState:(AttendanceLocation *) location {
    [_dbHelper setSignLocation:location.locationId status:location.enable];
}

//将地理位置加入数据库
- (void) addLocationToDB:(NSMutableArray *) locationArray {
    if (locationArray.count > 0) {
        AttendanceLocation *location = [locationArray lastObject];
        [_dbHelper addSignLocation:location];
    }
}

- (void)setIsEditable:(BOOL)isEditable {
    _editable = isEditable;
}

- (NSMutableArray *) getAccuracyArray {
    NSMutableArray * target = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < 10;index++) {
        [target addObject:[NSNumber numberWithInteger:100 * (index + 1)]];
    }
    [target addObject:[NSNumber numberWithInteger:2000]];
    [target addObject:[NSNumber numberWithInteger:3000]];
    
    return target;
}

- (NSMutableArray *) getAccuracyDescriptionArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(NSNumber * tmp in _accuracyTarget) {
        NSString * strAccuracy = [self getAccuracyDescription:tmp.integerValue];
        [array addObject:strAccuracy];
    }
    
    return array;
}

- (NSString *) getAccuracyDescription:(NSInteger) accuracy {
    NSString * res = @"";
    res = [[NSString alloc] initWithFormat:@"%ld%@", accuracy, [[BaseBundle getInstance] getStringByKey:@"meter" inTable:nil]];
    return res;
}

#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[_accuracyPicker class]]) {
        BasePickerActionType type = subView.tag;
        NSNumber * tmpNumber;
        NSInteger tmp;
        switch(type) {
            case BASE_PICKER_ACTION_CANCEL:
                break;
            case BASE_PICKER_ACTION_OK:
                tmp = [_accuracyPicker getSelectedIndex];
                tmpNumber = _accuracyTarget[tmp];
                if (_accuracy != tmpNumber.integerValue) {
                    _accuracy = tmpNumber.integerValue;
                    [self requestSaveAccuracyWithShowingLoading:YES];
                }
                break;
            default:
                break;
        }
        [_alertView close];
    }
}

- (void) showAccuracySelectDialog {
    [_accuracyPicker setCenterData:[self getAccuracyDescription:_accuracy]];
    [_alertView showType:@"accuracy"];
    [_alertView show];
}

#pragma mark - NetWorking
- (void) requestDeleteLocation:(AttendanceLocation *) obj position:(NSInteger) position{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    AttendanceOperateLocation * location = [[AttendanceOperateLocation alloc] init];
    location.locationId = [obj.locationId copy];
    location.name = [obj.name copy];
    location.desc = [obj.desc copy];
    location.lat = [obj.lat copy];
    location.lon = [obj.lon copy];
    location.enable = obj.enable;
    [array addObject:location];
    
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfLocation:array sType:ATTENDANCE_OPERATE_LOCATION_TYPE_DELETE accuracy:_accuracy success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf deleteLocationFromDBById:location.locationId];
        [weakSelf updateList];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_delete_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) requestSaveAccuracyWithShowingLoading:(BOOL) showLoading {
    if (showLoading) {
        [self showLoadingDialog];
    }
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfLocation:nil sType:ATTENDANCE_OPERATE_LOCATION_TYPE_UPDATE accuracy:_accuracy success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf saveAccuracyToDB:weakSelf.accuracy];
        [weakSelf updateList];
        if (showLoading) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_update_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        if (showLoading) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_update_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }];
}

- (void) requestChangeLocationState:(AttendanceLocation *) location {
    NSMutableArray *array = [NSMutableArray arrayWithObject:location];
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfLocation:array sType:ATTENDANCE_OPERATE_LOCATION_TYPE_UPDATE accuracy:_accuracy success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf updateLocationState:location];
        [weakSelf updateList];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_update_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_update_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

#pragma mark - OnMessageHandleListener
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([GpsDetailTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            GpsDetailTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            AttendanceLocation * location;
            NSMutableDictionary * data;
            NSNumber * tmpNumber;
            switch(eventType) {
                case GPS_DETAIL_TABLE_EVENT_DELETE:
                    if(_editable) {
                        data = [result valueForKeyPath:@"eventData"];
                        location = [data valueForKeyPath:@"location"];
                        tmpNumber = [data valueForKeyPath:@"position"];
                        if(location) {
                            [self requestDeleteLocation:location position:tmpNumber.integerValue];
                        }
                    }
                    break;
                    
                case GPS_DETAIL_TABLE_EVENT_SELECT_ACCURACY:
                    if(_editable) {
                        [self showAccuracySelectDialog];
                    }
                    break;
                    
                case GPS_DETAIL_TABLE_EVENT_STATE_CHANGE:
                    data = [result valueForKeyPath:@"eventData"];
                    location = [data valueForKeyPath:@"location"];
                    [self requestChangeLocationState:location];
                    break;
                    
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([AttendanceGpsAddViewController class])]) {
            NSMutableArray * array = [msg valueForKeyPath:@"result"];
            [self addLocationToDB:array];
//            _needUpdate = YES;
            [self updateList];
        }
    }
}

#pragma mark - PushEvent
- (void) gotoAddLocation {
    AttendanceGpsAddViewController *VC = [[AttendanceGpsAddViewController alloc] init];
    [VC setOnMessageHandleListener:self];
    [self gotoViewController:VC];
}

@end

