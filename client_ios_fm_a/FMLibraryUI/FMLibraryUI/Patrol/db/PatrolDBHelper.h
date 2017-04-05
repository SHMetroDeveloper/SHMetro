//
//  PatrolDBHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/19.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DBHelper.h"
#import "PatrolDBHelper.h"
#import "PatrolTaskEntity.h"
#import "DBPatrolTask+CoreDataClass.h"
#import "DBPatrolSpot+CoreDataClass.h"
#import "DBPatrolDevice+CoreDataClass.h"
#import "DBSpotCheckContent+CoreDataClass.h"
#import "DBSpotCheckContentPicture+CoreDataClass.h"
#import "AssetManagementConfig.h"

@interface PatrolDBHelper : DBHelper

+ (instancetype) getInstance;

//巡检任务
- (BOOL) isPatrolTaskExist:(NSNumber*) patrolTaskId withUser:(NSNumber *) userId;
- (BOOL) addPatrolTask:(PatrolTask*) patrolTask withUserId:(NSNumber *) userId;
- (BOOL) addPatrolTasks:(NSArray *) patrolTaskArray withUserId:(NSNumber *) userId;
- (BOOL) deletePatrolTaskById:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId;
//删除 id 值在 patrolTaskIdArray 中的巡检任务
- (BOOL) deletePatrolTaskIn:(NSArray*) patrolTaskIdArray userId:(NSNumber *) userId;
//删除 id 值不在 patrolTaskIdArray 中的巡检任务,如果数组为空则删除该用户所有任务
- (BOOL) deletePatrolTaskNotIn:(NSArray*) patrolTaskIdArray userId:(NSNumber *) userId;
//删除指定用户所有的巡检任务
- (BOOL) deleteAllPatrolTaskOfUser:(NSNumber *) userId;
//删除所有的巡检任务
- (BOOL) deleteAllPatrolTask;
//删除用户在 timeEnd 之前结束的任务
- (BOOL) deletePatrolTaskEndedByTime:(NSNumber *) timeEnd userId:(NSNumber *) userId;
//删除所有的巡检任务
- (BOOL) deleteAllPatrolTask;
- (BOOL) updatePatrolTaskById:(NSNumber*) patrolTaskId userId:(NSNumber*) userId patrolTask:(DBPatrolTask*) patrolTask;
//更新巡检任务状态
- (BOOL) updatePatrolTaskStatus:(PatrolStatusType) status byId:(NSNumber *) patrolTaskId userId:(NSNumber *) userId;
//查询巡检任务，默认以时间排序（开始时间递减，结束时间递增）
- (NSMutableArray*) queryAllDBPatrolTasksBy:(NSNumber *) userId ;
//查询用户当前所有有效的巡检任务，依据任务时间来判断是否有效
- (NSMutableArray*) queryAllValidDBPatrolTasksBy:(NSNumber *) userId;
//查询 id 值在 idArray 中的巡检任务，默认以时间排序（开始时间递减，结束时间递增）
- (NSMutableArray*) queryAllDBPatrolTasksByIds:(NSMutableArray *) idArray andUserId:(NSNumber *) userId;
- (DBPatrolTask*) queryDBPatrolTaskById:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId;

//巡检点位
- (BOOL) isPatrolSpotExist:(NSNumber*) spotId;
- (BOOL) addPatrolkSpot:(PatrolTaskSpot*) patrolSpot withPatrolTaskId:(NSNumber *) patrolTaskId taskName:(NSString *) taskName andUserId:(NSNumber *) userId task:(DBPatrolTask *) task;
- (BOOL) addPatrolSpots:(NSArray *) spotArray withPatrolTaskId:(NSNumber *) patrolTaskId taskName:(NSString *) taskName andUserId:(NSNumber *) userId task:(DBPatrolTask *) task;
//删除任务相关点位
- (BOOL) deletePatrolSpotOf:(NSNumber*) patrolTaskId;
//删除任务相关点位
- (BOOL) deleteAllPatrolSpot;
- (BOOL) updatePatrolSpotById:(NSNumber*) spotId patrolSpot:(DBPatrolSpot*) patrolTaskSpot;
//更新指定点位的同步状态
- (BOOL) updatePatrolSpotSynStateById:(NSNumber*) recordId;
//更新指定点位的同步状态---同时更新多个
- (BOOL) updatePatrolSpotSynStateByIds:(NSMutableArray*) idArray;
//更新属于指定任务的所有点位的同步状态
- (BOOL) updatePatrolSpotSynStateByTask:(NSNumber*) patrolTaskId;
//查询任务相关的所有点位
- (NSMutableArray*) queryAllDBPatrolSpotsOf:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;
//依据 记录ID 查询指定点位任务
- (DBPatrolSpot*) queryDBPatrolSpotById:(NSNumber*) spotId;
//查询用户相关指定点位下的所有点位任务
- (NSMutableArray *) queryAllDBPatrolSpotsByCode:(NSString *) code andUserId:(NSNumber *) userId;
//查询用户相关的点位下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *) queryAllValidDBPatrolSpotsByCode:(NSString *) code andUserId:(NSNumber *) userId;
//查询用户相关的点位下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *) queryAllValidDBPatrolSpotsById:(NSNumber *) spotId andUserId:(NSNumber *) userId;
//查询用户相关的车站下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *)queryAllValidDBPatrolSpotsByBuildingId:(NSNumber *)buildingId andUserId:(NSNumber *) userId;
//查询所有的点位任务
- (NSMutableArray *) queryAllDBPatrolSpots;

