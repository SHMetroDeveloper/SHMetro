//
//  BaseDataDownloader.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseDataDownloader.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "BaseDataDbHelper.h"
#import "ReportDbHelper.h"
#import "ReportNetRequest.h"
#import "ReportEntity.h"
#import "UploadConfig.h"
#import "PatrolDBHelper.h"
#import "NotificationDbHelper.h"
#import "CommonBusiness.h"

static BaseTaskManager * taskManagerInstance;
static BaseDataDownloader * downloaderInstance;
static BaseDataUploader * uploaderInstance;
static LocalTaskManager * localTaskInstance;

const NSInteger TASK_INDEX_UNKNOW = -1;

const CGFloat PERCENT_OF_SUCCESS = 100.0;

@implementation BaseTaskResult
- (instancetype) init {
    self = [super init];
    if(self) {
        _taskStatus = BASE_TASK_STATUS_INIT;
        _taskProgress = 0;
    }
    return self;
}
//获取任务完成时的进度比值
+ (CGFloat) getPercentOfSuccess {
    return PERCENT_OF_SUCCESS;
}
@end

@interface BaseTask ()
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> msgHandler;
@end

@implementation BaseTask

- (instancetype) init {
    self = [super init];
    if(self) {
        _taskType = BASE_TASK_TYPE_UNKNOW;
        _taskLevel = BASE_TASK_LEVEL_UNKNOW;
        _taskStatus = BASE_TASK_STATUS_UNKNOW;
        _taskProgress = [NSNumber numberWithFloat:0];
        
        _aliveTime = 0;
        _projectId = [SystemConfig getCurrentProjectId];
    }
    return self;
}

- (instancetype) initWithType:(BaseTaskType) type andLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _taskType = type;
        _taskLevel = level;
        _taskStatus = BASE_TASK_STATUS_INIT;
        _taskProgress = [NSNumber numberWithFloat:0];
        
        _aliveTime = 0;
        _projectId = [SystemConfig getCurrentProjectId];
    }
    return self;
}

//任务的实体
- (void) taskProcessMethod {
    
}

//提示任务开始
- (void) notifyTaskStart {
    _taskStatus = BASE_TASK_STATUS_HANDLING;
    [self broadcastCurrentTaskStatusAndProgress];
}

//提示任务完成
- (void) notifyTaskFinish:(BOOL) success {
    if(success) {
        _taskStatus = BASE_TASK_STATUS_FINISH_SUCCESS;
    } else {
        _taskStatus = BASE_TASK_STATUS_FINISH_FAIL;
    }
    [self broadcastCurrentTaskStatusAndProgress];
}

//提示进度更新
- (void) notifyProgressUpdate:(NSNumber *) newProgress {
    if(newProgress) {
        _taskProgress = [newProgress copy];
        [self broadcastCurrentTaskStatusAndProgress];
    }
}

//设置任务的状态监听代理
- (void) setOnTaskStatusListener:(id<OnMessageHandleListener>) handler {
    _msgHandler = handler;
}

//
- (void) broadcastCurrentTaskStatusAndProgress {
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
    [msg setValue:_taskKey forKeyPath:@"taskKey"];
    [msg setValue:[NSNumber numberWithInteger:_taskType] forKeyPath:@"taskType"];
    [msg setValue:[NSNumber numberWithInteger:_taskStatus] forKeyPath:@"taskStatus"];
    [msg setValue:[_taskProgress copy] forKeyPath:@"taskProgress"];
    if(_msgHandler) {
        [_msgHandler handleMessage:msg];
    }
}

- (BaseTaskType) getTaskType {
    return _taskType;
}
- (BaseTaskLevel) getTaskLevel {
    return _taskLevel;
}
- (BaseTaskStatus) getTaskStatus {
    return _taskStatus;
}
@end


@interface OrgDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * orgList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation OrgDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _orgList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_ORG];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _orgList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_ORG];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSLog(@"-------taskProcessMethod-----org---");
    NSNumber * preRequestDate = [SystemConfig getPreRequestDate];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetOrgListRequestParam * wr = [[BaseDataGetOrgListRequestParam alloc] initWith:preRequestDate];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * orgIdDeletedArray = [[NSMutableArray alloc] init];
        if(!_orgList) {
            _orgList = [[NSMutableArray alloc] init];
        } else {
            [_orgList removeAllObjects];
        }
        for(NSDictionary * dorg in data) {
            Org * org = [[Org alloc] init];
            org.orgId = [dorg valueForKeyPath:@"orgId"];
            if([org.orgId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [dorg valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [orgIdDeletedArray addObject:org.orgId];
                continue;
            }
            org.code = [dorg valueForKeyPath:@"code"];
            if([org.code isKindOfClass:[NSNull class]]) {
                org.code = nil;
            }
            org.name = [dorg valueForKeyPath:@"name"];
            if([org.name isKindOfClass:[NSNull class]]) {
                org.name = nil;
            }
            org.fullName = [dorg valueForKeyPath:@"fullName"];
            if([org.fullName isKindOfClass:[NSNull class]]) {
                org.fullName = nil;
            }
            org.level = [[dorg valueForKeyPath:@"level"] integerValue];
            org.parentOrgId = [dorg valueForKeyPath:@"parentOrgId"];
            if([org.parentOrgId isKindOfClass:[NSNull class]]) {
                org.parentOrgId = nil;
            }
            [_orgList addObject:org];
        }
        [self saveOrgInfo:_orgList];
        [self deleteOrgInfo:orgIdDeletedArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
        [self notifyTaskFinish:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) saveOrgInfo:(NSArray *) orgList{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addOrgs:_orgList projectId:self.projectId];
}
- (void) deleteOrgInfo:(NSArray *) orgIdArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteOrgByIds:orgIdArray];
}
@end

@interface PriorityDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * priorityList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation PriorityDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _priorityList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_PRIORITY];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _priorityList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_PRIORITY];
        [self setTaskLevel:level];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetPriorityListRequestParam * wr = [[BaseDataGetPriorityListRequestParam alloc] initWith:preRequestTime];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        if(!_priorityList) {
            _priorityList = [[NSMutableArray alloc] init];
        } else {
            [_priorityList removeAllObjects];
        }
        for(NSDictionary * dpriority in data) {
            Priority * priority = [[Priority alloc] init];
            priority.priorityId = [dpriority valueForKeyPath:@"priorityId"];
            if([priority.priorityId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [dpriority valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:priority.priorityId];
                continue;
            }
            priority.name = [dpriority valueForKeyPath:@"name"];
            if([priority.name isKindOfClass:[NSNull class]]) {
                priority.name = nil;
            }
            priority.desc = [dpriority valueForKeyPath:@"desc"];
            if([priority.desc isKindOfClass:[NSNull class]]) {
                priority.desc = nil;
            }
            priority.color = [dpriority valueForKeyPath:@"color"];
            if([priority.color isKindOfClass:[NSNull class]]) {
                priority.color = nil;
            }
            [_priorityList addObject:priority];
        }
        [self savePriorityInfo:_priorityList];
        [self deletePriorityInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
        [self notifyTaskFinish:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) savePriorityInfo:(NSArray *) priorityArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addPrioritys:_priorityList projectId:self.projectId];
}
- (void) deletePriorityInfo:(NSArray *) priorityIdArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deletePriorityByIds:priorityIdArray];
}
@end

@interface ServiceTypeDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * stypeList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation ServiceTypeDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _stypeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _stypeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE];
        [self setTaskLevel:level];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetServiceTypeListRequestParam * wr = [[BaseDataGetServiceTypeListRequestParam alloc] initWith:preRequestTime];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        if(!_stypeList) {
            _stypeList = [[NSMutableArray alloc] init];
        } else {
            [_stypeList removeAllObjects];
        }
        for(NSDictionary * dstype in data) {
            ServiceType * stype = [[ServiceType alloc] init];
            stype.serviceTypeId = [dstype valueForKeyPath:@"serviceTypeId"];
            if([stype.serviceTypeId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [dstype valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if([deleted boolValue]) {
                [deletedIdArray addObject:stype.serviceTypeId];
                continue;
            }
            stype.name = [dstype valueForKeyPath:@"name"];
            if([stype.name isKindOfClass:[NSNull class]]) {
                stype.name = nil;
            }
            stype.fullName = [dstype valueForKeyPath:@"fullName"];
            if([stype.fullName isKindOfClass:[NSNull class]]) {
                stype.fullName = nil;
            }
            stype.stypeDesc = [dstype valueForKeyPath:@"stypeDesc"];
            if([stype.stypeDesc isKindOfClass:[NSNull class]]) {
                stype.stypeDesc = nil;
            }
            stype.parentId = [dstype valueForKeyPath:@"parentId"];
            if([stype.parentId isKindOfClass:[NSNull class]]) {
                stype.parentId = nil;
            }
            [_stypeList addObject:stype];
        }
        [self saveServiceTypeInfo:_stypeList];
        [self deleteServiceTypeInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
        [self notifyTaskFinish:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) saveServiceTypeInfo:(NSArray *) stypeArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addServiceTypes:stypeArray projectId:self.projectId];
}
- (void) deleteServiceTypeInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteServiceTypeByIds:idArray];
}
@end

