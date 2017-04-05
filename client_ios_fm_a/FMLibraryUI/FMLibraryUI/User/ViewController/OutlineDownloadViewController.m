//
//  OutLineDownloadViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  离线下载详情

#import "OutlineDownloadViewController.h"
#import "FMTheme.h"
#import "BaseItemView.h"
#import "BaseGroupView.h"
#import "UIButton+Bootstrap.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "BaseDataDbHelper.h"
#import "BaseDataDownloader.h"
#import "DownloadItemView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "PowerManager.h"
#import "WorkOrderFunctionPermission.h"
#import "RequirementFunctionPermission.h"
#import "BaseBundle.h"

@interface OutlineDownloadViewController ()

@property (readwrite, nonatomic, strong) DownloadItemView * deviceItemView;     //设备信息
@property (readwrite, nonatomic, strong) DownloadItemView * deviceTypeItemView; //设备类型信息
@property (readwrite, nonatomic, strong) DownloadItemView * locationItemView;   //位置信息
@property (readwrite, nonatomic, strong) DownloadItemView * orgItemView;   //部门信息
@property (readwrite, nonatomic, strong) DownloadItemView * priorityItemView;   //优先级信息
@property (readwrite, nonatomic, strong) DownloadItemView * flowItemView;        //流程信息
@property (readwrite, nonatomic, strong) DownloadItemView * serviceTypeItemView;        //服务类型信息
@property (readwrite, nonatomic, strong) DownloadItemView * requirementTypeItemView;    //需求信息
//@property (readwrite, nonatomic, strong) DownloadItemView * satisfactionTypeItemView;   //满意度信息

@property (readwrite, nonatomic, strong) BaseGroupView * groupReport;

@property (readwrite, nonatomic, strong) UIButton * downloadAllBtn;         //一键下载按钮
@property (readwrite, nonatomic, assign) CGFloat btnHeight;                 //按钮高度
@property (readwrite, nonatomic, assign) CGFloat controlHeight;             //按钮所在区域高度

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;        //主容器

@property (readwrite, nonatomic, strong) Positions* positionsList;
@property (readwrite, nonatomic, strong) NSMutableArray* orgList;       //
@property (readwrite, nonatomic, strong) NSMutableArray* stypeList;     //
@property (readwrite, nonatomic, strong) NSMutableArray* priorityList;  //

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, strong) BaseDataDownloader* downloader;

@property (readwrite, nonatomic, strong) UpdateRecord * record;

@property (readwrite, nonatomic, strong) NSMutableArray * recordArray;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;

@property (readwrite, nonatomic, assign) BOOL hasDevices;
@property (readwrite, nonatomic, assign) BOOL hasDeviceTypes;
@property (readwrite, nonatomic, assign) BOOL hasLocations;
@property (readwrite, nonatomic, assign) BOOL hasOrgs;
@property (readwrite, nonatomic, assign) BOOL haspriorities;
@property (readwrite, nonatomic, assign) BOOL hasFlows;
@property (readwrite, nonatomic, assign) BOOL hasServiceTypes;
@property (readwrite, nonatomic, assign) BOOL hasRequirementTypes;
//@property (readwrite, nonatomic, assign) BOOL hasSatisfactionTypes;
@end

