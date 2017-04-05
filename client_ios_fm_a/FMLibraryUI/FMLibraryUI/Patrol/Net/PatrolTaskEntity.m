//
//  PatrolTaskEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskEntity.h"
#import "SystemConfig.h"
#import "PatrolServerConfig.h"
#import "FMUtils.h"
#import "BaseBundle.h"


//NSString* const PATROL_STATUS_BEGIN_STR = @"未开始";
//NSString* const PATROL_STATUS_INPROGRESS_STR = @"进行中";
//NSString* const PATROL_STATUS_COMPLETE_STR = @"已完成";
//NSString* const PATROL_STATUS_DELAY_STR = @"延期完成";
//NSString* const PATROL_STATUS_INCOMPLETE_STR = @"未完成";
//
//
//
//NSString* const PATROL_SPOT_STATUS_NOT_BEGIN_STR = @"未开始";
//NSString* const PATROL_SPOT_STATUS_NORMAL_STR = @"已完成";
//NSString* const PATROL_SPOT_STATUS_EXCEPTION_STR = @"异常";
//NSString* const PATROL_SPOT_STATUS_NOT_FINISH_STR = @"未完成";



@implementation Patrol

- (instancetype) init {
    self = [super init];
    return self;
}

@end


@implementation PatrolTask

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"spots" : @"PatrolTaskSpot"
             };
}

- (instancetype) init {
    self = [super init];
    _spots = [[NSMutableArray alloc] init];
    return self;
}

- (NSInteger) getSpotCount {
    NSInteger count = 0;
    if(self.spots) {
        count = [self.spots count];
    }
    return count;
}
- (NSInteger) getEquipmentCount {
    NSInteger count = 0;
    for(PatrolTaskSpot * spot in self.spots) {
        if(spot && spot.equipments) {
            count += [spot.equipments count];
        }
    }
    return count;
}

- (NSString*) getStatus {
    NSString* statusStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_begin" inTable:nil];
    if([self getUnFinishCount] == 0) {
        statusStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
    } else if([self getFinishCount]) {
        statusStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_in_progress" inTable:nil];
    }
    return statusStr;
}




- (BOOL) needToBeSubmited {
    if(_status == PATROL_STATUS_COMPLETE) {
        return NO;
    }
    return YES;
}
- (NSString *) getContact {
    return [[BaseBundle getInstance] getStringByKey:@"patrol_laborer" inTable:nil];
}
//获取漏检数量
- (NSInteger) getIgnoreCount {
    NSInteger count = 0;
    for(PatrolTaskSpot * spot in _spots) {
        
        for(Equipment * equip in spot.equipments) {
            if([equip isIgnored]) {
                count++;
            }
        }
    }
    count = 1;
    return count;
}
//获取异常数量
- (NSInteger) getExceptionCount {
    NSInteger count = 0;
    for(PatrolTaskSpot * spot in _spots) {
        for(Equipment * equip in spot.equipments) {
            if([equip getExceptionCount] > 0) {
                count++;
            }
        }
    }
    return count;
}

//获取已完成的项数量
- (NSInteger) getFinishCount {
    NSInteger count = 0;
    for(PatrolTaskSpot * spot in _spots) {
        for(Equipment * equip in spot.equipments) {
            if([equip.finish boolValue]) {
                count++;
            }
        }
    }
    return count;
}
//获取未完成的项数量
- (NSInteger) getUnFinishCount {
    NSInteger count = 0;
    for(PatrolTaskSpot * spot in _spots) {
        for(Equipment * equip in spot.equipments) {
            if(![equip.finish boolValue]) {
                count++;
            }
        }
    }
    return count;
}

//判断是否有图片
- (BOOL) hasPhoto {
    BOOL res = NO;
    for(PatrolTaskSpot * spot in _spots) {
        if([spot hasPhoto]) {
            res = YES;
            break;
        }
    }
    return res;
}
//是否报修
- (BOOL) hasReport {
    BOOL res = NO;
    for(PatrolTaskSpot * spot in _spots) {
        if([spot hasReport]) {
            res = YES;
            break;
        }
    }
    return res;
}

//获取开始时间
- (NSString *) getStartTimeString {
    NSString * res = [FMUtils timeLongToDateString:_dueStartDateTime];
    return res;
}
//获取结束时间
- (NSString *) getEndTimeString {
    NSString * res = [FMUtils timeLongToDateString:_dueEndDateTime];
    return res;
}

