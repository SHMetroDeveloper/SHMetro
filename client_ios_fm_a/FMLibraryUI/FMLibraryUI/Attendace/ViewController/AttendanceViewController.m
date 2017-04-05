//
//  AttendanceViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceViewController.h"
#import "FMUtilsPackages.h"
#import "AttendanceBusiness.h"
#import "SystemConfig.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "AttendanceDbHelper.h"

//view
#import "AttendanceSignView.h"
#import "AttendanceSettingView.h"
#import "AttendanceSignTabBarView.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "ImageItemView.h"
#import "BaseBundle.h"

//entity
#import "AttendanceSignHistoryEntity.h"
#import "AttendanceSettingEntity.h"

//controller
#import "AttendanceEmployeeDetailViewController.h"
#import "AttendanceGpsDetailViewController.h"
#import "AttendanceWifiDetailViewController.h"
#import "AttendanceBluetoothDetailViewController.h"

@interface AttendanceViewController () <OnItemClickListener, OnClickListener, AMapLocationManagerDelegate, AMapSearchDelegate>
@property (nonatomic, strong) UIView *mainContainerView; //主容器

@property (nonatomic, strong) AttendanceSignView *signView;               //签到页面
@property (nonatomic, strong) AttendanceSettingView *settingView;         //设置页面
@property (nonatomic, strong) AttendanceSignTabBarView *signTabBarView;   //tabbar页面
@property (nonatomic, strong) ImageItemView *noticeLbl; //提醒页面

@property (nonatomic, strong) AttendanceBusiness *business;
@property (nonatomic, strong) AttendanceDbHelper *dbHelper;

@property (nonatomic, strong) __block AttendanceSettingDetail *settingDetail;
@property (nonatomic, strong) AttendanceLocation *location;//签出
@property (nonatomic, assign) NSInteger type;   //签到方式 1 --- wifi 签到 2 --- 蓝牙签到 3 --- gps签到
@property (nonatomic, strong) NSNumber *typeId; //签到方式记录的ID

@property (nonatomic, strong) BaseTimePicker *datePicker;
@property (nonatomic, strong) TaskAlertView *alertView;

@property (nonatomic, strong) BabyBluetooth *BLEManager;   //蓝牙检测Manager
@property (nonatomic, assign) __block CBManagerState BLEState; //当前蓝牙状态

@property (nonatomic, strong) AMapLocationManager *locationManager;  //地理位置Manager
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) __block CLLocation *currentLocation;  //当前定位位置

@property (nonatomic, strong) __block NSNumber *queryTime;
@property (nonatomic, assign) __block NSInteger queryType;

@property (nonatomic, strong) __block NSNumber *employeeType;  //员工权限

@property (nonatomic, strong) NSMutableArray *matchLocation;  //符合条件的地理位置信息
@property (nonatomic, strong) NSMutableArray *matchDistance;  //符合条件的地理位置距离

@property (nonatomic, assign) BOOL needUpdate;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat tabBarHeight;

@end

@implementation AttendanceViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_navigation_title_sign" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSettingConfigureData];
    [self requestSignHistory];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        _needUpdate = NO;
        [self updateSettingViewFromDB];
    }
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _tabBarHeight = [AttendanceSignTabBarView getItemHeight];
    

    //init other
    _queryTime = [FMUtils getTimeLongNow];  //默认查询时间为现在
    _queryType = 0;   //默认为0 获取指定人在指定日期的签到记录
    
    //签入签到请求参数设置
    _type = 0;      //默认为不在范围内
    _typeId = nil;  //默认无签到方式id
    
    //初始化BabyBluetooth
    _BLEManager = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    
    //初始化地理定位Manager
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];//设置期望定位精度
    [_locationManager setPausesLocationUpdatesAutomatically:YES];//设置系统暂停定位
    [_locationManager setAllowsBackgroundLocationUpdates:NO];//设置在后台定位
    
    //初始化地理位置搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //初始化网络请求Manager
    if (!_business) {
        _business = [AttendanceBusiness getInstance];
    }

    if(!_dbHelper) {
        _dbHelper = [AttendanceDbHelper getInstance];
    }
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    [self.view addSubview:_mainContainerView];
    [self initAlertView];
}

