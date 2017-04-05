//
//  PatrolSpotViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolSpotViewController.h"
#import "PatrolTaskItemView.h"
#import "FMTheme.h"
#import "PatrolTaskSpotItemView.h"
#import "SpotContentItemView.h"
#import "PatrolCheckViewController.h"
#import "BaseBundle.h"
 
#import "SeperatorView.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "UIButton+Bootstrap.h"
#import "SystemConfig.h"
#import "PatrolServerConfig.h"
#import "PhotoShowHelper.h"


@interface PatrolSpotViewController ()
@property (readwrite, nonatomic, assign) CGFloat itemHeight;


@property (readwrite, nonatomic, strong) UITableView * tableView;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) NSMutableArray* mDeviceEquipments;
@property (readwrite, nonatomic, strong) DBPatrolDevice * mSpotCheckContent;

//@property (readwrite, nonatomic, strong) UIButton* checkBtn;

@property (readwrite, nonatomic, strong) DBPatrolSpot * spot;

@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;

@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;
@end


@implementation PatrolSpotViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initUI {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);

    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
//    _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, height-controlHeight, width-orginX*2, btnControlHeight)];
//    [_checkBtn primaryStyle];
//    [_checkBtn setTitle:@"开始检查" forState:UIControlStateNormal];
//    [_checkBtn addTarget:self action:@selector(beginCheck) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainContainerView addSubview:_tableView];
//    [_mainContainerView addSubview:_checkBtn];
    
    [self.view addSubview:_mainContainerView];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _itemHeight = 80;
    _dbHelper = [PatrolDBHelper getInstance];
    [self initUI];
    [self getDataFromDB];
}

