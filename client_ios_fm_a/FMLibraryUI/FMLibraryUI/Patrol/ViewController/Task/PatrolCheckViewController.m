//
//  PatrolCheckViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolCheckViewController.h"
#import "PatrolTaskItemView.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "PatrolTaskSpotItemView.h"
#import "SpotContentItemView.h"
#import "QuestionView.h"
#import "FMUtils.h"
#import "BaseBundle.h"
 
#import "FMUtils.h"
#import "SeperatorView.h"
#import "PhotoItem.h"
#import "SystemConfig.h"
#import "DXAlertView.h"
#import "UIButton+Bootstrap.h"
#import "FeedbackViewController.h"
#import "PhotoShowHelper.h"
#import "SeperatorTableViewCell.h"
#import "CameraHelper.h"

#import "PatrolServerConfig.h"
#import "ToggleItemView.h"
//#import "IQKeyboardManager.h"


@interface PatrolCheckViewController () <OnMessageHandleListener>
@property (readwrite, nonatomic, assign) CGFloat itemHeight;    //列表项高度
@property (readwrite, nonatomic, assign) CGFloat controlHeight; //按钮区高度

@property (readwrite, nonatomic, strong) ToggleItemView * statusSwitchView; //状态开关
@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UIView * mainControlView;
//@property (readwrite, nonatomic, strong) UILabel * exceptionStatusLbl;  //异常状态提示标签
@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) UIButton* previousBtn;
@property (readwrite, nonatomic, strong) UIButton* nextBtn;

@property (readwrite, nonatomic, strong) DBPatrolSpot * spot;
@property (readwrite, nonatomic, strong) NSMutableArray * devArray;
@property (readwrite, nonatomic, strong) NSMutableArray * contentArray;
@property (readwrite, nonatomic, assign) NSInteger curIndex;
@property (readwrite, nonatomic, assign) NSInteger curContentIndex; //当前拍照的巡检项位置

@property (readwrite, nonatomic, strong) NSMutableArray * tmpImgPathArray;   //图片数组，存储名字

@property (readwrite, nonatomic, assign) BOOL isBackFromCommentEdit;
@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;

@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;
@property (readwrite, nonatomic, strong) CameraHelper * cameraHelper;

@property (readwrite, nonatomic, assign) CGFloat paddingTop; //
@property (readwrite, nonatomic, assign) CGFloat toggleHeight; //开关高度
//@property (readwrite, nonatomic, assign) CGFloat exceptionStatusHeight; //异常状态提示高度
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL showOneDevice; // 只显示一个设备，不显示上一项和下一项按钮

@end

@implementation PatrolCheckViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    
    NSNumber * userId = [SystemConfig getUserId];
    
    /* 综合巡检 */
    DBPatrolDevice * equip = _devArray[[self getShowIndex:_curIndex]];
    if (equip.deviceId && [equip.deviceId isEqualToNumber:@0]) {
        
        _contentArray = [_dbHelper queryAllDBSpotCheckContentOfDevice:equip.id andUserId:userId];
        _toggleHeight = 0;
        _paddingTop = 0;
    }
    /* 停机 */
    else if (equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_ITEM_CONTENT_VALID_STATUS_STOP) {
        
        _contentArray = [_dbHelper queryAllDBSpotCheckContentOfDevice:equip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_STOP andUserId:userId];
        _toggleHeight = 50;
        _paddingTop = 10;
    }
    /* 正常 */
    else {
        
        _contentArray = [_dbHelper queryAllDBSpotCheckContentOfDevice:equip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_WORKING andUserId:userId];
        _toggleHeight = 50;
        _paddingTop = 10;
    }
    
    [self saveDefaultValue];
    NSString* title = [[NSString alloc] initWithFormat:@"%@", equip.name];
    if([equip.deviceId longValue] != 0) {
        title = [[NSString alloc] initWithFormat:@"%@ * %@", equip.code, equip.name];
    } else {
        title = [[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive" inTable:nil];
    }
    [self setTitleWith:title];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _paddingTop = 10;
    _itemHeight = 200;
    _controlHeight = [FMSize getInstance].bottomControlHeight;
    _dbHelper = [PatrolDBHelper getInstance];
    _toggleHeight = 50;
    
    [self getDataFromDB];
    [self updateTitle];
    [self initUI];
    
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
    
    [self initCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateList];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveCurSpotContent];
}