- (void) initAlertView {
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_DAY];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void) updateViewWithNetWorkingSuccess:(BOOL) success {
    if (success) {
        if (_employeeType.integerValue == 2) {
            [_mainContainerView addSubview:self.signView];
            [_mainContainerView addSubview:self.signTabBarView];
        } else {
            [_mainContainerView addSubview:self.signView];
        }
    } else {
        if (!_noticeLbl) {
            [_mainContainerView addSubview:self.noticeLbl];
        }
        self.noticeLbl.hidden = NO;
        [self.noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_getting_setting_configuration_fail" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
    }
}

- (void) updateSettingViewFromDB {
    AttendanceSettingDetail *setting = [[AttendanceSettingDetail alloc] init];
    setting.person = [_dbHelper queryAllSignPerson];
    setting.wifi = [_dbHelper queryAllSignWifi];
    AttendanceConfigureGPS *gps = [[AttendanceConfigureGPS alloc] init];
    gps.locations = [_dbHelper queryAllSignLocation];
    gps.accuracy = [SystemConfig getSignLocationAccurancy];
    setting.gps = gps;
    
    _settingView.settingDetail = setting;
}

#pragma mark lazyLoad
//信息获取失败提示框
- (ImageItemView *) noticeLbl {
    if (!_noticeLbl) {
        CGFloat noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-noticeHeight)/2, _realWidth, noticeHeight)];
        [_noticeLbl setInfoWithName:@"" andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        _noticeLbl.hidden = YES;
    }
    return _noticeLbl;
}

//签到页面
- (AttendanceSignView *)signView {
    if (!_signView) {
        _signView = [[AttendanceSignView alloc] init];
        [_signView setEmployeeType:_employeeType.integerValue];
        if (_employeeType.integerValue == 2) {
            [_signView setFrame:CGRectMake(0, 0, _realWidth, _realHeight - _tabBarHeight)];
        } else {
            [_signView setFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        }
        __weak typeof(self) weakSelf = self;
        _signView.actionBlock = ^(AttendanceSignActionType type){
            switch (type) {
                case ATTENDANCE_SIGN_ACTION_EVENT_SIGN_IN:
//                    [weakSelf requestOperateSignIn];
                    [weakSelf requestOperateSign:YES];
                    break;
                    
                case ATTENDANCE_SIGN_ACTION_EVENT_SIGN_OUT:
//                    [weakSelf requestOperateSignOut];
                    [weakSelf requestOperateSign:NO];
                    break;
                    
                case ATTENDANCE_SIGN_ACTION_EVENT_DATE_CHANGE:
                    [weakSelf showTimeSelectDialog];
                    break;
            }
        };
    }
    
    return _signView;
}

//设置页面
- (AttendanceSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[AttendanceSettingView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight - _tabBarHeight) style:UITableViewStyleGrouped];
        _settingView.settingDetail = _settingDetail;
        __weak typeof(self) weakSelf = self;
        _settingView.actionBlock = ^(AttendanceSettingActionEventType type){
            switch (type) {
                case ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_EDIT:
                    //设置签到人员
                    [weakSelf gotoEditEmployee:YES];
                    break;
                case ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_DETAIL:
                    //查看签到人员
                    [weakSelf gotoEditEmployee:NO];
                    break;
                case ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_EDIT:
                    //设置签到地理位置
                    [weakSelf gotoEditLocation:YES];
                    break;
                    
                case ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_DETAIL:
                    //查看签到地理位置
                    [weakSelf gotoEditLocation:NO];
                    break;
                    
                case ATTENDANCE_SETTING_ACTION_TYPE_WIFI_EDIT:
                    //设置签到wifi
                    [weakSelf gotoEditWifi:YES];
                    break;
                case ATTENDANCE_SETTING_ACTION_TYPE_WIFI_DETAIL:
                    //查看签到WiFi
                    [weakSelf gotoEditWifi:NO];
                    break;
                    
                case ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_EDIT:
                    //设置签到蓝牙
                    [weakSelf gotoEditBluetooth:YES];
                    break;
                case ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_DETAIL:
                    //查看签到蓝牙
                    [weakSelf gotoEditBluetooth:NO];
                    break;
            }
        };
    }
    return _settingView;
}

