//
//  ReportEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportEntity.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "ReportServerConfig.h"


//报障上传的设备信息
@implementation ReportDevice
@end


//上传报障返回的结果
@implementation ReportResponseData
@end

//报障数据
@implementation Report

- (instancetype) init {
    self = [super init];
    if(self) {
        _position = [[Position alloc] init];
        _devices = [[NSMutableArray alloc] init];
        _orderType = REPORT_ORDER_TYPE_MAINTENANCE;
    }
    return self;
}

- (NSString *) getUserName {
    return _name;
}

@end



@implementation ReportUploadRequest

- (instancetype) initWith:(Report *) report {
    self = [super init];
    if(self) {
        _userId = [report.userId copy];
        _name = [report.name copy];
        _phone = [report.phone copy];
        _organizationId = [report.orgId copy];
        _serviceTypeId = [report.stypeId copy];
        _scDescription = [report.desc copy];
        _location = [report.position copy];
        _equipmentIds = [[NSMutableArray alloc] init];
        
        //此处需要把原来的ReportDevice类替换成 新的Device
        for(Device * rdev in report.devices)  {
            [_equipmentIds addObject:rdev.eqId];
        }
//        for(ReportDevice * rdev in report.devices)  {
//            [_equipmentIds addObject:[rdev.deviceId copy]];
//        }
        
        _priorityId = [report.priorityId copy];
        _processId = [report.processId copy];
        _patrolItemDetailId = [report.patrolItemDetailId copy];
        _reqId = [report.reqId copy];
        _woType = report.orderType;
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], REPORT_UPLOAD_URL];
    return res;
}
@end

@implementation ReportEntity



@end

