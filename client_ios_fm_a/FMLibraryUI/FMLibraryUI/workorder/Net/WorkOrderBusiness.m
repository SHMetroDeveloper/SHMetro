//
//  WorkOrderBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/1.
//  Copyright © 2016年 flynn. All rights reserved.
//


#import "WorkOrderBusiness.h"
#import "WorkOrderServerConfig.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderDetailEntity.h"
#import "WorkOrderUnClosedEntity.h"
#import "WorkOrderUnValidatedEntity.h"
#import "MyReportHistoryEntity.h"

#import "ApplyApprovalWorkOrderEntity.h"
#import "WorkOrderUndoEntity.h"
#import "WorkOrderDispachEntity.h"
#import "WorkOrderApprovalEntity.h"
#import "MJExtension.h"
#import "AcceptWorkOrderEntity.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "WorkOrderApproverEntity.h"
#import "WorkTeamSupervisorEntity.h"


WorkOrderBusiness * woBusinessInstance;

@interface WorkOrderBusiness ()

@property (readwrite, nonatomic, strong) WorkOrderNetRequest * netRequest;

@end

@implementation WorkOrderBusiness

+ (instancetype) getInstance {
    if(!woBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            woBusinessInstance = [[WorkOrderBusiness alloc] init];
        });
    }
    return woBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [WorkOrderNetRequest getInstance];
    }
    return self;
}

//获取待处理工单
- (void) getOrdersUndoPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        UndoWorkOrderRequestParam * param = [[UndoWorkOrderRequestParam alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            UndoWorkOrderResponse * response = [UndoWorkOrderResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_UNDO, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_UNDO, error);
            }
        }];
    }
}

//获取待派工工单
- (void) getOrdersDispachPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        WorkOrderDispachRequestParam * param = [[WorkOrderDispachRequestParam alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DispachWorkOrderResponse * response = [DispachWorkOrderResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_WO_GET_DISPACH, response.data);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_WO_GET_DISPACH, error);
            }
        }];
    }
}

//获取待审核工单
- (void) getOrdersApprovalPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderApprovalRequestParam * param = [[WorkOrderApprovalRequestParam alloc] initWithPage:page];    //初始化网络请求参数
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {  //AFNet 网络请求
            ApprovalWorkOrderResponse * response = [ApprovalWorkOrderResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_APPROVAL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_APPROVAL, error);
            }
        }];
    }
}

//获取我的报障工单列表
- (void) getOrdersMyReportPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        MyReportRequestParam * param = [[MyReportRequestParam alloc] initWithRequestPage:page];///初始化网络请求参数
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            MyreportHistoryResponse * response = [MyreportHistoryResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_WO_GET_MYREPORT,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_WO_GET_MYREPORT,error);
            }
        }];
    }
}







//获取待抢工单
- (void) getOrdersGrabSuccess:(business_success_block) success fail:(business_failure_block) fail {
    
}

//获取已抢工单
- (void) getOrdersGrabedSuccess:(business_success_block) success fail:(business_failure_block) fail {
    
}

//获取待验证工单
- (void) getOrdersUnValidatedPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail  {
    if(_netRequest) {
        WorkOrderUnValidatedRequestParam * param = [[WorkOrderUnValidatedRequestParam alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderUnValidatedResponse * response = [WorkOrderUnValidatedResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_VALIDATE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_VALIDATE, error);
            }
        }];
    }
    
}

//获取待存档工单
- (void) getOrdersUnClosedPage:(NetPageParam *) page Success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderUnClosedRequestParam * param = [[WorkOrderUnClosedRequestParam alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderUnClosedResponse * response = [WorkOrderUnClosedResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_CLOSE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_CLOSE, error);
            }
        }];
    }
}

//工单查询
- (void) getOrdersHistoryPage:(NetPageParam *) page
                    condition:(WorkOrderHistorySearchCondition *) condition
                      Success:(business_success_block) success
                         fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderHistoryRequestParam * param = [[WorkOrderHistoryRequestParam alloc] initWithSearchCondition:condition andPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderHistoryResponse * response = [WorkOrderHistoryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_CLOSE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_CLOSE, error);
            }
        }];
    }
}


//获取工单详情
- (void) getDetailInfoOfOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderDetailRequestParam * param = [[WorkOrderDetailRequestParam alloc] initWithOrderID:woId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderDetailResponse * response = [WorkOrderDetailResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_DETAIL, error);
            }
        }];
    }
}

//获取执行人所属的工作组信息
- (void) getWorkGroups:(NSNumber *) emId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderLaborerWorkTeamRequestParam * param = [[WorkOrderLaborerWorkTeamRequestParam alloc] init];
        param.laborerId = emId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderLaborerWorkTeamResponse * response = [WorkOrderLaborerWorkTeamResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_WORK_GROUPS, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_WORK_GROUPS, error);
            }
        }];
    }
}