//tabBar切换
- (AttendanceSignTabBarView *)signTabBarView {
    if (!_signTabBarView) {
        _signTabBarView = [[AttendanceSignTabBarView alloc] initWithFrame:CGRectMake(0, _realHeight-_tabBarHeight, _realWidth, _tabBarHeight)];
        _signTabBarView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        __weak typeof(self) weakSelf = self;
        _signTabBarView.actionBlock = ^(SignTabBarActionType type){
            switch (type) {
                case SIGN_ACTION_BUTTON_SIGN: {
                    __block BOOL isAdded = NO;
                    for (UIView *view in weakSelf.mainContainerView.subviews) {
                        if ([view isEqual:weakSelf.signView]) {
                            isAdded = YES;
                        }
                    }
                    if (!isAdded) {
                        [weakSelf.mainContainerView addSubview:weakSelf.signView];
                    }
                    //保证性能移除另一个页面
                    [weakSelf.settingView removeFromSuperview];
                    weakSelf.settingView = nil;
                    //更新导航栏的标题
                    [weakSelf setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_navigation_title_sign" inTable:nil]];
                    [weakSelf updateNavigationBar];
                    //再次请求数据
                    weakSelf.queryTime = [FMUtils getTimeLongNow];
                    weakSelf.queryType = 0;
                    
                    [weakSelf.signView setQueryTime:weakSelf.queryTime];
                    
                    [weakSelf requestSettingConfigureData];
                    [weakSelf requestSignHistory];
                }
                    break;
                    
                case SIGN_ACTION_BUTTON_SETTING: {
                    __block BOOL isAdded = NO;
                    for (UIView *view in weakSelf.mainContainerView.subviews) {
                        if ([view isEqual:weakSelf.settingView]) {
                            isAdded = YES;
                        }
                    }
                    if (!isAdded) {
                        [weakSelf.mainContainerView addSubview:weakSelf.settingView];
                    }
                    //保证性能移除另一个页面
                    [weakSelf.signView removeFromSuperview];
                    weakSelf.signView = nil;
                    //更新导航栏的标题
                    [weakSelf setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_navigation_title_setting" inTable:nil]];
                    [weakSelf updateNavigationBar];
                }
                    break;
            }
        };
    }
    return _signTabBarView;
}

#pragma mark - 保存数据到数据库
- (void) saveToDb {
    if(_settingDetail) {
        //保存签到人员信息
        [_dbHelper addSignPersonWithArray:_settingDetail.person];
        //保存签到 wifi 信息
        [_dbHelper addSignWifiWithArray:_settingDetail.wifi];
        //保存签到蓝牙信息
        [_dbHelper addSignBluetoothWithArray:_settingDetail.bluetooth];
        //保存签到位置信息
        [_dbHelper addSignLocationWithArray:_settingDetail.gps.locations];
        //保存签到精准度
        [SystemConfig saveSignLocationAccurancy:_settingDetail.gps.accuracy];
        
        //保存当前执行人的状态信息
        NSNumber *emId = [SystemConfig getEmployeeId];
        [_dbHelper setSignType:_settingDetail.type status:_settingDetail.status ofPerson:emId];

//        [self updateViewWithNetWorkingSuccess:YES];
    }
}

#pragma mark - NetWorking
//获取签到设置信息
- (void) requestSettingConfigureData {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    if (!_settingDetail) {
        _settingDetail = [[AttendanceSettingDetail alloc] init];
    }
    [_business getSignSettingInfoSuccess:^(NSInteger key, id object) {
        weakSelf.settingDetail = (AttendanceSettingDetail *) object;
        weakSelf.employeeType = [NSNumber numberWithInteger:weakSelf.settingDetail.type];
        [weakSelf saveToDb];
        [weakSelf checkSignReachable];
//        if (weakSelf.settingDetail.status == 0) {
//            [weakSelf checkSignReachable];
//        }
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
//        [weakSelf updateViewWithNetWorkingSuccess:NO];
        [weakSelf hideLoadingDialog];
    }];
}


/**
 请求签到历史记录
 */
- (void) requestSignHistory {
    [self showLoadingDialog];	
    __weak typeof(self) weakSelf = self;
    [_business getSignHistoryByParam:[self getHistoryRequestParam] Success:^(NSInteger key, id object) {
        NSMutableArray *dataArray = object;
        if (dataArray.count == 0 && weakSelf.queryType == 0) {
            //获取最后一条记录
            weakSelf.queryType = 1;
            [weakSelf requestSignHistory];
        } else {
            if (weakSelf.queryType == 1) {
                weakSelf.queryType = 0;
                //判断最后一条数据是什么时候的
                AttendanceSignHistoryDetailEntity *lastHistory = [dataArray lastObject];
                NSInteger timeStatus = [FMUtils compareTimeA:lastHistory.time withTimeB:_queryTime];
                if (timeStatus == -1 && lastHistory.signin == 1) {
                    //如果最后一条是签入的话则要求显示签出
                    weakSelf.signView.dateArray = dataArray;
                } else {
                    weakSelf.signView.dateArray = nil;
                }
            } else {
                weakSelf.signView.dateArray = dataArray;
            }
        }
        [weakSelf updateViewWithNetWorkingSuccess:YES];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateViewWithNetWorkingSuccess:NO];
        [weakSelf hideLoadingDialog];
    }];
}

//签入签出
- (void) requestOperateSign:(BOOL) signin {
    __weak typeof(self) weakSelf = self;
    [_business attendanceOperateSign:[self getSignRequestParamBySignin:signin] success:^(NSInteger key, id object) {
        //签入成功，再次请求历史记录并且刷新界面
        [weakSelf requestSettingConfigureData];
        [weakSelf requestSignHistory];
    } fail:^(NSInteger key, NSError *error) {
        if (signin) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_fail_in" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_fail_out" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
        [weakSelf hideLoadingDialog];
    }];
}

//获取地理位置表示最近的公司名
- (void) requestSearchPOIAround {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.keywords = @"公司企业";
    /* 按照距离排序. */
    request.sortrule = 0;
    request.requireExtension = YES;
    if (!_location) {
        [_search AMapPOIAroundSearch:request];
    }
}

#pragma mark - PrivateMethod
- (AttendanceSignHistoryRequestParam *) getHistoryRequestParam {
    AttendanceSignHistoryRequestParam *param = [[AttendanceSignHistoryRequestParam alloc] init];
    param.emId = [SystemConfig getEmployeeId];
    param.time = _queryTime;
    param.type = _queryType;
    
    return param;
}

- (AttendanceOperateSignRequestParam *) getSignRequestParamBySignin:(BOOL) signin {
    AttendanceOperateSignRequestParam *param = [[AttendanceOperateSignRequestParam alloc] init];
    param.time = [FMUtils getTimeLongNow];
    param.emId = [SystemConfig getEmployeeId];
    param.typeId = _typeId;
    param.type = _type;
    param.signin = signin;
    param.location = _location;
    
    return param;
}

- (void) showTimeSelectDialog {
    [_datePicker setCenterDate:_queryTime];
    [_alertView showType:@"time"];
    [_alertView show];
}

//开始WiFi扫描判断
- (BOOL) startWiFiScan {
    BOOL isReachable = NO;
    
    NSDictionary *nativeWiFi = [FMUtils getCurrentWiFiInfo];  //判断WiFi是否符合条件
    if (![FMUtils isStringEmpty:[nativeWiFi valueForKeyPath:@"mac"]]) {
        for (AttendanceConfigureWiFi *remoteWiFi in _settingDetail.wifi) {
            if (remoteWiFi.enable) {  
                if ([[nativeWiFi valueForKeyPath:@"mac"] isEqualToString:remoteWiFi.mac]) {
                    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                    isReachable = YES;
                    NSString *statusDesc = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_WiFi_within" inTable:nil],[nativeWiFi valueForKeyPath:@"name"]];
                    [resultDic setValue:[NSNumber numberWithBool:isReachable] forKeyPath:@"reachable"];
                    [resultDic setValue:statusDesc forKeyPath:@"statusDesc"];
                    _typeId = remoteWiFi.wifiId;
                    _type = 1;
                    self.signView.signReachable = resultDic;
                    break;
                }
            }
        }
    }
    
    return isReachable;
}

//开始地理定位
- (void) startLocationScan {
    //开始连续定位
    [self stopLocationScan];  //开始前停止上一次定位
    [_locationManager startUpdatingLocation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopLocationScan];
    });
}

