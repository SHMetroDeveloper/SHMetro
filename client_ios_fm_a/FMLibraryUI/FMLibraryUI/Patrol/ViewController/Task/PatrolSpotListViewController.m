//
//  PatrolSpotListViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolSpotListViewController.h"
#import "PatrolDBHelper.h"
#import "PatrolSpotsListHelper.h"
#import "PatrolSpotViewController.h"
#import "BaseBundle.h"

#import "OnMessageHandleListener.h"

#import "SystemConfig.h"
#import "FMColor.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "UserBusiness.h"
#import "AttendanceRecordEntity.h"
#import "BaseDataDbHelper.h"

@interface PatrolSpotListViewController () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * spotTableView;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;       //提示标签
@property (readwrite, nonatomic, assign) CGFloat noticeWidth;       //提示标签宽度
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (readwrite, nonatomic, strong) NSMutableArray * spotArray;

@property (readwrite, nonatomic, strong) NSString * spotCode;

@property (nonatomic, strong) NSNumber * spotId;
@property (nonatomic, strong) NSString * spotName;
@property (nonatomic, strong) NSNumber * buildingId;
@property (nonatomic, strong) NSString * buildingName;
@property (nonatomic, strong) PatrolDBHelper * dbHelper;
@property (nonatomic, strong) PatrolSpotsListHelper *listHelper;
@property (nonatomic, strong) AttendanceRecordEntity * attendanceRecord;

@end

@implementation PatrolSpotListViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    
    if([_spotArray count] > 0) {
        
        if (_spotName) {
            
            [self setTitleWith:_spotName];
        }
        else if (_buildingName) {
            
            [self setTitleWith:_buildingName];
        }
    }
    else {
        
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_patrol_spot_list" inTable:nil]];
    }
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 请求最后一次签到记录 */
    [self requestLastRecord];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _dbHelper = [PatrolDBHelper getInstance];
        _listHelper = [[PatrolSpotsListHelper alloc] init];
        [_listHelper setShowTask:YES];
        [_listHelper setOnMessageHandleListener:self];
        
        _noticeHeight = [FMSize getInstance].defaultNoticeHeight;
        
        CGRect frame = [self getContentFrame];
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _spotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _spotTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _spotTableView.dataSource = _listHelper;
        _spotTableView.delegate = _listHelper;
        _spotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        [_noticeLbl setHidden:YES];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        
        [_mainContainerView addSubview:_spotTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *) getSpotName {
    NSString * res = nil;
    if([_spotArray count] > 0) {
        DBPatrolSpot * spot = _spotArray[0];
        res = spot.name;
    }
    return res;
}

- (void) updateList {
    [self updateNotice];
    [_spotTableView reloadData];
}

- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void) updateNotice {
    _noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_no_task_current" inTable:nil];
    BOOL show = YES;
    if([_spotArray count] > 0) {
        show = NO;
    }
    if(show) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) setInfoWithCode:(NSString *) spotCode {
    _spotCode = spotCode;
    
}

- (void) setInfoWithSpotId:(NSNumber *)spotId spotName:(NSString *)spotName {
    
    _spotId = spotId;
    _spotName = spotName;
}

- (void) setInfoWithBuildingId:(NSNumber *)buildingId buildingName:(NSString *)buildingName {
    
    _buildingId = buildingId;
    _buildingName = buildingName;
}


/**
 请求点位数据
 */
- (void) requestData {
    
    NSNumber * userId = [SystemConfig getUserId];
    NSArray * spots;
    if(!_spotArray) {
        
        _spotArray = [[NSMutableArray alloc] init];
    }
    else {
        
        [_spotArray removeAllObjects];
    }
    if(_spotId) {
        
        spots = [[PatrolDBHelper getInstance] queryAllValidDBPatrolSpotsById:_spotId andUserId:userId];
    }
    else if(_buildingId) {
        
        spots = [[PatrolDBHelper getInstance] queryAllValidDBPatrolSpotsByBuildingId:_buildingId andUserId:userId];
    }
//    else if(_spotCode) {
//         spots = [[PatrolDBHelper getInstance] queryAllValidDBPatrolSpotsByCode:_spotCode andUserId:userId];
//    }
    
    [_spotArray addObjectsFromArray:spots];
    [_listHelper setDataWithArray:_spotArray];
    [self updateTitle];
    [self updateList];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_listHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            PatrolSpotsListEventType type = [tmpNumber integerValue];
            DBPatrolSpot * spot;
            if (type == PATROL_SPOTS_LIST_SHOW_DETAIL) {
                
                spot = [result valueForKeyPath:@"eventData"];
                if(spot.finish) {
                    
                    /* 判断是否签到 */
                    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
                    if (user && [user.type isEqualToNumber:@(USER_TYPE_OUTSOURCE)] && ![self canHandleSpot:spot]) {
                        
                        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_need_check" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    }
                    else {
                        
                        [self gotoSpotDetail:spot];
                    }
                }
            }
        }
    }
}


/**
 请求最后一次签到记录
 */
- (void)requestLastRecord {
    
    [[UserBusiness getInstance] getLastAttendanceRecordSuccess:^(NSInteger key, id object) {
        
        _attendanceRecord = object;
        
    } fail:^(NSInteger key, NSError *error) {
        
        DLog(@"请求签到记录失败");
    }];
}


/**
 判断是否允许处理点位

 @param spot 点位
 @return 是否允许
 */
- (BOOL)canHandleSpot:(DBPatrolSpot *)spot {
    
    BOOL res = NO;
    if(_attendanceRecord) {
        
        if(spot) {
            
            Position * pos = [[Position alloc] init];
            pos.buildingId = spot.buildingId;
            pos.floorId = spot.floorId;
            pos.roomId = spot.roomId;
            
            /* 如果点位属于签到站点 */
            if([pos isBelongTo:_attendanceRecord.location]) {
                
                res = YES;
            }
        }
    }
    return res;
}


//跳转点位详情
- (void) gotoSpotDetail:(DBPatrolSpot *) spot {
    PatrolSpotViewController * spotVC = [[PatrolSpotViewController alloc] init];
    [spotVC setPatrolSpot:spot];
    [self gotoViewController:spotVC];
}

@end
