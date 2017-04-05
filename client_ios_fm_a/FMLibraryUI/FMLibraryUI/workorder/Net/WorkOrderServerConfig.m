//
//  WorkOrderServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderServerConfig.h"
#import "SystemConfig.h"
#import "BaseDataDbHelper.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"

///工单操作接口（接单，暂停，退单，处理完成，终止，验证，存档接口）
NSString * const OPERATE_WORK_ORDER_URL = @"/m/v2/workorder/wos/operate";
//签字处理请求
NSString * const WORK_ORDER_SIGN_URL = @"/m/v1/workorder/save/sign";
//工单执行人时间设置
NSString * const WORK_ORDER_LABORER_TIME_SAVE_URL = @"/m/v1/workorder/save/laborer";
//工单工具保存
NSString * const WORK_ORDER_TOOL_SAVE_URL = @"/m/v1/workorder/save/tool";
//保存收费明细
NSString * const WORK_ORDER_CHARGE_SAVE_URL = @"/m/v1/workorder/save/charge";
//编辑故障设备
NSString * const WORK_ORDER_EQUIPMENT_EDIT_URL = @"/m/v2/workorder/save/equipment";
//工作内容保存
NSString * const WORK_ORDER_WORKCONTENT_SAVE_URL = @"/m/v1/workorder/save/workcontent";
//计划性维护步骤编辑
NSString * const WORK_ORDER_PLAN_MAINTENANCE_STEP_URL = @"/m/v1/workorder/save/step";
//保存故障原因
NSString * const WORK_ORDER_FAILURE_REASON_SAVE_URL = @"/m/v1/workorder/save/reason";
//获取执行人所属的工作组
NSString * const WORK_ORDER_LABORER_WORK_TEAM_URL = @"/m/v1/workteams/laborer";
//获取执行人所属的工作组的主管
NSString * const WORK_ORDER_LABORER_WORK_TEAM_SUPERVISOR_URL = @"/m/v1/workteams/supervisor";
//今日工单概况
NSString * const WORK_ORDER_CHART_TODAY = @"/m/v1/chart/order/today";
//近七日工单完成情况
NSString * const WORK_ORDER_CHART_CURRENT = @"/m/v1/chart/order/currently";
//工单总数
NSString * const WORK_ORDER_CHART_STATISTICS = @"/m/v1/chart/order/statistics";
//每月工单数量
NSString * const WORK_ORDER_CHART_MONTHLY = @"/m/v1/chart/order/statistics";
//消息已读确认
NSString * const MESSAGE_IS_READ_URL = @"/m/v1/message/read";
//获取消息列表
NSString * const MESSAGE_GET_URL = @"/m/v1/message/query";




// 获取未完成工单个数地址
NSString * const GET_UNDO_WORK_ORDER_NUMBER_URL = @"/v1/order/processed";
// 工单列表地址
NSString * const GET_JOB_URL = @"/m/v1/workorder/undo";
// 工单查询地址
NSString * const GET_HISTORY_JOB_URL = @"/m/v1/workorder/hquery";
// 工单查询地址
NSString * const GET_MY_REPORT_URL = @"/m/v2/workorder/hquery";
// 工单详情地址
//NSString * const GET_JOB_DETAIL_URL = @"/m/v1/workorder/wos/detail";
NSString * const GET_JOB_DETAIL_URL = @"/m/v3/workorder/wos/detail";
// 接单地址
NSString * const ACCEPT_WORK_ORDER_URL = @"/m/v1/workorder/wos/accept";
// 工单保存接口
NSString * const WORK_ORDER_SAVE_URL = @"/m/v1/workorder/wos/complete";

// 请求待派工工单接口
NSString * const GET_WORK_ORDER_DISPACH_URL = @"/m/v1/workorder/undispatch";
// 派工执行人列表接口
NSString * const GET_WORK_ORDER_DISPACH_LABORER_LIST_URL = @"/m/v2/workteams/query";
// 派工接口
NSString * const WORK_ORDER_DISPACH_URL = @"/m/v1/workorder/wos/dispatch";
// 获取待派工工单计数接口
NSString * const GET_WORK_ORDER_DISPACH_COUNT_URL = @"/v1/assignment/wolistcount";


// 请求待审批工单接口
NSString * const GET_WORK_ORDER_APPROVAL_URL = @"/m/v1/workorder/wos/unapproval";
// 审批工单接口
NSString * const WORK_ORDER_APPROVAL_URL = @"/m/v1/workorder/wos/approval";
// 获取待审批工单计数接口
NSString * const GET_WORK_ORDER_APPROVAL_COUNT_URL = @"/v1/assignment/wolistcount";
// 转发工单接口
NSString * const WORK_ORDER_TRANSMIT_URL = @"/v1/assignment/updatewo";

//请求审批人接口
NSString * const GET_WORK_ORDER_APPROVER_URL = @"/m/v1/workorder/approvers";
// 申请审批接口
NSString * const WORK_ORDER_APPLY_APPROVAL_URL = @"/m/v1/workorder/approvals/request";