//停止地理位置扫描
- (void) stopLocationScan {
    [_locationManager stopUpdatingLocation];
    [self requestSearchPOIAround];
}

//开始蓝牙扫描
- (void) startBluetoothScan {
    [_BLEManager cancelAllPeripheralsConnection];
    _BLEManager.scanForPeripherals().begin().stop(30);  //链式语法 30秒后停止搜索
//    _BLEManager.scanForPeripherals().begin();
}

//获取能否签到信息
- (void) checkSignReachable {
    BOOL reachable = NO;
    NetworkStatus netStatus = [self getServerStatus];
    if (netStatus == ReachableViaWiFi) {  //首先判断是否连接了WiFi
        reachable = [self startWiFiScan];  //判断WiFi是否准确
        if (!reachable) {  //WiFi = wrong 进行蓝牙和地理位置判断
//            [self startBluetoothScan];
            
            [self startLocationScan];
        }
    } else {   // WiFi = OFF 进行蓝牙和地理位置判断
//        [self startBluetoothScan];
        
        [self startLocationScan];
    }
}


#pragma mark - OnClickListenerDelegate
- (void)onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

#pragma mark - OnItemClickListenerDelegate
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[BaseTimePicker class]]) {
        BaseTimePickerActionType type = subView.tag;
        switch (type) {
            case BASE_TIME_PICKER_ACTION_OK:
                _queryType = 0;
                _queryTime = [_datePicker getSelectTime];
                [self.signView setQueryTime:_queryTime];  //设置headerBtn的时间
                [self requestSignHistory];
                break;
                
            case BASE_TIME_PICKER_ACTION_CANCEL:
                
                break;
        }
        [_alertView close];
    }
}

