//
//  BaseDataDownloader.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "FileUploadService.h"

typedef NS_ENUM(NSInteger, BaseTaskType) {      //任务类型
    BASE_TASK_TYPE_UNKNOW,
    BASE_TASK_TYPE_DOWNLOAD_ALL,            //下载所有（包括部门，优先级，服务类型，位置，设备类型，设备，流程）
    BASE_TASK_TYPE_DOWNLOAD_ORG,            //部门
    BASE_TASK_TYPE_DOWNLOAD_PRIORITY,       //优先级
    BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE,   //服务类型
    BASE_TASK_TYPE_DOWNLOAD_LOCATION,       //位置
    BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE,    //设备类型
    BASE_TASK_TYPE_DOWNLOAD_DEVICE,         //设备
    BASE_TASK_TYPE_DOWNLOAD_FLOW,           //流程
    BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE,//需求类型
    BASE_TASK_TYPE_DOWNLOAD_SATISFACTION_TYPE,//满意度类型
    BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE,//故障原因
    BASE_TASK_TYPE_CLEAR_BASE_DATA,         //清除当前项目的基本数据
    BASE_TASK_TYPE_RESET_DB_DATA,           //清除所有数据库数据
    BASE_TASK_TYPE_INSERT_PATROL_TASK,      //往数据库中添加巡检任务数据
    BASE_TASK_TYPE_CLEAR_PATROL_TASK,      //从数据库中清除巡检任务
    
    
    BASE_TASK_TYPE_UPLOAD_ALL,              //上传
    BASE_TASK_TYPE_UPLOAD_REPORT,           //上传报障数据
};

typedef NS_ENUM(NSInteger, BaseTaskLevel) {     //任务级别
    BASE_TASK_LEVEL_UNKNOW,
    BASE_TASK_LEVEL_LOW,           //级别---低
    BASE_TASK_LEVEL_NORMAL,        //级别---正常
    BASE_TASK_LEVEL_HIGH,          //级别---高
};

typedef NS_ENUM(NSInteger, BaseTaskStatus) {     //任务状态
    BASE_TASK_STATUS_UNKNOW,
    BASE_TASK_STATUS_INIT,             //初始状态
    BASE_TASK_STATUS_HANDLING,         //处理中
    BASE_TASK_STATUS_FINISH_SUCCESS,   //完成---成功
    BASE_TASK_STATUS_FINISH_FAIL,      //完成---失败
    BASE_TASK_STATUS_TYPE_FINISH       //指定类型的任务结束
};

//任务的完成状态
@interface BaseTaskResult : NSObject
@property (readwrite, nonatomic, assign) BaseTaskStatus taskStatus;   //任务状态---任务的状态
@property (readwrite, nonatomic, assign) CGFloat taskProgress;      //任务完成进度---实际下载的数据量占总数据量的百分比
- (instancetype) init;

//获取任务完成时的进度比值
+ (CGFloat) getPercentOfSuccess;
@end

@interface BaseTask : NSObject
@property (readwrite, nonatomic, strong) NSNumber* taskKey;           //任务的ID---用来标识不同的任务
@property (readwrite, nonatomic, assign) BaseTaskType taskType;       //任务类型
@property (readwrite, nonatomic, assign) BaseTaskLevel taskLevel;     //任务级别---任务的优先级
@property (readwrite, nonatomic, assign) BaseTaskStatus taskStatus;   //任务状态---任务的状态
@property (readwrite, nonatomic, strong) NSNumber * taskProgress;      //任务完成进度---实际下载的数据量占总数据量的百分比
@property (readwrite, nonatomic, strong) NSNumber * projectId;

@property (readwrite, nonatomic, assign) NSInteger aliveTime;   //任务存活时间

- (instancetype) init;
- (instancetype) initWithType:(BaseTaskType) type andLevel:(BaseTaskLevel) level;
//任务的实体，子类需重写本方法以实现任务的处理
- (void) taskProcessMethod;

//提示任务开始---子类通过调用本接口来通知任务开始处理
- (void) notifyTaskStart;
//提示任务完成---子类通过调用本接口来通知任务完成
- (void) notifyTaskFinish:(BOOL) success;
//提示进度更新---子类通过调用本接口来通知任务进度的更新
- (void) notifyProgressUpdate:(NSNumber *) newProgress;

//设置任务的状态监听代理
- (void) setOnTaskStatusListener:(id<OnMessageHandleListener>) handler;

- (BaseTaskType) getTaskType;
- (BaseTaskLevel) getTaskLevel;
- (BaseTaskStatus) getTaskStatus;
@end

//部门信息下载任务
@interface OrgDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//优先级信息下载任务
@interface PriorityDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//服务类型信息下载任务
@interface ServiceTypeDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//位置信息下载任务
@interface LocationDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//设备类型信息下载任务
@interface DeviceTypeDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//设备信息下载任务
@interface DeviceDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//流程信息下载任务
@interface FlowDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//需求类型信息下载任务
@interface RequirementTypeDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//满意度类型信息下载任务
@interface SatisfactionTypeDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//故障原因下载任务
@interface FailureReasonDownloadTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//清除当前项目基本数据任务
@interface ClearBaseDataTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//清空所有数据库数据
@interface ResetDBTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//上传报障任务
@interface ReportUploadTask : BaseTask<FileUploadListener>
- (instancetype) initWithReportId:(NSNumber *) reportId;
- (instancetype) initWithReportId:(NSNumber *) reportId andLevel:(BaseTaskLevel) level;
- (void) taskProcessMethod;
@end