@interface LocationDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * locationList;
@property (readwrite, nonatomic, strong) NSMutableArray * cityList;
@property (readwrite, nonatomic, strong) NSMutableArray * siteList;
@property (readwrite, nonatomic, strong) NSMutableArray * buildingList;
@property (readwrite, nonatomic, strong) NSMutableArray * floorList;
@property (readwrite, nonatomic, strong) NSMutableArray * roomList;
@property (readwrite, nonatomic, strong) NetPage * buildingPage;
@property (readwrite, nonatomic, strong) NetPage * floorPage;
@property (readwrite, nonatomic, strong) NetPage * roomPage;
@property (readwrite, atomic, assign) CGFloat curTaskProgress;  //当前任务的进度，百分比，其中city,site,building 占50%，floor和Room各占25%；

@property (readwrite, atomic, assign) CGFloat DEFAULT_PERCENT_CITY; //城市所占百分比
@property (readwrite, atomic, assign) CGFloat DEFAULT_PERCENT_SITE; //区域所占百分比
@property (readwrite, atomic, assign) CGFloat DEFAULT_PERCENT_BUILDING; //单元所占百分比
@property (readwrite, atomic, assign) CGFloat DEFAULT_PERCENT_FLOOR; //楼层所占百分比
@property (readwrite, atomic, assign) CGFloat DEFAULT_PERCENT_ROOM; //房间所占百分比

@property (readwrite, atomic, strong) NSCondition * lock;

@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation LocationDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        [self initDefaultSetting];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_LOCATION];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        [self initDefaultSetting];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_LOCATION];
        [self setTaskLevel:level];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}

- (void) initDefaultSetting {
    _DEFAULT_PERCENT_CITY = 10;
    _DEFAULT_PERCENT_SITE = 20;
    _DEFAULT_PERCENT_BUILDING = 20;
    _DEFAULT_PERCENT_FLOOR = 25;
    _DEFAULT_PERCENT_ROOM = 25;
    
    _curTaskProgress = 0;
    
    _lock = [[NSCondition alloc] init];
    
    _locationList = [[NSMutableArray alloc] init];
    _cityList = [[NSMutableArray alloc] init];
    _siteList = [[NSMutableArray alloc] init];
    _buildingList = [[NSMutableArray alloc] init];
    _floorList = [[NSMutableArray alloc] init];
    _roomList = [[NSMutableArray alloc] init];
    _dbHelper = [BaseDataDbHelper getInstance];
    
    _buildingPage = [[NetPage alloc] init];
    _floorPage = [[NetPage alloc] init];
    _roomPage = [[NetPage alloc] init];
    
}

- (CGFloat) getTotalTaskPercent {
    return (_DEFAULT_PERCENT_CITY + _DEFAULT_PERCENT_SITE + _DEFAULT_PERCENT_BUILDING + _DEFAULT_PERCENT_FLOOR + _DEFAULT_PERCENT_ROOM);
}

- (void) updateProgressWithAdd:(CGFloat) newPercent {
    [_lock lock];
    _curTaskProgress += newPercent;
    if(_curTaskProgress > [self getTotalTaskPercent]) {
        _curTaskProgress = [self getTotalTaskPercent];
    }
    [_lock unlock];
}

- (CGFloat) getCurTaskFinishProgress {
    return (_curTaskProgress * PERCENT_OF_SUCCESS)/[self getTotalTaskPercent];
}

- (void) downloadCityAnSite {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetPositionListRequestParam * wr = [[BaseDataGetPositionListRequestParam alloc] initWith:preRequestTime];
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedBuildingIdArray = [[NSMutableArray alloc] init];
        NSMutableArray * dbuildings = [data valueForKeyPath:@"building"];
        if([dbuildings isKindOfClass:[NSNull class]]) {
            dbuildings = nil;
        }
        for(NSDictionary * dbuilding in dbuildings) {
            Building * building = [[Building alloc] init];
            building.buildingId = [dbuilding valueForKeyPath:@"buildingId"];
            if([building.buildingId isKindOfClass:[NSNull class]]) {
                building.buildingId = nil;
                continue;
            }
            NSNumber * deleted = [dbuilding valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedBuildingIdArray addObject:building.buildingId];
                continue;
            }
            building.code = [dbuilding valueForKeyPath:@"code"];
            if([building.code isKindOfClass:[NSNull class]]) {
                building.code = nil;
            }
            building.name = [dbuilding valueForKeyPath:@"name"];
            if([building.name isKindOfClass:[NSNull class]]) {
                building.name = nil;
            }
            building.siteId = [dbuilding valueForKeyPath:@"siteId"];
            if([building.siteId isKindOfClass:[NSNull class]]) {
                building.siteId = nil;
            }
            [_buildingList addObject:building];
        }
        
        NSMutableArray * deletedSiteIdArray = [[NSMutableArray alloc] init];
        NSMutableArray * dsites = [data valueForKeyPath:@"site"];
        if([dsites isKindOfClass:[NSNull class]]) {
            dsites = nil;
        }
        for(NSDictionary * dsite in dsites) {
            Site * site = [[Site alloc] init];
            site.siteId = [dsite valueForKeyPath:@"siteId"];
            if([site.siteId isKindOfClass:[NSNull class]]) {
                site.siteId = nil;
                continue;
            }
            NSNumber * deleted = [dsite valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedSiteIdArray addObject:site.siteId];
                continue;
            }
            site.code = [dsite valueForKeyPath:@"code"];
            if([site.code isKindOfClass:[NSNull class]]) {
                site.code = nil;
            }
            site.name = [dsite valueForKeyPath:@"name"];
            if([site.name isKindOfClass:[NSNull class]]) {
                site.name = nil;
            }
            site.cityId = [dsite valueForKeyPath:@"cityId"];
            if([site.cityId isKindOfClass:[NSNull class]]) {
                site.cityId = nil;
            }
            [_siteList addObject:site];
        }
        
        CGFloat curPercent = (_DEFAULT_PERCENT_CITY + _DEFAULT_PERCENT_SITE + _DEFAULT_PERCENT_BUILDING);
        [self updateProgressWithAdd:curPercent];
        NSNumber * curProgress = [NSNumber numberWithFloat:[self getCurTaskFinishProgress]];
        [self notifyProgressUpdate:curProgress];
        if([curProgress isEqualToNumber:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]]) {
            [self notifyTaskFinish:YES];
        }
        
        [self saveCityInfo:_cityList];
        [self saveSiteInfo:_siteList];
        [self saveBuildingInfo:_buildingList];
        [self deleteSiteInfo:deletedSiteIdArray];
        [self deleteBuildingInfo:deletedBuildingIdArray];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}


/**
 下载站点和区间信息
 */