#pragma mark - BabyDelegate
- (void) babyDelegate {
    __weak typeof(self) weakSelf = self;
    //设置开始扫描的代理
    [_BLEManager setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，准备扫描设备");
        }
        weakSelf.BLEState = central.state;
    }];
    
    //设置扫描到设备的代理
    [_BLEManager setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Name:%@ UUID:%@",peripheral.name,peripheral.identifier.UUIDString);
        
        for (AttendanceConfigureBluetooth *remoteBlue in weakSelf.settingDetail.bluetooth) {
            if (remoteBlue.enable) {
                if ([peripheral.identifier.UUIDString isEqualToString:remoteBlue.mac]) {
                    //是否可以签到
                    BOOL reachable = YES;
                    //签到描述信息
                    NSString *statusDesc = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_BLE_within" inTable:nil],peripheral.name];
                    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                    [resultDic setValue:[NSNumber numberWithBool:reachable] forKeyPath:@"reachable"];
                    [resultDic setValue:statusDesc forKeyPath:@"statusDesc"];
                    _typeId = remoteBlue.bluetoothId;
                    _type = 2;
                    weakSelf.signView.signReachable = resultDic;
                    //停止扫描
                    [weakSelf.BLEManager cancelScan];
                }
            }
        }
    }];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    MAMapPoint nativePoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));
    NSMutableArray *locations = _settingDetail.gps.locations;
    _currentLocation = location;
    
    if (!_matchLocation) {
        _matchLocation = [NSMutableArray new];
    }
    if (!_matchDistance) {
        _matchDistance = [NSMutableArray new];
    }
    
    for (AttendanceLocation *remoteGps in locations) {
        if (remoteGps.enable || _settingDetail.status == 1) {
            MAMapPoint remotePoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(remoteGps.lat.doubleValue,remoteGps.lon.doubleValue));
            CLLocationDistance distance = MAMetersBetweenMapPoints(nativePoint,remotePoint);
            
            if (distance <= _settingDetail.gps.accuracy) {
                if (_matchLocation.count == 0) {
                    [_matchLocation addObject:remoteGps];
                    [_matchDistance addObject:[NSNumber numberWithFloat:distance]];
                } else {
                    if (distance < [_matchDistance[0] floatValue]) {
                        [_matchLocation replaceObjectAtIndex:0 withObject:remoteGps];
                        [_matchDistance replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:distance]];
                    }
                }
            }
        }
    }
    
    
    _location = nil;
    self.signView.signReachable = nil;
    if (_matchLocation.count > 0) {
        AttendanceLocation *location = _matchLocation[0];
        //是否可以签到
        BOOL reachable = YES;
        //签到描述信息
        NSString *statusDesc = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_GPS_within" inTable:nil],location.name];
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic setValue:[NSNumber numberWithBool:reachable] forKeyPath:@"reachable"];
        [resultDic setValue:statusDesc forKeyPath:@"statusDesc"];
        _typeId = location.locationId;
        _type = 3;
        _location = location;
        self.signView.signReachable = resultDic;
        //停止定位
        [self stopLocationScan];
        
        _matchLocation = nil;
        _matchDistance = nil;
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_location_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"地理位置获取信息的权限是:%d",status);
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (!_location && response.pois.count > 0) {
        _location = [[AttendanceLocation alloc] init];
        AMapPOI *obj = response.pois[0];
        _location.name = obj.name;
        _location.desc = obj.address;
        _location.lat = [[NSString alloc] initWithFormat:@"%f", obj.location.latitude];
        _location.lon = [[NSString alloc] initWithFormat:@"%f", obj.location.longitude];
    } else {
        return;
    }
}

#pragma mark - PushEvent

- (void) gotoEditEmployee:(BOOL) isEditable {
    _needUpdate = isEditable;
    AttendanceEmployeeDetailViewController *vc = [[AttendanceEmployeeDetailViewController alloc] init];
    vc.isEditable = isEditable;
    [self gotoViewController:vc];
}

- (void) gotoEditLocation:(BOOL) isEditable {
    _needUpdate = isEditable;
    AttendanceGpsDetailViewController * vc = [[AttendanceGpsDetailViewController alloc] init];
    vc.editable = isEditable;
    [self gotoViewController:vc];
}

- (void) gotoEditWifi:(BOOL) isEditable {
    _needUpdate = isEditable;
    AttendanceWifiDetailViewController * vc = [[AttendanceWifiDetailViewController alloc] init];
    vc.isEditable = isEditable;
    [self gotoViewController:vc];
}

- (void) gotoEditBluetooth:(BOOL) isEditable {
    _needUpdate = isEditable;
    AttendanceBluetoothDetailViewController * vc = [[AttendanceBluetoothDetailViewController alloc] init];
    vc.isEditable = isEditable;
    [self gotoViewController:vc];
}

@end
