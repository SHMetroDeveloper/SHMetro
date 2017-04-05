//
//  BaseDataEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"


typedef NS_ENUM(NSInteger, PositionLevelType) {
    LEVEL_CITY,
    LEVEL_SITE,
    LEVEL_BUILDING,
    LEVEL_FLOOR,
    LEVEL_ROOM
};

typedef NS_ENUM(NSInteger, BaseDataType) {
    BASE_DATA_TYPE_UNKNOW,
    BASE_DATA_TYPE_ALL,         //所有基础数据
    BASE_DATA_TYPE_DEVICE,      //设备
    BASE_DATA_TYPE_DEVICE_TYPE, //设备类型
    BASE_DATA_TYPE_LOCATION,    //位置
    BASE_DATA_TYPE_ORG,         //部门
    BASE_DATA_TYPE_PRIORITY,    //优先级
    BASE_DATA_TYPE_FLOW,        //流程
    BASE_DATA_TYPE_SERVICE_TYPE, //服务类型
    BASE_DATA_TYPE_REQUIREMENT_TYPE,//需求类型
    BASE_DATA_TYPE_SATISFACTION //满意度
};

typedef NS_ENUM(NSInteger, MetroBuildingType) {
    METRO_BUILDING_TYPE_STATION,    //站点
    METRO_BUILDING_TYPE_AREA,       //区间
};

//部门
@interface Org : NSObject
@property (readwrite, nonatomic, strong) NSNumber * orgId;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* fullName;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, assign) NSInteger level;
@property (readwrite, nonatomic, strong) NSNumber * parentOrgId;
@property (readwrite, nonatomic, assign) NSInteger sort;
@end

//服务类型
@interface ServiceType : NSObject
@property (readwrite, nonatomic, strong) NSNumber * serviceTypeId;
@property (readwrite, nonatomic, strong) NSString* stypeDesc;
@property (readwrite, nonatomic, strong) NSString* fullName;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSNumber * parentId;
@property (readwrite, nonatomic, assign) NSInteger sort;
@end


//城市
@interface City : NSObject
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSNumber* timezoneId;
@end

//区域
@interface Site : NSObject
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@end

//单元
@interface Building : NSObject
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, assign) BOOL deleted;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* fullName;
@property (readwrite, nonatomic, assign) MetroBuildingType type;    //0 --- 站点，1---区间
@property (readwrite, nonatomic, strong) NSNumber * relatedBuildingId;//如果是区间的话存关联站点的ID
@property (readwrite, nonatomic, assign) BOOL isThisStation;    //是否属于该线路管理
@property (readwrite, nonatomic, strong) NSNumber * projectId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@end

//楼层
@interface Floor : NSObject
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* fullName;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, assign) NSInteger sort;
@end

//房间
@interface Room : NSObject
@property (readwrite, nonatomic, strong) NSNumber* roomId;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* fullName;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, assign) NSInteger sort;
@end

//具体位置
@interface Position : NSObject
@property (readwrite, nonatomic, strong) NSNumber* cityId;
@property (readwrite, nonatomic, strong) NSNumber* siteId;
@property (readwrite, nonatomic, strong) NSNumber* buildingId;
@property (readwrite, nonatomic, strong) NSNumber* floorId;
@property (readwrite, nonatomic, strong) NSNumber* roomId;

- (BOOL) isNull;
- (BOOL) isCityNull;
- (BOOL) isSiteNull;
- (BOOL) isBuildingNull;
- (BOOL) isFloorNull;
- (BOOL) isRoomNull;

- (NSString *) getPositionStr;
- (instancetype) copy;
- (BOOL) isEqual:(id)pos;


/**
 判断位置是否属于指定站点
 @param pos --- 目标位置
 @return 判断结果
 */
- (BOOL) isBelongTo:(Position *) pos;
@end