//查询所有的工作组以及组内的执行人
- (void) getWorkgroupsAndEmployeeByUserId:(NSNumber *) userId andOrderId:(NSNumber *) orderId success:(business_success_block) success fail:(business_failure_block) fail {
    WorkOrderLaborerDispachRequestParam * param = [[WorkOrderLaborerDispachRequestParam alloc] initWithUserId:userId andOrderId:orderId];
    [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success) {
            WorkOrderLaborerResponse * response = [WorkOrderLaborerResponse mj_objectWithKeyValues:responseObject];
            success(BUSINESS_WO_GET_WORK_GROUPS_EMPLOYEE, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail) {
            fail(BUSINESS_WO_GET_WORK_GROUPS_EMPLOYEE, error);
        }
    }];
}

//获取执行人所属的工作组的所有主管
- (void) getWorkGroupSupervisors:(NSNumber *) emId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkTeamSupervisorRequestParam * param = [[WorkTeamSupervisorRequestParam alloc] init];
        param.laborerId = emId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkTeamSupervisorRequestResponse * response = [WorkTeamSupervisorRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_WORK_GROUPS_SUPERVISOR, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_WORK_GROUPS_SUPERVISOR, error);
            }
        }];
    }
}

//获取审批人列表
- (void) getApproversByUserId:(NSNumber *) userId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        WorkOrderApproverRequestParam * param = [[WorkOrderApproverRequestParam alloc] initWithPostId:userId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                WorkOrderApproverResponse * response = [WorkOrderApproverResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_WO_GET_APPROVER, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_APPROVER, error);
            }
        }];
    }
    
    
}

//接单
- (void) receiveOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        AcceptWorkOrderRequestParam * param = [[AcceptWorkOrderRequestParam alloc] initWithOrderID:woId andOperateType:ORDER_OPERATE_ACCEPT_TYPE_ACCEPT andOperateDescription:@""];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_RECEIVE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_RECEIVE, error);
            }
        }];
    }
}

//退单
- (void) chargeBackOrder:(NSNumber *) woId desc:(NSString *) desc success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        AcceptWorkOrderRequestParam * param = [[AcceptWorkOrderRequestParam alloc] initWithOrderID:woId andOperateType:ORDER_OPERATE_ACCEPT_TYPE_REJECT andOperateDescription:desc];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_BACK, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_BACK, error);
            }
        }];
    }
}

//暂停
- (void) pauseOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail{
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_PAUSE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_PAUSE, error);
            }
        }];
    }
}

//继续工作
- (void) continueOrder:(NSNumber *) woId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        AcceptWorkOrderRequestParam * param = [[AcceptWorkOrderRequestParam alloc] initWithOrderID:woId andOperateType:ORDER_OPERATE_ACCEPT_TYPE_CONTINUE andOperateDescription:@""];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_CONTINUE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_CONTINUE, error);
            }
        }];
    }
}


//终止
- (void) terminateOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail{
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_TERMINATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_TERMINATE, error);
            }
        }];
    }
}

//完成
- (void) finishOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_TERMINATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_TERMINATE, error);
            }
        }];
    }
}

//验证
- (void) validateOrder:(NSNumber *) orderId
                  desc:(NSString *) desc
                  pass:(BOOL) validatePass
               success:(business_success_block) success
                  fail:(business_failure_block) fail {
    if(_netRequest) {
        SaveWorkOrderRequestParam * param = [[SaveWorkOrderRequestParam alloc] init];
        param.woId = [orderId copy];
        param.operateType = ORDER_OPERATE_SAVE_TYPE_VALIDATE;
        param.operateDescription = desc;
        param.validatePass = validatePass;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_VALIDATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_VALIDATE, error);
            }
        }];
    }
}

//存档
- (void) closeOrder:(NSNumber *) orderId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        SaveWorkOrderRequestParam * param = [[SaveWorkOrderRequestParam alloc] init];
        param.woId = [orderId copy];
        param.operateType = ORDER_OPERATE_SAVE_TYPE_CLOSE;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_VALIDATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_VALIDATE, error);
            }
        }];
    }
}




//老的内容保存
//- (void) saveOrder:(SaveWorkOrderRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail {
//    if(_netRequest) {
//        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if(success) {
//                success(BUSINESS_WO_OPERATE_SAVE, nil);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if(fail) {
//                fail(BUSINESS_WO_OPERATE_SAVE, error);
//            }
//        }];
//    }
//}

- (void) operateOrder:(WorkOrderOperateRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(param.operateType, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(param.operateType, error);
            }
        }];
    }
}


