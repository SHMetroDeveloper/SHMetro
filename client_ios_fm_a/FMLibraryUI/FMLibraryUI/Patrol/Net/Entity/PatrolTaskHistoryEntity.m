//
//  PatrolTaskHistoryEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/28.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskHistoryEntity.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "PatrolServerConfig.h"
#import "BaseBundle.h"

NSString * PATROL_HISTORY_STATUS_UNKNOW_STR = @"未知";

NSString * PATROL_HISTORY_STATUS_NORMAL_STR = @"正常";
NSString * PATROL_HISTORY_STATUS_EXCEPTION_STR = @"异常";
NSString * PATROL_HISTORY_STATUS_MISS_STR = @"漏检";
NSString * PATROL_HISTORY_STATUS_REPAIR_STR = @"报修";
NSString * PATROL_HISTORY_STATUS_ADD_STR = @"补检";

@implementation PatrolTaskHistoryItem

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}
- (NSString *) getContact {
    return _laborer;
}

//获取实际时间
- (NSString *) getRealityTimeDesc {
    NSString * res = @"";
    return res;
    
}
//获取预估时间
- (NSString *) getEstatedTimeDesc {
    NSString * res = @"";
    return res;
}

//获取预估开始时间
- (NSString *) getActualEndDate {
    NSString * res = @"";
    res = [FMUtils timeLongToDateString:_dueEndDateTime];
    return res;
}
//获取实际开始时间
- (NSString *) getActualStartDate {
    NSString * res = @"";
    res = [FMUtils timeLongToDateString:_dueStartDateTime];
    return res;
}

//获取漏检的数量
- (NSInteger) getIgnoreCount {
    NSInteger count = _leakNumber;
    return count;
}
//获取异常的数量
- (NSInteger) getExceptionCount {
    NSInteger exception = _exceptionNumber;
    return exception;
}
//获取正常的数量
- (NSInteger) getNormalCount {
    NSInteger normal = _normalNumber;
    return normal;
}
//获取报修的数量
- (NSInteger) getRepairCount {
    NSInteger normal = _repairNumber;
    return normal;
}
//是否含图片
- (BOOL) hasPhoto {
    BOOL res = NO;
    return res;
}
//是否已报修
- (BOOL) hasReport {
    BOOL res = YES;
    return res;
}
//是否有补检
- (BOOL) hasInspection {
    BOOL res = NO;
    return res;
}
//获取点位个数
- (NSInteger) getSpotCount {
    return _spotNumber;
}

//获取开始时间
- (NSString *) getStartTimeString {
    NSString * res = @"";
    res = [FMUtils timeLongToDateStringWithOutYear:_dueStartDateTime];
    return res;
}
//获取结束时间
- (NSString *) getEndTimeString {
    NSString * res = @"";
    res = [FMUtils timeLongToDateStringWithOutYear:_dueEndDateTime];
    return res;
}

//获取状态的字符串表示
+ (NSString *) getStatusStringByStatus:(PatrolTaskHistoryStatus) status{
    NSString * res = @"";
    switch (status) {
        case PATROL_HISTORY_STATUS_NORMAL:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_normal" inTable:nil];
            break;
        case PATROL_HISTORY_STATUS_EXCEPTION:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil];
            break;
        case PATROL_HISTORY_STATUS_MISS:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil];
            break;
        case PATROL_HISTORY_STATUS_REPAIR:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil];
            break;
        case PATROL_HISTORY_STATUS_ADD:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_status_fillup" inTable:nil];
            break;
    }
    return res;
}

@end

@implementation PatrolSearchCondition

- (instancetype) init {
    self = [super init];
    if(self) {
        _normal = [NSNumber numberWithBool:NO];
        _exception = [NSNumber numberWithBool:NO];
        _leak = [NSNumber numberWithBool:NO];
        _repair = [NSNumber numberWithBool:NO];
    }
    return self;
}
@end


@implementation PatrolTaskHistoryDetailItem

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"spots" : @"PatrolTaskHistorySpot"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _spots = [[NSMutableArray alloc] init];
    }
    return self;
}
//
//- (NSString *) getFullName {
//    NSString * strName = @"";
//    if(_patrolName) {
//        strName = _patrolName;
//    }
//    return strName;
//}
//获取开始时间的字符串
- (NSString *) getStartTimeString {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_dueStartDateTime] && ![_dueStartDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_dueStartDateTime];
    }
    return res;
}
//获取结束时间的字符串
- (NSString *) getFinishTimeString {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_dueEndDateTime] && ![_dueEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_dueEndDateTime];
    }
    return res;
}