//巡检任务插入
@interface PatrolDBInsertTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) setPatrolArray:(NSMutableArray *)patrolArray;
- (void) taskProcessMethod;
@end

//巡检任务清理
@interface PatrolDBClearTask : BaseTask
- (instancetype) init;
- (instancetype) initWithLevel:(BaseTaskLevel) level;
- (void) setPatrolTaskIds:(NSMutableArray *) idArray;
- (void) taskProcessMethod;
@end


//任务---调度器
@interface BaseTaskManager : NSObject
@property (readwrite, atomic, strong) NSMutableArray * taskList;
@property (readwrite, nonatomic, assign) NSInteger curTaskIndex;
@property (readwrite, nonatomic, assign) NSInteger taskKey; //taskKey计数
@property (readwrite, nonatomic, assign) NSInteger maxAliveTime;    //任务的最大存活时间，大于0 时有效

//+ (instancetype) getInstance;

//计算当前任务总数
- (NSInteger) getTaskCount;

//添加下载任务
- (void) addTask:(BaseTask *) task;

//移除指定位置任务
- (void) removeTaskAt:(NSInteger) position;

//移除指定任务
- (void) removeTask:(BaseTask *) task;

//移除指定类型的所有任务
- (void) removeAllTaskOfType:(BaseTaskType) taskType;

//移除所有任务
- (void) removeAllTask;

//获取下一个待处理任务
- (BaseTask *) getNextTask;

//获取下载任务信息
- (BaseTask *) getTaskByKey:(NSNumber *) taskKey;

//更新任务数据
- (void) updateTask:(BaseTask *) task;

//检测是否含有指定类型的任务
- (BOOL) hasTaskOfTypeToHandle:(BaseTaskType) taskType;

@end


//基础数据的下载器
@interface BaseDataDownloader : NSObject<OnMessageHandleListener>

+ (instancetype) getInstance;

//判断是否正在下载基础数据
- (BOOL) isDownloading;

//获取部门下载信息信息
- (BaseTaskResult *) getOrgDownloadResult;

//获取位置下载信息信息
- (BaseTaskResult *) getLocationDownloadResult;

//获取服务类型下载信息信息
- (BaseTaskResult *) getServiceTypeDownloadResult;

//获取设备下载信息信息
- (BaseTaskResult *) getDeviceDownloadResult;

//获取设备类型下载信息
- (BaseTaskResult *) getDeviceTypeDownloadResult;

//获取流程下载信息
- (BaseTaskResult *) getFlowDownloadResult;

//获取优先级下载信息
- (BaseTaskResult *) getPriorityDownloadResult;

//获取需求类型下载信息
- (BaseTaskResult *) getRequirementTypeDownloadResult;

//获取优先级下载信息
- (BaseTaskResult *) getSatisfactionDownloadResult;

//设置基础数据目标记录
- (void) setTargetRecord:(NSNumber *) targetRequestDate;

//下载部门数据
- (void) downloadOrgInfo;

//下载优先级数据
- (void) downloadPriorityInfo;

//下载服务类型数据
- (void) downloadServiceTypeInfo;

//下载位置数据
- (void) downloadLocationInfo;

//下载设备类型数据
- (void) downloadDeviceTypeInfo;

//下载设备数据
- (void) downloadDeviceInfo;

//下载流程数据
- (void) downloadFlowInfo;

//下载需求类型数据
- (void) downloadRequirementTypeInfo;

//下载满意度数据
- (void) downloadSatisfactionInfo;

//下载故障原因数据
- (void) downloadFailureReasonInfo;

//清除当前项目基本数据
- (void) clearBaseData;


//清除数据库所有数据
- (void) resetDbData;

//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType;

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType;

//移除所有的任务监听器
- (void) removeAllTaskListener;

//复位下载服务(清除当前所有的正在执行或将要执行的下载任务)
- (void) reset;

//停止工作
- (void) exit;


@end

//数据上传
@interface BaseDataUploader : NSObject<OnMessageHandleListener>

+ (instancetype) getInstance;

//上传报障数据
- (void) uploadReportInfo:(NSNumber *) reportId;

//上传一组报障数据
- (void) uploadReportInfos:(NSMutableArray *) reportIdArray;

//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType;

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType;

//移除所有的任务监听器
- (void) removeAllTaskListener;

//停止工作
- (void) exit;


@end


//
@interface LocalTaskManager : NSObject<OnMessageHandleListener>

+ (instancetype) getInstance;

//添加巡检任务
- (void) addPatrolTask:(NSMutableArray *) taskArray;

//清除 ID 不在数组之内的巡检任务
- (void) clearPatrolTaskNotIn:(NSMutableArray *) idArray;

//清除当前用户所有巡检任务
- (void) clearPatrolTaskOfCurrentUser;

//设置指定类型任务的监听器
- (void) setTaskListener:(id<OnMessageHandleListener>) listener withType:(BaseTaskType) taskType;

//移除指定类型任务的监听器
- (void) removeTaskListenerOfType:(BaseTaskType) taskType;

//移除所有的任务监听器
- (void) removeAllTaskListener;

//停止工作
- (void) exit;

@end