//派工
- (void) dispachOrder:(DispachWorkOrderRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_DISPACH, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_DISPACH, error);
            }
        }];
    }
}

//审核
- (void) approvalOrder:(ApprovalWorkOrderRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_TERMINATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_TERMINATE, error);
            }
        }];
    }
}

//申请审批
- (void) requestApprovalWithApprovers:(NSMutableArray *) approvers
                      approvalContent:(ApplyApprovalContent *) content
                              orderId:(NSNumber *) woId
                              success:(business_success_block) success
                                 fail:(business_failure_block) fail {
    if(_netRequest) {
        
        ApplyApprovalWorkOrderParam * param = [[ApplyApprovalWorkOrderParam alloc] init];
        param.approverIds = approvers;
        param.approval = content;
        param.woId = woId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_OPERATE_REQUEST_APPROVAL, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_OPERATE_REQUEST_APPROVAL, error);
            }
        }];
    }
}

//签字
- (void) signOrder:(WorkOrderSignRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SIGN, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SIGN, error);
            }
        }];
    }
}

//是否允许操作工单
- (BOOL) canOperateOrder:(WorkOrderDetail *) orderDetail laborer:(NSNumber *) laborerId{
    BOOL res = NO;
    if(orderDetail.status != ORDER_STATUS_CLOSE) {  //已存档的不允许操作
        if(orderDetail && [orderDetail.currentRoles count] > 0) {
            res = YES;
        }
        if(!res) {
            //如果能看见待审批的功能，表示能审批该工单
            if(orderDetail.status == ORDER_STATUS_APPROVE) {
                res = YES;
            }
            if(!res && laborerId && orderDetail.workOrderLaborers) {    //执行人员有接单,处理权限
                for(WorkOrderLaborer * laborer in orderDetail.workOrderLaborers) {
                    if(laborer.laborerId && [laborer.laborerId isEqualToNumber:laborerId]) {
                        res = YES;
                        break;
                    }
                }
            }
        }
    }
    return res;
}

//是否允许接单
- (BOOL) canReceiveOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber*) laborerId  {
    BOOL res = NO;
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或追踪人员有所有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_TRACKER)) {
            res = YES;
            break;
        }
    }
    if(!res) {
        if(laborerId && orderDetail.workOrderLaborers) {    //执行人员有接单权限
            for(WorkOrderLaborer * laborer in orderDetail.workOrderLaborers) {
                if(laborer.laborerId && [laborer.laborerId isEqualToNumber:laborerId]) {
                    res = YES;
                    break;
                }
            }
        }
    }
    return res;
}

//是否允许处理工单
- (BOOL) canSaveOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber*) laborerId{
    BOOL res = NO;
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或追踪人员有所有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_TRACKER)) {
            res = YES;
            break;
        }
    }
    if(!res) {
        if(laborerId && orderDetail.workOrderLaborers) {    //执行人有操作权限
            for(WorkOrderLaborer * laborer in orderDetail.workOrderLaborers) {
                if(laborer.laborerId && [laborer.laborerId isEqualToNumber:laborerId]) {
                    res = YES;
                    break;
                }
            }
        }
    }
    return res;
}

//是否允许继续工作
- (BOOL) canContinueOrder:(WorkOrderDetail *) orderDetail laborerId:(NSNumber *) laborerId{
    BOOL res = NO;
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或追踪人员有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_TRACKER)) {
            res = YES;
            break;
        }
    }
    if(!res) {
        if(laborerId && orderDetail.workOrderLaborers) {    //执行人有操作权限
            for(WorkOrderLaborer * laborer in orderDetail.workOrderLaborers) {
                if(laborer.laborerId && [laborer.laborerId isEqualToNumber:laborerId]) {
                    res = YES;
                    break;
                }
            }
        }
    }
    return res;
}

//是否允许派工
- (BOOL) canDispachOrder:(WorkOrderDetail *) orderDetail {
    BOOL res = NO;
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或派工人员有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_DISPATCHER)) {
            res = YES;
            break;
        }
    }
    return res;
}

//TODO: 此处需要调整
//是否允许审核
- (BOOL) canApprovalOrder:(WorkOrderDetail *) orderDetail {
    BOOL res = YES;//目前只要能看见待审批的单就有审核权限，实际应该是包含在审批人员列表的人才有权限
    
    return res;
}

//是否允许验证
- (BOOL) canValidateOrder:(WorkOrderDetail *) orderDetail {
    BOOL res = NO;
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或验证人员有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_VALIDATOR || role.integerValue == ORDER_USER_ROLE_TYPE_ARCHIVER)) {
            res = YES;
            break;
        }
    }
    return res;
}