- (void) downloadBuilding {
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataGetBuildingListRequestParam * param = [[BaseDataGetBuildingListRequestParam alloc] initWith:preRequestTime];
    [[CommonBusiness getInstance] getBuildingByParam:param success:^(NSInteger key, id object) {
        NSMutableArray * data = object;
        NSMutableArray * deletedBuildingIdArray = [[NSMutableArray alloc] init];
        if(!_buildingList) {
            _buildingList = [[NSMutableArray alloc] init];
        } else {
            [_buildingList removeAllObjects];
        }
        for(Building * building in data) {
            if(building.deleted) {
                [deletedBuildingIdArray addObject:building.buildingId];
            } else {
                [_buildingList addObject:building];
            }
        }
        CGFloat curPercent = (_DEFAULT_PERCENT_CITY + _DEFAULT_PERCENT_SITE + _DEFAULT_PERCENT_BUILDING);
        [self updateProgressWithAdd:curPercent];
        NSNumber * curProgress = [NSNumber numberWithFloat:[self getCurTaskFinishProgress]];
        [self notifyProgressUpdate:curProgress];
        
        [self deleteBuildingInfo:deletedBuildingIdArray];
        if([curProgress isEqualToNumber:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]]) {
            [self notifyTaskFinish:YES];
        }
        [self saveBuildingInfo:_buildingList];
        
    } fail:^(NSInteger key, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) downloadFloor {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestDate = [NSNumber numberWithLong:0];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetFloorListRequestParam * wr = [[BaseDataGetFloorListRequestParam alloc] initWith:preRequestDate andPage:_floorPage];
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        NSDictionary * page = [data valueForKeyPath:@"page"];
        if(page && ![page isKindOfClass:[NSNull class]]) {
            [_floorPage setPageWithDictionary:page];
        }
        if(!_floorList) {
            _floorList = [[NSMutableArray alloc] init];
        } else {
            if([_floorPage isFirstPage]) {
                [_floorList removeAllObjects];
            }
        }
        
        NSMutableArray * dFloors = [data valueForKeyPath:@"contents"];
        if([dFloors isKindOfClass:[NSNull class]]) {
            dFloors = nil;
        }
        for(NSDictionary * dbFloor in dFloors) {
            Floor * floor = [[Floor alloc] init];
            floor.floorId = [dbFloor valueForKeyPath:@"floorId"];
            if([floor.floorId isKindOfClass:[NSNull class]]) {
                floor.floorId = nil;
                continue;
            }
            NSNumber * deleted = [dbFloor valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:floor.floorId];
                continue;
            }
            floor.code = [dbFloor valueForKeyPath:@"code"];
            if([floor.code isKindOfClass:[NSNull class]]) {
                floor.code = nil;
            }
            floor.name = [dbFloor valueForKeyPath:@"name"];
            if([floor.name isKindOfClass:[NSNull class]]) {
                floor.name = nil;
            }
            floor.buildingId = [dbFloor valueForKeyPath:@"buildingId"];
            if([floor.buildingId isKindOfClass:[NSNull class]]) {
                floor.buildingId = nil;
            }
            [_floorList addObject:floor];
        }
        
        
        CGFloat curPercent = 1 * _DEFAULT_PERCENT_FLOOR / (_floorPage.totalPage.integerValue);
        [self updateProgressWithAdd:curPercent];
        NSNumber * curProgress = [NSNumber numberWithFloat:[self getCurTaskFinishProgress]];
        [self deleteFloorInfo:deletedIdArray];
        [self notifyProgressUpdate:curProgress];
        if([_floorPage haveMorePage]) {
            [_floorPage nextPage];
            [self downloadFloor];
        } else {
            if([curProgress isEqualToNumber:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]]) {
                [self notifyTaskFinish:YES];
            }
            [self saveFloorInfo:_floorList];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) downloadRoom {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestDate = [NSNumber numberWithLong:0];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetRoomListRequestParam * wr = [[BaseDataGetRoomListRequestParam alloc] initWith:preRequestDate andPage:_roomPage];
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        NSDictionary * page = [data valueForKeyPath:@"page"];
        if(page && ![page isKindOfClass:[NSNull class]]) {
            [_roomPage setPageWithDictionary:page];
        }
        if(!_roomList) {
            _roomList = [[NSMutableArray alloc] init];
        } else {
            if([_roomPage isFirstPage]) {
                [_roomList removeAllObjects];
            }
        }
        NSMutableArray * drooms = [data valueForKeyPath:@"contents"];
        if([drooms isKindOfClass:[NSNull class]]) {
            drooms = nil;
        }
        for(NSDictionary * droom in drooms) {
            Room * room = [[Room alloc] init];
            room.roomId = [droom valueForKeyPath:@"roomId"];
            if([room.roomId isKindOfClass:[NSNull class]]) {
                room.roomId = nil;
                continue;
            }
            NSNumber * deleted = [droom valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:room.roomId];
                continue;
            }
            room.code = [droom valueForKeyPath:@"code"];
            if([room.code isKindOfClass:[NSNull class]]) {
                room.code = nil;
            }
            room.name = [droom valueForKeyPath:@"name"];
            if([room.name isKindOfClass:[NSNull class]]) {
                room.name = nil;
            }
            room.floorId = [droom valueForKeyPath:@"floorId"];
            if([room.floorId isKindOfClass:[NSNull class]]) {
                room.floorId = nil;
            }
            [_roomList addObject:room];
        }
        
        CGFloat curPercent = 1 * _DEFAULT_PERCENT_ROOM / (_roomPage.totalPage.integerValue);
        [self updateProgressWithAdd:curPercent];
        NSNumber * curProgress = [NSNumber numberWithFloat:[self getCurTaskFinishProgress]];
        [self deleteRoomInfo:deletedIdArray];
        [self notifyProgressUpdate:curProgress];
        if([_roomPage haveMorePage]) {
            
            [_roomPage nextPage];
            [self downloadRoom];
        } else {
            [self saveRoomInfo:_roomList];
            if([curProgress isEqualToNumber:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]]) {
                [self notifyTaskFinish:YES];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) taskProcessMethod {
    [super notifyTaskStart];
    
//    [self downloadCityAnSite];
    [self downloadBuilding];
    [self downloadFloor];
    [self downloadRoom];
}
- (void) saveCityInfo:(NSArray *) cityArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addCities:cityArray projectId:self.projectId];
}
- (void) deleteCityInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteCityByIds:idArray];
}
- (void) saveSiteInfo:(NSArray *) siteArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addSites:siteArray projectId:self.projectId];
}
- (void) deleteSiteInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteSiteByIds:idArray];
}
- (void) saveBuildingInfo:(NSArray *) buildingArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addBuildings:buildingArray projectId:self.projectId];
}
- (void) deleteBuildingInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteBuildingByIds:idArray];
}
- (void) saveFloorInfo:(NSArray *) floorArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addFloors:floorArray projectId:self.projectId];
}
- (void) deleteFloorInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteFloorByIds:idArray];
}
- (void) saveRoomInfo:(NSArray *) roomArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addRooms:roomArray projectId:self.projectId];
}
- (void) deleteRoomInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteRoomByIds:idArray];
}
@end

@interface DeviceTypeDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * deviceTypeList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@property (readwrite, nonatomic, strong) NetPage * mPage;
@end

@implementation DeviceTypeDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _deviceTypeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _deviceTypeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetDeviceTypeRequestParam * wr = [[BaseDataGetDeviceTypeRequestParam alloc] initWith:preRequestTime page:_mPage];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSDictionary * page = [data valueForKeyPath:@"page"];
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        NSDictionary * dataArray = [data valueForKeyPath:@"contents"];
        if([page isKindOfClass:[NSNull class]]) {
            page = nil;
        }
        if(page) {
            [_mPage setPageWithDictionary:page];
        }
        if(!_deviceTypeList) {
            _deviceTypeList = [[NSMutableArray alloc] init];
        } else {
            [_deviceTypeList removeAllObjects];
        }
        if([dataArray isKindOfClass:[NSNull class]]) {
            dataArray = nil;
        }
        for(NSDictionary * ddeviceType in dataArray) {
            DeviceType * deviceType = [[DeviceType alloc] init];
            deviceType.equSysId = [ddeviceType valueForKeyPath:@"equSysId"];
            if([deviceType.equSysId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [ddeviceType valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:deviceType.equSysId];
                continue;
            }
            deviceType.equSysCode = [ddeviceType valueForKeyPath:@"equSysCode"];
            if([deviceType.equSysCode isKindOfClass:[NSNull class]]) {
                deviceType.equSysCode = nil;
            }
            deviceType.equSysName = [ddeviceType valueForKeyPath:@"equSysName"];
            if([deviceType.equSysName isKindOfClass:[NSNull class]]) {
                deviceType.equSysName = nil;
            }
            deviceType.equSysDescription = [ddeviceType valueForKeyPath:@"equSysDescription"];
            if([deviceType.equSysDescription isKindOfClass:[NSNull class]]) {
                deviceType.equSysDescription = nil;
            }
            deviceType.equSysFullName = [ddeviceType valueForKeyPath:@"equSysFullName"];
            if([deviceType.equSysFullName isKindOfClass:[NSNull class]]) {
                deviceType.equSysFullName = nil;
            }
            deviceType.level = [[ddeviceType valueForKeyPath:@"level"] integerValue];
            deviceType.equSysParentSystemId = [ddeviceType valueForKeyPath:@"equSysParentSystemId"];
            if([deviceType.equSysParentSystemId isKindOfClass:[NSNull class]]) {
                deviceType.equSysParentSystemId = nil;
            }
            
            [_deviceTypeList addObject:deviceType];
        }
        [self saveDeviceTypeInfo:_deviceTypeList];
        [self deleteDeviceTypeInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:(_mPage.pageNumber.integerValue+1)*PERCENT_OF_SUCCESS/_mPage.totalPage.integerValue]];
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self taskProcessMethod];
        } else {
            [self notifyTaskFinish:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) saveDeviceTypeInfo:(NSArray *) deviceTypeList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addDeviceTypes:deviceTypeList projectId:self.projectId];
}
- (void) deleteDeviceTypeInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteDeviceTypeByIds:idArray];
}
@end

@interface DeviceDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * deviceList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@property (readwrite, nonatomic, strong) NetPage * mPage;
@end

