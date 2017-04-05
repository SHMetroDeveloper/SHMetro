//
//  WorkOrderServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WorkOrderPriorityLevel) {        //工单优先级
    ORDER_PRIORITY_LEVEL_UNKNOW = 0,
    ORDER_PRIORITY_LEVEL_NORMAL = 1,    //一般
    ORDER_PRIORITY_LEVEL_EMERGENCY,     //紧急
    ORDER_PRIORITY_LEVEL_IMPORTANT,     //重要
    ORDER_PRIORITY_LEVEL_EMERGENCY_IMPORTANT,    //紧急重要
    ORDER_PRIORITY_LEVEL_SELF_CHECK    //自检
};

typedef NS_ENUM(NSInteger, WorkOrderStatus) {   //工单状态
    ORDER_STATUS_CREATE = 0,   //已创建
    ORDER_STATUS_DISPACHED = 1,//已发布
    ORDER_STATUS_PROCESS,       //处理中
    ORDER_STATUS_STOP,     //暂停---继续工作
    ORDER_STATUS_TERMINATE,      //已终止
    ORDER_STATUS_FINISH,   //已完成
    ORDER_STATUS_VALIDATATION,   //已验证
    ORDER_STATUS_CLOSE,      //已存档
    ORDER_STATUS_APPROVE,  //待审批
    ORDER_STATUS_STOP_N,     //暂停---不继续工作
    ORDER_STATUS_DELAYED_FINISH,     //延期完成
    ORDER_STATUS_DISCARD,   //已作废
};


typedef NS_ENUM(NSInteger, WorkOrderGrabType) {
    WORK_ORDER_GRAB_TYPE_COMMON,    //普通工单
    WORK_ORDER_GRAB_TYPE_GRAB       //可抢工单
};

//执行人的抢单状态
typedef NS_ENUM(NSInteger, WorkOrderGrabLaborerStatus) {
    WORK_ORDER_GRAB_LABORER_STATUS_UNKNOW,    //未知
    WORK_ORDER_GRAB_LABORER_STATUS_UNTOOK,     //未抢
    WORK_ORDER_GRAB_LABORER_STATUS_WAITING,    //审核中
    WORK_ORDER_GRAB_LABORER_STATUS_SUCCESS,    //抢单成功
    WORK_ORDER_GRAB_LABORER_STATUS_FAIL,       //抢单失败
};


typedef NS_ENUM(NSInteger, WorkOrderLaborerStatus)  {
    ORDER_STATUS_PERSONAL_UN_ACCEPT,  // 未接单
    ORDER_STATUS_PERSONAL_ACCEPT,     // 已接单
    ORDER_STATUS_PERSONAL_BACK,       // 已退单
    ORDER_STATUS_PERSONAL_SUBMIT      // 已提交
};       //执行人状态


typedef NS_ENUM(NSInteger, WorkOrderHitoryStep)  {
    ORDER_STEP_CREATE,     //创建
    ORDER_STEP_DISPACH,       //派工
    ORDER_STEP_RECEIVE,      //接单
    ORDER_STEP_UPDATE,      //更新
    ORDER_STEP_STOP,      //暂停
    ORDER_STEP_TERMINATE,      //终止
    ORDER_STEP_FINISH,      //完成
    ORDER_STEP_VALIDATE,      //验证
    ORDER_STEP_CLOSE,     //关闭
    ORDER_STEP_APPROVAL_REQUEST,      //申请审批
    ORDER_STEP_APPROVE,      //批准申请
    ORDER_STEP_ESCALATION,      //工单升级
    ORDER_STEP_CONTINUE,      //继续
    ORDER_STEP_REJECT_ORDER      //退单
};       //工单的历史记录步骤

typedef NS_ENUM(NSInteger, OrderApplyApprovalType) {
    ORDER_APPLY_APPROVAL_TYPE_SINGLE,       //独立审批
    ORDER_APPLY_APPROVAL_TYPE_MULTI         //联合审批
};

//工单相关人员的角色
typedef NS_ENUM(NSInteger, OrderUserRoleType) {
    ORDER_USER_ROLE_TYPE_UNKNOW,       //
    ORDER_USER_ROLE_TYPE_SUPERVISOR = 1,   //主管
    ORDER_USER_ROLE_TYPE_TRACKER,          //追踪人员---处理工单
    ORDER_USER_ROLE_TYPE_VALIDATOR,        //验证人员---验证工单
    ORDER_USER_ROLE_TYPE_DISPATCHER,       //派工人员---派单
    ORDER_USER_ROLE_TYPE_ARCHIVER,         //归档人员---归档
};

//设备维修类型
typedef NS_ENUM(NSInteger, OrderEquipmentRepairType) {
    ORDER_EQUIPMENT_REPAIR_TYPE_NONE,   //不需要维修
    ORDER_EQUIPMENT_REPAIR_TYPE_REPAIR, //维修
    ORDER_EQUIPMENT_REPAIR_TYPE_RECTIFY,   //整改，换品牌
    ORDER_EQUIPMENT_REPAIR_TYPE_REPLACE,   //更换，同品牌
};

@interface WorkOrderServerConfig : NSObject

+ (NSString*) getWorkOrderImageUploadUrl:(NSString*) token id:(NSInteger) id;

+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url;