//是否允许存档
- (BOOL) canCloseOrder:(WorkOrderDetail *) orderDetail {
    BOOL res = NO;//
    for(NSNumber * role in orderDetail.currentRoles) {  //主管或归档人员有权限
        if(role && (role.integerValue == ORDER_USER_ROLE_TYPE_SUPERVISOR || role.integerValue == ORDER_USER_ROLE_TYPE_VALIDATOR || role.integerValue == ORDER_USER_ROLE_TYPE_ARCHIVER)) {
            res = YES;
            break;
        }
    }
    return res;
}


- (BOOL) hasLaborerReceived:(WorkOrderDetail *) orderDetail laborerId:(NSNumber *) laborerId{
    BOOL res = NO;
    if(laborerId && orderDetail.workOrderLaborers) {    //执行人有操作权限
        for(WorkOrderLaborer * laborer in orderDetail.workOrderLaborers) {
            if(laborer.laborerId && [laborer.laborerId isEqualToNumber:laborerId]) {
                if(laborer.status == ORDER_STATUS_PERSONAL_ACCEPT) {
                    res = YES;
                }
                break;
            }
        }
    }
    return res;
}


#pragma mark - 报表数据获取
//获取今日工单概况
- (void) getTodayChartData:(WorkOrderChartTodayParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderChartTodayResponse * response = [WorkOrderChartTodayResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_CHART_TODAY, response);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_CHART_TODAY, error);
            }
        }];
    }
}


//获取近七日工单完成情况
- (void) getCurrentChartData:(WorkOrderChartCurrentDaysParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderChartCurrentDaysResponse * response = [WorkOrderChartCurrentDaysResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_CHART_CURRENT, response);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_CHART_CURRENT, error);
            }
        }];
    }
}


//获取工单总数
- (void) getStatisticsChartData:(WorkOrderChartStatisticsParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderChartStatisticsResponse * response = [WorkOrderChartStatisticsResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_CHART_STATISTICS, response);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_CHART_STATISTICS, error);
            }
        }];
    }
}


//获取每月工单数
- (void) getMonthlyChartData:(WorkOrderChartMonthlyParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderChartMonthlyResponse * response = [WorkOrderChartMonthlyResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_CHART_MONTH, response);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_CHART_MONTH, error);
            }
        }];
    }
}

#pragma mark - 工单保存操作
//工单执行人时间设置保存
- (void) saveLaborerTimeInfo:(WorkOrderLaborerTimeSaveRequestParam *) param success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SAVE_LABORER, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_LABORER, error);
            }
        }];
    }
}

//工具保存
- (void) saveWorkOrderTools:(WorkOrderToolSaveRequestParam *) param success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WorkOrderToolIDResponse * response = [WorkOrderToolIDResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_SAVE_TOOL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_TOOL, error);
            }
        }];
    }
}

//收费项明细保存
- (void) saveWorkOrderCharge:(WorkOrderChargeSaveRequestParam *) param success:(business_success_block)success fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WokrOrderChargeResponse * response = [WokrOrderChargeResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_SAVE_CHARGE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_CHARGE, error);
            }
        }];
    }
}

//编辑故障设备
- (void) saveOrderEquipment:(WorkOrderEquipmentEditRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SAVE_EQUIPMENT, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_EQUIPMENT, error);
            }
        }];
    }
}


//工作内容保存
- (void) saveOrderContent:(WorkOrderWorkContentSaveRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SAVE_CONTENT, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_CONTENT, error);
            }
        }];
    }
}

//计划性维护步骤
- (void) saveOrderPlanSteps:(WorkOrderPlanMaintanceStepRequestParam *) param success:(business_success_block)    success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SAVE_STEPS, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_STEPS, error);
            }
        }];
    }
    
}

//保存故障原因
- (void) saveFailureReason:(WorkOrderSaveFailureReasonParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_SAVE_FAILURE_REASON, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_SAVE_FAILURE_REASON, error);
            }
        }];
    }
}

//获取工单相关物料列表
- (void) getMaterialList:(BaseDataGetWorkOrderMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BaseDataGetWorkOrderMaterialResponse * response = [BaseDataGetWorkOrderMaterialResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_MATERIAL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_MATERIAL, error);
            }
        }];
    }
}

//获取物料库存数量
- (void) getMaterialAmount:(BaseDataGetMaterialAmountParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BaseDataGetMaterialAmountResponse * response = [BaseDataGetMaterialAmountResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_WO_GET_MATERIAL_AMOUNT, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_GET_MATERIAL_AMOUNT, error);
            }
        }];
    }
}

//为工单预定物料
- (void) reserveMaterial:(BaseDataReserveMaterialParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_WO_RESERVE_MATERIAL, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_WO_RESERVE_MATERIAL, error);
            }
        }];
    }
}

@end