@implementation DeviceDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _deviceList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_DEVICE];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _deviceList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_DEVICE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataGetDeviceListRequestParam * param = [[BaseDataGetDeviceListRequestParam alloc] initWith:preRequestTime page:_mPage];
    [[CommonBusiness getInstance] getEquipmentByParam:param success:^(NSInteger key, id object) {
        BaseDataGetDeviceListRequestResponseData * data = object;
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        _mPage = data.page;
        if(!_deviceList) {
            _deviceList = [[NSMutableArray alloc] init];
        } else {
            [_deviceList removeAllObjects];
        }
        for(Device * dev in data.contents) {
            if(dev.deleted) {
                [deletedIdArray addObject:dev.eqId];
            } else {
                [_deviceList addObject:dev];
            }
        }
        [self saveDeviceInfo:_deviceList];
        [self deleteDeviceInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:(_mPage.pageNumber.integerValue+1)*PERCENT_OF_SUCCESS/_mPage.totalPage.integerValue]];
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self taskProcessMethod];
        } else {
            [self notifyTaskFinish:YES];
        }
    } fail:^(NSInteger key, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}

- (void) saveDeviceInfo:(NSArray *) deviceList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addDevices:deviceList];
}
- (void) deleteDeviceInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteDeviceByIds:idArray];
}
@end

@interface FlowDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * flowList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@property (readwrite, nonatomic, strong) NetPage * mPage;
@end

@implementation FlowDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _flowList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_FLOW];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _flowList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        _mPage = [[NetPage alloc] init];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_FLOW];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataGetFlowListRequestParam * param = [[BaseDataGetFlowListRequestParam alloc] initWith:preRequestTime page:_mPage];
    [[CommonBusiness getInstance] getFlowByParam:param success:^(NSInteger key, id object) {
        BaseDataGetFlowListRequestResponseData * data = object;
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        _mPage = data.page;
        if(!_flowList) {
            _flowList = [[NSMutableArray alloc] init];
        } else {
            [_flowList removeAllObjects];
        }
        for(Flow * flow in data.contents) {
            if(flow.deleted) {
                [deletedIdArray addObject:flow.wopId];
            } else {
                [_flowList addObject:flow];
            }
        }
        [self saveFlowInfo:_flowList];
        [self deleteFlowInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:(_mPage.pageNumber.integerValue+1)*PERCENT_OF_SUCCESS/_mPage.totalPage.integerValue]];
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self taskProcessMethod];
        } else {
            [self notifyTaskFinish:YES];
        }
    } fail:^(NSInteger key, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) saveFlowInfo:(NSArray *) flowList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addFlows:flowList];
}
- (void) deleteFlowInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteFlowByIds:idArray];
}
@end

//需求类型下载
@interface RequirementTypeDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * typeList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation RequirementTypeDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _typeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _typeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetRequirementTypeListRequestParam * wr = [[BaseDataGetRequirementTypeListRequestParam alloc] initWith:preRequestTime];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        
        for(NSDictionary * dtype in data) {
            RequirementType * type = [[RequirementType alloc] init];
            type.typeId = [dtype valueForKeyPath:@"typeId"];
            if([type.typeId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [dtype valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:type.typeId];
                continue;
            }
            type.parentTypeId = [dtype valueForKeyPath:@"parentTypeId"];
            if([type.parentTypeId isKindOfClass:[NSNull class]]) {
                type.parentTypeId = nil;
            }
            type.name = [dtype valueForKeyPath:@"name"];
            if([type.name isKindOfClass:[NSNull class]]) {
                type.name = nil;
            }
            type.fullName = [dtype valueForKeyPath:@"fullName"];
            if([type.fullName isKindOfClass:[NSNull class]]) {
                type.fullName = nil;
            }
            
            
            [_typeList addObject:type];
        }
        [self saveRequirementInfo:_typeList];
        [self deleteRequirementInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
        [self notifyTaskFinish:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) saveRequirementInfo:(NSArray *) typeList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addRequirementTypes:typeList projectId:self.projectId];
}
- (void) deleteRequirementInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteRequirementTypeByIds:idArray];
}
@end

//满意度类型下载
@interface SatisfactionTypeDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * typeList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation SatisfactionTypeDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _typeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _typeList = [[NSMutableArray alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    BaseDataGetSatisfactionListRequestParam * wr = [[BaseDataGetSatisfactionListRequestParam alloc] initWith:preRequestTime];
    
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
            return;
        }
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        for(NSDictionary * dtype in data) {
            SatisfactionType * type = [[SatisfactionType alloc] init];
            type.sdId = [dtype valueForKeyPath:@"sdId"];
            if([type.sdId isKindOfClass:[NSNull class]]) {
                continue;
            }
            NSNumber * deleted = [dtype valueForKeyPath:@"deleted"];
            if([deleted isKindOfClass:[NSNull class]]) {
                deleted = nil;
            }
            if(deleted.boolValue) {
                [deletedIdArray addObject:type.sdId];
                continue;
            }
            type.degree = [dtype valueForKeyPath:@"degree"];
            if([type.degree isKindOfClass:[NSNull class]]) {
                type.degree = nil;
            }
            type.sdValue = [dtype valueForKeyPath:@"sdValue"];
            if([type.sdValue isKindOfClass:[NSNull class]]) {
                type.sdValue = nil;
            }
            
            [_typeList addObject:type];
        }
        [self saveSatisfactionInfo:_typeList];
        [self deleteSatisfactionInfo:deletedIdArray];
        [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
        [self notifyTaskFinish:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) saveSatisfactionInfo:(NSArray *) typeList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addSatisfactionTypes:typeList projectId:self.projectId];
}
- (void) deleteSatisfactionInfo:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteSatisfactionTypeByIds:idArray];
}
@end

@interface FailureReasonDownloadTask ()
@property (readwrite, nonatomic, strong) NSMutableArray * reasonList;
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@property (readwrite, nonatomic, strong) NetPage * page;
@end
@implementation FailureReasonDownloadTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _reasonList = [[NSMutableArray alloc] init];
        _page = [[NetPage alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _reasonList = [[NSMutableArray alloc] init];
        _page = [[NetPage alloc] init];
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}

- (void) requestFailureReasonOfCurrentPage {
    NSNumber * preRequestTime = [SystemConfig getPreRequestDate];
    BaseDataGetFailureReasonRequestParam * param = [[BaseDataGetFailureReasonRequestParam alloc] initWith:preRequestTime];
    [param setPage:_page];
    [[CommonBusiness getInstance] getFailureReasonByParam:param success:^(NSInteger key, id object) {
        BaseDataGetFailureReasonResponseData * data = object;
        [_page setPage:data.page];
        NSMutableArray * reasonList = [[NSMutableArray alloc] init];
        NSMutableArray * deletedIdArray = [[NSMutableArray alloc] init];
        for(FailureReason * reason in data.contents) {
            if(reason.deleted) {
                [deletedIdArray addObject:reason.reasonId];
            } else {
                [reasonList addObject:reason];
            }
        }
        [self saveFailureReasonInfo:reasonList];
        [self deleteFailureReasonByIds:deletedIdArray];
        
        if([_page haveMorePage]) {
            [self notifyProgressUpdate:[NSNumber numberWithFloat:(_page.pageNumber.integerValue+1)*PERCENT_OF_SUCCESS/_page.totalPage.integerValue]];
            [_page nextPage];
            [self requestFailureReasonOfCurrentPage];
        } else {
            [self notifyProgressUpdate:[NSNumber numberWithFloat:PERCENT_OF_SUCCESS]];
            [self notifyTaskFinish:YES];
        }
    } fail:^(NSInteger key, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    [self requestFailureReasonOfCurrentPage];
}
- (void) saveFailureReasonInfo:(NSArray *) reasonList {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper addFailureReasons:reasonList];
}
- (void) deleteFailureReasonByIds:(NSArray *) idArray {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteFailureReasonByIds:idArray];
}
@end



@interface ClearBaseDataTask ()
@property (readwrite, nonatomic, strong) BaseDataDbHelper * dbHelper;
@end

@implementation ClearBaseDataTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_CLEAR_BASE_DATA];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _dbHelper = [BaseDataDbHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_CLEAR_BASE_DATA];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    [self performSelectorInBackground:@selector(clearAllBaseInfo) withObject:nil];
}

- (void) clearAllBaseInfo {
    [self clearDeviceInfo];
    [self clearDeviceTypeInfo];
    [self clearLocationInfo];
    [self clearOrgInfo];
    [self clearPriorityInfo];
    [self clearFlowInfo];
    [self clearServiceTypeInfo];
    [self clearRequirementTypeInfo];
    [self clearSatisfactionInfo];
    
    [self clearDownloadRecord];
    [self notifyTaskFinish:YES];
}