@implementation OutlineDownloadViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_outline_download" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        CGFloat originY = 0;
        CGFloat sepHeight = 0;
        CGFloat itemHeight = 55;
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        _controlHeight = [FMSize getInstance].bottomControlHeight;
        _paddingLeft = 15;
        _paddingRight = _paddingLeft;
        _dbHelper = [BaseDataDbHelper getInstance];
        
        frame.size.height -= _controlHeight;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        NSInteger itemCount = 0;
        NSInteger orderCount = 0;
        NSInteger assetCount = 0;
        NSInteger requirementCount = 0;
        if([SystemConfig needShowOrder]) {
            orderCount = 5; //位置，部门，优先级，流程，服务类型
        }
        if([SystemConfig needShowAsset]) {
            assetCount = 2; //设备，设备类型
        }
        if([SystemConfig needShowRequirement]) {
            requirementCount = 1;   //需求类型
        }
        
        itemCount = orderCount + assetCount + requirementCount;
        
        if(itemCount > 0) {
            _groupReport = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight * itemCount)];
            [_groupReport setItemHeight:itemHeight];
            [_groupReport setShowSeperator:NO];
            
            if([SystemConfig needShowAsset]) {
                _deviceItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_deviceItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_device" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_deviceItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                _deviceTypeItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_deviceTypeItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_device_type" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_deviceTypeItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                [_groupReport addMember:_deviceItemView];
                [_groupReport addMember:_deviceTypeItemView];
            }
            
            if([SystemConfig needShowOrder]) {
                _locationItemView= [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_locationItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_location" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_locationItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                _orgItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_orgItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_org" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_orgItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                _priorityItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_priorityItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_priority" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_priorityItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                
                _flowItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_flowItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_flow" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_flowItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                _serviceTypeItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_serviceTypeItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_service_type" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_serviceTypeItemView setSeperatorPadding:0];
                [_serviceTypeItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
                [_groupReport addMember:_locationItemView];
                [_groupReport addMember:_orgItemView];
                [_groupReport addMember:_priorityItemView];
                [_groupReport addMember:_flowItemView];
                [_groupReport addMember:_serviceTypeItemView];
            }
            
            if([SystemConfig needShowRequirement]) {
                _requirementTypeItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
                [_requirementTypeItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_requirement_type" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
                [_requirementTypeItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
                originY += itemHeight + sepHeight;
                
//                _satisfactionTypeItemView = [[DownloadItemView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, itemHeight)];
//                [_satisfactionTypeItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"download_satisfaction" inTable:nil] isNew:NO status:[[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil] time:nil];
//                [_satisfactionTypeItemView setPaddingLeft:_paddingLeft andPaddingRight:_paddingRight];
//                originY += itemHeight + sepHeight;
                
                [_groupReport addMember:_requirementTypeItemView];
//                [_groupReport addMember:_satisfactionTypeItemView];
            }
            
            [_mainContainerView addSubview:_groupReport];
        }
        
        _mainContainerView.contentSize = CGSizeMake(frame.size.width, originY);
        
        _downloadAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(_paddingLeft/2, self.view.frame.size.height - _controlHeight + (_controlHeight-_btnHeight-_paddingLeft/2), frame.size.width - _paddingLeft, _btnHeight)];
        [_downloadAllBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"download_all" inTable:nil] forState:UIControlStateNormal];
        [_downloadAllBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_downloadAllBtn addTarget:self action:@selector(requestAllBaseInfo) forControlEvents:UIControlEventTouchUpInside];
        [_downloadAllBtn successStyle];
        
        
        [self.view addSubview:_mainContainerView];
        [self.view addSubview:_downloadAllBtn];
    }
}

- (void) checkHasBaseData {
    NSMutableArray * tmpArray = [_dbHelper queryAllDevicesOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasDevices = YES;
    } else {
        _hasDevices = NO;
    }
    
    tmpArray = [_dbHelper queryAllDeviceTypesOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasDeviceTypes = YES;
    } else {
        _hasDeviceTypes = NO;
    }
    
    tmpArray = [_dbHelper queryAllSitesOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasLocations = YES;
    } else {
        _hasLocations = NO;
    }
    
    tmpArray = [_dbHelper queryAllOrgsOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasOrgs = YES;
    } else {
        _hasOrgs = NO;
    }
    
    tmpArray = [_dbHelper queryAllPrioritysOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _haspriorities = YES;
    } else {
        _haspriorities = NO;
    }
    
    tmpArray = [_dbHelper queryAllFlowsOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasFlows = YES;
    } else {
        _hasFlows = NO;
    }
    
    tmpArray = [_dbHelper queryAllServiceTypeOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasServiceTypes = YES;
    } else {
        _hasServiceTypes = NO;
    }
    
    tmpArray = [_dbHelper queryAllRequirementTypesOfCurrentProject];
    if(tmpArray && [tmpArray count] > 0) {
        _hasRequirementTypes = YES;
    } else {
        _hasRequirementTypes = NO;
    }
    
//    tmpArray = [_dbHelper queryAllSatisfactionTypes];
//    if(tmpArray && [tmpArray count] > 0) {
//        _hasSatisfactionTypes = YES;
//    } else {
//        _hasSatisfactionTypes = NO;
//    }
}

