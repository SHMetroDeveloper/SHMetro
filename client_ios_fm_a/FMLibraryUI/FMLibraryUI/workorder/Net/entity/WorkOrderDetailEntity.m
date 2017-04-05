//
//  WorkOrderDetailEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseBundle.h"

@implementation WorkOrderDetailRequestParam

- (instancetype) initWithOrderID:(NSNumber *) woId {
    self = [super init];
    if(self) {
        _woId = woId;
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_JOB_DETAIL_URL];
    return res;
}

@end

@implementation WorkOrderImage
@end

@implementation WorkOrderDetailEquipmentComponent
@end

@implementation WorkOrderEquipment

- (instancetype) copy {
    WorkOrderEquipment * equip = [[WorkOrderEquipment alloc] init];
    equip.equipmentId = [_equipmentId copy];
    equip.woId = [_woId copy];
    equip.equipmentCode = [_equipmentCode copy];
    equip.equipmentName = [_equipmentName copy];
    equip.location = [_location copy];
    equip.equipmentSystemName = [_equipmentSystemName copy];
    equip.failureDesc = [_failureDesc copy];
    equip.repairDesc = [_repairDesc copy];
    return equip;
}
@end

@implementation WorkOrderLaborer
//获取到场时间
- (NSString *) getArriveDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualArrivalDateTime] && ![_actualArrivalDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_actualArrivalDateTime];
        res = [FMUtils getMinuteStrWithoutYear:date];
    }
    return res;
}
//获取完成时间
- (NSString *) getFinishDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualCompletionDateTime] && ![_actualCompletionDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_actualCompletionDateTime];
        res = [FMUtils getMinuteStrWithoutYear:date];
    }
    return res;
}
//获取执行人状态
- (NSString *) getStatusStr {
    NSString * res = @"";
    WorkOrderLaborerStatus status = (WorkOrderLaborerStatus)_status;
    res = [WorkOrderServerConfig getOrderLaborerStatusDesc:status];
    return res;
}
@end

@implementation WorkOrderTool
- (instancetype) copy {
    WorkOrderTool * tool = [[WorkOrderTool alloc] init];
    if(tool) {
        tool.toolId = [_toolId copy];
        tool.name = [_name copy];
        tool.unit = [_unit copy];
        tool.amount = [_amount copy];
        tool.cost = [_cost copy];
        tool.comment = [_comment copy];
        tool.model = [_model copy];
        //        tool.brand = [_brand copy];
    }
    return tool;
}
@end



@implementation WorkOrderHistoryItem
- (instancetype)init {
    self = [super init];
    if (self) {
        _pictures = [NSMutableArray new];
        _attachment = [NSMutableArray new];
    }
    return self;
}
- (NSString *) getPortraitPhotoPathByportraitId:(NSNumber *) photo {
    NSString * imgPath = nil;
    /**
     *  此处填写从网络获取头像
     */
    return imgPath;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attachment" : @"WorkOrderAttachmentItem"
             };
}
@end

@implementation WorkOrderStep

//获取步骤的描述信息---形如“步骤一”
- (NSString *) getStepIndexDesc {
    NSString * desc;
    NSString * pre = [[BaseBundle getInstance] getStringByKey:@"order_step_step" inTable:nil];
    
    NSMutableArray * tmpArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"number_ten" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_one" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_two" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_three" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_four" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_five" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_six" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_seven" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_eight" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"number_nine" inTable:nil], nil];
    if(_sort > 0 && _sort < 100) {
        if(_sort < 10) {
            desc = [[NSString alloc] initWithFormat:@"%@%@", pre, tmpArray[_sort]];
        } else if(_sort < 20 ) {
            desc = [[NSString alloc] initWithFormat:@"%@%@%@", pre,  [[BaseBundle getInstance] getStringByKey:@"number_ten" inTable:nil], tmpArray[_sort%10]];
        } else {
            desc = [[NSString alloc] initWithFormat:@"%@%@%@%@", pre, tmpArray[_sort/10], [[BaseBundle getInstance] getStringByKey:@"number_ten" inTable:nil], tmpArray[_sort%10]];
        }
        
    }
    return desc;
}