- (void) clearOrgInfo {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllOrgsOfCurrentProject];
}
- (void) clearDeviceInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllDevicesOfCurrentProject];
}
- (void) clearDeviceTypeInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllDeviceTypeOfCurrentProject];
}
- (void) clearLocationInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllCitiesOfCurrentProject];
    [_dbHelper deleteAllBuildingsOfCurrentProject];
    [_dbHelper deleteAllSitesOfCurrentProject];
    [_dbHelper deleteAllFloorOfCurrentProject];
    [_dbHelper deleteAllRoomOfCurrentProject];
}
- (void) clearPriorityInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllPriorityOfCurrentProject];
}
- (void) clearFlowInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllFlowOfCurrentProject];
}
- (void) clearServiceTypeInfo{
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllServiceTypeOfCurrentProject];
}

- (void) clearRequirementTypeInfo {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllRequirementTypeOfCurrentProject];
}

- (void) clearSatisfactionInfo {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllSatisfactionTypeOfCurrentProject];
}

- (void) clearDownloadRecord {
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    [_dbHelper deleteAllDownloadRecordOfCurrentProject];
}
@end

//复位所有设置
@interface ResetDBTask ()
@property (readwrite, nonatomic, strong) BaseDataDbHelper * baseDbHelper;   //基础数据
@property (readwrite, nonatomic, strong) PatrolDBHelper * patrolDbHelper;   //巡检数据
@property (readwrite, nonatomic, strong) NotificationDbHelper * notificationDbHelper;   //消息数据
@end

@implementation ResetDBTask
- (instancetype) init {
    self = [super init];
    if(self) {
        _baseDbHelper = [BaseDataDbHelper getInstance];
        _patrolDbHelper = [PatrolDBHelper getInstance];
        _notificationDbHelper = [NotificationDbHelper getInstance];

        [self setTaskType:BASE_TASK_TYPE_RESET_DB_DATA];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _baseDbHelper = [BaseDataDbHelper getInstance];
        _patrolDbHelper = [PatrolDBHelper getInstance];
        _notificationDbHelper = [NotificationDbHelper getInstance];
        
        [self setTaskType:BASE_TASK_TYPE_RESET_DB_DATA];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    [self performSelectorInBackground:@selector(clearAllSettings) withObject:nil];
}

- (void) clearAllSettings {
    [self deleteDbData];
    [self notifyTaskFinish:YES];
}

//清除数据库
- (void) deleteDbData {
    [self deleteAllBaseData];
    [self deleteAllPatrolTaskData];
    [self deleteAllNotification];
}
//清除基础数据
- (void) deleteAllBaseData {
    [_baseDbHelper deleteAllBaseData];
}
//清除巡检任务
- (void) deleteAllPatrolTaskData {
    [_patrolDbHelper deleteAllPatrolData];
}
//清除消息记录
- (void) deleteAllNotification {
    [_notificationDbHelper deleteAllNotification];
}
@end


@interface ReportUploadTask ()
@property (readwrite, nonatomic, strong) NSNumber * reportId;
@property (readwrite, nonatomic, strong) NSMutableArray * imgs;
@property (readwrite, nonatomic, strong) NSMutableArray * imgIds;
@property (readwrite, nonatomic, strong) ReportDbHelper * dbHelper;
@end

@implementation ReportUploadTask

- (instancetype) initWithReportId:(NSNumber *) reportId {
    self = [super init];
    if(self) {
        _reportId = reportId;
        _dbHelper = [ReportDbHelper getInstance];
        [self setTaskKey:_reportId];
        [self setTaskType:BASE_TASK_TYPE_UPLOAD_REPORT];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithReportId:(NSNumber *) reportId andLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _reportId = reportId;
        _dbHelper = [ReportDbHelper getInstance];
        [self setTaskKey:_reportId];
        [self setTaskType:BASE_TASK_TYPE_UPLOAD_REPORT];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) taskProcessMethod {
    [super notifyTaskStart];
    _imgs = [_dbHelper queryAllImageByReport:_reportId];
    if(_imgs && [_imgs count] > 0) {
        [self requestUploadFile];
    } else {
        [self requestUploadReport];
    }
    
}

- (void) requestUploadFile {
    [[FileUploadService getInstance] uploadImageFiles:_imgs listener:self];
}

- (void) requestUploadReport {
    ReportNetRequest * netRequest = [ReportNetRequest getInstance];

    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    Report * report = [_dbHelper queryReportById:_reportId];
    ReportUploadRequest * wr = [[ReportUploadRequest alloc] initWith:report];
    wr.pictures = _imgIds;
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }
        NSNumber * orderId = [data valueForKeyPath:@"workOrderId"];
        if([orderId isKindOfClass:[NSNull class]]) {
            orderId = nil;
        }
        [self notifyTaskFinish:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self notifyTaskFinish:NO];
    }];
}


- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    _imgIds = nil;
    [self notifyTaskFinish:NO];
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)object {
    _imgIds = object;
    [self requestUploadReport];
}

@end

@interface PatrolDBInsertTask ()

@property (readwrite, nonatomic, strong) NSMutableArray * patrolArray;
@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;

@end

@implementation PatrolDBInsertTask

- (instancetype) init {
    self = [super init];
    if(self) {
        _patrolArray = [[NSMutableArray alloc] init];
        _dbHelper = [PatrolDBHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_INSERT_PATROL_TASK];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _patrolArray = [[NSMutableArray alloc] init];
        _dbHelper = [PatrolDBHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_INSERT_PATROL_TASK];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}

- (void) setPatrolArray:(NSMutableArray *)patrolArray {
    _patrolArray = patrolArray;
}

- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSNumber * userId = [SystemConfig getUserId];
    [_dbHelper addPatrolTasks:_patrolArray withUserId:userId];
    [self notifyTaskFinish:YES];
}


@end


@interface PatrolDBClearTask ()

@property (readwrite, nonatomic, strong) NSMutableArray * idArray;
@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;

@end

@implementation PatrolDBClearTask

- (instancetype) init {
    self = [super init];
    if(self) {
        _idArray = [[NSMutableArray alloc] init];
        _dbHelper = [PatrolDBHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_CLEAR_PATROL_TASK];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:BASE_TASK_LEVEL_NORMAL];
    }
    return self;
}
- (instancetype) initWithLevel:(BaseTaskLevel) level {
    self = [super init];
    if(self) {
        _idArray = [[NSMutableArray alloc] init];
        _dbHelper = [PatrolDBHelper getInstance];
        [self setTaskType:BASE_TASK_TYPE_CLEAR_PATROL_TASK];
        [self setTaskStatus:BASE_TASK_STATUS_INIT];
        [self setTaskLevel:level];
    }
    return self;
}
- (void) setPatrolTaskIds:(NSMutableArray *)idArray {
    _idArray = idArray;
}

- (void) taskProcessMethod {
    [super notifyTaskStart];
    NSNumber * userId = [SystemConfig getUserId];
    [_dbHelper deletePatrolTaskNotIn:_idArray userId:userId];
    [self notifyTaskFinish:YES];
}


@end


@implementation BaseTaskManager


//+ (instancetype) getInstance {
//    if(!taskManagerInstance) {
//        taskManagerInstance = [[BaseTaskManager alloc] init];
//    }
//    return taskManagerInstance;
//}

- (instancetype) init {
    self = [super init];
    if(self) {
        _taskList = [[NSMutableArray alloc] init];
        _curTaskIndex = TASK_INDEX_UNKNOW;
    }
    return self;
}

- (NSNumber *) getAnTaskKey {
    NSNumber * key = 0;
    key = [NSNumber numberWithInteger:_taskKey++];
    return key;
}

- (BOOL) isTaskExist:(BaseTask *) task {
    BOOL res = NO;
    for(BaseTask * bt in _taskList) {
        if(task.taskType == bt.taskType && (task.taskKey == bt.taskKey || [task.taskKey isEqualToNumber:bt.taskKey])) {
            res = YES;
            break;
        }
    }
    return res;
}

//计算当前任务总数
- (NSInteger) getTaskCount {
    NSInteger count = 0;
    if(_taskList) {
        count = [_taskList count];
    }
    return count;
}

//添加下载任务
- (void) addTask:(BaseTask *) task {
    if(!_taskList) {
        _taskList = [[NSMutableArray alloc] init];
    }
    if(![self isTaskExist:task]) {
        @synchronized(_taskList) {
            [_taskList addObject:task];
        }
    }
}

//移除指定位置任务
- (void) removeTaskAt:(NSInteger) position {
    if(position >=0 && position < [self getTaskCount]) {
        [_taskList removeObjectAtIndex:position];
    }
}

//移除指定任务
- (void) removeTask:(BaseTask *) task {
    if(_taskList) {
        [_taskList removeObject:task];
    }
}

