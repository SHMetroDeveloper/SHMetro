//
//  PatrolTaskDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskDetailViewController.h"
#import "PatrolTaskItemView.h"
#import "FMTheme.h"
#import "PatrolTaskSpotItemView.h"
#import "PatrolSpotViewController.h"
#import "BaseBundle.h"
 
#import "SeperatorView.h"
#import "CheckableButton.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "PatrolNetRequest.h"
#import "PatrolServerConfig.h"
#import "SystemConfig.h"
#import "SubmitPatrolTaskEntity.h"
#import "FileUploadService.h"
#import "BaseDataDbHelper.h"
#import "FMSize.h"
#import "DXAlertView.h"
#import "DSAlertDisplayer.h"
#import "BaseTabbarView.h"
#import "PatrolSpotsListHelper.h"
#import "PatrolBusiness.h"
#import "PatrolSpotQrcode.h"
#import "UserBusiness.h"
#import "AttendanceRecordEntity.h"


typedef NS_ENUM(NSInteger, PatrolSpotStatusKind) {
    PATROL_SPOT_STATUS_TYPE_ALL,
    PATROL_SPOT_STATUS_TYPE_FINISH,
    PATROL_SPOT_STATUS_TYPE_UNFINISH
};


@interface PatrolTaskDetailViewController () <OnItemClickListener, OnMessageHandleListener>


@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UIView * filterContainerView;  //
@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) BaseTabbarView * statusTabbar;

@property (nonatomic, strong) UIButton * syncBtn;

@property (readwrite, nonatomic, assign) CGFloat filterHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, strong) DBPatrolTask * task;

@property (readwrite, nonatomic, strong) NSMutableArray * curspotArray;    //当前要显示的点位信息数组
@property (readwrite, nonatomic, strong) NSMutableArray * spotArray;    //点位信息数组

@property (readwrite, nonatomic, strong) NSMutableArray * synSpotIdArray; //需要同步的点位的ID数组

@property (readwrite, nonatomic, strong) NSMutableArray * contentArray; //巡检项数组，用于数据同步时图片上传使用
@property (readwrite, nonatomic, assign) NSInteger contentIndex;        //
@property (readwrite, nonatomic, strong) NSMutableArray * tmpDbImageArray;

@property (readwrite, nonatomic, strong) NSMutableArray * contentIdArray;   //存储包含图片的 contentId 数组
@property (readwrite, nonatomic, strong) NSMutableDictionary * imageIdsArray;   //存储对应的图片数组

@property (readwrite, nonatomic, assign) PatrolSpotStatusKind curType;
@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;

@property (readwrite, nonatomic, assign) BOOL isBackFromQrCode;
@property (readwrite, nonatomic, strong) DBPatrolSpot* curSpot;
@property (readwrite, nonatomic, strong) PatrolSpotQrcode * spotQrcode;

@property (readwrite, nonatomic, assign) BOOL isUploading;

@property (readwrite, nonatomic, strong) PatrolSpotsListHelper * listHelper;
@property (readwrite, nonatomic, strong) PatrolBusiness * business;
@property (readwrite, nonatomic, assign) PatrolSubmitOperateType operateType;

@property (nonatomic, strong) AttendanceRecordEntity * attendanceRecord;
@end