//获取图片 URL 数组
- (NSMutableArray *) getPhotoArray {
    NSMutableArray * res;
    if(_photos) {
        res = [[NSMutableArray alloc] init];
        for (NSNumber * photoId in _photos) {
            NSURL * url = [FMUtils getUrlOfImageById:photoId];
            if(url) {
                [res addObject:url];
            }
        }
    }
    return res;
}
@end

@implementation WorkOrderStepInfo
@end

@implementation WorkOrderApprovalItem
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"approvalContent" : @"ApprovalContentItem",
             @"approvalResults" : @"ApprovalResult"
             };
}
@end

@implementation WorkOrderChargeItem
@end

@implementation WorkOrderAttachmentItem
@end

@implementation WorkOrderRelatedOrder
@end

@implementation WorkOrderDetail

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"histories" : @"WorkOrderHistoryItem",
             @"workOrderEquipments" : @"WorkOrderEquipment",
             @"workOrderLaborers" : @"WorkOrderLaborer",
             @"workOrderTools" : @"WorkOrderTool",
             @"approvals" : @"WorkOrderApprovalItem",
             @"charges" : @"WorkOrderChargeItem",
             @"steps" : @"WorkOrderStep",
             @"attachment" : @"WorkOrderAttachmentItem",
             @"relatedOrder" : @"WorkOrderRelatedOrder",
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        
        _workOrderEquipments = [[NSMutableArray alloc] init];
        _workOrderLaborers = [[NSMutableArray alloc] init];
        _workOrderTools = [[NSMutableArray alloc] init];
        _approvals = [[NSMutableArray alloc] init];
        _histories = [[NSMutableArray alloc] init];
        _steps = [[NSMutableArray alloc] init];
        _requirementPictures = [[NSMutableArray alloc] init];
        _currentRoles = [[NSMutableArray alloc] init];
        _requirementAudios = [[NSMutableArray alloc] init];
        _requirementVideos = [[NSMutableArray alloc] init];
        _requirementShortVideos = [[NSMutableArray alloc] init];
        _charges = [[NSMutableArray alloc] init];
        _attachment = [[NSMutableArray alloc] init];
//        _pictures = [[NSMutableArray alloc] init];
//        _pictures = [[NSMutableArray alloc] init];
//        _workOrderMaterials = [[NSMutableArray alloc] init];
    }
    return self;
}


//获取创建时间
- (NSString *) getCreateTimeStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateStringWithOutYear:_createDateTime];
    }
    return res;
}

//获取优先级描述
- (NSString *) getPriorityStr {
    NSString * res = @"";
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priorityId.integerValue;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}

//获取联系人
- (NSString *) getContact {
    NSString * res = @"";
    if(_applicantName) {
        res = _applicantName;
    }
    return res;
}

- (NSString *) getOrgStr {
    return _organizationName;
}
//到场时间
- (NSString *) getArriveTimeStr {
    NSString * res = @"";
    if(![FMUtils isNumberNullOrZero:_actualArrivalDateTime]) {
        res = [FMUtils timeLongToDateString:_actualArrivalDateTime];
    }
    return res;
}
//完成时间
- (NSString *) getFinishTimeStr {
    NSString * res = @"";
    if(![FMUtils isNumberNullOrZero:_actualCompletionDateTime]) {
        res = [FMUtils timeLongToDateString:_actualCompletionDateTime];
    }
    return res;
}
//获取耗时
- (NSString *) getTimeUsedStr {
    NSString * res = @"";
    if(![FMUtils isNumberNullOrZero:_actualArrivalDateTime] && ![FMUtils isNumberNullOrZero:_actualCompletionDateTime]) {
        CGFloat hours = (_actualCompletionDateTime.longLongValue - _actualArrivalDateTime.longLongValue)*1.0/(1000 * 60 * 60);
        res = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"order_time_used" inTable:nil], hours];
    }
    return res;
}
//获取预估时间
- (NSString *) getEstimateTimeStr {
    NSString * res = @"";
    if(![FMUtils isNumberNullOrZero:_estimateStartTime] && ![FMUtils isNumberNullOrZero:_estimateEndTime]) {
        
        res = [[NSString alloc] initWithFormat:@"%@ ~ %@", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_estimateStartTime]], [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_estimateEndTime]]];
    } else if(![FMUtils isNumberNullOrZero:_estimateStartTime]) {
        res = [[NSString alloc] initWithFormat:@"%@ ~ ", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_estimateStartTime]]];
    } else if(![FMUtils isNumberNullOrZero:_estimateEndTime]) {
        res = [[NSString alloc] initWithFormat:@" ~ %@", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_estimateEndTime]]];
    }
    return res;
}
//获取预约时间
- (NSString *) getReserveTimeStr {
    NSString * res = @"";
    if(![FMUtils isNumberNullOrZero:_reserveStartTime] && ![FMUtils isNumberNullOrZero:_reserveEndTime]) {

        res = [[NSString alloc] initWithFormat:@"%@ ~ %@", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_reserveStartTime]], [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_reserveEndTime]]];
    } else if(![FMUtils isNumberNullOrZero:_reserveStartTime]) {
        res = [[NSString alloc] initWithFormat:@"%@ ~ ", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_reserveStartTime]]];
    } else if(![FMUtils isNumberNullOrZero:_reserveEndTime]) {
        res = [[NSString alloc] initWithFormat:@" ~ %@", [FMUtils getMinuteStrWithoutYear:[FMUtils timeLongToDate:_reserveEndTime]]];
    }
    return res;
}