+ (NSString *) getStatusStringBy:(PatrolStatusType) patrolStatus {
    NSString * res;
    switch (patrolStatus) {
        case PATROL_STATUS_BEGIN:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_begin" inTable:nil];
            break;
        case PATROL_STATUS_INPROGRESS:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_in_progress" inTable:nil];
            break;
        case PATROL_STATUS_COMPLETE:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
            break;
        case PATROL_STATUS_DELAY:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_delay" inTable:nil];
            break;
        case PATROL_STATUS_INCOMPLETE:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_incomplete" inTable:nil];
            break;
        default:
            res = @"";
            break;
    }
    return res;
}


@end

@implementation Spot

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}
- (instancetype) copy {
    Spot * res = [[Spot alloc] init];
    res.spotId = [_spotId copy];
    res.name = [_name copy];
    res.spotLocation = [_spotLocation copy];
    res.qrCode = [_qrCode copy];
    res.nfcTag = [_nfcTag copy];
    res.spotType = [_spotType copy];
    return res;
}
@end

@implementation PatrolTaskSpot

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"PatrolTaskItemDetail",
             @"equipments" : @"Equipment"
             };
}

- (instancetype) init {
    self = [super init];
    _spot = [[Spot alloc] init];
    _equipments = [[NSMutableArray alloc] init];
    _contents = [[NSMutableArray alloc] init];
    _startDateTime = [NSNumber numberWithLong:0];
    _endDateTime = [NSNumber numberWithLong:0];
    return self;
}

- (NSString*) getSpotName {
    return _spot.name;
}
- (NSString*) getSpotPlace {
    return _spot.spotLocation;
}
- (NSInteger) getCompisiteCount {
    NSInteger count = 0;
    if(_contents && [_contents count] > 0) {
        count = [_contents count];
    }
    return count;
}
- (NSInteger) getDeviceCount {
    NSInteger count = [_equipments count];
    return count;
}
- (NSString*) getTaskState {
    NSString* stateStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_begin" inTable:nil];
    BOOL isFinish = YES;
    BOOL isBegin = NO;
    BOOL isException = NO;
    for (Equipment * equip in _equipments) {
        if([equip getExceptionCount] > 0) {
            isException = YES;
            break;
        }
        if([equip.finish boolValue]) {    //只要有一个任务已经完成，表示任务已经处于开始处理状态
            isBegin = YES;
        }
        else {                            //只要有一个任务还未完成，表示任务还没完成
            isFinish = NO;
        }
    }
    if(isException) {
        stateStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_begin" inTable:nil];
    } else if(isFinish) {
        stateStr = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil];
    } else if(isBegin) {
        stateStr = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil];
    }
    return stateStr;
}
- (NSString *) getTaskFinishState {
    NSString * res;
    if([self isFinished]) {
        res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil];
    } else {
        res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil];
    }
    return res;
}