////获取状态的字符串表示
//+ (NSString *) getStatusStringByStatus:(PatrolTaskHistoryStatus) status{
//    NSString * res = @"";
//    switch (status) {
//        case PATROL_HISTORY_STATUS_NORMAL:
//            res = PATROL_HISTORY_STATUS_NORMAL_STR;
//            break;
//        case PATROL_HISTORY_STATUS_EXCEPTION:
//            res = PATROL_HISTORY_STATUS_EXCEPTION_STR;
//            break;
//        case PATROL_HISTORY_STATUS_MISS:
//            res = PATROL_HISTORY_STATUS_MISS_STR;
//            break;
//        case PATROL_HISTORY_STATUS_REPAIR:
//            res = PATROL_HISTORY_STATUS_REPAIR_STR;
//            break;
//        case PATROL_HISTORY_STATUS_ADD:
//            res = PATROL_HISTORY_STATUS_ADD_STR;
//            break;
//    }
//    return res;
//}
//获取实际开始时间
- (NSString *) getActualStartTimeString {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualStartDateTime] && ![_actualStartDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_actualStartDateTime];
    }
    return res;
}
//获取实际完成时间
- (NSString *) getActualEndTimeString {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualEndDateTime] && ![_actualEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_actualEndDateTime];
    }
    return res;
}

// 获取预估时间
- (NSString *) getEstimateTimeString {
    NSString * timeSep = @"";
    if(![FMUtils isNumberNullOrZero:_dueStartDateTime] || ![FMUtils isNumberNullOrZero:_dueEndDateTime]) {
        timeSep = @" ~ ";
    }
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@%@", [FMUtils timeLongToDateStringWithOutYear:_dueStartDateTime], timeSep, [FMUtils timeLongToDateStringWithOutYear:_dueEndDateTime]];
    
    return res;
}
//获取实际时间
- (NSString *) getActualTimeString {
    NSString * timeSep = @"";
    if(![FMUtils isNumberNullOrZero:_actualStartDateTime] || ![FMUtils isNumberNullOrZero:_actualEndDateTime]) {
        timeSep = @" ~ ";
    }
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@%@", [FMUtils timeLongToDateStringWithOutYear:_actualStartDateTime], timeSep, [FMUtils timeLongToDateStringWithOutYear:_actualEndDateTime]];
    
    return res;
}
//获取正常的巡检项个数
- (NSInteger) getReportCount {
    NSInteger res = 0;
    for(PatrolTaskHistorySpot * spot in _spots) {
        res += [spot getReportCount];
    }
    return res;
}
//获取漏检项个数
- (NSInteger) getLeakCount {
    NSInteger res = 0;
    for(PatrolTaskHistorySpot * spot in _spots) {
        res += [spot getLeakCount];
    }
    return res;
}
//获取异常巡检项个数
- (NSInteger) getExceptionCount {
    NSInteger res = 0;
    for(PatrolTaskHistorySpot * spot in _spots) {
        res += [spot getExceptionCount];
    }
    return res;
}

//获取巡检周期
- (NSString *) getCycle {
    return _period;
}
@end