+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId;

//音频
+ (NSString *) wrapAudioUrlById:(NSString *)token audioId:(NSNumber *)audioId;

//视频
+ (NSString *) wrapVideoUrlById:(NSString *)token videoId:(NSNumber *)videoId;

+ (NSString *) getOrderPriorityLevelDesc:(NSInteger) level;

//获取相应状态的描述
+ (NSString *) getOrderStatusDesc:(WorkOrderStatus) status;

//获取相应状态的颜色
+ (UIColor *) getOrderStatusColor:(WorkOrderStatus) status;

+ (NSString *) getOrderLaborerStatusDesc:(WorkOrderLaborerStatus) status;

//获取维修类型描述
+ (NSString *) getOrderEquipmentRepairTypeDesc:(OrderEquipmentRepairType) type;

+ (NSString *) getOrderStepDesc:(WorkOrderHitoryStep) step;

//获取客户签字图片上传 URL 地址
+ (NSString *) getCustomerSignImageUploadUrl:(NSString *) token orderId:(NSNumber *) orderId;

//获取主管签字图片上传 URL 地址
+ (NSString *) getSupervisorSignImageUploadUrl:(NSString *) token orderId:(NSNumber *) orderId;
@end


//工单操作接口（接单，暂停，退单，正常保存，处理完成，终止，验证，存档接口）
extern NSString * const OPERATE_WORK_ORDER_URL;
//签字处理请求
extern NSString * const WORK_ORDER_SIGN_URL;
//工单执行人时间设置保存
extern NSString * const WORK_ORDER_LABORER_TIME_SAVE_URL;
//工单工具保存
extern NSString * const WORK_ORDER_TOOL_SAVE_URL;
//保存收费明细
extern NSString * const WORK_ORDER_CHARGE_SAVE_URL;
//编辑故障设备
extern NSString * const WORK_ORDER_EQUIPMENT_EDIT_URL;
//工作内容保存
extern NSString * const WORK_ORDER_WORKCONTENT_SAVE_URL;
//计划性维护步骤编辑
extern NSString * const WORK_ORDER_PLAN_MAINTENANCE_STEP_URL;
//保存故障原因
extern NSString * const WORK_ORDER_FAILURE_REASON_SAVE_URL;
//获取执行人所属的工作组
extern NSString * const WORK_ORDER_LABORER_WORK_TEAM_URL;
//获取执行人所属的工作组的主管
extern NSString * const WORK_ORDER_LABORER_WORK_TEAM_SUPERVISOR_URL;
//今日工单概况
extern NSString * const WORK_ORDER_CHART_TODAY;
//近七日工单完成情况
extern NSString * const WORK_ORDER_CHART_CURRENT;
//工单总数
extern NSString * const WORK_ORDER_CHART_STATISTICS;
//每月工单数量
extern NSString * const WORK_ORDER_CHART_MONTHLY;
//消息已读确认
extern NSString * const MESSAGE_IS_READ_URL;
//获取消息列表
extern NSString * const MESSAGE_GET_URL;





// 获取未完成工单个数地址
extern NSString * const GET_UNDO_WORK_ORDER_NUMBER_URL;
// 工单列表地址
extern NSString * const GET_JOB_URL;
// 我的报障地址
extern NSString * const GET_MY_REPORT_URL;
// 可抢工单列表地址
extern NSString * const GET_JOB_GRAB_URL;
// 抢单请求地址
extern NSString * const GRAB_WORK_ORDER_URL;
// 工单查询地址
extern NSString * const GET_HISTORY_JOB_URL;
// 工单详情地址
extern NSString * const GET_JOB_DETAIL_URL;
// 接单地址
extern NSString * const ACCEPT_WORK_ORDER_URL;
// 工单保存接口（暂停，正常保存，处理完成，终止，验证，存档）
extern NSString * const WORK_ORDER_SAVE_URL;

// 待派工工单接口
extern NSString * const GET_WORK_ORDER_DISPACH_URL;
// 执行人列表接口
extern NSString * const GET_WORK_ORDER_DISPACH_LABORER_LIST_URL;
// 派工接口
extern NSString * const WORK_ORDER_DISPACH_URL;
// 获取待派工工单数量接口
extern NSString * const GET_WORK_ORDER_DISPACH_COUNT_URL;

// 请求待审批工单接口
extern NSString * const GET_WORK_ORDER_APPROVAL_URL;
// 审批工单接口
extern NSString * const WORK_ORDER_APPROVAL_URL;
// 获取待审批工单计数接口
extern NSString * const GET_WORK_ORDER_APPROVAL_COUNT_URL;
// 转发工单接口
extern NSString * const WORK_ORDER_TRANSMIT_URL;

//审批人列表接口
extern NSString * const GET_WORK_ORDER_APPROVER_URL;
//提交审批申请接口
extern NSString * const WORK_ORDER_APPLY_APPROVAL_URL;

// 请求待验证工单接口
extern NSString * const GET_WORK_ORDER_VALIDATE_URL;

// 请求待存档工单接口
extern NSString * const GET_WORK_ORDER_CLOSE_URL;


extern NSString * const WORK_ORDER_UPLOAD_IMAGE_URL;
extern NSString * const WORK_ORDER_UPLOAD_IMAGE_URL_END;
