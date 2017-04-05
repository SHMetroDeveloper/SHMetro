//
//  WorkOrderBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseBusiness.h"
#import "WorkOrderDetailEntity.h"
#import "SaveWorkOrderEntity.h"
#import "DispachWorkOrderEntity.h"
#import "ApprovalWorkOrderEntity.h"
#import "ApplyApprovalWorkOrderEntity.h"
#import "WorkOrderHistoryEntity.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderOperateEntity.h"
#import "WorkOrderChartEntity.h"
#import "WorkOrderSignEntity.h"



typedef NS_ENUM(NSInteger, WorkOrderBusinessType) {
    BUSINESS_WO_UNKNOW,   //
    BUSINESS_WO_GET_UNDO,       //获取待处理工单
    BUSINESS_WO_GET_DISPACH,    //获取待派工工单
    BUSINESS_WO_GET_APPROVAL,   //获取待审核工单
    BUSINESS_WO_GET_VALIDATE,   //获取待验证工单
    BUSINESS_WO_GET_MYREPORT,  //获取我的保障列表
    BUSINESS_WO_GET_CLOSE,   //获取待存档工单
    BUSINESS_WO_GET_DETAIL,   //获取待工单详情
    BUSINESS_WO_GET_HISTORY,   //工单查询
    BUSINESS_WO_GET_WORK_GROUPS,   //工作组查询(查询执行人所属的工作组)
    BUSINESS_WO_GET_WORK_GROUPS_EMPLOYEE,   //查询所有的工作组以及相应的执行人列表
    BUSINESS_WO_GET_WORK_GROUPS_SUPERVISOR,   //工作组主管查询(查询执行人所属的工作组的所有主管)
    BUSINESS_WO_GET_APPROVER,   //获取审批执行人列表
    BUSINESS_WO_GET_MATERIAL,   //物料列表
    BUSINESS_WO_GET_MATERIAL_AMOUNT,   //物料库存数量
    BUSINESS_WO_RESERVE_MATERIAL,   //预定物料
    BUSINESS_WO_OPERATE_RECEIVE,   //接单
    BUSINESS_WO_OPERATE_BACK,   //退单
    BUSINESS_WO_OPERATE_DISPACH,   //派工
    BUSINESS_WO_OPERATE_APPROVAL,   //审核
    BUSINESS_WO_OPERATE_REQUEST_APPROVAL,   //审批申请
    BUSINESS_WO_OPERATE_PAUSE,   //暂停
    BUSINESS_WO_OPERATE_CONTINUE,   //继续工作
    BUSINESS_WO_OPERATE_TERMINATE,   //终止
    BUSINESS_WO_OPERATE_SAVE,   //保存
    BUSINESS_WO_OPERATE_FINISH,   //完成
    BUSINESS_WO_OPERATE_VALIDATE,   //验证
    BUSINESS_WO_OPERATE_CLOSE,   //存档
    
    BUSINESS_WO_CHART_TODAY,  //报表获取今日工单概况
    BUSINESS_WO_CHART_CURRENT,  //报表获取近七日工单完成情况
    BUSINESS_WO_CHART_STATISTICS,  //报表获取工单总数
    BUSINESS_WO_CHART_MONTH,  //报表获取每月工单数
    
    BUSINESS_WO_SAVE_LABORER,  //操作执行人时间
    BUSINESS_WO_SAVE_TOOL,     //工具操作
    BUSINESS_WO_SAVE_CHARGE,     //收费项操作
    BUSINESS_WO_SAVE_EQUIPMENT,  //故障设备
    BUSINESS_WO_SAVE_CONTENT,    //工作内容
    BUSINESS_WO_SAVE_STEPS,     //计划性维护步骤
    BUSINESS_WO_SAVE_FAILURE_REASON,     //保存故障原因
    
    BUSINESS_WO_SIGN    //签字
};

@interface WorkOrderBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;


#pragma mark - 权限查询
//是否有可能操作工单
- (BOOL) canOperateOrder:(WorkOrderDetail *) orderDetail laborer:(NSNumber *) laborerId;

//是否允许接单
- (BOOL) canReceiveOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber*) laborerId;

//是否允许处理工单
- (BOOL) canSaveOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber*) laborerId;

//是否允许继续工作
- (BOOL) canContinueOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber *) laborerId;

//是否允许派工
- (BOOL) canDispachOrder:(WorkOrderDetail *) orderDetail;

//是否允许审核
- (BOOL) canApprovalOrder:(WorkOrderDetail *) orderDetail;

//是否允许验证
- (BOOL) canValidateOrder:(WorkOrderDetail *) orderDetail;

//是否允许存档
- (BOOL) canCloseOrder:(WorkOrderDetail *) orderDetail;