@implementation PatrolTaskDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _listHelper = [[PatrolSpotsListHelper alloc] init];
        [_listHelper setOnMessageHandleListener:self];
        
        _business = [[PatrolBusiness alloc] init];
        
        _itemHeight = 120;
        _filterHeight = [FMSize getInstance].filterControlHeight;
        _btnWidth = [FMSize getInstance].filterBtnWidth;
        _btnHeight = [FMSize getInstance].btnHeight;
        _dbHelper = [PatrolDBHelper getInstance];
        
        _curType = PATROL_SPOT_STATUS_TYPE_ALL;
        
        _synSpotIdArray = [[NSMutableArray alloc] init];
        
        CGRect frame = [self getContentFrame];
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGFloat sepHeight = 0;
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        CGRect filterFrame = CGRectMake(0, 0, width, _filterHeight);
        _filterContainerView = [[UIView alloc] initWithFrame:filterFrame];
        _filterContainerView.backgroundColor = [UIColor whiteColor];
        
        sepHeight = (_filterHeight - _btnHeight) / 2;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        
        _statusTabbar = [[BaseTabbarView alloc] initWithFrame:CGRectMake(padding, sepHeight, width-padding*2, _btnHeight)];
        [_statusTabbar setInfoWithArray:[[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"patrol_btn_all" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_btn_finished" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_btn_unfinished" inTable:nil], nil]];
        [_statusTabbar setOnItemClickListener:self];
        
        
        SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, _filterHeight-seperatorHeight, width, seperatorHeight)];
        
        [_filterContainerView addSubview:seperator];
        [_filterContainerView addSubview:_statusTabbar];
        
        
        CGFloat btnSyncWidth = 60;
        _syncBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-padding-btnSyncWidth, height-padding-btnSyncWidth, btnSyncWidth, btnSyncWidth)];
        [_syncBtn setImage:[[FMTheme getInstance] getImageByName:@"sync_btn_normal"] forState:UIControlStateNormal];
        [_syncBtn setImage:[[FMTheme getInstance] getImageByName:@"sync_btn_highlight"] forState:UIControlStateHighlighted];
        [_syncBtn addTarget:self action:@selector(submitLocalData) forControlEvents:UIControlEventTouchUpInside];
        _syncBtn.layer.cornerRadius = btnSyncWidth/2;
        
        
        CGRect mainFrame = CGRectMake(0, _filterHeight, width, height-_filterHeight);
        
        _tableView = [[UITableView alloc] initWithFrame:mainFrame];
        _tableView.dataSource = _listHelper;
        _tableView.delegate = _listHelper;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_mainContainerView addSubview:_filterContainerView];
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_syncBtn];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initNavigation {
    NSString * title = [[BaseBundle getInstance] getStringByKey:@"patrol_task" inTable:nil];
    if(_task) {
        title = _task.patrolTaskName;
    }
    [self setTitleWith:title];
    NSArray * menuTextArray = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil], nil];
    [self setMenuWithTextArray:menuTextArray];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self requestLastRecord];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(_isBackFromQrCode) {
        _isBackFromQrCode = NO;
        [self gotoSpotView];
    } else {
        [self refreshData];
    }
}

- (void) onMenuItemClicked:(NSInteger) position {
    if(position == 0) {
        if(_isUploading) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"upload_notice_uploading" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [self gotoUploadPatrolTask];
        }
    }
}

- (void) finish {
    if(_task && (_task.finishStartDate && ![_task.finishStartDate isEqualToNumber:[NSNumber numberWithLongLong:0]]) && (!_task.finishEndDate || [_task.finishEndDate isEqualToNumber:[NSNumber numberWithLongLong:0]])) {
        _task.finishEndDate = [FMUtils getTimeLongNow];
        [_dbHelper updatePatrolTaskById:_task.patrolTaskId userId:[SystemConfig getUserId] patrolTask:_task];
    }
    [super finish];
}

- (void) setPatrolTask: (DBPatrolTask *) task {
    _task = task;
}

- (void) refreshData {
    [self getDataFromDB];
    [self updateBtntitle];
    [self updateList];
}