- (void) showTaskResult:(BaseTaskResult *) result with:(DownloadItemView *) itemView {
    NSString * strProgress;
    NSString * strNow = [FMUtils timeLongToDateString:[FMUtils getTimeLongNow]];
    CGFloat progress = result.taskProgress;
    switch (result.taskStatus) {
        case BASE_TASK_STATUS_INIT:
        case BASE_TASK_STATUS_HANDLING:
            strProgress = [[NSString alloc] initWithFormat:@"%@ %.1f%@", [[BaseBundle getInstance] getStringByKey:@"download_downloading" inTable:nil], result.taskProgress, @"%"];
            [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNUPDATED]];
            break;
        case BASE_TASK_STATUS_FINISH_FAIL:
            strProgress = [[BaseBundle getInstance] getStringByKey:@"download_fail" inTable:nil];
            progress = [BaseTaskResult getPercentOfSuccess];
            [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED]];
            break;
        case BASE_TASK_STATUS_FINISH_SUCCESS:
            strProgress = [[BaseBundle getInstance] getStringByKey:@"download_success" inTable:nil];
            progress = [BaseTaskResult getPercentOfSuccess];
            [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_DOWNLOADED]];
            break;
        default:
            break;
    }
    [itemView updateStatus:strProgress andTime:strNow progress:progress];
}

- (void) updateBaseData {
    NSString * status;
    NSString * strTime = [FMUtils timeLongToDateString:_record.newestDate];
    BaseDataDownloader * downloader = [BaseDataDownloader getInstance];
    if([[BaseDataDownloader getInstance] isDownloading]) {
        
        BaseTaskResult * orgResult = [downloader getOrgDownloadResult];
        BaseTaskResult * deviceResult = [downloader getDeviceDownloadResult];
        BaseTaskResult * deviceTypeResult = [downloader getDeviceTypeDownloadResult];
        BaseTaskResult * locationResult = [downloader getLocationDownloadResult];
        BaseTaskResult * serviceTypeResult = [downloader getServiceTypeDownloadResult];
        BaseTaskResult * flowResult = [downloader getFlowDownloadResult];
        BaseTaskResult * priorityResult = [downloader getPriorityDownloadResult];
        BaseTaskResult * requirementTypeResult = [downloader getRequirementTypeDownloadResult];
//        BaseTaskResult * satisfactionResult = [downloader getSatisfactionDownloadResult];
        
        [self showTaskResult:orgResult with:_orgItemView];
        [self showTaskResult:deviceResult with:_deviceItemView];
        [self showTaskResult:deviceTypeResult with:_deviceTypeItemView];
        [self showTaskResult:locationResult with:_locationItemView];
        [self showTaskResult:priorityResult with:_priorityItemView];
        [self showTaskResult:flowResult with:_flowItemView];
        [self showTaskResult:serviceTypeResult with:_serviceTypeItemView];
        [self showTaskResult:requirementTypeResult with:_requirementTypeItemView];
//        [self showTaskResult:satisfactionResult with:_satisfactionTypeItemView];
        
    } else {
        if(!_record) {
            status = [[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil];
            [_deviceItemView updateStatus:status andTime:nil progress:0];
            [_deviceTypeItemView updateStatus:status andTime:nil progress:0];
            [_locationItemView updateStatus:status andTime:nil progress:0];
            [_orgItemView updateStatus:status andTime:nil progress:0];
            [_priorityItemView updateStatus:status andTime:nil progress:0];
            [_flowItemView updateStatus:status andTime:nil progress:0];
            [_serviceTypeItemView updateStatus:status andTime:nil progress:0];
            [_requirementTypeItemView updateStatus:status andTime:nil progress:0];
//            [_satisfactionTypeItemView updateStatus:status andTime:nil progress:0];
        } else {
            [self updateDownloadItemView:_deviceItemView withStatus:_record.deviceNew localStatus:_hasDevices timeStr:strTime];
            [self updateDownloadItemView:_deviceTypeItemView withStatus:_record.deviceTypeNew localStatus:_hasDeviceTypes timeStr:strTime];
            [self updateDownloadItemView:_locationItemView withStatus:_record.locationNew localStatus:_hasLocations timeStr:strTime];
            [self updateDownloadItemView:_orgItemView withStatus:_record.departmentNew localStatus:_hasOrgs timeStr:strTime];
            [self updateDownloadItemView:_priorityItemView withStatus:_record.priorityTypeNew localStatus:_haspriorities timeStr:strTime];
            [self updateDownloadItemView:_flowItemView withStatus:_record.workFlowNew localStatus:_hasFlows timeStr:strTime];
            [self updateDownloadItemView:_serviceTypeItemView withStatus:_record.serviceTypeNew localStatus:_hasServiceTypes timeStr:strTime];
            [self updateDownloadItemView:_requirementTypeItemView withStatus:_record.requirementTypeNew localStatus:_hasRequirementTypes timeStr:strTime];
//            [self updateDownloadItemView:_satisfactionTypeItemView withStatus:_record.satisfactionDegreeNew localStatus:_hasSatisfactionTypes timeStr:strTime];
        }
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _downloader = [BaseDataDownloader getInstance];
    [_downloader setTaskListener:self withType:BASE_TASK_TYPE_DOWNLOAD_ALL];
    [self checkHasBaseData];
    [self updateBaseData];
}

- (void) updateDownloadItemView:(DownloadItemView *) itemView withStatus:(BOOL) hasNewData localStatus:(BOOL) hasLocalData timeStr:(NSString *) timeDesc {
    NSString * strNeedUpdate = [[BaseBundle getInstance] getStringByKey:@"download_need_update" inTable:nil];
    NSString * strNeedDownload = [[BaseBundle getInstance] getStringByKey:@"download_need_download" inTable:nil];
    NSString * strDownloaded = [[BaseBundle getInstance] getStringByKey:@"download_downloaded" inTable:nil];
    NSString * strNoData = [[BaseBundle getInstance] getStringByKey:@"download_no_data" inTable:nil];
    if(hasNewData) {
        if(hasLocalData) {
            [itemView updateStatus:strNeedUpdate andTime:nil progress:0];
            [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNUPDATED]];
        } else {
            [itemView updateStatus:strNeedDownload andTime:nil progress:0];
            [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED]];
        }
//        [itemView updateNeweast:YES];
    } else {
        [itemView setStatusColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_DOWNLOADED]];
        if(hasLocalData) {
            [itemView updateStatus:strDownloaded andTime:timeDesc progress:0];
        } else {
            [itemView updateStatus:strNoData andTime:timeDesc progress:0];
        }
    }
}

