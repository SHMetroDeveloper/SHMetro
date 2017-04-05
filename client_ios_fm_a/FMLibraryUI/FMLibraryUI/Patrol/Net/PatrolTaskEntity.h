//
//  PatrolTaskEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetPage.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "PatrolServerConfig.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, PatrolStatusType) {
    PATROL_STATUS_BEGIN,         //未开始
    PATROL_STATUS_INPROGRESS,         //进行中
    PATROL_STATUS_COMPLETE,         //已完成
    PATROL_STATUS_DELAY,         //延期完成
    PATROL_STATUS_INCOMPLETE,         //未完成
    PATROL_STATUS_ADDITIONAL,         //补检
    PATROL_STATUS_CANCEL         //取消
};


typedef NS_ENUM(NSInteger, PatrolSpotStatusType) {
    PATROL_SPOT_STATUS_UNKNOW,         //
    PATROL_SPOT_STATUS_NOT_BEGIN,         //未开始
    PATROL_SPOT_STATUS_NOT_FINISH,         //未完成
    PATROL_SPOT_STATUS_NORMAL,         //已完成
    PATROL_SPOT_STATUS_EXCEPTION         //异常
};


typedef NS_ENUM(NSInteger, NetRequestTypePatrol) {
    PATROL_QUERY_TYPE_ALL = 0, // 所有巡检任务
    PATROL_QUERY_TYPE_UNFINISH = 1, // 未完成的巡检任务
    // （未完成巡检任务包括：未开始、进行中）
    PATROL_QUERY_TYPE_FINISH = 2 // 完成的巡检任务
};


//巡检
@interface Patrol : NSObject
@property (readwrite, nonatomic, strong) NSNumber * id;
@property (readwrite, nonatomic, strong) NSString * name;
- (instancetype) init;
@end



//巡检任务
@interface PatrolTask : NSObject

@property (readwrite, nonatomic, strong) NSNumber *patrolId;        //计划ID
@property (readwrite, nonatomic, strong) NSNumber *patrolTaskId;    //任务ID
@property (readwrite, nonatomic, assign) PatrolTaskType taskType;      //任务类型；0---巡检，1---巡视
@property (readwrite, nonatomic, strong) NSString *patrolTaskName;  //任务名称
@property (readwrite, nonatomic, strong) NSNumber *dueStartDateTime;//预定开始时间
@property (readwrite, nonatomic, strong) NSNumber *dueEndDateTime;  //预定结束时间
@property (readwrite, nonatomic, assign) PatrolStatusType status;          //任务状态
@property (readwrite, nonatomic, strong) NSNumber *activated;      //是否可以巡检
@property (readwrite, nonatomic, strong) NSMutableArray *spots;

- (instancetype) init;
//获取点位数量
- (NSInteger) getSpotCount;
//获取设备数量
- (NSInteger) getEquipmentCount;
//获取任务状态
- (NSString*) getStatus;
//任务是否需要被提交
- (BOOL) needToBeSubmited;
//获取巡检人员
- (NSString *) getContact;
//获取漏检数量
- (NSInteger) getIgnoreCount;
//获取异常数量
- (NSInteger) getExceptionCount;
//获取已完成的项数量
- (NSInteger) getFinishCount;
//获取未完成的项数量
- (NSInteger) getUnFinishCount;
//判断是否有图片
- (BOOL) hasPhoto;
//是否报修
- (BOOL) hasReport;
//获取开始时间
- (NSString *) getStartTimeString;
//获取开始时间
- (NSString *) getEndTimeString;

//获取状态所对应的描述
+ (NSString *) getStatusStringBy:(PatrolStatusType) patrolStatus;
@end

//点位
@interface Spot : NSObject
@property (readwrite, nonatomic, strong) NSNumber *spotId;     //点位ID
@property (readwrite, nonatomic, strong) NSString *name;        //点位名
@property (readwrite, nonatomic, strong) NSString *spotLocation;//位置
@property (readwrite, nonatomic, strong) NSString *qrCode;    //二维码
@property (readwrite, nonatomic, strong) NSString *nfcTag;      //NFC 编码
@property (readwrite, nonatomic, strong) NSString *spotType;    //
@property (readwrite, nonatomic, strong) Position *location;
- (instancetype) init;
@end

//巡检子任务，针对每个点位
@interface PatrolTaskSpot : NSObject
@property (readwrite, nonatomic, strong) Spot *spot;
@property (readwrite, nonatomic, strong) NSNumber *patrolSpotId;
@property (readwrite, nonatomic, strong) NSNumber *startDateTime;
@property (readwrite, nonatomic, strong) NSNumber *endDateTime;
@property (readwrite, nonatomic, assign) NSInteger status;