- (void) updateBtntitle {
    NSMutableArray * tmpArray = [[NSMutableArray alloc ] init];
    
    if(!tmpArray) {
        tmpArray = [[NSMutableArray alloc] init];
    } else {
        [tmpArray removeAllObjects];
    }
    for(DBPatrolSpot * spot in _spotArray) {
        [tmpArray addObject:spot];
    }
    NSString * statusAll = [NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"patrol_btn_all" inTable:nil],[tmpArray count]];

    
    if(!tmpArray) {
        tmpArray = [[NSMutableArray alloc] init];
    } else {
        [tmpArray removeAllObjects];
    }
    for(DBPatrolSpot * spot in _spotArray) {
        if(spot.finish.boolValue) {
            [tmpArray addObject:spot];
        }
    }
    NSString * statusFinish = [NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"patrol_btn_finished" inTable:nil],[tmpArray count]];

    
    if(!tmpArray) {
        tmpArray = [[NSMutableArray alloc] init];
    } else {
        [tmpArray removeAllObjects];
    }
    for(DBPatrolSpot * spot in _spotArray) {
        if(!spot.finish.boolValue) {
            [tmpArray addObject:spot];
        }
    }
    NSString * statusUnFinish = [NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"patrol_btn_unfinished" inTable:nil],[tmpArray count]];

    
    [_statusTabbar setInfoWithArray:[[NSMutableArray alloc] initWithObjects:statusAll, statusFinish, statusUnFinish, nil]];
}

- (void) updateList {
    NSString * strNotice;
    switch (_curType) {
        case PATROL_SPOT_STATUS_TYPE_ALL:
            if(!_curspotArray) {
                _curspotArray = [[NSMutableArray alloc] init];
            } else {
                [_curspotArray removeAllObjects];
            }
            for(DBPatrolSpot * spot in _spotArray) {
                [_curspotArray addObject:spot];
            }
            [_statusTabbar setSelected:0];
            
            strNotice = [[BaseBundle getInstance] getStringByKey:@"patrol_no_spot" inTable:nil];
            break;
        case PATROL_SPOT_STATUS_TYPE_FINISH:
            if(!_curspotArray) {
                _curspotArray = [[NSMutableArray alloc] init];
            } else {
                [_curspotArray removeAllObjects];
            }
            for(DBPatrolSpot * spot in _spotArray) {
                if(spot.finish.boolValue) {
                    [_curspotArray addObject:spot];
                }
            }
            [_statusTabbar setSelected:1];
            strNotice = [[BaseBundle getInstance] getStringByKey:@"patrol_no_spot_finished" inTable:nil];
            break;
        case PATROL_SPOT_STATUS_TYPE_UNFINISH:
            if(!_curspotArray) {
                _curspotArray = [[NSMutableArray alloc] init];
            } else {
                [_curspotArray removeAllObjects];
            }
            for(DBPatrolSpot * spot in _spotArray) {
                if(!spot.finish.boolValue) {
                    [_curspotArray addObject:spot];
                }
            }
            [_statusTabbar setSelected:2];
            strNotice = [[BaseBundle getInstance] getStringByKey:@"patrol_no_spot_unfinished" inTable:nil];
            break;
            
        default:
            break;
    }
    if((!_curspotArray || [_curspotArray count] == 0) && ![FMUtils isStringEmpty:strNotice]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:strNotice time:DIALOG_ALIVE_TIME_SHORT];
    }
    [_listHelper setDataWithArray:_curspotArray];
    [_tableView reloadData];
}

//更新任务状态
- (void) updateTaskState {
    if(_task && _spotArray && [_spotArray count] > 0) {
        NSNumber * finish = _task.finish;
        if(!finish.boolValue) {
            BOOL isFinish = YES;
            BOOL isException = NO;
            for(DBPatrolSpot * spot in _spotArray) {
                isFinish = isFinish && spot.finish.boolValue;
                isException = isException || spot.exception.boolValue;
            }
            _task.finish = [NSNumber numberWithBool:isFinish];
            _task.exception = [NSNumber numberWithBool:isException];
            if(isFinish) {
                _task.finishEndDate = [FMUtils getTimeLongNow];
            }
            [_dbHelper updatePatrolTaskById:_task.patrolTaskId userId:[SystemConfig getUserId] patrolTask:_task];
        }
    }
}

//展示全部点位数据
- (void) showSpotAll {
    _curType = PATROL_SPOT_STATUS_TYPE_ALL;
    [self updateList];
}
//展示已完成点位数据
- (void) showSpotFinish {
    _curType = PATROL_SPOT_STATUS_TYPE_FINISH;
    [self updateList];
}
//展示未完成点位数据
- (void) showSpotUnFinish {
    _curType = PATROL_SPOT_STATUS_TYPE_UNFINISH;
    
    [self updateList];
}