//
@interface Positions : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray* citys;
@property (readwrite, nonatomic, strong) NSMutableArray* sites;
@property (readwrite, nonatomic, strong) NSMutableArray* buildings;
@property (readwrite, nonatomic, strong) NSMutableArray* floors;
@property (readwrite, nonatomic, strong) NSMutableArray* rooms;

- (instancetype) init;
- (void) clear;
- (City*) getCity:(NSNumber *) cityId;
- (Site*) getSite:(NSNumber *) siteId;
- (Building*) getBuilding:(NSNumber *) buildingId;
- (Floor*) getFloor:(NSNumber *) floorId;
- (Room*) getRoom:(NSNumber *) roomId;
- (NSString*) getPositionString:(Position*) pos;

+ (NSInteger) getPositionLevel:(Position*) pos;

@end

//设备类型
@interface DeviceType : NSObject
@property (readwrite, nonatomic, strong) NSNumber * equSysId;
@property (readwrite, nonatomic, strong) NSString* equSysCode;
@property (readwrite, nonatomic, strong) NSString* equSysDescription;
@property (readwrite, nonatomic, strong) NSString* equSysFullName;
@property (readwrite, nonatomic, strong) NSString* equSysName;
@property (readwrite, nonatomic, assign) NSInteger level;
@property (readwrite, nonatomic, strong) NSNumber * equSysParentSystemId;

@end

//设备
@interface Device : NSObject
@property (readwrite, nonatomic, strong) NSNumber * eqId;
@property (readwrite, nonatomic, assign) BOOL deleted;
@property (readwrite, nonatomic, strong) NSString* code;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* sysType;
@property (readwrite, nonatomic, strong) NSNumber* equSystem;
@property (readwrite, nonatomic, strong) NSString* qrcode;
@property (readwrite, nonatomic, strong) NSNumber* projectId;
@property (readwrite, nonatomic, strong) Position* position;
- (instancetype) init;
//获取设备分类
- (DeviceType*) getDeviceType;
- (BOOL) isEqual:(id)object;
@end



//优先级
@interface Priority : NSObject
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) NSString* desc;
@property (readwrite, nonatomic, strong) NSString* color;
@end

//流程
@interface Flow : NSObject
@property (readwrite, nonatomic, strong) NSNumber * wopId;
@property (readwrite, nonatomic, assign) BOOL deleted;
@property (readwrite, nonatomic, strong) NSNumber * organizationId;
@property (readwrite, nonatomic, strong) NSNumber * serviceTypeId;
@property (readwrite, nonatomic, strong) NSNumber * priorityId;
@property (readwrite, nonatomic, strong) Position* position;
@property (readwrite, nonatomic, strong) NSString* notice;
@property (readwrite, nonatomic, assign) NSInteger type;            //工单类型
@property (readwrite, nonatomic, strong) NSNumber *projectId;       //所属项目
- (instancetype) init;
@end

//需求类型
@interface RequirementType : NSObject
@property (readwrite, nonatomic, strong) NSNumber * typeId;
@property (readwrite, nonatomic, strong) NSNumber * parentTypeId;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * fullName;
@end

//需求满意度类型
@interface SatisfactionType : NSObject
@property (readwrite, nonatomic, strong) NSNumber * sdId;
@property (readwrite, nonatomic, strong) NSString * degree;
@property (readwrite, nonatomic, strong) NSNumber * sdValue;
@end

//故障原因
@interface FailureReason : NSObject
@property (nonatomic, strong) NSNumber *reasonId;
@property (nonatomic, strong) NSString *reasonCode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, assign) BOOL deleted;
@end

//流程
@interface DownloadRecord : NSObject
@property (readwrite, nonatomic, assign) NSInteger dataType;
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWithDataType:(NSInteger) dataType andPreRequestDate:(NSNumber *) preRequestDate;
@end