#pragma mark - 状态判断
//判断指定执行人是否已经接单
- (BOOL) hasLaborerReceived:(WorkOrderDetail *) orderDetail laborerId:(NSNumber *) laborerId;

//获取待处理工单
- (void) getOrdersUndoPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待派工工单
- (void) getOrdersDispachPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待审核工单
- (void) getOrdersApprovalPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail;

//获取我的保障工单列表
- (void) getOrdersMyReportPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待抢工单
- (void) getOrdersGrabSuccess:(business_success_block) success fail:(business_failure_block) fail;

//获取已抢工单
- (void) getOrdersGrabedSuccess:(business_success_block) success fail:(business_failure_block) fail;

//获取待验证工单
- (void) getOrdersUnValidatedPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail ;

//获取待存档工单
- (void) getOrdersUnClosedPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail ;

//工单查询
- (void) getOrdersHistoryPage:(NetPageParam *) page
                    condition:(WorkOrderHistorySearchCondition *) condition
                      Success:(business_success_block) success
                         fail:(business_failure_block) fail;

//获取工单详情
- (void) getDetailInfoOfOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail;

//获取执行人所属的工作组信息
- (void) getWorkGroups:(NSNumber *) emId success:(business_success_block) success fail:(business_failure_block) fail;

//查询所有的工作组以及组内的执行人
- (void) getWorkgroupsAndEmployeeByUserId:(NSNumber *) userId andOrderId:(NSNumber *) orderId success:(business_success_block) success fail:(business_failure_block) fail;

//获取执行人所属的工作组的所有主管
- (void) getWorkGroupSupervisors:(NSNumber *) emId success:(business_success_block) success fail:(business_failure_block) fail;

//获取审批人列表
- (void) getApproversByUserId:(NSNumber *) userId success:(business_success_block) success fail:(business_failure_block) fail;

//接单
- (void) receiveOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail;

//退单
- (void) chargeBackOrder:(NSNumber *) woId desc:(NSString *) desc success:(business_success_block) success fail:(business_failure_block) fail;

//暂停
- (void) pauseOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail;

//继续工作
- (void) continueOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail;

//终止
- (void) terminateOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail;

//完成
- (void) finishOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail;

//保存
//- (void) saveOrder:(SaveWorkOrderRequestParam *) info success:(business_success_block) success fail:(business_failure_block) fail;

//工单操作
- (void) operateOrder:(WorkOrderOperateRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//验证
- (void) validateOrder:(NSNumber *) orderId
                  desc:(NSString *) desc
                  pass:(BOOL) validatePass
               success:(business_success_block) success
                  fail:(business_failure_block) fail;

//存档
- (void) closeOrder:(NSNumber *) orderId
            success:(business_success_block) success
               fail:(business_failure_block) fail;

//派工
- (void) dispachOrder:(DispachWorkOrderRequestParam *) info success:(business_success_block) success fail:(business_failure_block) fail;

//审核
- (void) approvalOrder:(ApprovalWorkOrderRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//申请审批
- (void) requestApprovalWithApprovers:(NSMutableArray *) approvers
                      approvalContent:(ApplyApprovalContent *) content
                              orderId:(NSNumber *) woId
                              success:(business_success_block) success
                                 fail:(business_failure_block) fail;

//签字
- (void) signOrder:(WorkOrderSignRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;




#pragma mark - 报表数据获取
//获取今日工单概况
- (void) getTodayChartData:(WorkOrderChartTodayParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//获取近七日工单完成情况
- (void) getCurrentChartData:(WorkOrderChartCurrentDaysParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//获取工单总数
- (void) getStatisticsChartData:(WorkOrderChartStatisticsParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//获取每月工单数
- (void) getMonthlyChartData:(WorkOrderChartMonthlyParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

#pragma mark - 工单保存操作
//工单执行人时间设置保存
- (void) saveLaborerTimeInfo:(WorkOrderLaborerTimeSaveRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//工具保存
- (void) saveWorkOrderTools:(WorkOrderToolSaveRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//收费项操作保存
- (void) saveWorkOrderCharge:(WorkOrderChargeSaveRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//编辑故障设备
- (void) saveOrderEquipment:(WorkOrderEquipmentEditRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//工作内容保存
- (void) saveOrderContent:(WorkOrderWorkContentSaveRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//计划性维护步骤编辑
- (void) saveOrderPlanSteps:(WorkOrderPlanMaintanceStepRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//保存故障原因
- (void) saveFailureReason:(WorkOrderSaveFailureReasonParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取工单相关物料列表
- (void) getMaterialList:(BaseDataGetWorkOrderMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取物料库存数量
- (void) getMaterialAmount:(BaseDataGetMaterialAmountParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//为工单预定物料
- (void) reserveMaterial:(BaseDataReserveMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

@end