// 获取可抢工单列表地址
NSString * const GET_JOB_GRAB_URL = @"/m/v1/workorder/undo";    //TODO：抢单测试，需要修正
//抢单地址
NSString * const GRAB_WORK_ORDER_URL = @"/m/v1/order/pick";

// 请求待验证工单接口
NSString * const GET_WORK_ORDER_VALIDATE_URL = @"/m/v1/workorder/unverified";
//NSString * const GET_WORK_ORDER_VALIDATE_URL = @"/m/v1/workorder/undo";


// 请求待存档工单接口
NSString * const GET_WORK_ORDER_CLOSE_URL = @"/m/v1/workorder/to-be-closed";
//NSString * const GET_WORK_ORDER_CLOSE_URL = @"/m/v1/workorder/undo";

//客户签字地址
NSString * const WORK_ORDER_UPLOAD_SIGN_IMAGE_CUSTOMER_URL = @"/m/v1/files/upload/WorkOrder/";
NSString * const WORK_ORDER_UPLOAD_SIGN_IMAGE_CUSTOMER_URL_END = @"/sign_customer";

//主管签字地址
NSString * const WORK_ORDER_UPLOAD_SIGN_IMAGE_SUPERVISOR_URL = @"/m/v1/files/upload/WorkOrder/";
NSString * const WORK_ORDER_UPLOAD_SIGN_IMAGE_SUPERVISOR_URL_END = @"/sign_manager";



NSString * const WORK_ORDER_UPLOAD_IMAGE_URL = @"/v1/files/upload/WorkOrder/";
NSString * const WORK_ORDER_UPLOAD_IMAGE_URL_END = @"/img/";




@implementation WorkOrderServerConfig

+ (NSString*) getWorkOrderImageUploadUrl:(NSString*) token id:(NSInteger) id {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@%ld%@?access_token=%@", [SystemConfig getServerAddress], WORK_ORDER_UPLOAD_IMAGE_URL, id, WORK_ORDER_UPLOAD_IMAGE_URL_END, token];
    return res;
}

+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/files/id/%lld/img", [photoId longLongValue]];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

//音频
+ (NSString *) wrapAudioUrlById:(NSString *)token audioId:(NSNumber *)audioId {
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSString * url = [[NSString alloc] initWithFormat:@"/common/media/%lld", [audioId longLongValue]];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], url, deviceId, token];
    //    res = @"http://www.w3school.com.cn/i/song.mp3";
    return res;
}

//视频
+ (NSString *) wrapVideoUrlById:(NSString *)token videoId:(NSNumber *)videoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/media/%lld", [videoId longLongValue]];
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], url, deviceId, token];
    //    res = @"http://www.w3school.com.cn/i/movie.mp4";
    return res;
}

+ (NSString *) getOrderPriorityLevelDesc:(NSInteger) level{
    NSString * res = @"";
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    Priority * priority = [dbHelper queryPriorityById:[NSNumber numberWithInteger:level]];
    if(priority) {
        res = priority.name;
    }
    return res;
}

+ (NSString *) getOrderStatusDesc:(WorkOrderStatus) status {
    NSString * res = nil;
    switch(status) {
        
        case ORDER_STATUS_CREATE:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_create" inTable:nil];
            break;
        case ORDER_STATUS_DISPACHED:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_dispached" inTable:nil];
            break;
        case ORDER_STATUS_PROCESS:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_process" inTable:nil];
            break;
        case ORDER_STATUS_STOP:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_stop" inTable:nil];
            break;
        case ORDER_STATUS_TERMINATE:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_teminate" inTable:nil];
            break;
        case ORDER_STATUS_FINISH:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_finish" inTable:nil];
            break;
        case ORDER_STATUS_VALIDATATION:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_validation" inTable:nil];
            break;
        case ORDER_STATUS_CLOSE:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_close" inTable:nil];
            break;
        case ORDER_STATUS_APPROVE:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_approve" inTable:nil];
            break;
        case ORDER_STATUS_STOP_N:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_stop" inTable:nil];
            break;
        case ORDER_STATUS_DELAYED_FINISH:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_delayed_finished" inTable:nil];
            break;
        case ORDER_STATUS_DISCARD:
            res = [[BaseBundle getInstance] getStringByKey:@"order_status_discard" inTable:nil];
            break;
            
        default:
            res = @"";
            break;
    }
    
    return res;
}

//获取相应状态的颜色
+ (UIColor *) getOrderStatusColor:(WorkOrderStatus) status {
    UIColor * res;
    switch(status) {
        case ORDER_STATUS_CREATE:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
        case ORDER_STATUS_DISPACHED:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case ORDER_STATUS_PROCESS:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case ORDER_STATUS_STOP:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case ORDER_STATUS_TERMINATE:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
        case ORDER_STATUS_FINISH:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case ORDER_STATUS_VALIDATATION:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case ORDER_STATUS_CLOSE:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            break;
        case ORDER_STATUS_APPROVE:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case ORDER_STATUS_STOP_N:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case ORDER_STATUS_DELAYED_FINISH:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case ORDER_STATUS_DISCARD:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
            
        default:
            res = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
    }
    return res;
}