- (void) getDataFromDB {
    if(_task) {
        NSNumber * userId = [SystemConfig getUserId];
        _spotArray = [_dbHelper queryAllDBPatrolSpotsOf:_task.patrolTaskId andUserId:userId];
    }
    [self updateTaskState];
}

- (void) requestLastRecord {
    [[UserBusiness getInstance] getLastAttendanceRecordSuccess:^(NSInteger key, id object) {
        _attendanceRecord = object;
    } fail:^(NSInteger key, NSError *error) {
        FMLog(@"请求签到记录失败");
    }];
}

//判断是否允许处理点位
- (BOOL) canHandleSpot:(DBPatrolSpot *) spot {
    BOOL res = NO;
    if(_attendanceRecord) {
        if(spot) {
            Position * pos = [[Position alloc] init];
            pos.buildingId = spot.buildingId;
            pos.floorId = spot.floorId;
            pos.roomId = spot.roomId;
            
            if([pos isBelongTo:_attendanceRecord.location]) {//如果点位属于签到站点
                res = YES;
            }
        }
    }
    return res;
}


- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[BaseTabbarView class]]) {
        NSInteger index = subView.tag;
        switch(index) {
            case 0:
                [self showSpotAll];
                break;
            case 1:
                [self showSpotFinish];
                break;
            case 2:
                [self showSpotUnFinish];
                break;
        }
    }
}

- (BOOL) hasImageNeedUpload {
    BOOL res = NO;
    NSNumber * userId = [SystemConfig getUserId];
    NSArray * imgArray = [_dbHelper queryAllPictureUnUploadedOfTask:_task.patrolTaskId andUserId:userId];
    if(imgArray && [imgArray count] > 0) {
        for(DBSpotCheckContentPicture * pic in imgArray) {
            NSString * path = pic.url;
            UIImage * img = [FMUtils getImageWithName:path];
            if(img) {
                res = YES;
                break;
            }
        }
    }
    return res;
}