@property (readwrite, nonatomic, strong) NSMutableArray *contents;  //综合巡检
@property (readwrite, nonatomic, strong) NSMutableArray *equipments;//巡检设备
@property (readwrite, nonatomic, strong) NSNumber *finishStartTime;
@property (readwrite, nonatomic, strong) NSNumber *finishEndTime;
- (instancetype) init;

//获取点位名字
- (NSString*) getSpotName;
//获取点位位置
- (NSString*) getSpotPlace;
//获取综合检查项数量
- (NSInteger) getCompisiteCount;
//获取设备检查项数量
- (NSInteger) getDeviceCount;
//获取任务状态
- (NSString*) getTaskState;
//获取任务完成状态
- (NSString*) getTaskFinishState;

//是否含有图片
- (BOOL) hasPhoto;

//是否报修
- (BOOL) hasReport;

//判断是否已完成
- (BOOL) isFinished;

//判断是否存在异常
- (BOOL) isException;

//判断数据是否被同步
- (BOOL) isSyn;

- (instancetype) copy;

//获取点位状态
+ (NSString *) getStatusStringBy:(PatrolSpotStatusType) patrolStatus;
@end

@interface PatrolTaskItemDetail : NSObject

@property (readwrite, nonatomic, strong) NSNumber *spotContentId;
@property (readwrite, nonatomic, strong) NSString *content;             //
@property (readwrite, nonatomic, strong) NSString *selectEnums;          //选择---值，以逗号分割，如："清洁,不清洁"
@property (readwrite, nonatomic, strong) NSNumber *contentType;         //设备或点位 1-设备 2-点位
@property (readwrite, nonatomic, strong) NSNumber *resultType;          //单选或者输入 1-输入 2-单选
@property (readwrite, nonatomic, strong) NSString *selectRightValue;    //选择---默认正确的值, 可能有多个正确值
@property (readwrite, nonatomic, strong) NSNumber *inputUpper;          //输入的上限
@property (readwrite, nonatomic, strong) NSNumber *inputFloor;          //输入的下限
@property (readwrite, nonatomic, strong) NSNumber *defaultInputValue;          //默认的输入值
@property (readwrite, nonatomic, strong) NSString *defaultSelectValue;          //默认选择的值
@property (readwrite, nonatomic, strong) NSString *exceptions;          //常见的异常情况，使用 '||' 符号拼接
@property (readwrite, nonatomic, strong) NSString *unit;                //输入值的单位
@property (readwrite, nonatomic, assign) PatrolItemContentValidStatus validStatus;                //有效状态

@property (readwrite, nonatomic, strong) NSString *resultSelect;
@property (readwrite, nonatomic, strong) NSString *resultInput;

@property (readwrite, nonatomic, strong) NSString *comment;
@property (readwrite, nonatomic, strong) NSNumber *finish;     //BOOL
@property (readwrite, nonatomic, strong) NSMutableArray *pictures;

- (instancetype) init;

- (NSArray *) getSelectValues;
//数据是否异常
- (BOOL) isException;
//数据是否漏检
- (BOOL) isIgnore;
//是否报障
- (BOOL) isReport;
//获取检测结果
- (NSString *) getResultStr;

- (instancetype) copy;

@end

/** 检查设备-id为0或者空时表示检查内容是点位的 */
@interface Equipment : NSObject

@property (readwrite, nonatomic, strong) NSNumber *eqId;
@property (readwrite, nonatomic, strong) NSString *name;
@property (readwrite, nonatomic, strong) NSString *code;
@property (readwrite, nonatomic, strong) NSString *sysType;
@property (readwrite, nonatomic, strong) NSNumber *finish;     //BOOL
@property (readwrite, nonatomic, strong) NSMutableArray *contents;
- (instancetype) init;
- (NSInteger) getContentCount;
- (NSString*) getStateStr;
//设备是否被漏检
- (BOOL) isIgnored;
- (NSInteger) getExceptionCount;
//是否有图片
- (BOOL) hasPhoto;
//是否报修
- (BOOL) hasReport;

- (instancetype) copy;
@end

 /** 巡检任务请求 */
@interface PatrolTaskRequest : BaseRequest
@property (readwrite, nonatomic, strong) NetPageParam* page;
- (instancetype) initWithPage:(NetPageParam*) page;

- (NSString*) getUrl;
@end

@interface PatrolTaskResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * contents;
@end

@interface PatrolTaskResponse : BaseResponse
@property (readwrite, nonatomic, strong) PatrolTaskResponseData * data;
@end
