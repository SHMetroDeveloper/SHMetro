//
//  WorkOrderDetailEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "WorkOrderApprovalEntity.h"
#import "BaseDataEntity.h"
#import "BaseResponse.h"
#import "AssetManagementConfig.h"
#import "WorkOrderServerConfig.h"

@interface WorkOrderDetailRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * woId;

- (instancetype) initWithOrderID:(NSNumber *) woId;
- (NSString*) getUrl;

@end

@interface WorkOrderImage : NSObject
@property (readwrite, nonatomic, strong) NSNumber * imageId;
@property (readwrite, nonatomic, strong) NSString * imageUrl;
@end

@interface WorkOrderDetailEquipmentComponent : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * eqId;
@end

@interface WorkOrderEquipment : NSObject
@property (readwrite, nonatomic, strong) NSNumber * equipmentId;            //设备ID
@property (readwrite, nonatomic, strong) NSString * equipmentCode;          //设备编码
@property (readwrite, nonatomic, strong) NSString * equipmentName;          //设备名称
@property (readwrite, nonatomic, strong) NSString * location;               //位置
@property (readwrite, nonatomic, strong) NSString * equipmentSystemName;    //类型
@property (readwrite, nonatomic, strong) NSString * failureDesc;            //故障描述
@property (readwrite, nonatomic, strong) NSString * repairDesc;             //维修说明
@property (readwrite, nonatomic, strong) NSNumber * woId;                   //工单ID
@property (readwrite, nonatomic, assign) BOOL finished;                     //是否已完成
@property (readwrite, nonatomic, assign) OrderEquipmentRepairType repairType;   //维修类型，供编辑设备时使用
@property (readwrite, nonatomic, assign) EquipmentStatus equipmentStatus;             //设备状态
@property (readwrite, nonatomic, assign) BOOL needScan;   //是否必须扫描完成

- (instancetype) copy;
@end

@interface WorkOrderLaborer : NSObject
@property (readwrite, nonatomic, strong) NSNumber * laborerId;      //执行人ID
@property (readwrite, nonatomic, strong) NSNumber * woLaborerId;      //
@property (readwrite, nonatomic, strong) NSString * laborer;           //名字
@property (readwrite, nonatomic, strong) NSString * positionName;   //职位
@property (readwrite, nonatomic, strong) NSString * phone;          //联系方式
@property (readwrite, nonatomic, strong) NSNumber * actualArrivalDateTime;    //实际到达时间
@property (readwrite, nonatomic, strong) NSNumber * actualCompletionDateTime;     //实际完成时间
@property (readwrite, nonatomic, strong) NSNumber * actualWorkingTime;     //实际完成时间
@property (readwrite, nonatomic, assign) NSInteger status;           //执行人状态
@property (readwrite, nonatomic, assign) BOOL responsible;          //是否为负责人

//获取到场时间
- (NSString *) getArriveDateStr;
//获取完成时间
- (NSString *) getFinishDateStr;
//获取执行人状态
- (NSString *) getStatusStr;
@end

@interface WorkOrderTool : NSObject
@property (readwrite, nonatomic, strong) NSNumber * toolId;     //工具或者物料的ID
@property (readwrite, nonatomic, strong) NSString * name;           //名字
//@property (readwrite, nonatomic, strong) NSString * brand;           //品牌
@property (readwrite, nonatomic, strong) NSString * model;           //型号
@property (readwrite, nonatomic, strong) NSString * amount;       //数量
@property (readwrite, nonatomic, strong) NSString * unit;           //单位
@property (readwrite, nonatomic, strong) NSNumber * cost;           //费用
@property (readwrite, nonatomic, strong) NSString * comment;        //说明
- (instancetype) copy;
@end



@interface WorkOrderHistoryItem : NSObject
@property (readwrite, nonatomic, strong) NSNumber * historyId;
@property (readwrite, nonatomic, assign) NSInteger step;
@property (readwrite, nonatomic, strong) NSNumber * operationDate;
@property (readwrite, nonatomic, strong) NSString * handler;
@property (readwrite, nonatomic, strong) NSNumber * handlerImgId;
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;
@property (readwrite, nonatomic, strong) NSMutableArray * attachment;
- (NSString *) getPortraitPhotoPathByportraitId:(NSNumber *) photo;
@end

@interface WorkOrderStep : NSObject
@property (readwrite, nonatomic, strong) NSNumber * stepId;
@property (readwrite, nonatomic, strong) NSString * step;
@property (readwrite, nonatomic, assign) NSInteger sort;
@property (readwrite, nonatomic, assign) BOOL finished;
@property (readwrite, nonatomic, strong) NSString* comment;
@property (readwrite, nonatomic, strong) NSNumber * workTeamId;  //组id
@property (readwrite, nonatomic, strong) NSString * workTeamName;  //组名
@property (readwrite, nonatomic, strong) NSMutableArray * photos;  //图片 ID 数组

//获取步骤的描述信息---形如“步骤一”
- (NSString *) getStepIndexDesc;

//获取图片 URL 数组
- (NSMutableArray *) getPhotoArray;
@end

@interface WorkOrderStepInfo : NSObject
@property (readwrite, nonatomic, strong) NSNumber* pmId;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * influence;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@end


@interface WorkOrderApprovalItem : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray * approvalResults;
@property (readwrite, nonatomic, strong) NSMutableArray * approvalContent;
@end

//工单收费项
@interface WorkOrderChargeItem : NSObject
@property (readwrite, nonatomic, strong) NSNumber * chargeId;
@property (readwrite, nonatomic, strong) NSString * name;   //收费项名称
@property (readwrite, nonatomic, strong) NSNumber * amount; //收费金额
@end

