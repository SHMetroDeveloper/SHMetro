//
//  PatrolServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "PatrolServerConfig.h"
#import "SystemConfig.h"
#import "BaseBundle.h"

NSString * const UNDO_PATROL_TASK_URL = @"/v1/patrol/tasks/user/uncomplete/count";
NSString * const PATROL_TASK_URL = @"/m/v2/patrol/tasks";
NSString * const PATROL_SUBMIT_PATROL_TASK_URL = @"/m/v3/patrol/tasks/save";
//NSString * const PATROL_SUBMIT_SPOT_TASK_URL = @"/m/v1/patrol/tasks/save";

NSString * const PATROL_UPLOAD_IMAGE_URL = @"PatrolTaskSpotResult";
NSString * const PATROL_UPLOAD_IMAGE_URL_END = @"/img/";

//巡检记录列表
NSString * const PATROL_QUERY_LIST = @"/m/v2/patrol/tasks/query";
//巡检记录详情
NSString * const PATROL_QUERY_DETAIL = @"/m/v2/patrol/tasks/info";

//标记异常巡检项为异常已处理
NSString * const PATROL_CONTENT_ITEM_EXCEPTION_MARK = @"/m/v1/patrol/tasks/mark";

@implementation PatrolServerConfig

+ (NSString*) getPatrolImageUploadUrl:(NSNumber*) spotCheckContentId token:(NSString*) accessToken {
    NSString * res = [[NSString alloc] initWithFormat:@"%@/m/v1/files/upload/picture/%@/%lld%@?access_token=%@", [SystemConfig getServerAddress], PATROL_UPLOAD_IMAGE_URL, spotCheckContentId.longLongValue, PATROL_UPLOAD_IMAGE_URL_END, accessToken];
    return res;
}

+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

+ (NSString*) wrapPictureUrlById:(NSString*) token id:(NSNumber*) photoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/files/id/%lld/img", photoId.longLongValue];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

+ (NSString *) getEquipmentStatusDescription:(PatrolEquipmentExceptionStatus) status {
    NSString * res;
    switch(status) {
        case PATROL_EQUIPMENT_EXCEPTION_STATUS_IDLE:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_idle" inTable:nil];
            break;
        case PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_stop" inTable:nil];
            break;
        case PATROL_EQUIPMENT_EXCEPTION_STATUS_USING:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_using" inTable:nil];
            break;
        case PATROL_EQUIPMENT_EXCEPTION_STATUS_REPAIRING:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_repairing" inTable:nil];
            break;
        case PATROL_EQUIPMENT_EXCEPTION_STATUS_SCRAP:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_scrap" inTable:nil];
            break;
    }
    return res;
}

+ (NSString *) getTaskTypeDescription:(PatrolTaskType) taskType {
    NSString * res;
    switch (taskType) {
        case PATROL_TASK_TYPE_INSPECTION:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_type_inspection" inTable:nil];
            break;
            
        case PATROL_TASK_TYPE_PATROL:
            res = [[BaseBundle getInstance] getStringByKey:@"patrol_task_type_patrol" inTable:nil];
            break;
            
        default:
            break;
    }
    return res;
}

@end