//巡检设备
- (BOOL) isPatrolDeviceExist:(NSNumber*) id;
- (BOOL) addPatrolDevice:(Equipment*) equip withSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId task:(DBPatrolTask *) dbtask;
- (BOOL) addPatrolDevices:(NSArray *) devArray withSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId task:(DBPatrolTask *) dbtask;
//删除任务相关设备
- (BOOL) deletePatrolDeviceOf:(NSNumber*) patrolTaskId;
//删除任务相关设备
- (BOOL) deleteAllPatrolDevice;
- (BOOL) updatePatrolDeviceById:(NSNumber*) eqId patrolDevice:(DBPatrolDevice*) equip;


- (DBPatrolDevice*) queryDBPatrolDeviceById:(NSNumber*) recordId;
//查询任务相关的所有设备
- (NSMutableArray*) queryAllDBPatrolDevicesOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;

//查询点位相关的所有设备（依据点位ID）
- (NSMutableArray*) queryAllDBPatrolDevicesOfSpot:(NSNumber *) spotId;
//查询点位相关的所有设备（依据点位编码）
- (NSMutableArray*) queryAllDBPatrolDevicesOfSpotByCode:(NSString *) spotCode andUserId:(NSNumber *) userId;
//查询用户相关的点位下的所有有效的设备任务，依据相关巡检任务时间判断是否有效
- (NSMutableArray *) queryAllValidDBPatrolDevicesById:(NSNumber *) deviceId andUserId:(NSNumber *) userId;

//巡检检查项
- (BOOL) isSpotCheckContentExist:(NSNumber*) recordId;
- (BOOL) addSpotCheckContent:(PatrolTaskItemDetail*) content withDeviceId:(NSNumber*) devId andSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId ;
- (BOOL) addSpotCheckContents:(NSArray *) contentArray withDeviceId:(NSNumber*) devId andSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId ;
//删除任务相关检查项
- (BOOL) deleteSpotCheckContentOf:(NSNumber*) patrolTaskId;
//删除任务相关检查项
- (BOOL) deleteAllSpotCheckContent;
- (BOOL) updateSpotCheckContentById:(NSNumber*) recordId checkContent:(DBSpotCheckContent*) checkContent;
//查询任务相关的所有检查项
- (NSMutableArray*) queryAllDBSpotCheckContentOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;
//查询设备相关的所有检查项
- (NSMutableArray*) queryAllDBSpotCheckContentOfDevice:(NSNumber *) devId andUserId:(NSNumber *) userId;
//查询设备相关的所有检查项---按状态查询
- (NSMutableArray*) queryAllDBSpotCheckContentOfDevice:(NSNumber *) devId byValidStatus:(PatrolItemContentValidStatus) validStatus andUserId:(NSNumber *) userId;
- (DBSpotCheckContent*) queryDBSpotCheckContentById:(NSNumber*) recordId;


//巡检检查项图片
- (BOOL) isSpotCheckContentPictureExist:(NSNumber*) recordId;
- (BOOL) addSpotCheckContentPicture:(NSString*) url withSpotContentId:(NSNumber *) spotContentId andContentId:(NSNumber *) contentId andUserId:(NSNumber *) userId ;
- (BOOL) addSpotCheckContentPictures:(NSArray *) urlArray withSpotContentId:(NSNumber *) spotContentId andContentId:(NSNumber *) contentId andUserId:(NSNumber *) userId;
//删除巡检任务相关图片，会将文件从缓存中删除
- (BOOL) deleteSpotCheckContentPictureById:(NSNumber*) picId;
- (BOOL) deleteSpotCheckContentPictureOf:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId;
//删除巡检任务相关图片，会将文件从缓存中删除
- (BOOL) deleteAllSpotCheckContentPicture;
//把巡检项的相关图片标记为上传状态
- (BOOL) updatePictureStateOfSpotCheckContent:(NSNumber*) contentId andTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;

//更新图片的 ID（从远程服务器上获取的ID）
- (BOOL) updateImageId:(NSNumber *) imgId ofPicture:(NSNumber *) picId;
//查询任务相关的所有图片
- (NSMutableArray*) queryAllPictureOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;
//查询任务相关的所有待上传的图片
- (NSMutableArray*) queryAllPictureUnUploadedOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId;
//查询巡检项相关的所有图片
- (NSMutableArray*) queryAllPictureOfSpotCheckContent:(NSNumber *) spotCheckContentId andUserId:(NSNumber *) userId;
//查询巡检项相关的所有待上传的图片
- (NSMutableArray*) queryAllPictureUnUploadOfSpotCheckContent:(NSNumber *) spotCheckContentId andUserId:(NSNumber *) userId;

//查询巡检项相关的所有图片的ID
- (NSMutableArray*) queryAllImageIdOfSpotCheckContent:(NSNumber *) contentId andUserId:(NSNumber *) userId;
- (DBSpotCheckContentPicture*) queryDBSpotCheckContentPictureById:(NSNumber*) recordId;

//删除所有巡检任务数据
- (void) deleteAllPatrolData;
@end
