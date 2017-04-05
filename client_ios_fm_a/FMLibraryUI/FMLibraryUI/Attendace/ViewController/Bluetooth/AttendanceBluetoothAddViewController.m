//
//  AttendanceBluetoothAddViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceBluetoothAddViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BluetoothAddTableHelper.h"
#import "AttendanceBusiness.h"
#import "FMUtils.h"
#import "AttendanceSettingEntity.h"
#import "BabyBluetooth.h"
#import "AttendanceDbHelper.h"
#import "ImageItemView.h"
#import "BaseBundle.h"

@interface AttendanceBluetoothAddViewController () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;


@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, strong) BabyBluetooth *BLEManager;   //蓝牙检测Manager

@property (readwrite, nonatomic, strong) BluetoothAddTableHelper * helper;
@property (readwrite, nonatomic, strong) AttendanceDbHelper * dbHelper;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;


@end

@implementation AttendanceBluetoothAddViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_bluetooth_add" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self requestBluetooth];
}

- (void) initLayout {
    
    if(!_mainContainerView) {
        
        _helper = [[BluetoothAddTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        //初始化babyBluetooth
        _BLEManager = [BabyBluetooth shareBabyBluetooth];
        [self babyDelegate];
        
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
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_no_bluetooth" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:NO];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self saveSelectedBluetooth];
    }
}

- (void) updateList {
    [_tableView reloadData];
    [self updateNotice];
}

- (void) updateNotice {
    if([_helper getBluetoothCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([BluetoothAddTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            BluetoothAddTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            NSNumber * tmpNumber;
            NSMutableArray * tmpArray;
            NSDictionary * tmpDictionary;
            switch(eventType) {
                case BLUETOOTH_ADD_TABLE_EVENT_CHECK_UPDATE:
                    [self updateList];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void) requestBluetooth {
//    NSDictionary * dic = [FMUtils getCurrentWiFiInfo];
//    AttendanceConfigureBluetooth * entity = [[AttendanceConfigureBluetooth alloc] init];
//    entity.name = [dic valueForKeyPath:@"name"];
//    entity.mac = [dic valueForKeyPath:@"mac"];
//    NSLog(@"获取信息成功");
//    [_helper setBluetooth:[NSMutableArray arrayWithObject:entity]];
//    [self updateList];
    [self startBluetoothScan];
}

- (void) showBluetooth:(NSMutableArray *) array {
    [_helper setBluetooth:array];
    [self updateList];
}


- (void) saveSelectedBluetooth {
    NSMutableArray * array = [_helper getSelectedBluetoothArray];
    if([array count] == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_bluetooth_add_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        //TODO:添加执行人员
        [self handleResult:array];
        [self finish];
    }
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

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

//开始蓝牙扫描
- (void) startBluetoothScan {
    [_BLEManager cancelAllPeripheralsConnection];
    _BLEManager.scanForPeripherals().begin().stop(30);  //链式语法 30秒后停止搜索
    //    _BLEManager.scanForPeripherals().begin();
}

#pragma mark - BabyDelegate
- (void) babyDelegate {
    __weak typeof(self) weakSelf = self;
    //设置开始扫描的代理
    [_BLEManager setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，准备扫描设备");
        }
    }];
    
    //设置扫描到设备的代理
    __weak typeof(_helper) weakHelper = _helper;
    [_BLEManager setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Name:%@ UUID:%@",peripheral.name,peripheral.identifier.UUIDString);
        AttendanceConfigureBluetooth * entity = [[AttendanceConfigureBluetooth alloc] init];
        entity.name = peripheral.name;
        entity.mac = peripheral.identifier.UUIDString;
        [weakHelper addBluetooth:entity];
        [weakSelf updateList];
    }];
}


@end