- (void) initUI {
    
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
//    _exceptionStatusHeight = 40;
    
    CGFloat padding = [FMSize getSizeByPixel:20];
    CGFloat paddingTop = [FMSize getSizeByPixel:30];
    
    CGFloat controlHeight = [FMSize getInstance].bottomControlHeight;  //52
    CGFloat btnHeight = controlHeight - paddingTop - [FMSize getSizeByPixel:20];  //40
    
    CGFloat orginX = padding;
    CGFloat originY = paddingTop;
    
    CGFloat btnWidth = 0;
//    CGFloat btnPadding = (controlHeight - btnControlHeight) / 2;
    
    
    if(!_devArray) {
        _devArray = [_dbHelper queryAllDBPatrolDevicesOfSpot:_spot.id];
    }
    NSInteger count = [_devArray count];
    DBPatrolDevice * equip = _devArray[[self getShowIndex:_curIndex]];
    
    if(!_tableView) {
        
        _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        _mainContainerView = [[UIView alloc] init];
        _mainControlView = [[UIView alloc] init];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
        
        _statusSwitchView = [[ToggleItemView alloc] init];
        [_statusSwitchView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_operate_placeholder" inTable:nil]];
        [_statusSwitchView setPadding:paddingLeft];
        [_statusSwitchView setStatus:NO];
        [_statusSwitchView setShowBottomSeperator:YES];
        [_statusSwitchView setNameFont:[FMFont fontWithSize:15]];
        _statusSwitchView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_statusSwitchView setOnValueChangedListener:self];
        
//        if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
//            statusHeight = _exceptionStatusHeight;
//        }
//        _exceptionStatusLbl = [[UILabel alloc] init];
//        [_exceptionStatusLbl setFont:[FMFont fontWithSize:11]];
//        [_exceptionStatusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
//        [_exceptionStatusLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_notice_equipment_exception_status_stop" inTable:nil]];
        
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_mainContainerView addSubview:_statusSwitchView];
//        [_mainContainerView addSubview:_exceptionStatusLbl];
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_mainControlView];
        [self.view addSubview:_mainContainerView];
    }
    
    /* 综合巡检 */
    _statusSwitchView.hidden = equip.deviceId && [equip.deviceId isEqualToNumber:@0];
    
    _mainContainerView.frame = frame;
    _mainControlView.frame = CGRectMake(0, _realHeight-_controlHeight, _realWidth, _controlHeight);
    CGFloat topY = _paddingTop;
    _statusSwitchView.frame = CGRectMake(0, topY, _realWidth, _toggleHeight);
    topY += _toggleHeight + _paddingTop;
    _tableView.frame = CGRectMake(0, topY, _realWidth, _realHeight-controlHeight-topY);