- (void) setUpdateInfoWith:(UpdateRecord *) record {
    _record = [record copy];
}

//- (void) getLastDownloadRecord {
//    _recordArray = [_dbHelper queryAllDownloadRecord];
//    [self requestUpdateRecord];
//}


- (void) requestOrgInfo {
    [_downloader downloadOrgInfo];
}

- (void) requestServiceTypeInfo {
    [_downloader downloadServiceTypeInfo];
}


- (void) requestDeviceInfo {
    [_downloader downloadDeviceInfo];
}

- (void) requestDeviceTypeInfo {
    [_downloader downloadDeviceTypeInfo];
}

- (void) requestLocationInfo {
    [_downloader downloadLocationInfo];
}

- (void) requestPriorityInfo {
    [_downloader downloadPriorityInfo];
}

- (void) requestFlowInfo {
    [_downloader downloadFlowInfo];
}

- (void) requestRequirementTypeInfo {
    [_downloader downloadRequirementTypeInfo];
}

- (void) requestSatisfactionInfo {
    [_downloader downloadSatisfactionInfo];
}

- (void) requestFailureReasonInfo {
    [_downloader downloadFailureReasonInfo];
}

- (void) requestAllBaseInfo {
    if([[BaseDataDownloader getInstance] isDownloading]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_downloading" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        if(_record && ![_record isNewData]) { //如果数据都为最新的数据了就更新获取数据的时间
            DownloadRecord * downloadRecord = [[DownloadRecord alloc] initWithDataType:BASE_DATA_TYPE_ALL andPreRequestDate:_record.newestDate];
            if([_dbHelper isDownloadRecordExist:BASE_DATA_TYPE_ALL]) {
                [_dbHelper updateDownloadRecordByType:BASE_DATA_TYPE_ALL downloadRecord:downloadRecord];
            } else {
                [_dbHelper addDownloadRecord:downloadRecord projectId:[SystemConfig getCurrentProjectId]];
            }
            
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_not_need_update" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [_downloader setTargetRecord:_record.newestDate];
            //下载工单相关基础数据
            if([SystemConfig needShowOrder]) {
                if(!_record || _record.departmentNew) {
                    [self requestOrgInfo];
                }
                if(!_record || _record.serviceTypeNew) {
                    [self requestServiceTypeInfo];
                }
                if(!_record || _record.locationNew) {
                    [self requestLocationInfo];
                }
                if(!_record || _record.priorityTypeNew) {
                    [self requestPriorityInfo];
                }
                if(!_record || _record.workFlowNew) {
                    [self requestFlowInfo];
                }
                if(!_record || _record.failureReasonNew) {
                    [self requestFailureReasonInfo];
                }
            }
            //下载需求相关基础数据
            if([SystemConfig needShowRequirement]) {
                if(!_record || _record.requirementTypeNew) {
                    [self requestRequirementTypeInfo];
                }
//                if(!_record || _record.satisfactionDegreeNew) {
//                    [self requestSatisfactionInfo];
//                }
            }
            //下载资产相关基础数据
            if([SystemConfig needShowAsset]) {
                if(!_record || _record.deviceNew) {
                    [self requestDeviceInfo];
                }
                if(!_record || _record.deviceTypeNew) {
                    [self requestDeviceTypeInfo];
                }
            }
        }
    }
    
}
	