//判断是否有内容
//- (BOOL) hasContent {
//    BOOL res = NO;
//    if(![FMUtils isStringEmpty:_workContent]) {
//        res = YES;
//    }
//    return res;
//}

//判断是否有图片
//- (BOOL) hasPhoto {
//    BOOL res = NO;
//    if(![FMUtils isObjectNull:_pictures] && [_pictures count] > 0) {
//        res = YES;
//    }
//    return res;
//}

//获取待审核内容数组
- (NSMutableArray *) getApprovalContentsArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    BOOL isOK = NO;
    if( [_approvals count] > 0) {
        for(WorkOrderApprovalItem * item in _approvals) {
            isOK = NO;
            NSArray * approvalResults = item.approvalResults;
            NSNumber * result;
            for(ApprovalResult * itemResult in approvalResults) {
                result = itemResult.result;
                if(!result) {
                    isOK = YES;
                    break;
                }
            }
            if(!isOK) { //如果对应的审批结果不为空的话就是曾经审批过的内容，不用显示
                continue;
            }
            NSMutableArray * contents = item.approvalContent;
            for(ApprovalContentItem * itemContent in contents) {
                ApprovalContentItem * content = [[ApprovalContentItem alloc] init];
                content.name = itemContent.name;
                content.value = itemContent.value;
                [array addObject:content];
            }
        }
        
    }
    return array;
}

//获取审批内容
- (NSString *) getApprovalContent {
    NSString * res = @"";
    NSInteger index = 0;
    NSMutableArray * array = [self getApprovalContentsArray];
    for(WorkOrderApprovalContentItem * item in array) {
        NSString * sep = @"";
        if(index > 0) {
            sep = @"\n";
        }
        res = [[NSString alloc] initWithFormat:@"%@%@%@-%@", res, sep, item.name, item.value];
        index++;
    }
    return res;
}
//判断是否还有执行人还未接单
- (BOOL) hasSomeoneUnAccept {
    BOOL res = NO;
    for(WorkOrderLaborer * laborer in _workOrderLaborers) {
        NSInteger laborerStatus = laborer.status;
        if(laborerStatus == ORDER_STATUS_PERSONAL_UN_ACCEPT) {
            res = YES;
            break;
        }
    }
    return res;
}
//判断是否有设备未完成维保
- (NSInteger) getEquipmentUnCompletedCount {
    NSInteger res = 0;
    for(WorkOrderEquipment * equip in _workOrderEquipments) {
        if(!equip.finished && equip.needScan) {
            res++;
        }
    }
    return res;
}

//获取客户签字的图片URL
- (NSURL *) getCustomerSignImgUrl {
    NSURL * imgUrl;
    return imgUrl;
}
//获取主管签字的图片URL
- (NSURL *) getSupervisorSignImgUrl {
    NSURL * imgUrl;
    return imgUrl;
}
@end


@implementation WorkOrderDetailResponse
@end