//    _exceptionStatusLbl.frame = CGRectMake(paddingLeft, originY, _realWidth-paddingLeft*2, statusHeight);
    
    if(_curIndex == count-1 || _showOneDevice) {      //最后一项
        
        if (count == 1 || _showOneDevice) {
            
            btnWidth = _realWidth - padding * 2;
            if(!_nextBtn) {
                _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
                [_nextBtn successStyle];
                //                [_nextBtn setBackgroundColor:[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                [_mainControlView addSubview:_nextBtn];
            } else {
                [_nextBtn setFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
            }
            if(_previousBtn) {
                [_previousBtn setHidden:YES];
            }
            [_nextBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil] forState:UIControlStateNormal];
            [_nextBtn removeTarget:self action:@selector(showNextItem) forControlEvents:UIControlEventTouchUpInside];
            [_nextBtn addTarget:self action:@selector(finishChecking) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(count > 1) {
            btnWidth = (_realWidth - padding * 3)/2;
            if(!_previousBtn) {
                _previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
                [_previousBtn successStyle];
//                [_previousBtn setBackgroundColor:[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                [_mainControlView addSubview:_previousBtn];
                [_previousBtn addTarget:self action:@selector(showPreviousItem) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [_previousBtn setFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
                [_previousBtn setHidden:NO];
            }
            [_previousBtn setTitle:[self getPreviousTitle] forState:UIControlStateNormal];
            
            
            if(!_nextBtn) {
                _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX + btnWidth + padding, originY, btnWidth, btnHeight)];
                [_nextBtn successStyle];
//                [_nextBtn setBackgroundColor:[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                [_mainControlView addSubview:_nextBtn];
            } else {
                [_nextBtn setFrame:CGRectMake(orginX + btnWidth + padding, originY, btnWidth, btnHeight)];
            }
            [_nextBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil] forState:UIControlStateNormal];
            [_nextBtn removeTarget:self action:@selector(showNextItem) forControlEvents:UIControlEventTouchUpInside];
            [_nextBtn addTarget:self action:@selector(finishChecking) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if(_curIndex == 0) {     //第一项
        btnWidth = _realWidth - padding * 2;
        if(!_nextBtn) {
            _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
            [_nextBtn successStyle];
//            [_nextBtn setBackgroundColor:[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
            [_mainControlView addSubview:_nextBtn];
        } else {
            [_nextBtn setFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
        }
        if(_previousBtn) {
            [_previousBtn setHidden:YES];
        }
        [_nextBtn setTitle:[self getNextTitle] forState:UIControlStateNormal];
        [_nextBtn removeTarget:self action:@selector(finishChecking) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(showNextItem) forControlEvents:UIControlEventTouchUpInside];
        
    } else if(_curIndex > 0 && _curIndex < count - 1){  //中间的项
        btnWidth = (_realWidth - padding * 3)/2;
        if(!_previousBtn) {
            _previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
            [_previousBtn successStyle];
//            [_previousBtn setBackgroundColor:[[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
            [_mainControlView addSubview:_previousBtn];
            [_previousBtn addTarget:self action:@selector(showPreviousItem) forControlEvents:UIControlEventTouchUpInside];
            [_previousBtn setTitle:[self getPreviousTitle] forState:UIControlStateNormal];
        } else {
            [_previousBtn setFrame:CGRectMake(orginX, originY, btnWidth, btnHeight)];
            [_previousBtn setHidden:NO];
        }
        [_previousBtn setTitle:[self getPreviousTitle] forState:UIControlStateNormal];
        
        if(!_nextBtn) {
            _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX + btnWidth + padding, originY, btnWidth, btnHeight)];
            [_nextBtn successStyle];
            [_mainControlView addSubview:_nextBtn];
        } else {
            [_nextBtn setFrame:CGRectMake(orginX + btnWidth + padding, originY, btnWidth, btnHeight)];
        }
        [_nextBtn setTitle:[self getNextTitle] forState:UIControlStateNormal];
        [_nextBtn removeTarget:self action:@selector(finishChecking) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(showNextItem) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self updateExceptionSatusNotice];
    [self updateList];
}

- (void) updateList {
    [_tableView reloadData];
}

- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
    [self updateList];
}

////更新异常提示标签显示
//- (void) updateExceptionSatusNotice {
//    DBPatrolDevice * equip = _devArray[[self getShowIndex:_curIndex]];
//    CGFloat statusHeight = 0;
//    CGFloat padding = [FMSize getInstance].defaultPadding;
//    if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
//        statusHeight = _exceptionStatusHeight;
//        [_exceptionStatusLbl setHidden:NO];
//        
//        [_statusSwitchView setStatus:YES];
//    } else {
//        [_exceptionStatusLbl setHidden:YES];
//        [_statusSwitchView setStatus:NO];
//    }
//    CGFloat originY = 0;
//    if(equip.deviceId && equip.deviceId.integerValue > 0) {
//        [_exceptionStatusLbl setHidden:NO];
//        originY = _paddingTop + _toggleHeight;
//        [_exceptionStatusLbl setFrame:CGRectMake(padding, originY, _realWidth-padding*2, statusHeight)];
//        originY += statusHeight;
//        if(statusHeight == 0) {
//            originY += _paddingTop;
//        }
//    } else {
//        [_exceptionStatusLbl setHidden:YES];
//    }
//    
//    [_tableView setFrame:CGRectMake(0, originY, _realWidth, _realHeight-_controlHeight-originY)];
//}


/**
 更新异常提示标签显示
 */
- (void)updateExceptionSatusNotice {
    
    DBPatrolDevice * equip = _devArray[[self getShowIndex:_curIndex]];
    if(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
        
        [_statusSwitchView setStatus:YES];
    }
    else {
        
        [_statusSwitchView setStatus:NO];
    }
}


- (void) updateListByPosition:(NSInteger) position {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:position inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) updateContent {
    
}


//获取前一项索引
- (NSString *) getPreviousTitle {
    NSString * res = @"";
    NSString * indexDesc = @"";
    if(_curIndex > 0) {
        indexDesc = [[NSString alloc] initWithFormat:@"(%ld/%ld)", (_curIndex),[_devArray count]];
    }
    res = [[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"btn_title_previous_item" inTable:nil], indexDesc];
    return res;
}
//获取后一项索引
- (NSString *) getNextTitle {
    NSString * res = @"";
    NSString * indexDesc = @"";
    if(_curIndex >= 0 && _curIndex < [_devArray count] - 1) {
        indexDesc = [[NSString alloc] initWithFormat:@"(%ld/%ld)", (_curIndex+2),[_devArray count]];
    }
    res = [[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"btn_title_next_item" inTable:nil], indexDesc];
    return res;
}

- (void)setShowOneDevice:(BOOL)showOneDevice {
    
    _showOneDevice = showOneDevice;
}

- (void) showPreviousItem {
    [self finishCurrentItems];
    
    _curIndex -= 1;
    [self updateTitle];
    [self initUI];
}

- (void) showNextItem {
    [self finishCurrentItems];
    _curIndex += 1;
    [self updateTitle];
    [self initUI];
}

//把当前的项置为已完成状态
- (void) finishCurrentItems {
    [self saveCurSpotContent];
}

- (void) markSpotFinish {
    _spot.markFinish = [NSNumber numberWithBool:YES];
}

- (void) finishChecking {
    [self finishCurrentItems];
    [self markSpotFinish];
    [self checkAndSaveSpotFinishStatus];
    [self finish];
}


- (void) initCamera {
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self markEquipment];   //标记设备为正常或者已停机
    }
}


