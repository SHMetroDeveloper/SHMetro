//
//  AttendanceWifiDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceWifiDetailViewController.h"
#import "ImageItemView.h"
#import "WifiDetailTableHelper.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "AttendanceWifiAddViewController.h"
#import "AttendanceBusiness.h"
#import "AttendanceSettingEntity.h"
#import "AttendanceSettingOperateEntity.h"
#import "AttendanceDbHelper.h"
#import "BaseBundle.h"


@interface AttendanceWifiDetailViewController () <OnMessageHandleListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, strong) WifiDetailTableHelper * helper;
@property (nonatomic, strong) AttendanceBusiness * business;

@property (nonatomic, strong) AttendanceDbHelper * dbHelper;

@property (nonatomic, strong) NSMutableArray *wifiArray;

@property (nonatomic, assign) BOOL needUpdate;

@end

@implementation AttendanceWifiDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_WiFi" inTable:nil]];
    [self setBackAble:YES];
    if (_isEditable) {
        NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil]];
        [self setMenuWithArray:menuArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateList];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self gotoAddWifi];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _helper = [[WifiDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        _helper.isEditable = _isEditable;
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
        _business = [[AttendanceBusiness alloc] init];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
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
    _wifiArray = [_dbHelper queryAllSignWifi];
    [_helper setWifi:_wifiArray];
    
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

//从数据库删除WiFi
- (void) deleteWifiFromDBById:(NSNumber *) wifiId {
    [_dbHelper deleteSignWifiById:wifiId];
}

//更新WiFi状态
- (void) updateWifiState:(AttendanceConfigureWiFi *) wifi {
    [_dbHelper setSignWifi:wifi.wifiId status:wifi.enable];
}

//添加新的WiFi到数据库
- (void) saveNewWifiToDB:(NSMutableArray *) wifiArray {
    if (wifiArray.count > 0) {
        AttendanceConfigureWiFi *wifi = wifiArray[0];
        [_dbHelper addSignWifi:wifi];
    }
}

#pragma mark - NetWorking
//启用禁用WiFi
- (void) requestEnableWifi:(AttendanceConfigureWiFi *)wifi position:(NSInteger) position{
    NSMutableArray *array = [NSMutableArray arrayWithObject:wifi];
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfWifi:array sType:ATTENDANCE_OPERATE_WIFI_TYPE_UPDATE success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        //更新数据库中的WiFi状态
        [weakSelf updateWifiState:wifi];
        weakSelf.wifiArray = [weakSelf.dbHelper queryAllSignWifi];
        [weakSelf.helper setWifi:weakSelf.wifiArray];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:position inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_update_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_update_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//删除WiFi
- (void) requestDeleteWifi:(AttendanceConfigureWiFi *) obj position:(NSInteger) position{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    AttendanceOperateWiFi * wifi = [[AttendanceOperateWiFi alloc] init];
    wifi.wifiId = [obj.wifiId copy];
    wifi.name = [obj.name copy];
    wifi.mac = [obj.mac copy];
    wifi.enable = obj.enable;
    [array addObject:wifi];
    
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfWifi:array sType:ATTENDANCE_OPERATE_WIFI_TYPE_DELETE success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        //删除数据库中的某条WiFi数据
        [weakSelf deleteWifiFromDBById:wifi.wifiId];
        [weakSelf updateList];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_delete_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

#pragma mark - OnMessageHandleListener
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WifiDetailTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            WifiDetailTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            AttendanceConfigureWiFi * wifi;
            NSMutableDictionary * data;
            NSNumber * tmpNumber;
            switch(eventType) {
                case WIFI_DETAIL_TABLE_EVENT_DELETE:
                    data = [result valueForKeyPath:@"eventData"];
                    wifi = [data valueForKeyPath:@"wifi"];
                    tmpNumber = [data valueForKeyPath:@"position"];
                    if(wifi) {
                        [self requestDeleteWifi:wifi position:tmpNumber.integerValue];
                    }
                    break;
                    
                case WIFI_DETAIL_TABLE_EVENT_ENABLE_CHANGE:
                    data = [result valueForKeyPath:@"eventData"];
                    wifi = [data valueForKeyPath:@"wifi"];
                    tmpNumber = [data valueForKeyPath:@"position"];
                    if(wifi) {
                        [self requestEnableWifi:wifi position:tmpNumber.integerValue];
                    }
                    break;
                    
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([AttendanceWifiAddViewController class])]) {
            NSMutableArray * array = [msg valueForKeyPath:@"result"];
            [self saveNewWifiToDB:array];
            [self updateList];
        }
    }
}

#pragma mark - PushEvent
- (void) gotoAddWifi {
    AttendanceWifiAddViewController *vc = [[AttendanceWifiAddViewController alloc] init];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

@end
