//
//  PatrolTaskUnFinishedViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检任务

#import "PatrolTaskUnFinishedViewController.h"
#import "PatrolTaskEntity.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "PatrolTaskDetailViewController.h"
 
#import "NetPage.h"
#import "PatrolTaskEntity.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "PatrolDBHelper.h"
#import "FMFont.h"
#import "FMSize.h"
#import "PatrolServerConfig.h"
#import "BaseDataDbHelper.h"
#import "PatrolBusiness.h"

#import "BaseDataDownloader.h"
#import "PatrolTaskListHelper.h"

@interface PatrolTaskUnFinishedViewController ()<OnMessageHandleListener>

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, strong) UIView *mainContainerView;
@property (readwrite, nonatomic, strong) UITableView *pullTableView;
@property (readwrite, nonatomic, strong) __block NSMutableArray *pratrolTaskArray;  //存储巡检任务 DBPatrolTask
@property (readwrite, nonatomic, strong) __block NSMutableArray *taskIdArray;       //存储当前要展示的数据的ID，默认不需要初始化

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;       //提示标签
@property (readwrite, nonatomic, assign) CGFloat noticeWidth;       //提示标签宽度
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;      //提示标签高度
@property (readwrite, nonatomic, strong) NSNumber * curTaskId;
@property (readwrite, nonatomic, strong) __block NetPage * mPage;
@property (readwrite, nonatomic, assign) __block NSInteger pageSize;

@property (nonatomic, assign) CGFloat seperatorHeight;
@property (nonatomic, assign) CGFloat showMoreHeight;

@property (readwrite, nonatomic, strong) PatrolBusiness *business;
@property (readwrite, nonatomic, strong) PatrolDBHelper *dbHelper;
@property (readwrite, nonatomic, strong) PatrolTaskListHelper *tableHelper;
@property (nonatomic, assign) BOOL needUpdate;
@end

@implementation PatrolTaskUnFinishedViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_patrol_task" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        [self initData];
        
        CGRect frame = [self getContentFrame];
        CGFloat height = CGRectGetHeight(frame);
        CGFloat width = CGRectGetWidth(frame);
        
        _seperatorHeight = 15;
        _showMoreHeight = 50;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        
        _pullTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _pullTableView.dataSource = _tableHelper;
        _pullTableView.delegate = _tableHelper;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        [_noticeLbl setHidden:YES];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        
        
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initData {
    _itemHeight = 150;
    _pratrolTaskArray = [[NSMutableArray alloc] init];
    _noticeHeight = [FMSize getInstance].defaultNoticeHeight;
    _dbHelper = [PatrolDBHelper getInstance];
    _business = [PatrolBusiness getInstance];
    _mPage = [[NetPage alloc] init];
    
    _tableHelper = [[PatrolTaskListHelper alloc] init];
    [_tableHelper setOnMessageHandleListener:self];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initSpotTaskChangeHandler];
//    [self clearTaskTimeOut];    //清除超时的巡检任务
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {  //如果需要，从网络上重新获取数据
        [self work];
    }
    if([_taskIdArray count] > 0) {  //如果已经有数据，则刷新一下
        [self updateList];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) initSpotTaskChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMPatrolTaskUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMPatrolTaskUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    _needUpdate = YES;
}

//从网络上获取待处理的巡检任务数据
- (void) work {
    _needUpdate = NO;
    if(!_mPage) {
        _mPage = [[NetPage alloc] init];
    } else {
        [_mPage reset];
    }
    [self requestData];
}

- (void) getDataFromDb {
    NSNumber * userId = [SystemConfig getUserId];
    if(!_pratrolTaskArray) {
        _pratrolTaskArray = [[NSMutableArray alloc] init];
    } else {
        [_pratrolTaskArray removeAllObjects];
    }
    if(!_taskIdArray) { //如果联网失败，从本地获取所有数据
        _pratrolTaskArray = [_dbHelper queryAllValidDBPatrolTasksBy:userId];
    } else if([_taskIdArray count] > 0){//获取指定数据
        _pratrolTaskArray = [_dbHelper queryAllDBPatrolTasksByIds:_taskIdArray andUserId:userId];
    }
    [_tableHelper setDataWithArray:_pratrolTaskArray];
}