//移除指定类型的所有任务
- (void) removeAllTaskOfType:(BaseTaskType) taskType {
    if(_taskList) {
        @synchronized(_taskList) {
            NSInteger index = 0;
            NSInteger count = [_taskList count];
            for(index=0;index<count;) {
                BaseTask * task = _taskList[index];
                if(taskType == task.taskType && task.taskStatus != BASE_TASK_STATUS_HANDLING) {//只有任务的状态不是正在处理中才能删除
                    [_taskList removeObject:task];
                } else {
                    index++;
                }
                count = [_taskList count];
            }
        }
    }
}

//移除所有任务
- (void) removeAllTask {
    if(_taskList) {
        [_taskList removeAllObjects];
    }
}

//获取下一个待处理任务
- (BaseTask *) getNextTask {
    BaseTask * res;
    BaseTask * taskLow;
    BaseTask * taskNormal;
    BaseTask * taskHigh;
    @synchronized(_taskList){
        NSInteger count = [_taskList count];
        NSInteger index = 0;
        for(index = 0;index<count;index++) {
            BaseTask * taskItem = _taskList[index];
            BaseTaskStatus status = [taskItem getTaskStatus];
            if(status == BASE_TASK_STATUS_INIT) {
                switch(taskItem.taskLevel) {
                    case BASE_TASK_LEVEL_HIGH:
                        if(!taskHigh) {
                            taskHigh = taskItem;
                        }
                        break;
                    case BASE_TASK_LEVEL_NORMAL:
                        if(!taskNormal) {
                            taskNormal = taskItem;
                        }
                        break;
                    case BASE_TASK_LEVEL_LOW:
                        if(!taskLow) {
                            taskLow = taskItem;
                        }
                        break;
                    default:
                        break;
                }
                if(taskHigh) {      //只有在找到一个最高级别的任务时才能立刻停止查找
                    break;
                }
            }
        }
    }
    if(taskHigh) {
        res = taskHigh;
    } else if (taskNormal) {
        res = taskNormal;
    } else {
        res = taskLow;
    }
    if(res) {
        [res setTaskStatus:BASE_TASK_STATUS_HANDLING];
    }
    return res;
}

//获取下载任务信息
- (BaseTask *) getTaskByKey:(NSNumber *) taskKey {
    BaseTask * task = nil;
    for(BaseTask * t in _taskList) {
        if([t.taskKey isEqualToNumber:taskKey]) {
            task = t;
            break;
        }
    }
    return task;
}

//更新任务数据
- (void) updateTask:(BaseTask *) task {
    NSInteger position = [_taskList indexOfObject:task];
    if(position >= 0 && position < [_taskList count]) {
        _taskList[position] = task;
    }
}

- (BOOL) hasTaskOfTypeToHandle:(BaseTaskType) taskType {
    BOOL res = NO;
    for(BaseTask * task in _taskList) {
        if(task.taskType == taskType && (task.taskStatus == BASE_TASK_STATUS_INIT || task.taskStatus == BASE_TASK_STATUS_HANDLING)) {
            res = YES;
            break;
        }
    }
    return res;
}
@end


@interface BaseDataDownloader ()

@property (readwrite, nonatomic, strong) BaseTaskManager * taskManager;
@property (readwrite, nonatomic, assign) BOOL working;
@property (readwrite, nonatomic, assign) NSInteger taskCheckTimeSep;//任务检测的频率
@property (readwrite, nonatomic, assign) NSInteger defaultTaskCheckTimeSep;//默认任务检测的频率

@property (readwrite, nonatomic, strong) NSMutableDictionary * taskListenerMap;

@property (readwrite, atomic, strong) NSCondition *condition;   //锁

@property (readwrite, nonatomic, strong) NSNumber * targetRequestDate;    //保存上次请求时间

@property (readwrite, nonatomic, assign) BOOL isDownloadingOrg;         //部门
@property (readwrite, nonatomic, strong) BaseTaskResult * orgResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingPriority;    //优先级
@property (readwrite, nonatomic, strong) BaseTaskResult * priorityResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingServiceType; //服务类型
@property (readwrite, nonatomic, strong) BaseTaskResult * serviceTypeResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingLocation;    //位置
@property (readwrite, nonatomic, strong) BaseTaskResult * locationResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingDeviceType;  //设备类型
@property (readwrite, nonatomic, strong) BaseTaskResult * deviceTypeResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingDevice;      //设备
@property (readwrite, nonatomic, strong) BaseTaskResult * deviceResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingFlow;        //流程
@property (readwrite, nonatomic, strong) BaseTaskResult * flowResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingRequirementType; //需求类型
@property (readwrite, nonatomic, strong) BaseTaskResult * requirementTypeResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingSatisfaction; //满意度
@property (readwrite, nonatomic, strong) BaseTaskResult * satisfactionResult;

@property (readwrite, nonatomic, assign) BOOL isDownloadingFailureReason; //故障原因
@property (readwrite, nonatomic, strong) BaseTaskResult * failureReasonResult;

@end

@implementation BaseDataDownloader

- (instancetype) init {
    self = [super init];
    if(self) {
        _taskManager = [[BaseTaskManager alloc] init];
        _working = YES;
        _defaultTaskCheckTimeSep = 10;
        _taskListenerMap = [[NSMutableDictionary alloc] init];
        _condition = [[NSCondition alloc] init];
        _targetRequestDate = [SystemConfig getPreRequestDate];
        [self performSelectorInBackground:@selector(handleTask) withObject:nil];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!downloaderInstance) {
        downloaderInstance = [[BaseDataDownloader alloc] init];
    }
    return downloaderInstance;
}

//判断是否正在下载基础数据
- (BOOL) isDownloading {
    BOOL res = NO;
    res = _isDownloadingOrg || _isDownloadingLocation || _isDownloadingPriority || _isDownloadingDeviceType || _isDownloadingDevice || _isDownloadingFlow || _isDownloadingServiceType || _isDownloadingRequirementType || _isDownloadingSatisfaction;
    return res;
}

//获取部门下载信息信息
- (BaseTaskResult *) getOrgDownloadResult {
    return _orgResult;
}

//获取位置下载信息信息
- (BaseTaskResult *) getLocationDownloadResult {
    return _locationResult;
}

//获取服务类型下载信息信息
- (BaseTaskResult *) getServiceTypeDownloadResult {
    return _serviceTypeResult;
}

//获取设备下载信息信息
- (BaseTaskResult *) getDeviceDownloadResult {
    return _deviceResult;
}

//获取设备类型下载信息
- (BaseTaskResult *) getDeviceTypeDownloadResult {
    return _deviceTypeResult;
}

//获取流程下载信息
- (BaseTaskResult *) getFlowDownloadResult {
    return _flowResult;
}

//获取优先级下载信息
- (BaseTaskResult *) getPriorityDownloadResult {
    return _priorityResult;
}

//获取需求类型下载信息
- (BaseTaskResult *) getRequirementTypeDownloadResult {
    return _requirementTypeResult;
}

//获取优先级下载信息
- (BaseTaskResult *) getSatisfactionDownloadResult {
    return _satisfactionResult;
}

- (void) handleTask {
    while (_working) {
        [_condition lock];
        BaseTask * task = [_taskManager getNextTask];
        if(!task) {
            [_condition wait];
        }
        [_condition unlock];
        [task taskProcessMethod];
    }
}

//设置基础数据目标记录
- (void) setTargetRecord:(NSNumber *) targetRequestDate {
    _targetRequestDate = targetRequestDate;
}