@implementation PatrolTaskHistorySynthesize

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"synthesizedContents" : @"PatrolTaskHistoryContentItem",
            @"synthesizedOrders" : @"PatrolTaskHistoryOrderItem",
             };
}
- (instancetype) init {
    self = [super init];
    if(self) {
        _synthesizedOrders = [[NSMutableArray alloc] init];
        _synthesizedContents = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation HistorySpot
@end

@implementation PatrolTaskHistorySpot

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"equipments" : @"PatrolTaskHistoryEquipment"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _spot = [[HistorySpot alloc] init];
        _equipments = [[NSMutableArray alloc] init];
        _synthesized = [[PatrolTaskHistorySynthesize alloc] init];
    }
    return self;
}
//是否异常
- (NSInteger) getExceptionCount {
    NSInteger res = 0;
    res += [self getSynthesizeExceptionCount];
    for(PatrolTaskHistoryEquipment * equip in _equipments) {
        res += [equip getExceptionCount];
    }
    return res;
}
//获取综合巡检部分异常数量
- (NSInteger) getSynthesizeExceptionCount {
    NSInteger res = 0;
    if(_synthesized) {
        for(PatrolTaskHistoryContentItem * content in _synthesized.synthesizedContents) {
            if([content isException]) {
                res++;
            }
        }
    }
    return res;
}
//是否漏检
- (NSInteger) getLeakCount {
    NSInteger res = 0;
    res += [self getSynthesizeLeakCount];
    for(PatrolTaskHistoryEquipment * equip in _equipments) {
        res += [equip getLeakCount];
    }
    return res;
    
}
//获取综合巡检部分漏检数量
- (NSInteger) getSynthesizeLeakCount {
    NSInteger res = 0;
    if(_synthesized) {
        for(PatrolTaskHistoryContentItem * content in _synthesized.synthesizedContents) {
            if([content isLeak]) {
                res++;
            }
        }
    }
    return res;
}
//是否正常
- (NSInteger) getNormalCount {
    NSInteger res = 0;
    res += [self getSynthesizeNormalCount];
    for(PatrolTaskHistoryEquipment * equip in _equipments) {
        res += [equip getNormalCount];
    }
    return res;
}
//获取综合巡检部分正常数量
- (NSInteger) getSynthesizeNormalCount {
    NSInteger res = 0;
    if(_synthesized) {
        for(PatrolTaskHistoryContentItem * content in _synthesized.synthesizedContents) {
            if([content isNormal]) {
                res++;
            }
        }
    }
    return res;
}
//是否报修过
- (NSInteger) getReportCount {
    NSInteger res = 0;
    res += [self getSynthesizeReportCount];
    if(_equipments) {
        for(PatrolTaskHistoryEquipment * equip in _equipments) {
            res += [equip getReportCount];
        }
    }
    return res;
}
//获取综合巡检部分正常数量
- (NSInteger) getSynthesizeReportCount {
    NSInteger res = 0;
    if(_synthesized) {
        res = [_synthesized.synthesizedOrders count];
    }
    return res;
}
@end

//@implementation PatrolTaskHistoryLaborer
//- (NSString *) getActualStartTimeString {
//    NSString * res = @"";
//    res = [FMUtils timeLongToDateString:_actualStartTime];
//    return res;
//}
//- (NSString *) getActualFinishTimeString {
//    NSString * res = @"";
//    res = [FMUtils timeLongToDateString:_actualFinishTime];
//    return res;
//}
//@end

@implementation PatrolTaskHistoryEquipment

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"orders" : @"PatrolTaskHistoryOrderItem",
             @"patrolTaskItemDetails" : @"PatrolTaskHistoryContentItem"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _orders = [[NSMutableArray alloc] init];
        _patrolTaskItemDetails = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSString *) getSystemName {
    return _sysType;
}
//是否异常
- (NSInteger) getExceptionCount {
    NSInteger res = 0;
    for(PatrolTaskHistoryContentItem * content in _patrolTaskItemDetails) {
        if([content isException]) {
            res++;
        }
    }
    return res;
}
//是否漏检
- (NSInteger) getLeakCount {
    NSInteger res = 0;
    for(PatrolTaskHistoryContentItem * content in _patrolTaskItemDetails) {
        if([content isLeak]) {
            res++;
        }
    }
    return res;
    
}
//是否正常
- (NSInteger) getNormalCount {
    NSInteger res = 0;
    for(PatrolTaskHistoryContentItem * content in _patrolTaskItemDetails) {
        if([content isNormal]) {
            res++;
        }
    }
   
    return res;
}
//是否报修过
- (NSInteger) getReportCount {
    NSInteger res = 0;
    res += [_orders count];
    return res;
}
@end

