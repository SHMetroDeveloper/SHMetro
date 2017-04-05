//
//  WorkOrderApprovalEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderApprovalEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"
#import "MJExtension.h"

@implementation WorkOrderApprovalRequestParam

- (instancetype) initWithPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        if(!_page) {
            _page = [[NetPageParam alloc] init];
        }
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WORK_ORDER_APPROVAL_URL];
    return res;
}

@end

@implementation WorkOrderApprovalContentItem
@end

@implementation ApprovalContentItem
@end

@implementation ApprovalResult
@end

@implementation WorkOrderApproval

+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"approvalContent": @"ApprovalContentItem"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _approvalContent = [[NSMutableArray alloc] init];
    }
    return self;
}

//- (instancetype) initWithDictionary:(NSDictionary *) dic{
//    self = [super init];
//    if (self) {
//        _approvalContent = [[NSMutableArray alloc] init];
//        
//        _woId = [dic valueForKeyPath:@"woId"];
//        if([_woId isKindOfClass:[NSNull class]]) {
//            _woId = nil;
//        }
//        _actualCompletionDateTime = [dic valueForKeyPath:@"actualCompletionDateTime"];
//        if([_actualCompletionDateTime isKindOfClass:[NSNull class]]) {
//            _actualCompletionDateTime = nil;
//        }
//        _applicantName = [dic valueForKeyPath:@"applicantName"];
//        if ([_applicantName isKindOfClass:[NSNull class]]) {
//            _applicantName = nil;
//        }
//        _woDescription = [dic valueForKeyPath:@"woDescription"];
//        if([_woDescription isKindOfClass:[NSNull class]]) {
//            _woDescription = nil;
//        }
//        _createDateTime = [dic valueForKeyPath:@"createDateTime"];
//        if ([_createDateTime isKindOfClass:[NSNull class]]) {
//            _createDateTime = nil;
//        }
//        _priorityId = [dic valueForKeyPath:@"priorityId"];
//        if ([_priorityId isKindOfClass:[NSNull class]]) {
//            _priorityId = nil;
//        }
//        _workContent = [dic valueForKeyPath:@"workContent"];
//        if([_workContent isKindOfClass:[NSNull class]]) {
//            _workContent = nil;
//        }
//        _approvalSubmitDateTime = [dic valueForKeyPath:@"approvalSubmitDateTime"];
//        if ([_approvalSubmitDateTime isKindOfClass:[NSNull class]]) {
//            _approvalSubmitDateTime = nil;
//        }
//        _woCode = [dic valueForKeyPath:@"code"];
//        if ([_woCode isKindOfClass:[NSNull class]]) {
//            _woCode = nil;
//        }
//        _location = [dic valueForKeyPath:@"location"];
//        if ([_location isKindOfClass:[NSNull class]]) {
//            _location = nil;
//        }
//        _applicantPhone = [dic valueForKeyPath:@"applicantPhone"];
//        if ([_applicantPhone isKindOfClass:[NSNull class]]) {
//            _applicantPhone = nil;
//        }
//        _serviceTypeName = [dic valueForKeyPath:@"serviceTypeName"];
//        if ([_serviceTypeName isKindOfClass:[NSNull class]]) {
//            _serviceTypeName = nil;
//        }
//        NSNumber * tmpCurrentLaborerStatus = [dic valueForKeyPath:@"currentLaborerStatus"];
//        if (![tmpCurrentLaborerStatus isKindOfClass:[NSNull class]]) {
//            _currentLaborerStatus = tmpCurrentLaborerStatus.integerValue;
//        }
//        NSArray * contents = [dic valueForKeyPath:@"approvalContent"];
//        if([contents isKindOfClass:[NSNull class]]) {
//            contents = nil;
//        }
//        for (NSDictionary * dic in contents) {
//            ApprovalContentItem * content = [[ApprovalContentItem alloc] init];
//            content.name = [dic valueForKeyPath:@"name"];
//            content.value = [dic valueForKeyPath:@"value"];
//            [_approvalContent addObject:content];
//        }
//        NSNumber * tmpStatus = [dic valueForKeyPath:@"status"];
//        if (![tmpStatus isKindOfClass:[NSNull class]]) {
//            _status = tmpStatus.integerValue;
//        }
//        _approvalId = [dic valueForKeyPath:@"approvalId"];
//        if ([_approvalId isKindOfClass:[NSNull class]]) {
//            _approvalId = nil;
//        }
//    }
//    return self;
//}