- (void) requestData {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business requestPatrolTaskByPage:_mPage success:^(NSInteger key, id object) {
        PatrolTaskResponseData *data = object;
        [weakSelf.mPage setPage:data.page];
        NSMutableArray *array = data.contents;
        
        if(!weakSelf.taskIdArray) {
            weakSelf.taskIdArray = [[NSMutableArray alloc] init];
        }
        if ([_mPage isFirstPage]) {
            if(weakSelf.taskIdArray) {
                [weakSelf.taskIdArray removeAllObjects];
            }
        }
        for(PatrolTask *task in array) {
            [weakSelf.taskIdArray addObject:task.patrolTaskId];
        }
        LocalTaskManager *manager = [[LocalTaskManager alloc] init];;
        [manager setTaskListener:self withType:BASE_TASK_TYPE_INSERT_PATROL_TASK];
        [manager addPatrolTask:array];
//        if(weakSelf.mPage && weakSelf.mPage.totalCount > 0 && ![weakSelf.mPage haveMorePage]) {    //如果获取到所有任务的 ID 则删除多余任务
//            [manager clearPatrolTaskNotIn:_taskIdArray];
//        }
        if ([weakSelf.mPage haveMorePage]) {   //获取所有的巡检任务
            [weakSelf.mPage nextPage];
            [weakSelf requestData];
        } else {
            [manager clearPatrolTaskNotIn:_taskIdArray];
            [weakSelf hideLoadingDialog];
        }
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.taskIdArray = nil;
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[NSString alloc] initWithFormat:@"%@:%@", [[BaseBundle getInstance] getStringByKey:@"patrol_request_fail" inTable:nil], [error localizedDescription]] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf updateList];
    }];
}


//更新列表
- (void) updateList {
    [self getDataFromDb];
    if(!_pratrolTaskArray || [_pratrolTaskArray count] == 0) {
        [self updateNotice:[[BaseBundle getInstance] getStringByKey:@"patrol_no_task_current" inTable:nil] display:YES];
    } else {
        [self updateNotice:@"" display:NO];
    }
    [_pullTableView reloadData];
}

//更新提示
- (void) updateNotice:(NSString *) notice display:(BOOL) show {
    _noticeLbl.text = notice;
    if(show) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

//删除超时的任务
- (void) clearTaskTimeOut {
    NSNumber * timeEnd = [FMUtils getTimeLongNow];
    NSNumber * userId = [SystemConfig getUserId];
    [_dbHelper deletePatrolTaskEndedByTime:timeEnd userId:userId];
}

- (void) goToPatrolTaskDetail:(DBPatrolTask *) task {
    PatrolTaskDetailViewController * taskDetailVC = [[PatrolTaskDetailViewController alloc] init];
    [taskDetailVC setPatrolTask:task];
    [self gotoViewController:taskDetailVC];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"BaseDataDownloader"]) {
            BaseTaskType taskType = [[msg valueForKeyPath:@"taskType"] integerValue];
            BaseTaskStatus taskStatus = [[msg valueForKeyPath:@"taskStatus"] integerValue];
            NSNumber * taskProgress = [msg valueForKeyPath:@"taskProgress"];
            NSString * strNotice = @"";
            if(taskStatus == BASE_TASK_STATUS_TYPE_FINISH) {    //指定类型的任务下载完成
                
            } else {
                switch(taskStatus) {
                    case BASE_TASK_STATUS_INIT:
                        strNotice = [[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil];
                        break;
                    case BASE_TASK_STATUS_HANDLING:
                        strNotice = [[NSString alloc] initWithFormat:@"%@ %.1f%@", [[BaseBundle getInstance] getStringByKey:@"download_downloading" inTable:nil], (taskProgress.floatValue), @"%"];
                        break;
                    case BASE_TASK_STATUS_FINISH_SUCCESS:
                        strNotice = [[BaseBundle getInstance] getStringByKey:@"download_success" inTable:nil];
                        [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO];
//                        [self performSelectorOnMainThread:@selector(stopRefresh) withObject:nil waitUntilDone:NO];
                        break;
                    case BASE_TASK_STATUS_FINISH_FAIL:
                        strNotice = [[BaseBundle getInstance] getStringByKey:@"download_fail" inTable:nil];
                        break;
                    default:
                        break;
                }
                
                switch(taskType) {
                    case BASE_TASK_TYPE_INSERT_PATROL_TASK:
                        break;
                    default:
                        break;
                }
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([_tableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            PatrolTaskListEventType type = [tmpNumber integerValue];
            DBPatrolTask * task;
            switch(type) {
                case PATROL_TASK_LIST_SHOW_DETAIL:
                    task = [result valueForKeyPath:@"eventData"];
                    [self goToPatrolTaskDetail:task];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma --- 通知处理
- (void) handleNotification {
    NSLog(@"巡检通知处理");
}

@end