@implementation PatrolTaskHistoryContentItem
- (instancetype) init {
    self = [super init];
    if(self) {
        _imageIds = [[NSMutableArray alloc] init];
    }
    return self;
}
- (BOOL) isLeak {
    BOOL res = NO;
    if(_status == PATROL_HISTORY_STATUS_MISS){
        res = YES;
    }
    return res;
}
//是否正常(既无漏检也无异常)
- (BOOL) isNormal {
    BOOL res = YES;
    if(_status == PATROL_HISTORY_STATUS_NORMAL){
        res = YES;
    }
    return res;
}
- (BOOL) isException {
    BOOL res = NO;
    if(_status == PATROL_HISTORY_STATUS_EXCEPTION){
        res = YES;
    }
    return res;
}
- (BOOL) hasPhoto {
    BOOL res = NO;
    if(_imageIds && [_imageIds count] > 0) {
        res = YES;
    }
    return res;
}
@end

@implementation PatrolTaskHistoryOrderItem
- (instancetype) init {
    self = [super init];
    return self;
}
//- (NSString *) getStatusString {
//    NSString * strStatus = @"";
//    switch (_status) {
//        case WORK_ORDER_STATUS_ASS_CODE:
//            strStatus = WORK_ORDER_STATUS_ASS_CODE_STR;
//            break;
//        case WORK_ORDER_STATUS_CLOSE_CODE:
//            strStatus = WORK_ORDER_STATUS_CLOSE_CODE_STR;
//            break;
//        case WORK_ORDER_STATUS_FINISH_CODE:
////            strStatus = [[WorkJobEntity getStatusMap] valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", _statusSituation]];
//            
//            break;
//        case WORK_ORDER_STATUS_CREATED_CODE:
//            strStatus = WORK_ORDER_STATUS_CREATED_CODE_STR;
//            break;
//        case WORK_ORDER_STATUS_DO_CODE:
//            strStatus = WORK_ORDER_STATUS_DO_CODE_STR;
//            break;
//        case WORK_ORDER_STATUS_ABORT_CODE:
//            strStatus = WORK_ORDER_STATUS_ABORT_CODE_STR;
//            break;
//        case WORK_ORDER_STATUS_WAITTING_CODE:
//            strStatus = [[WorkJobEntity getStatusMap] valueForKeyPath:[[NSString alloc] initWithFormat:@"%ld", _statusSituation]];
//            break;
//            
//        case WORK_ORDER_STATUS_FINISH_OK:
//            strStatus = WORK_ORDER_STATUS_FINISH_OK_STR;
//            break;
//        case WORK_ORDER_STATUS_FINISH_ERROR:
//            strStatus = WORK_ORDER_STATUS_FINISH_ERROR_STR;
//            break;
//        case WORK_ORDER_STATUS_FINISH_CHECK:
//            strStatus = WORK_ORDER_STATUS_FINISH_CHECK_STR;
//            break;
//            
//        case WORK_ORDER_STATUS_WARTING_WAIT:
//            strStatus = WORK_ORDER_STATUS_WARTING_WAIT_STR;
//            break;
//        case WORK_ORDER_STATUS_WAITTING_STOP:
//            strStatus = WORK_ORDER_STATUS_WAITTING_STOP_STR;
//            break;
//        case WORK_ORDER_STATUS_WAITTING_XUDAN:
//            strStatus = WORK_ORDER_STATUS_WAITTING_XUDAN_STR;
//            break;
//            
//        default:
//            strStatus = @"未知状态";
//            break;
//    }
//
//    return strStatus;
//}

- (NSString *) getCreateTimeString {
    NSString * res = [FMUtils timeLongToDateString:_createDateTime];
    return res;
}
- (NSString *) getLaborerString {
    if(![FMUtils isStringEmpty:_requestor]) {
        return _requestor;
    }
    return @"无";
}
@end



@implementation PatrolTaskQueryRequest

- (instancetype) init {
    self = [super init];
    if(self) {
        _searchCondition = [[PatrolSearchCondition alloc] init];
    }
    return self;
}

- (instancetype) initWithPage:(NetPageParam *)page andCondition:(PatrolSearchCondition *)condition {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
        _searchCondition = condition;
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_QUERY_LIST];
    return res;
}
@end

@implementation PatrolTaskQueryResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"PatrolTaskHistoryItem"
             };
}
@end

@implementation PatrolTaskQueryResponse
@end


@implementation PatrolTaskDetatilRequest

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithTaskId:(NSNumber *)taskId {
    self = [super init];
    if(self) {
        _postId = [taskId copy];
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_QUERY_DETAIL];
    return res;
}

@end


@implementation PatrolTaskDetatilResponse
@end