//是否含有图片
- (BOOL) hasPhoto {
    BOOL res = NO;
    for(Equipment * equip in _equipments) {
        if([equip hasPhoto]) {
            res = YES;
            break;
        }
    }
    return res;
}
- (BOOL) hasReport {
    BOOL res = NO;
    for(Equipment * equip in _equipments) {
        if([equip hasReport]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (BOOL) isFinished {
    BOOL res = YES;
    for (Equipment * equip in _equipments) {
        if(![equip.finish boolValue]) {//只要有一个任务还未完成，表示任务还没完成
            res = NO;
            break;
        }
    }
    return res;
}

//判断是否存在异常
- (BOOL) isException {
    BOOL res = NO;
    for (Equipment * equip in _equipments) {
        if([equip getExceptionCount] > 0) {
            res = YES;
            break;
        }
    }
    return res;
}

//判断数据是否被同步
- (BOOL) isSyn {
    BOOL res = NO;
    return res;
}

- (instancetype) copy {
    PatrolTaskSpot * res = [[PatrolTaskSpot alloc] init];
    res.spot = [_spot copy];
    res.startDateTime = [_startDateTime copy];
    res.endDateTime = [_endDateTime copy];
    res.equipments = [_equipments copy];
    res.finishStartTime = [_finishStartTime copy];
    res.finishEndTime = [_finishEndTime copy];
    return res;
}

//获取点位状态
+ (NSString *) getStatusStringBy:(PatrolSpotStatusType) spotStatus {
    NSString * res;
    switch (spotStatus) {
        case PATROL_SPOT_STATUS_NOT_BEGIN:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_begin" inTable:nil];
            break;
        case PATROL_SPOT_STATUS_NOT_FINISH:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil];
            break;
        case PATROL_SPOT_STATUS_NORMAL:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil];
            break;
        case PATROL_SPOT_STATUS_EXCEPTION:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_exception" inTable:nil];
            break;
        default:
            res = @"";
            break;
    }
    return res;
}
@end

@implementation PatrolTaskItemDetail

- (instancetype) init {
    self = [super init];
    _pictures = [[NSMutableArray alloc] init];
    _finish = [NSNumber numberWithBool:NO];
    return self;
}

- (NSArray *) getSelectValues {
    NSArray * array = [_selectEnums componentsSeparatedByString:@","];
    return array;
}

- (BOOL) isException {
    BOOL res = NO;
    if([_resultType integerValue] == 1) {  //输入
        NSNumber * tmpInput = [FMUtils stringToNumber:_resultInput];
        if([tmpInput compare:_inputFloor] == NSOrderedAscending || [tmpInput compare:_inputUpper] == NSOrderedDescending) {
            res = YES;
        }
    } else if([_resultType integerValue] == 2) {   //选择
        NSArray * valArray = [_selectRightValue componentsSeparatedByString:@","];
        res = YES;
        for(NSString * val in valArray) {
            if([_resultSelect compare:val] == NSOrderedSame) {
                res = NO;
                break;
            }
        }
    }
    return res;
}

//数据是否漏检
- (BOOL) isIgnore {
    BOOL res = NO;
    if([_resultType integerValue] == 1) {  //输入
        if(!_resultInput) {
            res = YES;
        }
    } else if([_resultType integerValue] == 2) {   //选择
        if([FMUtils isStringEmpty:_resultSelect]) {
            res = YES;
        }
    }
    return res;
}

- (BOOL) isReport {
    if([self isException]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *) getResultStr {
    NSString * res = nil;
    if([_resultType integerValue] == 1) {  //输入
        res = _resultInput;
    } else if([_resultType integerValue] == 2) {   //选择
        res = _resultSelect;
    }
    return res;
}

- (instancetype) copy {
    PatrolTaskItemDetail * res = [[PatrolTaskItemDetail alloc] init];
    res.spotContentId = [_spotContentId copy];
    res.content = [_content copy];
    res.selectEnums = [_selectEnums copy];
    res.contentType = [_contentType copy];
    res.resultType = [_resultType copy];
    res.selectRightValue = [_selectRightValue copy];
    res.inputUpper = [_inputUpper copy];
    res.inputFloor = [_inputFloor copy];
    res.resultSelect = [_resultSelect copy];
    res.resultInput = [_resultInput copy];
    
    res.comment = [_comment copy];
    res.finish = [_finish copy];
    res.pictures = [_pictures copy];
    return res;
}
@end

@implementation Equipment

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"PatrolTaskItemDetail"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _contents = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSInteger) getContentCount {
    return [_contents count];
}

- (NSString*) getStateStr {
    NSString * res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil];
    if([self getExceptionCount] > 0) {
        res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_exception" inTable:nil];
    } else if(_finish){
        res = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil];
    }
    return res;
}

- (BOOL) isIgnored {
    return NO;
}

- (NSInteger) getExceptionCount {
    NSInteger count = 0;
    for(PatrolTaskItemDetail * item in _contents) {
        if([item isException]) {
            count++;
        }
    }
    return count;
}

- (BOOL) hasPhoto {
    BOOL res = NO;
    for(PatrolTaskItemDetail * item in _contents) {
        if(item.pictures && [item.pictures count] > 0) {
            res = YES;
            break;
        }
    }
    return res;
}
- (BOOL) hasReport {
    BOOL res = NO;
    for(PatrolTaskItemDetail * item in _contents) {
        if([item isReport]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (instancetype) copy {
    Equipment * res = [[Equipment alloc] init];
    res.eqId = [_eqId copy];
    res.name = [_name copy];
    res.code = [_code copy];
    res.finish = [_finish copy];
    res.contents = [_contents copy];
    
    return res;
}
@end

@implementation PatrolTaskRequest
- (instancetype) init {
    self = [super init];
    if(self) {
        _page = [[NetPage alloc] init];
    }
    return self;
}
- (instancetype) initWithPage:(NetPageParam*) page {
    
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_TASK_URL];
    return res;
}

@end


@implementation PatrolTaskResponseData

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"PatrolTask"
             };
}

@end


@implementation PatrolTaskResponse
@end