@interface UpdateRecord : NSObject
@property (readwrite, nonatomic, strong) NSNumber * newestDate;
@property (readwrite, nonatomic, assign) BOOL departmentNew;
@property (readwrite, nonatomic, assign) BOOL locationNew;
@property (readwrite, nonatomic, assign) BOOL deviceNew;
@property (readwrite, nonatomic, assign) BOOL deviceTypeNew;
@property (readwrite, nonatomic, assign) BOOL serviceTypeNew;
@property (readwrite, nonatomic, assign) BOOL priorityTypeNew;
@property (readwrite, nonatomic, assign) BOOL workFlowNew;
@property (readwrite, nonatomic, assign) BOOL requirementTypeNew;
@property (readwrite, nonatomic, assign) BOOL failureReasonNew;
@property (readwrite, nonatomic, assign) BOOL satisfactionDegreeNew;
//是否需要更新
- (BOOL) isNewData;
- (instancetype) copy;
@end

@interface UndoTaskEntity : NSObject
@property (readwrite, nonatomic, assign) NSInteger undoOrderNumber;     //待处理工单
@property (readwrite, nonatomic, assign) NSInteger unArrangeOrderNumber;//待派工工单
@property (readwrite, nonatomic, assign) NSInteger unApprovalOrderNumber;    //待审批工单
@property (readwrite, nonatomic, assign) NSInteger patrolTaskNumber;    //巡检任务
@property (readwrite, nonatomic, assign) NSInteger unArchivedOrderNumber;  //待验证工单数量
@property (readwrite, nonatomic, assign) NSInteger unApprovalRequirementNumber;  //待审核需求数量
@property (readwrite, nonatomic, assign) NSInteger undoRequirementNumber;  //待处理需求数量
@property (readwrite, nonatomic, assign) NSInteger unEvaluateRequirementNumber;//待评价需求数量
@property (readwrite, nonatomic, assign) NSInteger unReadBulletinNumber;    //公告

@end

@interface UndoTaskResponse : BaseResponse
@property (readwrite, nonatomic, strong) UndoTaskEntity * data;
@end


@interface MaterialBatchEntity : NSObject       //物料批次
@property (readwrite, nonatomic, strong) NSNumber* date;    //过期时间
@property (readwrite, nonatomic, assign) NSInteger amount;  //数量
- (NSString *) getDateStr;
@end


//工单物料
@interface WorkOrderMaterial : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woMaterialId;       //工单跟物料关联ID
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;        //仓库ID
@property (readwrite, nonatomic, strong) NSString * warehouseName;      //仓库名称
@property (readwrite, nonatomic, strong) NSNumber * inventoryId;        //物料id
@property (readwrite, nonatomic, strong) NSString * materialName;
@property (readwrite, nonatomic, strong) NSString * materialBrand;
@property (readwrite, nonatomic, strong) NSString * materialModel;
@property (readwrite, nonatomic, strong) NSString * materialUnit;
@property (readwrite, nonatomic, assign) NSInteger amount;
@property (readwrite, nonatomic, strong) NSNumber* dueDate;
- (instancetype) copy;
@end

@interface BaseDataGetWorkOrderMaterialResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface BaseDataGetWorkOrderMaterialResponse : BaseResponse
@property (readwrite, nonatomic, strong) BaseDataGetWorkOrderMaterialResponseData * data;
@end


@interface ReserveMaterialEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * inventoryId;    //物料ID
@property (readwrite, nonatomic, strong) NSNumber * dueDate;        //批次时间
@property (readwrite, nonatomic, strong) NSNumber * amount;         //预定数量
@end


@interface UpdateMaterialEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woMaterialId;    //物料跟工单关联的ID
@property (readwrite, nonatomic, assign) NSInteger amount;        //批次数量
@end

@interface MaterialAmountEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber* inventoryId;    //物料id
@property (readwrite, nonatomic, assign) NSInteger realAmount;    //库存量
@property (readwrite, nonatomic, strong) NSMutableArray* batchDatas;    //批次数量
- (instancetype) init;
@end


@interface BaseDataGetMaterialAmountResponse : BaseResponse
@property (readwrite, nonatomic, strong) MaterialAmountEntity * data;
@end


