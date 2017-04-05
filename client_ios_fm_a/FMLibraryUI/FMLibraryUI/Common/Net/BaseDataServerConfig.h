//
//  BaseDataServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseDataServerConfig : NSObject
+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url;
+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId;
@end

// 获取部门列表
extern NSString * const BASE_DATA_GET_ORG_LIST_URL;
// 获取服务类型列表
extern NSString * const BASE_DATA_GET_SERVICE_TYPE_LIST_URL;
// 获取所有的位置信息
extern NSString * const BASE_DATA_GET_POSITION_LIST_URL;
// 获取站点和区间信息
extern NSString * const BASE_DATA_GET_BUILDING_LIST_URL;
// 获取所有的位置信息
extern NSString * const BASE_DATA_GET_FLOOR_LIST_URL;
// 获取所有的位置信息
extern NSString * const BASE_DATA_GET_ROOM_LIST_URL;
// 获取所有的设备信息
extern NSString * const BASE_DATA_GET_DEVICE_LIST_URL;

// 获取所有的设备类型信息
extern NSString * const BASE_DATA_GET_DEVICE_TYPE_URL;

//获取所有的优先级信息
extern NSString * const BASE_DATA_GET_PRIORITY_LIST_URL;
//获取所有的流程信息
extern NSString * const BASE_DATA_GET_FLOW_LIST_URL;

//获取需求类型信息
extern NSString * const BASE_DATA_GET_REQUIREMENT_TYPE_LIST_URL;

//获取所有的满意度信息
extern NSString * const BASE_DATA_GET_SATISFACTION_LIST_URL;

//获取所有的故障原因信息
extern NSString * const BASE_DATA_GET_FAILURE_REASON_LIST_URL;


//获取服务器基础数据的更新记录
extern NSString * const BASE_DATA_GET_UPDATE_RECORD_URL;

//获取待处理任务的个数
extern NSString * const BASE_DATA_GET_UNDO_TASK_COUNT;

//获取仓库信息
extern NSString * const BASE_DATA_GET_WARE_HOUSE_URL;

//获取物料信息
extern NSString * const BASE_DATA_GET_MATERIAL_URL;

//获取物料数量
extern NSString * const BASE_DATA_GET_MATERIAL_AMOUNT_URL;

//批量获取指定物料的数量
extern NSString * const BASE_DATA_GET_MATERIAL_AMOUNT_LIST_URL;

//获取工单相关物料
extern NSString * const BASE_DATA_GET_WORK_ORDER_MATERIAL_URL;

//预定物料
extern NSString * const BASE_DATA_RESERVE_MATERIAL_URL;

//更新预定物料数量
extern NSString * const BASE_DATA_UPDATE_MATERIAL_URL;

//获取报表数据
extern NSString * const BASE_DATA_GET_CHART_DATA_URL;

//获取服务器 ID 信息
extern NSString * const BASE_DATA_GET_SERVER_ID_URL;

//获取项目列表
extern NSString * const BASE_DATA_GET_PROJECT_LIST_URL;
