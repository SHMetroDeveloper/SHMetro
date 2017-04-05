//
//  BaseDataServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseDataServerConfig.h"
#import "SystemConfig.h"

// 获取部门列表
//NSString * const BASE_DATA_GET_ORG_LIST_URL = @"/v1/organization/orglist";
NSString * const BASE_DATA_GET_ORG_LIST_URL = @"/m/v1/organizations/list";

// 获取服务类型列表
//NSString * const BASE_DATA_GET_SERVICE_TYPE_LIST_URL = @"/v1/servicetype/stlist";
NSString * const BASE_DATA_GET_SERVICE_TYPE_LIST_URL = @"/m/v1/servicetype";

// 获取所有的位置信息
NSString * const BASE_DATA_GET_POSITION_LIST_URL = @"/m/v1/place/city/site/building";
// 获取所有的位置信息
NSString * const BASE_DATA_GET_BUILDING_LIST_URL = @"/m/v2/place/buildings";
// 获取所有的位置信息
NSString * const BASE_DATA_GET_FLOOR_LIST_URL = @"/m/v1/place/floors";
// 获取所有的位置信息
NSString * const BASE_DATA_GET_ROOM_LIST_URL = @"/m/v1/place/rooms";

// 获取所有的设备信息
//NSString * const BASE_DATA_GET_DEVICE_LIST_URL = @"/v1/equipment/equlist";
NSString * const BASE_DATA_GET_DEVICE_LIST_URL = @"/m/v2/equipments/list";
NSString * const BASE_DATA_GET_DEVICE_TYPE_URL = @"/m/v1/equipments/systems";

//获取所有的优先级信息
NSString * const BASE_DATA_GET_PRIORITY_LIST_URL = @"/m/v1/priority";
//获取所有的流程信息
//NSString * const BASE_DATA_GET_FLOW_LIST_URL = @"/v1/process/processList";
NSString * const BASE_DATA_GET_FLOW_LIST_URL = @"/m/v2/process/list";

//需求类型
NSString * const BASE_DATA_GET_REQUIREMENT_TYPE_LIST_URL = @"/m/v1/requirementtype";
//满意度
NSString * const BASE_DATA_GET_SATISFACTION_LIST_URL = @"/m/v1/satisfactiondegree";
//故障原因
NSString * const BASE_DATA_GET_FAILURE_REASON_LIST_URL = @"/m/v1/troublecause";


//获取待更新数据信息
NSString * const BASE_DATA_GET_UPDATE_RECORD_URL = @"/m/v2/common/data/update";

//获取待处理任务数量
NSString * const BASE_DATA_GET_UNDO_TASK_COUNT = @"/m/v1/common/tasks/undo";

//获取仓库数据
NSString * const BASE_DATA_GET_WARE_HOUSE_URL = @"/m/v1/stock/warehouses";
//获取仓库中的物料
NSString * const BASE_DATA_GET_MATERIAL_URL = @"/m/v2/stock/inventorys";

//获取指定物料的数量
NSString * const BASE_DATA_GET_MATERIAL_AMOUNT_URL = @"/m/v1/stock/inventoryinfo";

//批量获取指定物料的数量
NSString * const BASE_DATA_GET_MATERIAL_AMOUNT_LIST_URL = @"/m/v1/stock/inventorylistinfo";

//获取工单相关物料
NSString * const BASE_DATA_GET_WORK_ORDER_MATERIAL_URL = @"/m/v1/workorder/materials/list";
//预定物料
NSString * const BASE_DATA_RESERVE_MATERIAL_URL = @"/m/v1/workorder/materials";
//更新预定物料数量
NSString * const BASE_DATA_UPDATE_MATERIAL_URL = @"/m/v1/workorder/materials/update";

//获取报表数据
NSString * const BASE_DATA_GET_CHART_DATA_URL = @"/m/v1/home/chart";

//获取服务器ID
NSString * const BASE_DATA_GET_SERVER_ID_URL = @"/m/v1/user/server";

//获取项目列表
NSString * const BASE_DATA_GET_PROJECT_LIST_URL = @"/m/v1/project/projectlist";

@implementation BaseDataServerConfig

+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/files/id/%lld/img", [photoId longLongValue]];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

@end
