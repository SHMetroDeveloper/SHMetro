//
//  PatrolTaskHistoryEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/28.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetPage.h"
#import "BaseDataEntity.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "PatrolServerConfig.h"

typedef NS_ENUM(NSInteger, PatrolTaskHistoryStatus) {
    PATROL_HISTORY_STATUS_NORMAL = 0,   //正常
    PATROL_HISTORY_STATUS_EXCEPTION = 1,//异常
    PATROL_HISTORY_STATUS_MISS = 2,      //漏检
    PATROL_HISTORY_STATUS_REPAIR = 3,   //报修
    PATROL_HISTORY_STATUS_ADD = 4,      //补检
};

@interface PatrolTaskHistoryItem : NSObject         //巡检查询记录
@property (readwrite, nonatomic, strong) NSNumber * patrolTaskId;
@property (readwrite, nonatomic, strong) NSString * patrolName; //巡检任务名
@property (readwrite, nonatomic, strong) NSString * laborer;    //执行人

@property (readwrite, nonatomic, strong) NSNumber * dueStartDateTime; //实际开始时间
@property (readwrite, nonatomic, strong) NSNumber * dueEndDateTime; //实际结束时间

@property (readwrite, nonatomic, assign) NSInteger leakNumber; //漏检数
@property (readwrite, nonatomic, assign) NSInteger exceptionNumber; //异常数
@property (readwrite, nonatomic, assign) NSInteger repairNumber; //报修数
@property (readwrite, nonatomic, assign) NSInteger normalNumber; //正常数
@property (readwrite, nonatomic, assign) NSInteger spotNumber; //点位数
@property (readwrite, nonatomic, assign) PatrolTaskType taskType; //任务类型
//@property (readwrite, nonatomic, strong) NSString * location;   //位置
//@property (readwrite, nonatomic, assign) NSInteger spotStatus;      //状态

- (instancetype) init;
//获取巡检人员
- (NSString *) getContact;
//获取状态字符串
//- (NSString *) getStatusString;
+ (NSString *) getStatusStringByStatus:(PatrolTaskHistoryStatus) status;

//获取实际时间
- (NSString *) getRealityTimeDesc;
//获取预估时间
- (NSString *) getEstatedTimeDesc;
//获取预估开始时间
- (NSString *) getActualEndDate;
//获取实际开始时间
- (NSString *) getActualStartDate;
//获取漏检的数量
- (NSInteger) getIgnoreCount;
//获取异常的数量
- (NSInteger) getExceptionCount;
//获取正常的数量
- (NSInteger) getNormalCount;
//获取报修的数量
- (NSInteger) getRepairCount;
//是否含图片
- (BOOL) hasPhoto;
//是否已报修
- (BOOL) hasReport;
//是否有补检
- (BOOL) hasInspection;
//获取点位个数
- (NSInteger) getSpotCount;
//获取开始时间
- (NSString *) getStartTimeString;
//获取结束时间
- (NSString *) getEndTimeString;
@end

//巡检任务查询条件
@interface PatrolSearchCondition : NSObject
@property (readwrite, nonatomic, strong) NSNumber * normal;     //
@property (readwrite, nonatomic, strong) NSNumber * exception;  //
@property (readwrite, nonatomic, strong) NSNumber * leak;       //
@property (readwrite, nonatomic, strong) NSNumber * repair;     //
@property (readwrite, nonatomic, strong) NSNumber * startDateTime;
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;
@property (readwrite, nonatomic, strong) NSString * patrolName; //任务名称
- (instancetype) init;
@end


@interface PatrolTaskHistoryDetailItem : NSObject   //巡检任务详情
//基本信息
@property (readwrite, nonatomic, strong) NSNumber * patrolTaskId; //
@property (readwrite, nonatomic, strong) NSNumber * dueStartDateTime;  //预估开始时间
@property (readwrite, nonatomic, strong) NSNumber * dueEndDateTime; //预估结束时间
@property (readwrite, nonatomic, strong) NSNumber * actualStartDateTime;  //实际开始时间
@property (readwrite, nonatomic, strong) NSNumber * actualEndDateTime; //实际结束时间

@property (readwrite, nonatomic, assign) NSInteger leakNumber; //漏检个数
@property (readwrite, nonatomic, assign) NSInteger exceptionNumber; //异常个数
@property (readwrite, nonatomic, assign) NSInteger repairNumber; //维修个数
@property (readwrite, nonatomic, assign) NSInteger spotNumber; //点位个数
@property (readwrite, nonatomic, assign) NSInteger normalNumber; //正常个数
@property (readwrite, nonatomic, strong) NSString* period; //周期

//巡检人员
@property (readwrite, nonatomic, strong) NSString * laborer;
@property (nonatomic, assign) PatrolTaskType taskType;
//点位
@property (readwrite, nonatomic, strong) NSMutableArray * spots;

- (instancetype) init;

//获取预估开始时间的字符串
- (NSString *) getStartTimeString;
//获取预估结束时间的字符串
- (NSString *) getFinishTimeString;
//获取实际开始时间
- (NSString *) getActualStartTimeString;
//获取实际完成时间
- (NSString *) getActualEndTimeString;
// 获取预估时间
- (NSString *) getEstimateTimeString;
//获取实际时间
- (NSString *) getActualTimeString;
//获取正常的巡检项个数
- (NSInteger) getReportCount;
//获取漏检项个数
- (NSInteger) getLeakCount;
//获取异常巡检项个数
- (NSInteger) getExceptionCount;
//获取巡检周期
- (NSString *) getCycle;