- (void) handleMessage:(id)msg {
    NSDictionary * msgDict = (NSDictionary *)msg;
    
    BaseTaskType taskType = [[msgDict valueForKeyPath:@"taskType"] integerValue];
    BaseTaskStatus taskStatus = [[msgDict valueForKeyPath:@"taskStatus"] integerValue];
    NSNumber * taskProgress = [msgDict valueForKeyPath:@"taskProgress"];
    NSString * strNotice = @"";
    CGFloat progress = taskProgress.floatValue;
    DownloadItemView * itemView;
    NSString * strTimeNow = [FMUtils timeLongToDateString:[FMUtils getTimeLongNow]];
    UIColor * statusColor;
    if(taskStatus == BASE_TASK_STATUS_TYPE_FINISH) {    //指定类型的任务下载完成
        
    } else {
        switch(taskStatus) {
            case BASE_TASK_STATUS_INIT:
                strNotice = [[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil];
                statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED];
                break;
            case BASE_TASK_STATUS_HANDLING:
                strNotice = [[NSString alloc] initWithFormat:@"%@ %.1f%@", [[BaseBundle getInstance] getStringByKey:@"download_downloading" inTable:nil], progress, @"%"];
                statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNUPDATED];
                break;
            case BASE_TASK_STATUS_FINISH_SUCCESS:
                strNotice = [[BaseBundle getInstance] getStringByKey:@"download_success" inTable:nil];
                statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_DOWNLOADED];
                break;
            case BASE_TASK_STATUS_FINISH_FAIL:
                strNotice = [[BaseBundle getInstance] getStringByKey:@"download_fail" inTable:nil];
                statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED];
                break;
            default:
                break;
        }
        switch(taskType) {
            case BASE_TASK_TYPE_DOWNLOAD_ORG:
                itemView = _orgItemView;
                
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.departmentNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE:
                itemView = _serviceTypeItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.serviceTypeNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_LOCATION:
                itemView = _locationItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.locationNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_PRIORITY:
                itemView = _priorityItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.priorityTypeNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_FLOW:
                itemView = _flowItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.workFlowNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_DEVICE:
                itemView = _deviceItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.deviceNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE:
                itemView = _deviceTypeItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.deviceTypeNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
            case BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE:
                itemView = _requirementTypeItemView;
                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                    _record.requirementTypeNew = NO;
                    [itemView updateNeweast:NO];
                }
                break;
//            case BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE:
//                itemView = _satisfactionTypeItemView;
//                if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
//                    _record.satisfactionDegreeNew = NO;
//                    [itemView updateNeweast:NO];
//                }
//                break;
            default:
                break;
        }
        if(statusColor) {
            [itemView setStatusColor:statusColor];
        }
        [itemView updateStatus:strNotice andTime:strTimeNow progress:progress];
        if(_record && ![_record isNewData]) {//如果数据都为最新的数据了就更新获取数据的时间
//            DownloadRecord * downloadRecord = [[DownloadRecord alloc] initWithDataType:BASE_DATA_TYPE_ALL andPreRequestDate:_record.newestDate];
//            if([_dbHelper isDownloadRecordExist:BASE_DATA_TYPE_ALL]) {
//                [_dbHelper updateDownloadRecordByType:BASE_DATA_TYPE_ALL downloadRecord:downloadRecord];
//            } else {
//                [_dbHelper addDownloadRecord:downloadRecord];
//            }
        }
    }
    
}

//- (void) requestUpdateRecord {
//    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
//    NSString * deviceId = [FMUtils getDeviceIdString];
//    NSNumber * projectId = [SystemConfig getCurrentProjectId];
//    DownloadRecord * record = [_dbHelper queryDownloadRecordByType:BASE_DATA_TYPE_ALL];;
//    NSNumber * preRequestDate;
//    if(record) {
//        preRequestDate = record.preRequestDate;
//    } else {
//        preRequestDate = [NSNumber numberWithLong:0];
//    }
//    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
//    BaseDataGetUpdateRecordRequestParam * wr = [[BaseDataGetUpdateRecordRequestParam alloc] initWith:preRequestDate];
//    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
//}
//

@end


