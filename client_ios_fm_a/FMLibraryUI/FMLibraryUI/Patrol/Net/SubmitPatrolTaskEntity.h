//
//  SubmitPatrolTaskEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

typedef NS_ENUM(NSInteger, PatrolSubmitOperateType) {
    PATROL_SUBMIT_OPERATE_TYPE_SAVE = 1,    //保存
    PATROL_SUBMIT_OPERATE_TYPE_FINISH   //完成
};

@interface SubmitPatrolSpotResult : NSObject
@property (readwrite, nonatomic, strong) NSNumber * patrolTaskSpotResultId;
@property (readwrite, nonatomic, strong) NSString * resultSelect;   //巡检结果，选择项，string
@property (readwrite, nonatomic, strong) NSString * resultInput;    //巡检结果，选择项，double
@property (readwrite, nonatomic, strong) NSString * comment;        //故障描述
@property (readwrite, nonatomic, strong) NSArray * photoIds; //对应的图片 ID 数组
@end

//异常设备
@interface SubmitPatrolExceptionEquipment : NSObject
@property (readwrite, nonatomic, strong) NSNumber * eqId;   //设备ID
@property (readwrite, nonatomic, strong) NSNumber * status;    //异常状态
@property (readwrite, nonatomic, strong) NSString * desc;   //说明
@end

@interface SubmitPatrolSpot : NSObject
@property (readwrite, nonatomic, strong) NSNumber * patrolSpotId;   //点位Id
@property (readwrite, nonatomic, strong) NSNumber * startDateTime;  //开始检查时间
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;    //结束时间
@property (readwrite, nonatomic, strong) NSMutableArray * exceptionEquipment;   //异常设备列表
@property (readwrite, nonatomic, strong) NSMutableArray * contents; //检查结果列表
- (instancetype) init;
@end

@interface SubmitPatrolTask : NSObject

@property (readwrite, nonatomic, strong) NSNumber * patrolTaskId;   //巡检任务Id
@property (readwrite, nonatomic, strong) NSNumber * startDateTime;  //巡检任务开始时间
@property (readwrite, nonatomic, strong) NSNumber * endDateTime;    //巡检任务结束时间

@property (readwrite, nonatomic, strong) NSMutableArray * spots;    //点位信息

- (instancetype) init;

@end



@interface SubmitPatrolTaskRequest : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * userId;
@property (readwrite, nonatomic, assign) NSInteger operateType;
@property (readwrite, nonatomic, strong) NSMutableArray *patrolTask;//巡检任务数组
-(instancetype) initWithType:(PatrolSubmitOperateType) operateType patrolTasks:(NSMutableArray *) taskArray userId:(NSNumber*) userId;
-(NSString*) getUrl;
@end