#pragma - 同步任务
- (void) submitLocalData {
    if(_isUploading) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"upload_notice_uploading" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        if ([self isTaskNeedToBeSyned:_task]) {
            //从本地数据库获取数据然后提交
            _operateType = PATROL_SUBMIT_OPERATE_TYPE_SAVE;
            _isUploading = YES;
            [self showLoadingDialog];
            if([self hasImageNeedUpload]) {
                [self uploadImagesOfTask:_task.patrolTaskId];
            } else {
                [self synTheTask:_task];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_no_data_syn" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
   
}

- (BOOL) isTaskNeedToBeSyned:(DBPatrolTask *) task {
    BOOL res = NO;
    if(task && task.edit && !task.edit.boolValue) {
        res = YES;
    }
    return res;
}


//同步指定位置的让您无
- (void) synTheTask:(DBPatrolTask *) task {
    if(task) {
//        [self showLoadingDialog];
        _isUploading = YES;
        NSNumber* userId = [SystemConfig getEmployeeId];
        SubmitPatrolTask * submitTask = [self getSubmitTask:task operateType:PATROL_SUBMIT_OPERATE_TYPE_SAVE];
        SubmitPatrolTaskRequest * param = [[SubmitPatrolTaskRequest alloc] initWithType:PATROL_SUBMIT_OPERATE_TYPE_SAVE patrolTasks:[[NSMutableArray alloc] initWithObjects:submitTask, nil] userId:userId];
        
        [_business requestUploadPatrolTask:param success:^(NSInteger key, id object) {
            _isUploading = NO;
            [self performSelectorOnMainThread:@selector(hideLoadingDialog) withObject:nil waitUntilDone:NO];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_syned_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            task.edit = [NSNumber numberWithBool:YES];
            [_dbHelper updatePatrolTaskById:task.patrolTaskId userId:[SystemConfig getUserId] patrolTask:task];
            [_dbHelper updatePatrolSpotSynStateByIds:_synSpotIdArray];
            [self notifyPatrolStatusChanged];
            [self refreshData];
        } fail:^(NSInteger key, NSError *error) {
            _isUploading = NO;
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_syned_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
    
}

//获取指定任务待提交信息
- (SubmitPatrolTask *) getSubmitTask:(DBPatrolTask *) task operateType:(PatrolSubmitOperateType) type{
    SubmitPatrolTask * submitTask = [[SubmitPatrolTask alloc] init];
    submitTask.patrolTaskId = [task.patrolTaskId copy];
    if(![FMUtils isNumberNullOrZero:task.finishStartDate]) {
        submitTask.startDateTime = [task.finishStartDate copy];
    } else {
        submitTask.startDateTime = [FMUtils getTimeLongNow];
    }
//        submitTask.endDateTime = [task.finishEndDate copy];
    submitTask.endDateTime = nil;   //同步的时候时间不显示
    NSNumber * userId = [SystemConfig getUserId];
    NSArray * spots = [_dbHelper queryAllDBPatrolSpotsOf:task.patrolTaskId andUserId:userId];
    if(spots && [spots count] > 0) {
        if(!_synSpotIdArray) {
            _synSpotIdArray = [[NSMutableArray alloc] init];
        } else {
            [_synSpotIdArray removeAllObjects];
        }
        for(DBPatrolSpot * dbSpot in spots) {
            if((type == PATROL_SUBMIT_OPERATE_TYPE_SAVE && dbSpot.edit && !dbSpot.edit.boolValue) || type == PATROL_SUBMIT_OPERATE_TYPE_FINISH) {     //只同步需要同步的数据,或者提交所有数据
                //            if(YES) {     //同步所有数据
                SubmitPatrolSpot * spot = [[SubmitPatrolSpot alloc] init];
                spot.patrolSpotId = [dbSpot.patrolSpotId copy];
                if(![FMUtils isNumberNullOrZero:dbSpot.finishStartDateTime]) {
                    spot.startDateTime = [dbSpot.finishStartDateTime copy];
                }
                if(![FMUtils isNumberNullOrZero:dbSpot.finishEndDateTime]) {
                    spot.endDateTime = [dbSpot.finishEndDateTime copy];
                }
                [_synSpotIdArray addObject:dbSpot.id];
                
                NSArray * equips = [_dbHelper queryAllDBPatrolDevicesOfSpot:dbSpot.id];
                if(equips && [equips count] > 0) {
                    
                    /* 上传指定类型的巡检项 */
                    for(DBPatrolDevice * dbEquip in equips) {
                        
                        /* 是停运状态设备或者是处于完成状态 */
                        if(dbEquip.finish.boolValue || (dbEquip.exceptionStatus && dbEquip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP)) {
                            
                            NSArray *contents;
                            
                            /* 综合巡检 */
                            if (dbEquip.deviceId && [dbEquip.deviceId isEqualToNumber:@0]) {
                                
                                contents = [_dbHelper queryAllDBSpotCheckContentOfDevice:dbEquip.id andUserId:userId];
                            }
                            /* 停机 */
                            else if (dbEquip.exceptionStatus && dbEquip.exceptionStatus.integerValue == PATROL_ITEM_CONTENT_VALID_STATUS_STOP) {
                                
                                contents = [_dbHelper queryAllDBSpotCheckContentOfDevice:dbEquip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_STOP andUserId:userId];
                            }
                            /* 正常 */
                            else {
                                
                                contents = [_dbHelper queryAllDBSpotCheckContentOfDevice:dbEquip.id byValidStatus:PATROL_ITEM_CONTENT_VALID_STATUS_WORKING andUserId:userId];
                            }
                            
                            //异常设备
                            if(dbEquip.deviceId.integerValue > 0 && dbEquip.exceptionStatus && dbEquip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
                                SubmitPatrolExceptionEquipment * exEquip = [[SubmitPatrolExceptionEquipment alloc] init];
                                exEquip.eqId = [dbEquip.deviceId copy];
                                exEquip.status = [dbEquip.exceptionStatus copy];
                                exEquip.desc = [dbEquip.exceptionDesc copy];
                                [spot.exceptionEquipment addObject:exEquip];
                            }
                            if(contents && [contents count] > 0) {
                                for(DBSpotCheckContent * dbContent in contents) {
                                    SubmitPatrolSpotResult * spotResult = [[SubmitPatrolSpotResult alloc] init];
                                    spotResult.patrolTaskSpotResultId = [dbContent.spotCheckContentId copy];
                                    if(dbEquip.finish && [dbEquip.finish boolValue]) {
                                        if(dbContent.resultInput) {
                                            spotResult.resultInput = [dbContent.resultInput copy];
                                        } else {
                                            spotResult.resultInput = @"";
                                        }
                                        if(dbContent.resultSelect) {
                                            spotResult.resultSelect = [dbContent.resultSelect copy];
                                        } else {
                                            dbContent.resultSelect = @"";
                                        }
                                    }
                                    spotResult.comment = [dbContent.comment copy];
                                    
                                    NSArray * array = [_dbHelper queryAllImageIdOfSpotCheckContent:dbContent.id andUserId:userId];
                                    spotResult.photoIds = array;
                                    [spot.contents addObject:spotResult];
                                }
                            }
                        }
                    }
                }
                [submitTask.spots addObject:spot];
            }
        }
    }
    return submitTask;
}

//上传一个巡检项的图片数据,上传完成之后等上传结果,返回的结果表示图片上传过程是否完成
- (BOOL) uploadImagesOfOneContent {
    BOOL res = NO;
    BOOL flag = YES;
    while(flag) {
        if(_contentIndex >= 0 && _contentIndex < [_contentArray count]) {
            DBSpotCheckContent * content = _contentArray[_contentIndex];
            NSNumber * userId = [SystemConfig getUserId];
            NSNumber * contentId = content.id;
            _tmpDbImageArray = [_dbHelper queryAllPictureUnUploadOfSpotCheckContent:contentId andUserId:userId];
            NSInteger count = [_tmpDbImageArray count];
            
            if(count > 0) {
                NSMutableArray * imgArray = [[NSMutableArray alloc] init];
                [_contentIdArray addObject:contentId];
                for(DBSpotCheckContentPicture * pic in _tmpDbImageArray) {
                    NSString * imgName = pic.url;
                    if(![FMUtils isStringEmpty:imgName]) {
                        UIImage * image = [FMUtils getImageWithName:imgName];
                        if(image) {
                            [imgArray addObject:image];
                        }
                    }
                }
                if([imgArray count] > 0) {
                    [[FileUploadService getInstance] uploadImageFiles:imgArray listener:self];
                    flag = NO;
                } else {
                    _contentIndex++;
                }
                
            } else {
                _contentIndex++;
            }
        } else {
            res = YES;
            flag = NO;
        }
    }
    return res;
}

- (void) uploadImagesOfTask:(NSNumber *) patrolTaskId {
    NSNumber * userId = [SystemConfig getUserId];
    _contentArray = [_dbHelper queryAllDBSpotCheckContentOfTask:patrolTaskId andUserId:userId];//TODO:可能需要调整，此处上传所有类型的巡检项的图片
    _contentIndex = 0;
    _contentIdArray = [[NSMutableArray alloc] init];
    _imageIdsArray = [[NSMutableDictionary alloc] init];
    
    BOOL res = [self uploadImagesOfOneContent];
    if(res) {
        switch(_operateType) {
            case PATROL_SUBMIT_OPERATE_TYPE_SAVE:
                [self synTheTask:_task];
                break;
            case PATROL_SUBMIT_OPERATE_TYPE_FINISH:
                [self requestUploadPatrolTask:_task];
                break;
        }
    }
}

#pragma - 图片上传结果监听
- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    _contentIndex++;
    BOOL finished = [self uploadImagesOfOneContent];    //试着上传下一个巡检项的图片数据
    if(finished) {
        switch(_operateType) {
            case PATROL_SUBMIT_OPERATE_TYPE_SAVE:
                [self synTheTask:_task];
                break;
            case PATROL_SUBMIT_OPERATE_TYPE_FINISH:
                [self requestUploadPatrolTask:_task];
                break;
        }
    }
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    if(responseObject) {        //保存上传的图片ID
        NSArray * idArray = responseObject;
        DBSpotCheckContent * content = _contentArray[_contentIndex];
        NSNumber * contentId = content.id;
        [_imageIdsArray setValue:idArray forKeyPath:[[NSString alloc] initWithFormat:@"%lld", contentId.longLongValue]];
        NSNumber * userId = [SystemConfig getUserId];
        NSInteger idIndex = 0;
        for(NSNumber * imgId in idArray) {
            if(idIndex < [_tmpDbImageArray count]) {
                DBSpotCheckContentPicture * dbPic = _tmpDbImageArray[idIndex];
                [_dbHelper updateImageId:imgId ofPicture:dbPic.id];
                idIndex++;
            }
        }
        [_dbHelper updatePictureStateOfSpotCheckContent:contentId andTaskId:_task.patrolTaskId andUserId:userId];
    }
    _contentIndex++;
    BOOL finished = [self uploadImagesOfOneContent];    //试着上传下一个巡检项的图片数据
    if(finished) {
        switch(_operateType) {
            case PATROL_SUBMIT_OPERATE_TYPE_SAVE:
                [self synTheTask:_task];
                break;
            case PATROL_SUBMIT_OPERATE_TYPE_FINISH:
                [self requestUploadPatrolTask:_task];
                break;
        }
    }
}



//显示点位匹配错误提示
- (void) showQrcodeMatchError {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_qrcode_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    });
}

- (NSInteger) getUnFinishedItemOfTask:(DBPatrolTask *) task {
    NSInteger res = 0;
    NSNumber * userId = [SystemConfig getUserId];
    NSArray * spotArray = [_dbHelper queryAllDBPatrolSpotsOf:task.patrolTaskId andUserId:userId];
    for(DBPatrolSpot * spot in spotArray) {
        NSArray * equipArray = [_dbHelper queryAllDBPatrolDevicesOfSpot:spot.id];
        for(DBPatrolDevice * equip in equipArray) {
            if(!equip.finish.boolValue && !(equip.exceptionStatus && equip.exceptionStatus.integerValue == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP)) {   //不是停运状态设备，并且不是处于完成状态
                res += equip.checkNumber.integerValue;
            }
        }
    }
    return res;
}


//提示当前还有多少个检查项未完成
- (void) noticeTaskUnFinishedWithCount:(NSInteger) count {
    NSString * strNotice = @"";
    if(count > 0) {
        strNotice = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_unfinished_some" inTable:nil], count];
    } else {
        strNotice = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_unfinished" inTable:nil], count];
    }
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:strNotice leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
    [alert showIn:self];
    alert.leftBlock = ^() {
        [self tryToUploadPatrolTask];
    };
    alert.rightBlock = ^() {
        //
    };
    alert.dismissBlock = ^() {
        //
    };
}


- (void) requestUploadPatrolTask:(DBPatrolTask *) task {
//    [self showLoadingDialog];
    NSNumber* emId = [SystemConfig getEmployeeId];
    
    SubmitPatrolTask * submitTask = [self getSubmitTask:task operateType:PATROL_SUBMIT_OPERATE_TYPE_FINISH];
//    if(![FMUtils isNumberNullOrZero:task.finishEndDate]) {
//        submitTask.endDateTime = [task.finishEndDate copy];
//    } else {
        submitTask.endDateTime = [FMUtils getTimeLongNow];
//    }
    
    SubmitPatrolTaskRequest * param = [[SubmitPatrolTaskRequest alloc] initWithType:PATROL_SUBMIT_OPERATE_TYPE_FINISH patrolTasks:[[NSMutableArray alloc] initWithObjects:submitTask, nil] userId:emId];
    
    [_business requestUploadPatrolTask:param success:^(NSInteger key, id object) {
        [self requestDeleteTask];   //任务上传成功之后再本地删除
        [self notifyPatrolStatusChanged];
        [self hideLoadingDialog];
        _isUploading = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_submit_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        _isUploading = NO;
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//请求清除当前任务
- (void) requestDeleteTask {
    NSNumber * userId = [SystemConfig getUserId];
    [_dbHelper deletePatrolTaskById:_task.patrolTaskId andUserId:userId];
}

- (void) notifyPatrolStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMPatrolTaskUpdate" object:nil];
}

#pragma mark - handleMessage
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
                _curSpot = spot;
                if(spot.finish) {
                    
                    /* 判断是否签到 */
                    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
                    if (user && [user.type isEqualToNumber:@(USER_TYPE_OUTSOURCE)] && ![self canHandleSpot:spot]) {
                        
                        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_need_check" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    }
                    else {
                        
                        if(spot.finish.boolValue) {
                            
                            [self gotoSpotDetail:spot];
                        }
                        else {
                        
                            [self goToQrCode];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark -
- (void) gotoUploadPatrolTask {
    _operateType = PATROL_SUBMIT_OPERATE_TYPE_FINISH;
    if (_task) {
        if (_task.finish.boolValue) {
            [self tryToUploadPatrolTask];
        } else {
            NSInteger count = [self getUnFinishedItemOfTask:_task];
            [self noticeTaskUnFinishedWithCount:count];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_load_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void) tryToUploadPatrolTask {
    _isUploading = YES;
    [self showLoadingDialog];
    if([self hasImageNeedUpload]) {
        [self uploadImagesOfTask:_task.patrolTaskId];
    } else {
        [self requestUploadPatrolTask:_task];
    }
}

//跳转点位详情
- (void) gotoSpotView {
    PatrolSpotViewController * spotVC = [[PatrolSpotViewController alloc] init];
    [spotVC setPatrolSpot:_curSpot];
    [self gotoViewController:spotVC];
}

//跳转点位详情
- (void) gotoSpotDetail:(DBPatrolSpot *) spot {
    PatrolSpotViewController * spotVC = [[PatrolSpotViewController alloc] init];
    [spotVC setPatrolSpot:spot];
    [self gotoViewController:spotVC];
}

#pragma - 二维码
//二维码---开始扫描
- (void) goToQrCode {
    QrCodeViewController * qrcodeVC = [[QrCodeViewController alloc] init];
    [qrcodeVC setBackAble:YES];
    [qrcodeVC setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:qrcodeVC];
}

//扫描结果返回
- (void) onQrCodeScanFinished:(NSString *)result {
    
    NSNumber * curSpotId = _curSpot.spotId;
    NSNumber * curBuildingId = _curSpot.buildingId;
    BOOL isOK = NO;
    if(result && curSpotId) {
        
        _spotQrcode = [[PatrolSpotQrcode alloc] initWithString:result];
        if(_spotQrcode && [_spotQrcode isValidQrcode]) {
            
            NSNumber *spotId = [_spotQrcode getSpotId];
            NSNumber *buildingId = [_spotQrcode getBuildingId];
            
            if ([_task.taskType integerValue] == PATROL_TASK_TYPE_INSPECTION && buildingId && [curBuildingId isEqualToNumber:buildingId]) {
                
                _isBackFromQrCode = YES;
                isOK = YES;
            }
            else if ([_task.taskType integerValue] == PATROL_TASK_TYPE_PATROL && spotId && [curSpotId isEqualToNumber:spotId]) {
                
                _isBackFromQrCode = YES;
                isOK = YES;
            }
        }
    }
    if(!isOK){
        //此处是为了避免在回调过程中发生线程阻塞现象 特意延迟0.01秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_qrcode_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        });
    }
}

@end