- (void) setPatrolTaskSpot:(DBPatrolSpot *) spot withPosition:(NSInteger)position{
    _spot = spot;
    NSInteger count = _spot.spotCheckNumber.integerValue + _spot.deviceCheckNumber.integerValue;
    if(position >= 0 && position < count) {
        _curIndex = position;
    } else {
        _curIndex = 0;
    }
}

//根据需要计算展示数据的真实位置，因为综合巡检的位置不定
- (NSInteger) getShowIndex:(NSInteger) index {
    NSInteger res = index;
    NSInteger i = 0;
    BOOL flag = NO;     //是否有综合项
    if(_devArray) {
        for(DBPatrolDevice * equip in _devArray) {
            if([equip.deviceId longValue] == 0) {     //点位的综合项
                flag = YES;
                break;
            }
            i++;
        }
        if(flag) {
            if(index == 0) {
                res = i;
            } else if (index > 0) {
                if(index <= i) {
                    res = index - 1;
                }
            }
        }
    }
    return res;
}

- (void) getDataFromDB {
    if(_spot) {
        _devArray = [_dbHelper queryAllDBPatrolDevicesOfSpot:_spot.id];
    }
    [self markSpotCheckBegin];
}

- (void) saveDefaultValue {
    NSInteger count = 0;
    BOOL valueChanged = NO;
    if(_contentArray && [_contentArray count] > 0) {
        NSInteger position = 0;
        NSString * content;
        
        count = [_contentArray count];
        for(position = 0; position < count;position++) {
            DBSpotCheckContent * item = _contentArray[position];
            NSInteger valueType = [item.resultType integerValue];
            NSArray * selectValueArray;
            if(valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
                 selectValueArray = [item.selectEnum componentsSeparatedByString:@","];
            }
            if(valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
                if(![FMUtils isStringEmpty:item.resultSelect]) {
                    content = item.resultSelect;
                } else {
                    valueChanged = YES;
                    content = item.defaultSelectValue;
                }
                if([FMUtils isStringEmpty:content]) {
                    if(selectValueArray && [selectValueArray count] > 0) {
                        content = selectValueArray[0];
                        valueChanged = YES;
                    }
                }
                item.resultSelect = content;
                [_dbHelper updateSpotCheckContentById:item.id checkContent:item];
            } else if(valueType == QUESTION_VIEW_VALUE_TYPE_INPUT){
                if(![FMUtils isStringEmpty:item.resultInput]) {
                    content = [item.resultInput copy];
                } else {
                    if(![FMUtils isNumberNullOrZero:item.defaultInputValue]) {
                        content = item.defaultInputValue.description;
                    } else {
                        content = @"0";
                    }
                    item.resultInput = content;
                    valueChanged = YES;
                    [_dbHelper updateSpotCheckContentById:item.id checkContent:item];
                }
            }
        }
    }
    if(valueChanged) {
        [self markTaskUnSyned];
    }
}