- (void) initNavigation {
    [self setTitleWith:_spot.name];
    [self setBackAble:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateList];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(_spot.finish && _spot.finish.boolValue) {
        if(!_spot.finishEndDateTime || [_spot.finishEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            _spot.finishEndDateTime = [FMUtils getTimeLongNow];
            [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
        }
    }
}

- (void) finish {
    [super finish];
}

- (void) setPatrolSpot:(DBPatrolSpot *) spot {
    _spot = spot;
}

- (void) getDataFromDB {
    if(_spot) {
        _mSpotCheckContent = nil;
        if(!_mDeviceEquipments) {
            _mDeviceEquipments = [[NSMutableArray alloc] init];
        } else {
            [_mDeviceEquipments removeAllObjects];
        }
        NSMutableArray * resultArray = [_dbHelper queryAllDBPatrolDevicesOfSpot:_spot.id];
        if(resultArray && [resultArray count] > 0) {
            for(DBPatrolDevice * obj in resultArray) {
                if([obj.deviceId integerValue] == 0) {
                    _mSpotCheckContent = obj;
                } else {
                    [_mDeviceEquipments addObject:obj];
                }
            }
        }
        
    }
}

//如果必要的话标记当前点位处于开始检查状态
- (void) markTaskStart {
    if(_spot && (!_spot.finishStartDateTime || [_spot.finishStartDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]])) {
        _spot.finishStartDateTime = [FMUtils getTimeLongNow];
        [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
        
        NSNumber * userId = [SystemConfig getUserId];
        DBPatrolTask * task = [_dbHelper queryDBPatrolTaskById:_spot.patrolTaskId andUserId:userId];
        if(task && (!task.finishStartDate || [task.finishStartDate isEqualToNumber:[NSNumber numberWithLongLong:0]])) {
            task.finishStartDate = [_spot.finishStartDateTime copy];
            [_dbHelper updatePatrolTaskById:_spot.patrolTaskId userId:[SystemConfig getUserId] patrolTask:task];
        }
    }
}


- (void) updateList {
    [_tableView reloadData];
}

//标记设备为已停机或者正常
- (void) markEquipment:(NSInteger) position {
    if(_mSpotCheckContent) {
        position -= 1;
    }
    if(position >= 0 && position < [_mDeviceEquipments count]) {
        [self markTaskStart];
        DBPatrolDevice * equip = _mDeviceEquipments[position];
        if(!equip.exceptionStatus || equip.exceptionStatus.integerValue != PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
            equip.exceptionStatus = [NSNumber numberWithInteger:PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP];
            equip.exceptionDesc = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_mark_stop" inTable:nil];
            _mDeviceEquipments[position] = equip;
            [self checkAndSaveSpotFinishStatus];
        } else {
            equip.exceptionStatus  = nil;
            equip.exceptionDesc = nil;
            _mDeviceEquipments[position] = equip;
        }
        [_dbHelper updatePatrolDeviceById:equip.id patrolDevice:equip];
        
        if(!_spot.edit || _spot.edit.boolValue) {   //如果任务还未开始修改，标记为待同步状态

            _spot.edit = [NSNumber numberWithBool:NO];
            [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
            
            NSNumber * patrolTaskId = _spot.patrolTaskId;
            NSNumber * userId = [SystemConfig getUserId];
            DBPatrolTask * task = [_dbHelper queryDBPatrolTaskById:patrolTaskId andUserId:userId];
            if(!task.edit || task.edit.boolValue) {
                task.edit = [NSNumber numberWithBool:NO];
                [_dbHelper updatePatrolTaskById:patrolTaskId userId:[SystemConfig getUserId] patrolTask:task];
            }
        }
        
    }
}

//保存点位和任务的完成状态
- (void) checkAndSaveSpotFinishStatus {
    if(_mDeviceEquipments && [_mDeviceEquipments count] > 0) {
        BOOL isFinish = NO;
        if(_spot.markFinish.boolValue) {
            isFinish = YES;
            for(DBPatrolDevice * dev in _mDeviceEquipments) {
                isFinish = isFinish && (dev.finish.boolValue || dev.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP);    //已完成或者已停机
            }
            _spot.finish = [NSNumber numberWithBool:isFinish];
        }
        if(!_spot.edit) {
            _spot.edit = [NSNumber numberWithBool:NO];
            NSNumber * taskId = _spot.patrolTaskId;
            NSNumber * userId = [SystemConfig getUserId];
            DBPatrolTask * task = [_dbHelper queryDBPatrolTaskById:taskId andUserId:userId];
            if(!task.edit || task.edit.boolValue) {
                task.edit = [NSNumber numberWithBool:NO];
                [_dbHelper updatePatrolTaskById:taskId userId:[SystemConfig getUserId] patrolTask:task];
            }
        }
        if(isFinish && (!_spot.finishEndDateTime || [_spot.finishEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]])) {
            _spot.finishEndDateTime = [FMUtils getTimeLongNow];
        }
        [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if(_mSpotCheckContent) {
        count += 1;
    }
    count += [self.mDeviceEquipments count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger count = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat width = self.view.frame.size.width;
    if(_mSpotCheckContent) {
        count += 1;
    }
    count += [self.mDeviceEquipments count];
    SpotContentItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat itemHeight = _itemHeight;
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[SpotContentItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]){
                seperator = view;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(cell && !itemView) {
        itemView = [[SpotContentItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(itemView) {
        
        NSNumber *userId = [SystemConfig getUserId];
        NSArray *checkList; // 检查项列表
        
        if(position == 0 && _mSpotCheckContent) {
            NSString * strState;
            if(_mSpotCheckContent.finish.boolValue) {
                strState = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
            } else {
                strState = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_incomplete" inTable:nil];
            }
            
            [itemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive" inTable:nil]
                                state:strState
                            exception:_mSpotCheckContent.exception.boolValue
                                count:_mSpotCheckContent.checkNumber.integerValue
                            showImage:YES exceptionStatus:nil];
        } else if(position < count){
            if(_mSpotCheckContent) {
                position -= 1;
            }
            
            DBPatrolDevice * equip = _mDeviceEquipments[position];
            NSString * name = [[NSString alloc] initWithFormat:@"%@(%@)", equip.name, equip.code];
            NSString * strState;
            if(equip.finish.boolValue) {
                strState = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
            } else {
                strState = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_incomplete" inTable:nil];
            }
            
            /* 查询检查项数量 */
            if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_ITEM_CONTENT_VALID_STATUS_STOP) {
                
                /* 停机 */
                checkList = [_dbHelper queryAllDBSpotCheckContentOfDevice:equip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_STOP andUserId:userId];
            }
            else {
                
                /* 正常 */
                checkList = [_dbHelper queryAllDBSpotCheckContentOfDevice:equip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_WORKING andUserId:userId];
            }
            
            [itemView setInfoWithName:name
                                state:strState
                            exception:equip.exception.boolValue
                                count:checkList.count
                            showImage:YES
                      exceptionStatus:equip.exceptionStatus];
        }
    }
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger position = indexPath.row;
    if(_mSpotCheckContent && position == 0) {   //综合巡检
        [self gotoCheck:position];
    } else {    //设备巡检
        NSInteger equipmentIndex = position;
        if(_mSpotCheckContent) {
            equipmentIndex -= 1;
        }
        DBPatrolDevice * equip = _mDeviceEquipments[equipmentIndex];
        if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
            NSString * msg = [[BaseBundle getInstance] getStringByKey:@"patrol_notice_equipment_status_exception_stop" inTable:nil];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:msg time:DIALOG_ALIVE_TIME_SHORT];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self gotoCheck:position];
            });
        } else {
            [self gotoCheck:position];
        }
    }

}

#pragma mark - TableView EditConfiguration
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    BOOL editable = YES;
    if(_mSpotCheckContent && position == 0) {
        editable = NO;
    }
    return editable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if(_mSpotCheckContent) {
        position -= 1;
    }
    DBPatrolDevice * equip = _mDeviceEquipments[position];
    NSString * operateDesc = @"";
    BOOL showRed = NO;
    if(!equip.exceptionStatus || equip.exceptionStatus.integerValue != PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
        operateDesc = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_mark_stop" inTable:nil];
        showRed = YES;
    } else {
        operateDesc = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_mark_normal" inTable:nil];
    }
    //停机操作
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:operateDesc handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSInteger pos = indexPath.row;
        [self markEquipment:pos];
        [self updateList];
    }];
    if(showRed) {
        markAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
    } else {
        markAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    }
    
    return @[markAction];
}

- (void) onButtonClick:(UIView *)parent view:(UIView *)view {
    
}

- (void) gotoCheck:(NSInteger)position {
    PatrolCheckViewController *checkVC = [[PatrolCheckViewController alloc] init];
    DBPatrolSpot *spot = _spot;
    [checkVC setPatrolTaskSpot:spot withPosition:position];
    [self gotoViewController:checkVC];
}


@end