typedef NS_ENUM(NSInteger, TodayCountType) {
    TODAY_COUNT_TYPE_UNKNOW,
    TODAY_COUNT_TYPE_ORDER = 1,     //今日工单
    TODAY_COUNT_TYPE_COMPLAINT, //今日投诉
    TODAY_COUNT_TYPE_PATROL,    //今日巡检
};

//今日统计项
@interface TodayCountEntity : NSObject
@property (readwrite, nonatomic, assign) NSInteger type;    //统计类型，1--工单；2--投诉；3--巡检
@property (readwrite, nonatomic, assign) NSInteger count1;  //数量1，分别可能表示：未完成工单，未处理投诉或已报修数量
@property (readwrite, nonatomic, assign) NSInteger count2;  //数量2，分别可能表示：所有工单，所有投诉，异常巡检
@end



//近几日工单完成情况
@interface WorkOrderCurrentlyEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber* date;            //日期
@property (readwrite, nonatomic, assign) NSInteger newAmount;       //新生成的数量
@property (readwrite, nonatomic, assign) NSInteger finishedAmount;  //已处理的数量
@end

//今日工单项
@interface WorkOrderItemTodayEntity : NSObject
@property (readwrite, nonatomic, strong) NSString* orderType;       //工单类型
@property (readwrite, nonatomic, assign) NSInteger amount;          //该类型工单量
@end

//紧急工单
@interface EmergencyOrderEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber* woId;        //工单id
@property (readwrite, nonatomic, assign) NSInteger status;      //工单状态
@property (readwrite, nonatomic, strong) NSString* content;     //事件说明
@property (readwrite, nonatomic, strong) NSNumber* time;        //时间
@end

typedef NS_ENUM(NSInteger, NoticeType) {
    NOTICE_TYPE_UNKNOW,
    NOTICE_TYPE_CONTRACT,   //合同
    NOTICE_TYPE_MATERIAL,   //物料
};

//提醒
@interface NoticeEntity : NSObject
@property (readwrite, nonatomic, strong) NSNumber* noticeId;        //id
@property (readwrite, nonatomic, assign) NSInteger type;      //提醒类型，
@property (readwrite, nonatomic, strong) NSString* title;       //提醒标题
@property (readwrite, nonatomic, strong) NSString* content;     //提醒内容
@property (readwrite, nonatomic, strong) NSNumber* time;        //时间
@end

@interface HomeChartEntity : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray * countOfToday;//今日统计项
@property (readwrite, nonatomic, strong) NSMutableArray * workOrderCurrently;//近几日工单完成情况
@property (readwrite, nonatomic, strong) NSMutableArray * workOrderToday;//今日工单分析
@property (readwrite, nonatomic, strong) NSMutableArray * emergency;    //紧急事件
@property (readwrite, nonatomic, strong) NSMutableArray * notice;   //到期提醒
- (instancetype) init;
- (void) clear;
@end

//获取部门列表请求
@interface BaseDataGetOrgListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end


//获取服务类型列表请求
@interface BaseDataGetServiceTypeListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end


//获取位置列表请求  --- City, Site, Building
@interface BaseDataGetPositionListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end

//获取站点和区间请求
@interface BaseDataGetBuildingListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end

@interface BaseDataGetBuildingListRequestResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *data;
@end



//获取楼层列表请求
@interface BaseDataGetFloorListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam * page;
- (instancetype) initWith:(NSNumber *) preRequestDate andPage:(NetPageParam *) page;
- (NSString*) getUrl;
@end

//获取房间列表请求
@interface BaseDataGetRoomListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam * page;
- (instancetype) initWith:(NSNumber *) preRequestDate andPage:(NetPageParam *) page;
- (NSString*) getUrl;
@end



//获取设备信息请求
@interface BaseDataGetDeviceListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWith:(NSNumber *) preRequestDate
                     page:(NetPageParam*) page;