@end

//综合巡检
@interface PatrolTaskHistorySynthesize : NSObject
@property (readwrite, nonatomic, strong) NSMutableArray * synthesizedOrders;
@property (readwrite, nonatomic, strong) NSMutableArray * synthesizedContents;
- (instancetype) init;
@end

//点位基本信息
@interface HistorySpot : NSObject
@property (readwrite, nonatomic, strong) NSNumber * spotId;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * spotLocation;
@property (readwrite, nonatomic, strong) NSString * nfcTag;
@property (readwrite, nonatomic, strong) NSString * qrCode;
@property (readwrite, nonatomic, strong) NSString * spotType;
@end

//点位
@interface PatrolTaskHistorySpot : NSObject
@property (readwrite, nonatomic, assign) NSInteger exceptionNumber;
@property (readwrite, nonatomic, assign) NSInteger repairNumber;
@property (readwrite, nonatomic, assign) NSInteger leakNumber;
@property (readwrite, nonatomic, strong) NSNumber * startDateTime;
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) Position* locationDetail;
@property (readwrite, nonatomic, strong) HistorySpot * spot;
@property (readwrite, nonatomic, strong) PatrolTaskHistorySynthesize * synthesized;
@property (readwrite, nonatomic, strong) NSMutableArray * equipments;
- (instancetype) init;
//是否异常
- (NSInteger) getExceptionCount;
//获取综合巡检部分异常数量
- (NSInteger) getSynthesizeExceptionCount;
//是否漏检
- (NSInteger) getLeakCount;
//获取综合巡检部分漏检数量
- (NSInteger) getSynthesizeLeakCount;
//是否正常
- (NSInteger) getNormalCount;
//获取综合巡检部分正常数量
- (NSInteger) getSynthesizeNormalCount;
//是否报修过
- (NSInteger) getReportCount;
//获取综合巡检部分正常数量
- (NSInteger) getSynthesizeReportCount;
@end


//设备
@interface PatrolTaskHistoryEquipment : NSObject
@property (readwrite, nonatomic, strong) NSNumber * eqId;
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * systemName; //设备类型
@property (readwrite, nonatomic, strong) NSString * sysType; //
@property (readwrite, nonatomic, strong) NSNumber * exceptionStatus; // 异常状态
@property (readwrite, nonatomic, strong) NSString * exceptionDesc; //异常描述
@property (readwrite, nonatomic, strong) NSMutableArray * orders;
@property (readwrite, nonatomic, strong) NSMutableArray * patrolTaskItemDetails;
- (instancetype) init;
- (NSString *) getSystemName;
//是否异常
- (NSInteger) getExceptionCount;
//是否漏检
- (NSInteger) getLeakCount;
//是否正常
- (NSInteger) getNormalCount;
//是否报修过
- (NSInteger) getReportCount;
@end

//巡检内容
@interface PatrolTaskHistoryContentItem : NSObject
@property (readwrite, nonatomic, strong) NSNumber * patrolTaskSpotResultId;  //
@property (readwrite, nonatomic, strong) NSNumber * id;  //
@property (readwrite, nonatomic, strong) NSString * content;  //检查目标
@property (readwrite, nonatomic, strong) NSString * result; //检查结果
@property (readwrite, nonatomic, assign) BOOL isException;  //是否异常
@property (readwrite, nonatomic, assign) BOOL processed;  //异常是否已处理
@property (readwrite, nonatomic, strong) NSString * comment;   //
@property (readwrite, nonatomic, assign) NSInteger status; //状态
@property (readwrite, nonatomic, strong) NSMutableArray * imageIds; //图片的id数组

- (instancetype) init;
//是否漏检
- (BOOL) isLeak;
//是否异常
- (BOOL) isException;
//是否正常
- (BOOL) isNormal;
//是否含有图片
- (BOOL) hasPhoto;
@end

//关联工单
@interface PatrolTaskHistoryOrderItem : NSObject
@property (readwrite, nonatomic, strong) NSNumber * woId;  //
@property (readwrite, nonatomic, strong) NSString * code;  //单号
@property (readwrite, nonatomic, strong) NSString * content;  //
@property (readwrite, nonatomic, strong) NSString * desc;  //
@property (readwrite, nonatomic, strong) NSString * requestor;  //
@property (readwrite, nonatomic, strong) NSNumber * createDateTime; //创建时间
@property (readwrite, nonatomic, assign) NSInteger status;  //状态：正常，异常，漏检
- (instancetype) init;
//- (NSString *) getStatusString;
//获取创建时间
- (NSString *) getCreateTimeString;
//获取维修人员
- (NSString *) getLaborerString;
@end


//获取巡检任务列表请求
@interface PatrolTaskQueryRequest : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam * page;
@property (readwrite, nonatomic, strong) PatrolSearchCondition * searchCondition;
- (instancetype) init;
- (instancetype) initWithPage:(NetPageParam *) page andCondition:(PatrolSearchCondition *) condition;
- (NSString*) getUrl;
@end

@interface PatrolTaskQueryResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface PatrolTaskQueryResponse : BaseResponse
@property (readwrite, nonatomic, strong) PatrolTaskQueryResponseData * data;
@end

//获取巡检任务详情请求
@interface PatrolTaskDetatilRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * postId;
- (instancetype) init;
- (instancetype) initWithTaskId:(NSNumber *) taskId;
- (NSString*) getUrl;
@end

@interface PatrolTaskDetatilResponse : BaseResponse
@property (readwrite, nonatomic, strong) PatrolTaskHistoryDetailItem * data;
@end