//下载部门数据
- (void) downloadOrgInfo {
    OrgDownloadTask * task = [[OrgDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _orgResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingOrg = YES;
    [_condition signal];
    [_condition unlock];
}

//下载优先级数据
- (void) downloadPriorityInfo {
    PriorityDownloadTask * task = [[PriorityDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _priorityResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingPriority = YES;
    [_condition signal];
    [_condition unlock];
}

//下载服务类型数据
- (void) downloadServiceTypeInfo {
    ServiceTypeDownloadTask * task = [[ServiceTypeDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _serviceTypeResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingServiceType = YES;
    [_condition signal];
    [_condition unlock];
}

//下载位置数据
- (void) downloadLocationInfo {
    LocationDownloadTask * task = [[LocationDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _locationResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingLocation = YES;
    [_condition signal];
    [_condition unlock];
}

//下载设备类型数据
- (void) downloadDeviceTypeInfo {
    DeviceTypeDownloadTask * task = [[DeviceTypeDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _deviceTypeResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingDeviceType = YES;
    [_condition signal];
    [_condition unlock];
}

//下载设备数据
- (void) downloadDeviceInfo {
    DeviceDownloadTask * task = [[DeviceDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _deviceResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingDevice = YES;
    [_condition signal];
    [_condition unlock];
}

//下载流程数据
- (void) downloadFlowInfo {
    FlowDownloadTask * task = [[FlowDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _flowResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingFlow = YES;
    [_condition signal];
    [_condition unlock];
}

//下载需求类型数据
- (void) downloadRequirementTypeInfo {
    RequirementTypeDownloadTask * task = [[RequirementTypeDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _requirementTypeResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingRequirementType = YES;
    [_condition signal];
    [_condition unlock];
}

//下载满意度数据
- (void) downloadSatisfactionInfo {
    SatisfactionTypeDownloadTask * task = [[SatisfactionTypeDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _satisfactionResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingSatisfaction = YES;
    [_condition signal];
    [_condition unlock];
}

//下载故障原因信息
- (void) downloadFailureReasonInfo {
    FailureReasonDownloadTask * task = [[FailureReasonDownloadTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager addTask:task];
    _failureReasonResult = [[BaseTaskResult alloc] init];
    [_condition lock];
    _isDownloadingFailureReason = YES;
    [_condition signal];
    [_condition unlock];
}

//清除基本数据
- (void) clearBaseData {
    ClearBaseDataTask * task = [[ClearBaseDataTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager removeAllTaskOfType:BASE_TASK_TYPE_CLEAR_BASE_DATA];
    [_taskManager addTask:task];
    [_condition lock];
    [_condition signal];
    [_condition unlock];
}


//清除数据库所有数据
- (void) resetDbData {
    ResetDBTask * task = [[ResetDBTask alloc] init];
    task.taskKey = [_taskManager getAnTaskKey];
    [task setOnTaskStatusListener:self];
    [_taskManager removeAllTaskOfType:BASE_TASK_TYPE_RESET_DB_DATA];
    [_taskManager addTask:task];
    [_condition lock];
    [_condition signal];
    [_condition unlock];
}

//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType {
    if(!_taskListenerMap) {
        _taskListenerMap = [[NSMutableDictionary alloc] init];
    }
    [_taskListenerMap setValue:listener forKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
}

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType {
    if(_taskListenerMap) {
        [_taskListenerMap removeObjectForKey:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
}

//移除所有的任务监听器
- (void) removeAllTaskListener {
    if(_taskListenerMap) {
        [_taskListenerMap removeAllObjects];
    }
}

- (id<OnMessageHandleListener>) getListenerOfType:(BaseTaskType) taskType {
    id<OnMessageHandleListener> res;
    res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    if(!res) {  //如果找不到专用的事件代理，就找相应类型的通用代理
        switch (taskType) {
            case BASE_TASK_TYPE_DOWNLOAD_ORG:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_PRIORITY:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_LOCATION:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_DEVICE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_FLOW:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE:
                taskType = BASE_TASK_TYPE_DOWNLOAD_ALL;
                break;
            case BASE_TASK_TYPE_UPLOAD_REPORT:
                taskType = BASE_TASK_TYPE_UPLOAD_ALL;
                break;
            default:
                break;
        }
        res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
    return res;
}

//标记任务已经完成---当前项目任务
- (void) updateTaskProgress:(BaseTaskType) taskType status:(BaseTaskStatus) taskStatus progress:(CGFloat) progress {
    BOOL isDownloading = YES;
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS || taskStatus == BASE_TASK_STATUS_FINISH_FAIL) {
        progress = PERCENT_OF_SUCCESS;
        isDownloading = NO;
    }
    
    DownloadRecord * downloadRecord;
    if(_targetRequestDate) {
        downloadRecord = [[DownloadRecord alloc] initWithDataType:BASE_DATA_TYPE_ALL andPreRequestDate:_targetRequestDate];
    }
    BOOL isBaseData = NO;
    switch (taskType) {
        case BASE_TASK_TYPE_DOWNLOAD_ORG:
            _isDownloadingOrg = isDownloading;
            _orgResult.taskStatus = taskStatus;
            _orgResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_PRIORITY:
            _isDownloadingPriority = isDownloading;
            _priorityResult.taskStatus = taskStatus;
            _priorityResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE:
            _isDownloadingServiceType = isDownloading;
            _serviceTypeResult.taskStatus = taskStatus;
            _serviceTypeResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_LOCATION:
            _isDownloadingLocation = isDownloading;
            _locationResult.taskStatus = taskStatus;
            _locationResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE:
            _isDownloadingDeviceType = isDownloading;
            _deviceTypeResult.taskStatus = taskStatus;
            _deviceTypeResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_DEVICE:
            _isDownloadingDevice = isDownloading;
            _deviceResult.taskStatus = taskStatus;
            _deviceResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_FLOW:
            _isDownloadingFlow = isDownloading;
            _flowResult.taskStatus = taskStatus;
            _flowResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE:
            _isDownloadingRequirementType = isDownloading;
            _requirementTypeResult.taskStatus = taskStatus;
            _requirementTypeResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE:
            _isDownloadingSatisfaction = isDownloading;
            _satisfactionResult.taskStatus = taskStatus;
            _satisfactionResult.taskProgress = progress;
            isBaseData = YES;
            break;
        case BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE:
            _isDownloadingFailureReason = isDownloading;
            _failureReasonResult.taskStatus = taskStatus;
            _failureReasonResult.taskProgress = progress;
            isBaseData = YES;
            break;
        default:
            break;
    }
    if(progress == PERCENT_OF_SUCCESS && isBaseData && downloadRecord && ![self isDownloading]) {
        if([dbHelper isDownloadRecordExist:BASE_DATA_TYPE_ALL]) {
            [dbHelper updateDownloadRecordByType:BASE_DATA_TYPE_ALL downloadRecord:downloadRecord];
        } else {
            [dbHelper addDownloadRecord:downloadRecord projectId:[SystemConfig getCurrentProjectId]];
        }
    }
}

//处理内部的消息
- (void) handleMessage:(id)msg {
    NSDictionary * msgDict = (NSDictionary *)msg;
    BaseTaskType taskType = [[msgDict valueForKeyPath:@"taskType"] integerValue];
    BaseTaskStatus taskStatus = [[msgDict valueForKeyPath:@"taskStatus"] integerValue];
    NSNumber * taskProgress = [msgDict valueForKeyPath:@"taskProgress"];
    NSNumber * taskKey = [msgDict valueForKeyPath:@"taskKey"];
    BaseTask * task = [_taskManager getTaskByKey:taskKey];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId && [task.projectId isEqualToNumber:projectId]) {    //如果是当前项目的下载任务，正常处理
        id<OnMessageHandleListener> listener = [self getListenerOfType:taskType];
        BOOL allFinish = NO;
        if(taskStatus == BASE_TASK_STATUS_FINISH_FAIL || taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {   //判断当前类型的任务是否都已经完成
            allFinish = ![_taskManager hasTaskOfTypeToHandle:taskType];
        }
        [self updateTaskProgress:taskType status:taskStatus progress:taskProgress.floatValue];
        if(listener) {
            [msg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
            [listener handleMessage:msg];
            if(allFinish) {
                NSMutableDictionary * allFinishMsg = [[NSMutableDictionary alloc] init];
                [allFinishMsg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
                [allFinishMsg setValue:[NSNumber numberWithInteger:taskType] forKeyPath:@"taskType"];
                [allFinishMsg setValue:[NSNumber numberWithInteger:BASE_TASK_STATUS_TYPE_FINISH] forKeyPath:@"taskStatus"];
                
                [listener handleMessage:allFinishMsg];
                [_condition lock];
                [_taskManager removeAllTaskOfType:taskType];
                [_condition unlock];
            }
        }
    } else {    //如果不是当前项目的任务，完成之后就移除该任务
        [_taskManager removeTask:task];
    }
}

//复位下载服务
- (void) reset {
    _isDownloadingOrg = NO;
    _isDownloadingLocation = NO;
    _isDownloadingPriority = NO;
    _isDownloadingDeviceType = NO;
    _isDownloadingDevice = NO;
    _isDownloadingFlow = NO;
    _isDownloadingServiceType = NO;
    _isDownloadingRequirementType = NO;
    _isDownloadingSatisfaction = NO;
}

- (void) exit {
    _working = NO;
}

@end



@interface BaseDataUploader ()
@property (readwrite, nonatomic, strong) BaseTaskManager * taskManager;
@property (readwrite, nonatomic, assign) BOOL working;
@property (readwrite, nonatomic, assign) NSInteger taskCheckTimeSep;//任务检测的频率
@property (readwrite, nonatomic, assign) NSInteger defaultTaskCheckTimeSep;//默认任务检测的频率

@property (readwrite, nonatomic, strong) NSMutableDictionary * taskListenerMap;

@property (readwrite, atomic, strong) NSCondition *condition;   //锁

@end


@implementation BaseDataUploader

- (instancetype) init {
    self = [super init];
    if(self) {
        _taskManager = [[BaseTaskManager alloc] init];
        _working = YES;
        _defaultTaskCheckTimeSep = 10;
        _taskListenerMap = [[NSMutableDictionary alloc] init];
        _condition = [[NSCondition alloc] init];
        [self performSelectorInBackground:@selector(handleTask) withObject:nil];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!uploaderInstance) {
        uploaderInstance = [[BaseDataUploader alloc] init];
    }
    return uploaderInstance;
}

- (void) handleTask {
    while (_working) {
        [_condition lock];
        BaseTask * task = [_taskManager getNextTask];
        if(!task) {
            [_condition wait];
        }
        [_condition unlock];
        [task taskProcessMethod];
    }
}


//上传报障数据
- (void) uploadReportInfo:(NSNumber *) reportId {
    ReportUploadTask * reportTask = [[ReportUploadTask alloc] initWithReportId:reportId];
    [reportTask setOnTaskStatusListener:self];
    [_condition lock];
    [_taskManager addTask:reportTask];
    [_condition signal];
    [_condition unlock];
}

//上传一组报障数据
- (void) uploadReportInfos:(NSMutableArray *) reportIdArray {
    NSMutableArray * taskArray = [[NSMutableArray alloc] init];
    for(NSNumber * reportId in reportIdArray) {
        ReportUploadTask * reportTask = [[ReportUploadTask alloc] initWithReportId:reportId];
        [reportTask setOnTaskStatusListener:self];
        [taskArray addObject:reportTask];
    }
    [_condition lock];
    for(ReportUploadTask * task in taskArray) {
        [_taskManager addTask:task];
    }
    [_condition signal];
    [_condition unlock];
}

//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType {
    if(!_taskListenerMap) {
        _taskListenerMap = [[NSMutableDictionary alloc] init];
    }
    [_taskListenerMap setValue:listener forKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
}

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType {
    if(_taskListenerMap) {
        [_taskListenerMap removeObjectForKey:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
}

//移除所有的任务监听器
- (void) removeAllTaskListener {
    if(_taskListenerMap) {
        [_taskListenerMap removeAllObjects];
    }
}

- (id<OnMessageHandleListener>) getListenerOfType:(BaseTaskType) taskType {
    id<OnMessageHandleListener> res;
    res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    if(!res) {  //如果找不到专用的事件代理，就找相应类型的通用代理
        switch (taskType) {
                
            case BASE_TASK_TYPE_UPLOAD_REPORT:
                taskType = BASE_TASK_TYPE_UPLOAD_ALL;
                break;
            default:
                break;
        }
        res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
    return res;
}

//处理内部的消息
- (void) handleMessage:(id)msg {
    NSDictionary * msgDict = (NSDictionary *)msg;
    
    BaseTaskType taskType = [[msgDict valueForKeyPath:@"taskType"] integerValue];
    BaseTaskStatus taskStatus = [[msgDict valueForKeyPath:@"taskStatus"] integerValue];
//    NSNumber * taskProgress = [msgDict valueForKeyPath:@"taskProgress"];
    id<OnMessageHandleListener> listener = [self getListenerOfType:taskType];
    BOOL allFinish = NO;
    if(taskStatus == BASE_TASK_STATUS_FINISH_FAIL || taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
        allFinish = ![_taskManager hasTaskOfTypeToHandle:taskType];
    }
    if(listener) {
        [msg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
        [listener handleMessage:msg];
        if(allFinish) {
            NSMutableDictionary * allFinishMsg = [[NSMutableDictionary alloc] init];
            [allFinishMsg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
            [allFinishMsg setValue:[NSNumber numberWithInteger:taskType] forKeyPath:@"taskType"];
            [allFinishMsg setValue:[NSNumber numberWithInteger:BASE_TASK_STATUS_TYPE_FINISH] forKeyPath:@"taskStatus"];

            [listener handleMessage:allFinishMsg];
            [_condition lock];
            [_taskManager removeAllTaskOfType:taskType];
            [_condition unlock];
        }
    }
    
}

- (void) exit {
    _working = NO;
}


@end




@interface LocalTaskManager ()
@property (readwrite, nonatomic, strong) BaseTaskManager * taskManager;
@property (readwrite, nonatomic, assign) BOOL working;
@property (readwrite, nonatomic, assign) NSInteger taskCheckTimeSep;//任务检测的频率
@property (readwrite, nonatomic, assign) NSInteger defaultTaskCheckTimeSep;//默认任务检测的频率

@property (readwrite, nonatomic, strong) NSMutableDictionary * taskListenerMap;

@property (readwrite, atomic, strong) NSCondition *condition;   //锁

@end


@implementation LocalTaskManager

- (instancetype) init {
    self = [super init];
    if(self) {
        _taskManager = [[BaseTaskManager alloc] init];
        _working = YES;
        _defaultTaskCheckTimeSep = 10;
        _taskListenerMap = [[NSMutableDictionary alloc] init];
        _condition = [[NSCondition alloc] init];
        [self performSelectorInBackground:@selector(handleTask) withObject:nil];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!localTaskInstance) {
        localTaskInstance = [[LocalTaskManager alloc] init];
    }
    return localTaskInstance;
}

- (void) handleTask {
    while (_working) {
        [_condition lock];
        BaseTask * task = [_taskManager getNextTask];
        if(!task) {
            [_condition wait];
        }
        [_condition unlock];
        [task taskProcessMethod];
    }
}

//添加任务数据
- (void) addPatrolTask:(NSMutableArray *) taskArray {
    PatrolDBInsertTask * insertTask = [[PatrolDBInsertTask alloc] init];
    [insertTask setPatrolArray:taskArray];
    insertTask.taskKey = [_taskManager getAnTaskKey];
    [insertTask setOnTaskStatusListener:self];
    
    [_condition lock];
    [_taskManager addTask:insertTask];
    [_condition signal];
    [_condition unlock];
}

- (void) clearPatrolTaskNotIn:(NSMutableArray *) idArray {
    PatrolDBClearTask * clearTask = [[PatrolDBClearTask alloc] init];
    [clearTask setPatrolTaskIds:idArray];
    clearTask.taskKey = [_taskManager getAnTaskKey];
    [clearTask setOnTaskStatusListener:self];
    
    [_condition lock];
    [_taskManager addTask:clearTask];
    [_condition signal];
    [_condition unlock];
}


//清除当前用户所有巡检任务
- (void) clearPatrolTaskOfCurrentUser {
    [self clearPatrolTaskNotIn:nil];
}


//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType {
    if(!_taskListenerMap) {
        _taskListenerMap = [[NSMutableDictionary alloc] init];
    }
    [_taskListenerMap setValue:listener forKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
}

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType {
    if(_taskListenerMap) {
        [_taskListenerMap removeObjectForKey:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
}

//移除所有的任务监听器
- (void) removeAllTaskListener {
    if(_taskListenerMap) {
        [_taskListenerMap removeAllObjects];
    }
}

- (id<OnMessageHandleListener>) getListenerOfType:(BaseTaskType) taskType {
    id<OnMessageHandleListener> res;
    res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    if(!res) {  //如果找不到专用的事件代理，就找相应类型的通用代理
        switch (taskType) {
                
            case BASE_TASK_TYPE_UPLOAD_REPORT:
                taskType = BASE_TASK_TYPE_UPLOAD_ALL;
                break;
            default:
                break;
        }
        res = [_taskListenerMap valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", taskType]];
    }
    return res;
}

//处理内部的消息
- (void) handleMessage:(id)msg {
    NSDictionary * msgDict = (NSDictionary *)msg;
    
    BaseTaskType taskType = [[msgDict valueForKeyPath:@"taskType"] integerValue];
    BaseTaskStatus taskStatus = [[msgDict valueForKeyPath:@"taskStatus"] integerValue];
//    NSNumber * taskProgress = [msgDict valueForKeyPath:@"taskProgress"];
    id<OnMessageHandleListener> listener = [self getListenerOfType:taskType];
    BOOL allFinish = NO;
    if(taskStatus == BASE_TASK_STATUS_FINISH_FAIL || taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
        allFinish = ![_taskManager hasTaskOfTypeToHandle:taskType];
    }
    if(listener) {
        [msg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
        [listener handleMessage:msg];
        if(allFinish) {
            NSMutableDictionary * allFinishMsg = [[NSMutableDictionary alloc] init];
            [allFinishMsg setValue:@"BaseDataDownloader" forKeyPath:@"msgOrigin"];
            [allFinishMsg setValue:[NSNumber numberWithInteger:taskType] forKeyPath:@"taskType"];
            [allFinishMsg setValue:[NSNumber numberWithInteger:BASE_TASK_STATUS_TYPE_FINISH] forKeyPath:@"taskStatus"];
            
            [listener handleMessage:allFinishMsg];
        }
    }
    if(allFinish) {
        [_taskManager removeAllTaskOfType:taskType];
    }
    
}

- (void) exit {
    _working = NO;
}


@end
