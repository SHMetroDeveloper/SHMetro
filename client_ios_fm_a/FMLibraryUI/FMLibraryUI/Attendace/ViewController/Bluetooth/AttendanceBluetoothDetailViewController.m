//
//  AttendanceBluetoothDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceBluetoothDetailViewController.h"
#import "ImageItemView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "AttendanceBluetoothAddViewController.h"
#import "BluetoothDetailTableHelper.h"
#import "AttendanceDbHelper.h"
#import "BaseBundle.h"


@interface AttendanceBluetoothDetailViewController () <OnMessageHandleListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;


@property (readwrite, nonatomic, strong) BluetoothDetailTableHelper * helper;
@property (readwrite, nonatomic, strong) AttendanceDbHelper * dbHelper;

@property (nonatomic, assign) BOOL needUpdate;

@end

@implementation AttendanceBluetoothDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_bluetooth" inTable:nil]];
    [self setBackAble:YES];
    if (_isEditable) {
        NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil]];
        [self setMenuWithArray:menuArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBluetoothFromDb];
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
        [self gotoAddBluetooth];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _helper = [[BluetoothDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
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
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_no_bluetooth" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
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
    if([_helper getBluetoothCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) getBluetoothFromDb {
    if(_dbHelper) {
        NSMutableArray * array = [_dbHelper queryAllSignBluetooth];
        [self setBluetooth:array];
    }
}

- (void) setBluetooth:(NSMutableArray *) array {
    [_helper setBluetooth:array];
    [self updateList];
}

- (void) gotoAddBluetooth {
    AttendanceBluetoothAddViewController *vc = [[AttendanceBluetoothAddViewController alloc] init];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([BluetoothDetailTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            BluetoothDetailTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            switch(eventType) {
                case BLUETOOTH_DETAIL_TABLE_EVENT_DELETE:
                    [self updateList];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([AttendanceBluetoothAddViewController class])]) {
            NSMutableArray * array = [msg valueForKeyPath:@"result"];
            [_helper addBluetooth:array];
            _needUpdate = YES;
        }
    }
}



@end