//附件
@interface WorkOrderAttachmentItem : NSObject
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, strong) NSString *fileName;
@end

//关联工单
@interface WorkOrderRelatedOrder : NSObject
@property (nonatomic, strong) NSNumber *woId;
@property (nonatomic, strong) NSString *code;
@end


@interface WorkOrderDetail : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;    //工单ID
@property (readwrite, nonatomic, strong) NSNumber * approvalId;    //工单审核ID --- 供待审核工单使用
@property (readwrite, nonatomic, strong) NSString * code;       //单号
@property (readwrite, nonatomic, strong) NSString * pfmCode;    //pfm 编码
@property (readwrite, nonatomic, strong) NSString * serviceTypeName;//服务类型
@property (readwrite, nonatomic, assign) NSInteger status;  //工单状态
@property (readwrite, nonatomic, strong) NSString * type;       //工单类型
@property (readwrite, nonatomic, strong) NSNumber * priorityId;    //优先级
@property (readwrite, nonatomic, strong) NSNumber * flowId;    //关联流程
@property (readwrite, nonatomic, strong) NSString * woDescription;       //描述
@property (readwrite, nonatomic, strong) NSNumber * createDateTime;  //创建日期
@property (readwrite, nonatomic, strong) NSNumber * actualArrivalDateTime;  //到达日期
@property (readwrite, nonatomic, strong) NSNumber * actualCompletionDateTime;    //结束日期
@property (readwrite, nonatomic, strong) NSString * actualWorkingTime;  //实际工作时长
@property (readwrite, nonatomic, strong) NSString * location;    //
@property (readwrite, nonatomic, strong) Position * locationId;    //
@property (readwrite, nonatomic, strong) NSString * organizationName;  //部门
@property (readwrite, nonatomic, strong) NSString * applicantName;  //工单申请人
@property (readwrite, nonatomic, strong) NSString * applicantPhone;       //联系方式
@property (readwrite, nonatomic, strong) NSNumber * workTeamId;
@property (readwrite, nonatomic, strong) NSNumber * estimateStartTime;  //预估开始时间
@property (readwrite, nonatomic, strong) NSNumber * estimateEndTime;  //预估完成时间
@property (readwrite, nonatomic, strong) NSNumber * reserveStartTime;  //预约开始时间
@property (readwrite, nonatomic, strong) NSNumber * reserveEndTime;  //预约完成时间
@property (readwrite, nonatomic, strong) NSNumber * customerSignImgId;  //客户签字ID
@property (readwrite, nonatomic, strong) NSNumber * supervisorSignImgId;  //主管签字ID
@property (readwrite, nonatomic, strong) NSString *failueDescription;  //故障描述
@property (readwrite, nonatomic, strong) NSMutableArray * pictures;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementPictures;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementAudios;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementVideos;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementShortVideos;
@property (readwrite, nonatomic, strong) NSMutableArray * histories;  //工作历史
@property (readwrite, nonatomic, strong) NSMutableArray * approvals;
@property (readwrite, nonatomic, strong) NSMutableArray * workOrderEquipments;
@property (readwrite, nonatomic, strong) NSMutableArray * workOrderLaborers;
@property (readwrite, nonatomic, strong) NSMutableArray * workOrderTools;
@property (readwrite, nonatomic, strong) WorkOrderStepInfo * pmInfo;
@property (readwrite, nonatomic, strong) NSMutableArray * steps;    //预防性维护工单的步骤
@property (readwrite, nonatomic, strong) NSMutableArray * currentRoles;
@property (readwrite, nonatomic, strong) NSMutableArray * charges;       //收费明细
@property (readwrite, nonatomic, strong) NSMutableArray * attachment;       //附件

@property (nonatomic, strong) NSMutableArray * relatedOrder;    //关联工单

//@property (readwrite, nonatomic, strong) NSNumber * laborerId;    //当前申请该详情的用户的执行人ID
//@property (readwrite, nonatomic, strong) NSString * workContent;  //工作内容
//@property (readwrite, nonatomic, strong) NSString * orgName;  //部门名字
//@property (readwrite, nonatomic, strong) NSMutableArray * pictures;   //图片地址
//@property (readwrite, nonatomic, strong) NSMutableArray * workOrderMaterials;  //物料
//@property (readwrite, nonatomic, assign) NSInteger grabType;

- (instancetype) init;

//获取创建时间
- (NSString *) getCreateTimeStr;

//获取优先级描述
- (NSString *) getPriorityStr;

//获取联系人
- (NSString *) getContact;

- (NSString *) getOrgStr;
//到场时间
- (NSString *) getArriveTimeStr;
//完成时间
- (NSString *) getFinishTimeStr;
//耗时
- (NSString *) getTimeUsedStr;
//获取预估时间
- (NSString *) getEstimateTimeStr;
//获取预约时间
- (NSString *) getReserveTimeStr;
//判断是否有内容
//- (BOOL) hasContent;
//判断是否有图片
//- (BOOL) hasPhoto;
//获取审批内容
- (NSString *) getApprovalContent;
- (NSMutableArray *) getApprovalContentsArray;
//判断是否还有执行人还未接单
- (BOOL) hasSomeoneUnAccept;
//获取未完成维保的设备的数量
- (NSInteger) getEquipmentUnCompletedCount;
//获取客户签字的图片URL
- (NSURL *) getCustomerSignImgUrl;
//获取主管签字的图片URL
- (NSURL *) getSupervisorSignImgUrl;
@end



@interface WorkOrderDetailResponse : BaseResponse
@property (readwrite, nonatomic, strong) WorkOrderDetail * data;
@end