- (BOOL) isSpotCheckContentException:(DBSpotCheckContent *) spotContent {
    BOOL res = NO;
    
    if([spotContent.resultType integerValue] == QUESTION_VIEW_VALUE_TYPE_INPUT) {  //输入
        NSNumber * tmpNumber = [FMUtils stringToNumber:spotContent.resultInput];
        if([tmpNumber compare:spotContent.inputFloor] == NSOrderedAscending || [tmpNumber compare:spotContent.inputUpper] == NSOrderedDescending) {
            res = YES;
        }
    } else if([spotContent.resultType integerValue] == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {   //选择
        NSArray * valArray = [spotContent.selectRightValue componentsSeparatedByString:@","];
        res = YES;
        for(NSString * val in valArray) {
            if([spotContent.resultSelect compare:val] == NSOrderedSame) {
                res = NO;
                break;
            }
        }
    }
    return res;
}

//标记设备为已停机或者正常
- (void) markEquipment {
    NSInteger position = [self getShowIndex:_curIndex];
    DBPatrolDevice * equip = _devArray[position];

    if(!equip.exceptionStatus || equip.exceptionStatus.integerValue != PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {    //如果不是已停机就标记为已停机
        equip.exceptionStatus = [NSNumber numberWithInteger:PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP];
        equip.exceptionDesc = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_mark_stop" inTable:nil];
        _devArray[position] = equip;
    } else {
        equip.exceptionStatus  = nil;
        equip.exceptionDesc = nil;
        _devArray[position] = equip;
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
    [self markSpotCheckBegin];
    [self checkAndSaveSpotFinishStatus];    //更新点位的完成状态
    [self updateTitle];
    [self updateExceptionSatusNotice];
}

//如果必要的话标记当前点位处于开始检查状态
- (void) markSpotCheckBegin {
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

//保存当前巡检设备的 巡检项的值
- (void) saveCurSpotContent {
    if(_contentArray && [_contentArray count] > 0) {
        DBPatrolDevice * dbDev = _devArray[[self getShowIndex:_curIndex]];
        BOOL isException = NO;
        for(DBSpotCheckContent * spotContent in _contentArray) {
            if(!isException) {
                isException = [self isSpotCheckContentException:spotContent];
            }
            [_dbHelper updateSpotCheckContentById:spotContent.id checkContent:spotContent];
        };
        dbDev.finish = [NSNumber numberWithBool:YES];
        dbDev.exception = [NSNumber numberWithBool:isException];
        [_dbHelper updatePatrolDeviceById:dbDev.id patrolDevice:dbDev];
    }
    if(_devArray && [_devArray count] > 0) {
        BOOL isException = NO;
        for(DBPatrolDevice * dev in _devArray) {
            isException = isException || dev.exception.boolValue;
        }
        _spot.exception = [NSNumber numberWithBool:isException];
//        if(!_spot.edit) {
//            _spot.edit = [NSNumber numberWithBool:NO];
//            NSNumber * taskId = _spot.patrolTaskId;
//            NSNumber * userId = [SystemConfig getUserId];
//            DBPatrolTask * task = [_dbHelper queryDBPatrolTaskById:taskId andUserId:userId];
//            if(!task.edit || task.edit.boolValue) {
//                task.edit = [NSNumber numberWithBool:NO];
//                [_dbHelper updatePatrolTaskById:taskId userId:[SystemConfig getUserId] patrolTask:task];
//            }
//        }
        [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
    }
}

//保存点位和任务的完成状态
- (void) checkAndSaveSpotFinishStatus {
    if(_devArray && [_devArray count] > 0) {
        BOOL isFinish = NO;
        if(_spot.markFinish.boolValue) {
            isFinish = YES;
            for(DBPatrolDevice * dev in _devArray) {
                isFinish = isFinish && dev.finish.boolValue;    //已完成
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
    
//    DBPatrolDevice * equip = _devArray[[self getShowIndex:_curIndex]];
//    return equip.checkNumber.integerValue;
    
    return _contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSNumber * userId = [SystemConfig getUserId];
    CGFloat width = CGRectGetWidth(tableView.frame);
    DBSpotCheckContent * item;
    NSMutableArray * dbimgs;
    if(position >= 0 && position < [_contentArray count]) {
        item = _contentArray[position];
    }
    CGFloat height = _itemHeight;
    NSInteger count = 0;
    if (item) {
        dbimgs = [_dbHelper queryAllPictureOfSpotCheckContent:item.id andUserId:userId];
        NSInteger valueType = [item.resultType integerValue];
        if(valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
            NSArray * selectValueArray = [item.selectEnum componentsSeparatedByString:@","];
            count = [selectValueArray count];
        }
        height = [QuestionView getMinHeightByTitle:item.content andDesc:item.comment andWidth:width photoCount:[dbimgs count] andSelectValueCount:count];
    }
    return height + 10;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier=@"Cell";
    SeperatorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    QuestionView * itemView = nil;
    DBSpotCheckContent * item;
    if(position >= 0 && position < [_contentArray count]) {
        item = _contentArray[position];
    }
    NSNumber * userId = [SystemConfig getUserId];
    NSMutableArray * dbimgs = [_dbHelper queryAllPictureOfSpotCheckContent:item.id andUserId:userId];
    NSMutableArray * imgs = [[NSMutableArray alloc] init];
    for(DBSpotCheckContentPicture * pic in dbimgs) {    //TODO:可能会崩溃
        if(pic.url) {
            [imgs addObject:pic.url];
        }
    }
    CGFloat height = _itemHeight;
    CGFloat width = CGRectGetWidth(self.view.frame);
    NSInteger count = 0;
    NSInteger valueType = [item.resultType integerValue];
    NSArray * selectValueArray;
    NSString * content = @"";
    //        NSString * title = [[NSString alloc] initWithFormat:@"%d. %@", (position+1), item.content];
    NSString * title = item.content;
    if(valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
        selectValueArray = [item.selectEnum componentsSeparatedByString:@","];
        count = [selectValueArray count];
    }
    
    height = [QuestionView getMinHeightByTitle:title andDesc:item.comment andWidth:width photoCount:[dbimgs count] andSelectValueCount:count];
    
    if(!cell) {
        cell = [[SeperatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeperatorHeight:10];
    } else {
        NSArray * subViews = [cell subviews];
        for(id subView in subViews) {
            if([subView isKindOfClass:[QuestionView class]]) {
                itemView = subView;
                break;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[QuestionView alloc] init];
        [itemView setShowBound:YES];
        itemView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [itemView setOnMessageHandleListener:self];
        [cell addSubview:itemView];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, height)];
        itemView.tag = position;
       
        
        if(valueType == QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT) {
            if(![FMUtils isStringEmpty:item.resultSelect]) {
                content = item.resultSelect;
            } else {
                content = item.defaultSelectValue;
            }
            if([FMUtils isStringEmpty:content] && count > 0) {
                content = selectValueArray[0];
            }
            item.resultSelect = content;
        } else if(valueType == QUESTION_VIEW_VALUE_TYPE_INPUT){
            if(![FMUtils isStringEmpty:item.resultInput]) {
                content = [item.resultInput copy];
            } else {
                if(![FMUtils isNumberNullOrZero:item.defaultInputValue]) {
                    content = item.defaultInputValue.description;
                } else {
                    content = @"0";
                }
                
                item.resultInput = [content copy];
            }
        }

        [itemView setInfoWithtitle:title
                          valueType:valueType
                            content:content
                    valuesForSelect:selectValueArray
                               desc:item.comment
                          imageUrls:imgs];
        
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
}


#pragma - 填写说明
- (void)editDesc:(NSInteger) position {
    QuestionEditViewController * editVC = [[QuestionEditViewController alloc] init];
    DBSpotCheckContent * item = _contentArray[position];
    NSString * desc = item.comment;
    [editVC setContent:desc exceptions:item.exceptions withTag:position];
    [editVC setOnQuestionEditFinishedListener:self];
    [self gotoViewController:editVC];
}

- (void) onQuestionEditFinishedWithTag:(NSInteger)tag andDesc:(NSString *)desc {
    DBSpotCheckContent * item = _contentArray[tag];
    item.comment = desc;
    [_dbHelper updateSpotCheckContentById:item.id checkContent:item];
    _isBackFromCommentEdit = YES;
    [self markTaskUnSyned];
}

- (void) markTaskUnSyned {
    NSNumber * taskId = _spot.patrolTaskId;
    NSNumber * userId = [SystemConfig getUserId];
    DBPatrolTask * task = [_dbHelper queryDBPatrolTaskById:taskId andUserId:userId];
    if(!_spot.edit || _spot.edit.boolValue) {   //如果任务还未开始修改，标记为待同步状态
        _spot.edit = [NSNumber numberWithBool:NO];
        [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
    }
    if(!task.edit || task.edit.boolValue) {
        task.edit = [NSNumber numberWithBool:NO];
        [_dbHelper updatePatrolTaskById:taskId userId:[SystemConfig getUserId] patrolTask:task];
    }
    
    //如果是已经完成的，就更新下完成时间
    if(_spot.finishEndDateTime && ![_spot.finishEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        _spot.finishEndDateTime = [FMUtils getTimeLongNow];
        [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
        if(task.finishEndDate && ![task.finishEndDate isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            task.finishEndDate = [FMUtils getTimeLongNow];
        }
    }
}


//删除图片

- (void) tryToDeletePhoto:(NSInteger) position index:(NSInteger) picIndex {
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_photo_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
    [alert showIn:self];
    alert.leftBlock = ^() {
        DBSpotCheckContent * item = _contentArray[position];
        NSNumber * userId = [SystemConfig getUserId];
        NSMutableArray * dbimgs = [_dbHelper queryAllPictureOfSpotCheckContent:item.id andUserId:userId];
        DBSpotCheckContentPicture * dbPic = dbimgs[picIndex];
        NSNumber * imgId = dbPic.id;
        [_dbHelper deleteSpotCheckContentPictureById:imgId];
        [self markTaskUnSyned];
        [self updateList];
    };
    alert.rightBlock = ^() {
    };
    alert.dismissBlock = ^() {
    };
}


- (void) takePhoto {
    NSString * marker = _spot.name;
    [_cameraHelper getPhotoWithWaterMark:marker];
}


-(void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([QuestionView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            NSMutableDictionary * dict;
            NSMutableArray * array;
            DBSpotCheckContent * item;
            QuestionViewEventType eventType = tmpNumber.integerValue;
            NSInteger tag;
            NSString * tmpStr;
            switch(eventType) {
                case QUESTION_VIEW_EVENT_EDIT:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    [self editDesc:tmpNumber.integerValue];
                    break;
                case QUESTION_VIEW_EVENT_TAKE_PHOTO:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    _curContentIndex = tmpNumber.integerValue;
                    [self takePhoto];
                    break;
                case QUESTION_VIEW_EVENT_VALUE_CHANGE_INPUT:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    tag = tmpNumber.integerValue;
                    item = _contentArray[tag];
                    tmpStr  = [msg valueForKeyPath:@"result"];
                    if([FMUtils isFloatNumber:tmpStr]) {
                        item.resultInput = tmpStr;
                        [self markTaskUnSyned];
                    } else {
                        NSLog(@"数据输入出错。");
                        [self updateListByPosition:tag];
                    }
                    break;
                case QUESTION_VIEW_EVENT_VALUE_CHANGE_SINGLE_SELECT:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    tag = tmpNumber.integerValue;
                    item = _contentArray[tag];
                    item.resultSelect = [msg valueForKeyPath:@"result"];
                    [self markTaskUnSyned];
                    break;
                case QUESTION_VIEW_EVENT_VALUE_CHANGE_COMMENT:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    tag = tmpNumber.integerValue;
                    item = _contentArray[tag];
                    item.comment = [msg valueForKeyPath:@"result"];
                    [self markTaskUnSyned];
                    break;
                case QUESTION_VIEW_EVENT_SHOW_PHOTO:
                    dict = [msg valueForKeyPath:@"result"];
                    tmpNumber = [dict valueForKeyPath:@"position"];
                    array = [dict valueForKeyPath:@"photosArray"];
                    [_photoHelper setPhotos:array];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case QUESTION_VIEW_EVENT_DELETE_PHOTO:
                    tmpNumber = [msg valueForKeyPath:@"tag"];
                    tag = tmpNumber.integerValue;
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [self tryToDeletePhoto:tag index:tmpNumber.integerValue];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
            NSArray *imgPaths = [msg valueForKeyPath:@"result"];
            
            NSNumber *userId = [SystemConfig getUserId];
            DBSpotCheckContent *content = _contentArray[_curContentIndex];
            for (NSString *path in imgPaths) {
                [_dbHelper addSpotCheckContentPicture:path withSpotContentId:content.spotCheckContentId andContentId:content.id andUserId:userId];
            }
            
//            if(!_tmpImgPathArray) {
//                _tmpImgPathArray = [[NSMutableArray alloc] init];
//            }
//            [_tmpImgPathArray addObject:imgPath];
            [self markTaskUnSyned];
            [self updateList];
        } else if([strOrigin isEqualToString:NSStringFromClass([_statusSwitchView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"eventData"];
            BOOL checked = tmpNumber.boolValue;
            [self markEquipment];
        }
    }
}

#pragma --- 键盘的显示与隐藏
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    if(keyboardSize.height > 0) {
//        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//            CGRect frame = CGRectMake(0, 0, _realWidth, _realHeight-keyboardSize.height);
//            _tableView.frame = frame;
//            
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//        _tableView.frame = CGRectMake(0, 0, _realWidth, _realHeight);
//    }];
//}

@end