+ (NSString *) getOrderLaborerStatusDesc:(WorkOrderLaborerStatus) status {
    NSString * res = nil;
    switch(status) {
        case ORDER_STATUS_PERSONAL_UN_ACCEPT:
            res = [[BaseBundle getInstance] getStringByKey:@"order_laborer_status_un_accept" inTable:nil];
            break;
        case ORDER_STATUS_PERSONAL_ACCEPT:
            res = [[BaseBundle getInstance] getStringByKey:@"order_laborer_status_accept" inTable:nil];
            break;
        case ORDER_STATUS_PERSONAL_BACK:
            res = [[BaseBundle getInstance] getStringByKey:@"order_laborer_status_back" inTable:nil];
            break;
        case ORDER_STATUS_PERSONAL_SUBMIT:
            res = [[BaseBundle getInstance] getStringByKey:@"order_laborer_status_submit" inTable:nil];
            break;
        default:
            res = @"";
            break;
    }
    return res;
}

//获取维修类型描述
+ (NSString *) getOrderEquipmentRepairTypeDesc:(OrderEquipmentRepairType) type {
    NSString * res = nil;
    switch(type) {
        case ORDER_EQUIPMENT_REPAIR_TYPE_NONE:
            res = @"";
            break;
        case ORDER_EQUIPMENT_REPAIR_TYPE_REPAIR:
            res = [[BaseBundle getInstance] getStringByKey:@"order_equipment_repqir_type_repair" inTable:nil];
            break;
        case ORDER_EQUIPMENT_REPAIR_TYPE_RECTIFY:
            res = [[BaseBundle getInstance] getStringByKey:@"order_equipment_repqir_type_rectify" inTable:nil];
            break;
        case ORDER_EQUIPMENT_REPAIR_TYPE_REPLACE:
            res = [[BaseBundle getInstance] getStringByKey:@"order_equipment_repqir_type_replace" inTable:nil];
            break;
        default:
            res = @"";
            break;
    }
    return res;
}

+ (NSString *) getOrderStepDesc:(WorkOrderHitoryStep) step {
    NSString * res = nil;
    switch(step) {
        case ORDER_STEP_CREATE:     //创建
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_create" inTable:nil];
            break;
        case ORDER_STEP_DISPACH:        //派工
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_dispach" inTable:nil];
            break;
        case ORDER_STEP_RECEIVE:       //接单
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_receive" inTable:nil];
            break;
        case ORDER_STEP_UPDATE:       //更新
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_update" inTable:nil];
            break;
        case ORDER_STEP_STOP:       //暂停
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_stop" inTable:nil];
            break;
        case ORDER_STEP_TERMINATE:       //终止
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_terminate" inTable:nil];
            break;
        case ORDER_STEP_FINISH:       //完成
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_finish" inTable:nil];
            break;
        case ORDER_STEP_VALIDATE:       //验证
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_validate" inTable:nil];
            break;
        case ORDER_STEP_CLOSE:      //关闭
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_close" inTable:nil];
            break;
        case ORDER_STEP_APPROVAL_REQUEST:       //申请审批
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_approval_request" inTable:nil];
            break;
        case ORDER_STEP_APPROVE:       //批准申请
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_approval" inTable:nil];
            break;
        case ORDER_STEP_ESCALATION:       //工单升级
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_escalation" inTable:nil];
            break;
        case ORDER_STEP_CONTINUE:       //继续
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_continue" inTable:nil];
            break;
        case ORDER_STEP_REJECT_ORDER:       //退单
            res = [[BaseBundle getInstance] getStringByKey:@"order_step_reject" inTable:nil];
            break;
        default:
            res = @"";
            break;
    }
    return res;
}

//获取客户签字图片上传 URL 地址
+ (NSString *) getCustomerSignImageUploadUrl:(NSString *) token orderId:(NSNumber *) orderId {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@%lld%@?access_token=%@", [SystemConfig getServerAddress], WORK_ORDER_UPLOAD_SIGN_IMAGE_CUSTOMER_URL, orderId.longLongValue, WORK_ORDER_UPLOAD_SIGN_IMAGE_CUSTOMER_URL_END, token];
    return res;
}

//获取主管签字图片上传 URL 地址
+ (NSString *) getSupervisorSignImageUploadUrl:(NSString *) token orderId:(NSNumber *) orderId {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@%lld%@?access_token=%@", [SystemConfig getServerAddress], WORK_ORDER_UPLOAD_SIGN_IMAGE_SUPERVISOR_URL, orderId.longLongValue, WORK_ORDER_UPLOAD_SIGN_IMAGE_SUPERVISOR_URL_END, token];
    return res;
}
@end