- (NSString *) getCreateDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_createDateTime];
    }
    return res;
}

- (NSString *) getStatusStr {
    NSString * res = @"";
    WorkOrderStatus status = (WorkOrderStatus)_status;
    res = [WorkOrderServerConfig getOrderStatusDesc:status];
    return res;
}

- (NSString *) getPriorityName {
    NSString * res = @"";
    WorkOrderPriorityLevel level = (WorkOrderPriorityLevel)_priorityId.longLongValue;
    res = [WorkOrderServerConfig getOrderPriorityLevelDesc:level];
    return res;
}

- (NSString *) getEndDateStr {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_actualCompletionDateTime] && ![_actualCompletionDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = [FMUtils timeLongToDateString:_actualCompletionDateTime];
    }
    return res;
}

- (NSString *) getApprovalContent {
    NSString * res = @"";
    NSInteger index = 0;
    for(ApprovalContentItem * item in _approvalContent) {
        NSString * sep = @"";
        NSString * sepKeyValueLeft = @"";
        NSString * sepKeyValueRight = @"";
        if(index > 0) {
            sep = @";   ";
        }
        if(!item.name) {
            item.name = @"";
        }
        if(!item.value) {
            item.value = @"";
        }
        if(![FMUtils isStringEmpty:item.name] && ![FMUtils isStringEmpty:item.value]) {
            sepKeyValueLeft = @"(";
            sepKeyValueRight = @")";
        }
        res = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@", res, sep, item.name, sepKeyValueLeft, item.value, sepKeyValueRight];
        index++;
    }
    return res;
}
- (instancetype) copy {
    WorkOrderApproval * order = [[WorkOrderApproval alloc] init];
    order.woId = [_woId copy];
    order.code = [_code copy];
    order.pfmCode = [_pfmCode copy];
    order.location = [_location copy];
    order.actualCompletionDateTime = [_actualCompletionDateTime copy];
    order.woDescription = [_woDescription copy];
    order.approvalId = [_approvalId copy];
    order.applicantName = [_applicantName copy];
    order.applicantPhone = [_applicantPhone copy];
    order.serviceTypeName = [_serviceTypeName copy];
    order.createDateTime = [_createDateTime copy];
    order.approvalSubmitDateTime = [_approvalSubmitDateTime copy];
    order.priorityId = [_priorityId copy];
    order.status = _status;
    order.workContent = [_workContent copy];
    order.approvalContent = [_approvalContent copy];
    return order;
}
@end

@implementation ApprovalWorkOrderResponseData

+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"WorkOrderApproval"
             };
}

@end


@implementation ApprovalWorkOrderResponse

- (instancetype) init {
    self = [super init];
    if(self) {
        self.data = [[ApprovalWorkOrderResponseData alloc] init];
    }
    return self;
}

//- (id) getDataFromDictionary:(NSDictionary *)dic {
//    ApprovalWorkOrderResponseData * res;
//    if(dic) {
//        res = [[ApprovalWorkOrderResponseData alloc] init];
//        res.page = [[NetPage alloc] init];
//        [res.page setPageWithDictionary:[dic valueForKeyPath:@"page"]];
//        
//        res.contents = [[NSMutableArray alloc] init];
//        
//        NSMutableArray * orders = [dic valueForKeyPath:@"contents"];
//        if([orders isKindOfClass:[NSNull class]]) {
//            orders = nil;
//        }
//        
//        for(NSDictionary * order in orders) {
////            WorkOrderApproval * obj  = [[WorkOrderApproval alloc] initWithDictionary:order];
//            
//            [res.contents addObject:obj];
//        }
//    }
//    return res;
//}

@end