- (NSString*) getUrl;
@end

@interface BaseDataGetDeviceListRequestResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage *page;
@property (readwrite, nonatomic, strong) NSMutableArray *contents;
@end

@interface BaseDataGetDeviceListRequestResponse : BaseResponse
@property (nonatomic, strong) BaseDataGetDeviceListRequestResponseData *data;
@end


@interface BaseDataGetDeviceTypeRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWith:(NSNumber *) preRequestDate
                     page:(NetPageParam*) page;
- (NSString*) getUrl;
@end

//获取优先级信息列表请求
@interface BaseDataGetPriorityListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end


//获取优先级信息列表请求
@interface BaseDataGetFlowListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWith:(NSNumber *) preRequestDate
                     page:(NetPageParam*) page;
- (NSString*) getUrl;
@end

@interface BaseDataGetFlowListRequestResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage *page;
@property (readwrite, nonatomic, strong) NSMutableArray *contents;
@end

@interface BaseDataGetFlowListRequestResponse : BaseResponse
@property (nonatomic, strong) BaseDataGetFlowListRequestResponseData *data;
@end


//获取需求了类型信息列表请求
@interface BaseDataGetRequirementTypeListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end

//获取满意度信息列表请求
@interface BaseDataGetSatisfactionListRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end

#pragma mark - 故障原因
//获取故障原因
@interface BaseDataGetFailureReasonRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
@property (readwrite, nonatomic, strong) NetPageParam *page;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (void) setPage:(NetPageParam *) page;
- (NSString*) getUrl;
@end

@interface BaseDataGetFailureReasonResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray * contents;
@end

@interface BaseDataGetFailureReasonResponse : BaseResponse
@property (nonatomic, strong) BaseDataGetFailureReasonResponseData * data;
@end

#pragma mark - 数据更新记录
//获取数据更新信息
@interface BaseDataGetUpdateRecordRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * preRequestDate;
- (instancetype) initWith:(NSNumber *) preRequestDate;
- (NSString*) getUrl;
@end

//数据更新记录结果
@interface BaseDataGetUpdateRecordResponse : BaseResponse
@property (nonatomic, strong) UpdateRecord *data;
@end

//获取待处理任务的数量
@interface BaseDataGetUndoTaskCountParam : BaseRequest
- (NSString*) getUrl;
@end


//获取工单相关的物料列表
@interface BaseDataGetWorkOrderMaterialParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* woId; //工单ID
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWithOrderId:(NSNumber *) woId page:(NetPageParam *) page;
- (NSString*) getUrl;
@end

//预定物料请求
@interface BaseDataReserveMaterialParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* woId; //工单ID
@property (readwrite, nonatomic, strong) NSNumber* warehouseId; //仓库ID
@property (readwrite, nonatomic, strong) NSMutableArray * inventories;  //物料
- (instancetype) init;
- (NSString*) getUrl;
@end

////更新预定的物料数量
//@interface BaseDataUpdateMaterialParam : BaseRequest
//@property (readwrite, nonatomic, strong) NSNumber* woId; //工单ID
//@property (readwrite, nonatomic, strong) NSMutableArray * woMaterials;  //物料
//- (instancetype) init;
//- (NSString*) getUrl;
//@end

//获取物料的数量详情
@interface BaseDataGetMaterialAmountParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber* inventoryId; //物料ID
- (instancetype) initWithInventoryId:(NSNumber *) inventoryId;
- (NSString*) getUrl;
@end

//批量获取获取物料的数量详情
@interface BaseDataGetMaterialAmountListParam : BaseRequest
@property (readwrite, nonatomic, strong) NSMutableArray* inventoryIds; //物料ID数组
- (instancetype) initWithArray:(NSMutableArray *) inventoryIdArray;
- (NSString*) getUrl;
@end


//获取报表数据
@interface BaseDataGetChartDataParam : BaseRequest
- (NSString *) getUrl;
@end
