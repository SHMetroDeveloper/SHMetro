//
//  WorkOrderLaborerTimeEntity.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "AssetManagementConfig.h"
#import "WorkOrderDetailEntity.h"

typedef NS_ENUM(NSInteger, WorkOrderToolEditType) {    //工具编辑操作类型
    WORK_ORDER_TOOL_EDIT_TYPE_ADD = 0,   //添加
    WORK_ORDER_TOOL_EDIT_TYPE_MODIFY = 1,   //修改
    WORK_ORDER_TOOL_EDIT_TYPE_DELETE = 2,   //删除
};

typedef NS_ENUM(NSInteger, WorkOrderChargeEditType) {
    WORK_ORDER_CHARGE_TYPE_ADD = 0,  //添加
    WORK_ORDER_CHARGE_TYPE_MODIFY = 1,  //修改
    WORK_ORDER_CHARGE_TYPE_DELETE = 2,   //删除
};

typedef NS_ENUM(NSInteger, WorkOrderEquipmentEditType) {
    WORK_ORDER_EQUIPMENT_TYPE_ADD = 0,  //添加
    WORK_ORDER_EQUIPMENT_TYPE_MODIFY = 1,  //修改
    WORK_ORDER_EQUIPMENT_TYPE_DELETE = 2,   //删除
};


/**
 *  工单执行人时间设置
 */
@interface WorkOrderLaborerTimeSaveRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;  //工单ID
@property (readwrite, nonatomic, strong) NSNumber * laborerId; //执行人ID
@property (readwrite, nonatomic, strong) NSNumber * actualArrivalDate;  //执行人到场时间
@property (readwrite, nonatomic, strong) NSNumber * actualFinishDate;  //执行人完成时间
- (instancetype) init;
- (NSString *)getUrl;
@end


/**
 *  保存工具
 */
@interface WorkOrderToolSaveRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;  //工单Id
@property (readwrite, nonatomic, assign) NSInteger operateType;  //工具操作类型
@property (readwrite, nonatomic, strong) NSNumber * toolId;   //工具ID，在修改和删除工具请求时使用
@property (readwrite, nonatomic, strong) NSString * name;  //工具名称
@property (readwrite, nonatomic, strong) NSString * model;  //工具型号
@property (readwrite, nonatomic, strong) NSString * unit;  //工具单位
@property (readwrite, nonatomic, assign) NSInteger amount; //工具个数
@property (readwrite, nonatomic, assign) double cost;  //工具费用
@property (readwrite, nonatomic, strong) NSString * comment;  //工具备注
- (instancetype) init;
- (NSString *)getUrl;
@end

@interface WorkOrderToolIDResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSNumber * data;
- (instancetype)init;
@end



/**
 *  保存收费明细
 */
@interface WorkOrderChargeSaveRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;   //工单ID
@property (readwrite, nonatomic, assign) NSInteger operateType;   //收费明细操作类型
@property (readwrite, nonatomic, strong) NSNumber * chargeId;   //收费项id，在修改和删除请求时使用
@property (readwrite, nonatomic, strong) NSString * name;       //收费项名称
@property (readwrite, nonatomic, assign) double amount;        //收费金额
- (instancetype) init;
- (NSString *)getUrl;
@end

@interface WokrOrderChargeResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSNumber * data;
- (instancetype)init;
@end


//核心组件的替换记录
@interface WorkOrderEquipmentOperationRecord : NSObject
@property (nonatomic, strong) NSNumber *fromEqCoreId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic, strong) NSNumber *installDate;
@property (nonatomic, strong) NSNumber *expireDate;
@end


/**
 *  编辑故障设备
 */
@interface WorkOrderEquipmentEditRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;  //工单ID
@property (readwrite, nonatomic, assign) NSInteger operateType;  //操作类型，0---添加；1---修改；2---删除
@property (readwrite, nonatomic, strong) NSNumber * equipmentId; //设备ID
@property (readwrite, nonatomic, strong) NSString * failureDesc; //设备故障描述
@property (readwrite, nonatomic, strong) NSString * repairDesc;  //设备维修描述

@property (readwrite, nonatomic, assign) EquipmentStatus equipmentStatus;  //设备状态
@property (readwrite, nonatomic, assign) OrderEquipmentRepairType repairType;  //维修类型
@property (readwrite, nonatomic, strong) NSMutableArray * operation;  //核心组件操作记录

- (instancetype) init;
- (NSString *)getUrl;
@end


/**
 *  工作内容保存
 */
@interface WorkOrderWorkContentSaveRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;   //工单ID
@property (readwrite, nonatomic, strong) NSString * workContent;  //工作内容
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;  //工作相关的图片ID
- (instancetype)init;
- (NSString *)getUrl;
@end


/**
 *  计划性维护步骤
 */
@interface WorkOrderPlanMaintanceStepRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * woId;  //工单Id
@property (readwrite, nonatomic, strong) NSNumber * stepId;  //步骤Id
@property (readwrite, nonatomic, assign) BOOL finished;   //是否完成
@property (readwrite, nonatomic, strong) NSString * comment;  //工作描述
@property (readwrite, nonatomic, strong) NSMutableArray * photos;  //图片ID数组
- (instancetype) init;
- (NSString *)getUrl;
@end


/**
 *  获取执行人所属的工作组
 */
@interface WorkOrderLaborerWorkTeamRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * laborerId;  //执行人id
- (instancetype)init;
- (NSString *)getUrl;
@end

@interface WorkOrderLaborerWorkTeam : NSObject
@property (readwrite, nonatomic, strong) NSNumber * wtId; //工作组Id
@property (readwrite, nonatomic, strong) NSString * name;  //工作组名称
- (instancetype)init;
@end

@interface WorkOrderLaborerWorkTeamResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
- (instancetype)init;
@end

@interface WorkOrderSaveFailureReasonParam : BaseRequest
@property (nonatomic, strong) NSNumber *woId;
@property (nonatomic, strong) NSNumber *reasonId;
- (instancetype)init;
- (NSString *)getUrl;
@end























