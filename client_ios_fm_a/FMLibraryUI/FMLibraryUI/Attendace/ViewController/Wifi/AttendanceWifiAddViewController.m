//
//  AttendanceWifiAddViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceWifiAddViewController.h"
#import "WifiAddTableHelper.h"
#import "AttendanceBusiness.h"
//#import "AttendanceEmployeeSettingEntity.h"
#import "FMUtils.h"
#import "AttendanceSettingEntity.h"
#import "AttendanceBusiness.h"
#import "AttendanceDbHelper.h"
#import "ImageItemView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"

@interface AttendanceWifiAddViewController () <OnMessageHandleListener>

@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *wifiArray;

@property (nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度


@property (nonatomic, strong) WifiAddTableHelper * helper;
@property (nonatomic, strong) AttendanceBusiness * business;
@property (nonatomic, strong) AttendanceDbHelper * dbHelper;


@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation AttendanceWifiAddViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_add" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self saveSelectedWifi];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self getWifiFromDB];
    [self requestWifi];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _helper = [[WifiAddTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
        _business = [AttendanceBusiness getInstance];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;

        
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, realWidth, realHeight)];
        _tableView.delaysContentTouches = NO;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = _helper;
        _tableView.delegate = _helper;
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (realHeight-_noticeHeight)/2, realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_no_wifi" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        
        [_noticeLbl setHidden:NO];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void) updateList {
    [_tableView reloadData];
    [self updateNotice];
}

- (void) updateNotice {
    if([_helper getWifiCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) getWifiFromDB {
    if (!_wifiArray) {
        _wifiArray = [NSMutableArray new];
    }
    if(_dbHelper) {
        _wifiArray = [_dbHelper queryAllSignWifi];
    }
}

- (void) requestWifi {
    NSDictionary * dic = [FMUtils getCurrentWiFiInfo];
    AttendanceConfigureWiFi * wifi = [[AttendanceConfigureWiFi alloc] init];
    wifi.name = [dic valueForKeyPath:@"name"];
    wifi.mac = [dic valueForKeyPath:@"mac"];
    if(![FMUtils isStringEmpty:wifi.mac]) {
        NSNumber *wifiStatus = [NSNumber numberWithBool:NO];
        for (AttendanceConfigureWiFi *tempWifi in _wifiArray) {
            if ([wifi.mac isEqualToString:tempWifi.mac]) {
                wifiStatus = [NSNumber numberWithBool:YES];
                break;
            }
        }
        
        NSMutableDictionary *wifiDictionary = [[NSMutableDictionary alloc] init];
        [wifiDictionary setValue:[NSMutableArray arrayWithObject:wifi] forKeyPath:@"wifi"];
        [wifiDictionary setValue:[NSMutableArray arrayWithObject:wifiStatus] forKeyPath:@"wifiStatus"];
        
        [_helper setWifiInfo:wifiDictionary];
    }
//    [_helper setWifi:[NSMutableArray arrayWithObject:wifi]];

    [self updateList];
}


- (void) saveSelectedWifi {
    _wifiArray = [_helper getSelectedWifiArray];
    if([_wifiArray count] == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_wifi_add_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSMutableArray * array = [self getAddableWifiArray];
        if([array count] > 0) {
            [self requestAddSelectedWifi:array];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_wifi_add_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (NSMutableArray *) getAddableWifiArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(AttendanceConfigureWiFi * wifi in _wifiArray) {
        if(![_dbHelper isSignWifiExistByMac:wifi.mac]) {
            [array addObject:wifi];
        }
    }
    return array;
}

//获取所选的 wifi 并传值
- (void) saveResult {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(AttendanceConfigureWiFi * obj in _wifiArray) {
        AttendanceOperateWiFi * wifi = [[AttendanceOperateWiFi alloc] init];
        wifi.wifiId = [obj.wifiId copy];
        wifi.name = [obj.name copy];
        wifi.mac = [obj.mac copy];
        wifi.enable = YES;  //新添加的WiFi默认enable为YES
        [array addObject:wifi];
    }
    [self handleResult:array];
    [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

#pragma mark - 网络请求
- (void) requestAddSelectedWifi:(NSMutableArray *) wifiArray {

    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(AttendanceConfigureWiFi * obj in wifiArray) {
        AttendanceOperateWiFi * wifi = [[AttendanceOperateWiFi alloc] init];
        wifi.wifiId = [obj.wifiId copy];
        wifi.name = [obj.name copy];
        wifi.mac = [obj.mac copy];
        wifi.enable = YES;  //新添加的WiFi默认enable为YES
        [array addObject:wifi];
    }
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    __weak typeof(_wifiArray) weakWifiArray = _wifiArray;
    [_business setRuleOfWifi:array sType:ATTENDANCE_OPERATE_WIFI_TYPE_ADD success:^(NSInteger key, id object) {
        NSArray * idArray = object;
        NSInteger index = 0;
        NSInteger count = [weakWifiArray count];
        for(NSNumber * wifiId in idArray) {
            if(index < count) {
                AttendanceConfigureWiFi * wifi = weakWifiArray[index];
                wifi.wifiId = [wifiId copy];
                weakWifiArray[index] = wifi;
            } else {
                break;
            }
        }
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_add_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf saveResult];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_add_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) handleResult:(NSMutableArray *) array {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        [msg setValue:array forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WifiAddTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            WifiAddTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            switch(eventType) {
                case WIFI_ADD_TABLE_EVENT_CHECK_UPDATE:
                    [self updateList];
                    break;
                default:
                    break;
            }
        }
    }
}

@end

