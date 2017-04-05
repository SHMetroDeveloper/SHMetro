//
//  PatrolDBHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/19.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolDBHelper.h"
#import "FMUtils.h"
#import "DBHelper.h"
#import "SystemConfig.h"

static NSString * DB_ENTITY_NAME_PATROL_TASK = @"DBPatrolTask";
static NSString * DB_ENTITY_NAME_PATROL_SOPT = @"DBPatrolSpot";
static NSString * DB_ENTITY_NAME_PATROL_DEVICE = @"DBPatrolDevice";
static NSString * DB_ENTITY_NAME_SPOT_CHECK_CONTENT = @"DBSpotCheckContent";
static NSString * DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE = @"DBSpotCheckContentPicture";

static PatrolDBHelper * instance = nil;

@interface PatrolDBHelper ()

@property (readwrite, nonatomic, strong) DBHelper * dbHelper;
@property (readwrite, nonatomic, strong) NSString * collectionName;

@property (readwrite, nonatomic, strong) NSCondition * locker;
@property (readwrite, atomic, assign) BOOL isWorking;

@end

@implementation PatrolDBHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        _locker = [[NSCondition alloc] init];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[PatrolDBHelper alloc] init];
    }
    return instance;
}

#pragma mark - 巡检任务
//PatrolTask
- (BOOL) isPatrolTaskExist:(NSNumber*) patrolTaskId withUser:(NSNumber *) userId {
    BOOL res = NO;
    if(patrolTaskId && userId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_PATROL_TASK condition:dict];
    }
    return res;
    
}


- (BOOL) addPatrolTask:(PatrolTask*) patrolTask withUserId:(NSNumber *) userId{
    BOOL res = NO;
    if(patrolTask) {
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        DBPatrolTask * objData = (DBPatrolTask*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        
        [objData setPatrolTaskId:patrolTask.patrolTaskId];
        [objData setTaskType:[NSNumber numberWithInteger:patrolTask.taskType]];
        [objData setPatrolTaskName:patrolTask.patrolTaskName];
        [objData setStartDate:patrolTask.dueStartDateTime];
        [objData setEndDate:patrolTask.dueEndDateTime];
        [objData setStatus:[NSNumber numberWithInteger:patrolTask.status]];
        [objData setSpotNumber:[NSNumber numberWithInteger:[patrolTask getSpotCount]]];
        [objData setDeviceNumber:[NSNumber numberWithInteger:[patrolTask getEquipmentCount]]];
        [objData setFinishStartDate:[NSNumber numberWithLongLong:0]];
        [objData setFinishEndDate:[NSNumber numberWithLongLong:0]];
        [objData setFinish:[NSNumber numberWithBool:NO]];   //未完成
        [objData setEdit:nil];                              //未同步
        [objData setException:[NSNumber numberWithBool:NO]];//无异常
        [objData setUserId:userId];//
        [objData setProjectId:projectId];//
        
        res = [self save];
        
        if(res) {//如果巡检任务添加成功的话就将相关的巡检点位添加进去
            [self addPatrolSpots:patrolTask.spots withPatrolTaskId:patrolTask.patrolTaskId taskName:patrolTask.patrolTaskName andUserId:userId task:objData];
        } else {
            NSLog(@"巡检任务添加失败。");
        }
    }
    return res;
}

- (BOOL) addPatrolTasks:(NSArray *) patrolTaskArray withUserId:(NSNumber *) userId{
    BOOL res = YES;
    for(PatrolTask * patrolTask in patrolTaskArray) {
        NSNumber * patrolTaskId = patrolTask.patrolTaskId;
        if(patrolTaskId) {
            if(![self isPatrolTaskExist:patrolTaskId withUser:userId]) {    //遇到新任务就加到数据库中
                res = res && [self addPatrolTask:patrolTask withUserId:userId];
            } else {
                res = res && [self updatePatrolTaskStatus:patrolTask.status byId:patrolTaskId userId:userId];
            }
        }
    }
    return res;
}

- (BOOL) deletePatrolTaskById:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId{
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", projectId, @"projectId", nil];
        NSString * strParam = [self getSqlStringBy:param];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            NSNumber * taskId = patrolTask.patrolTaskId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    }
    return res;
}

//删除 id 值在 patrolTaskIdArray 中的巡检任务
- (BOOL) deletePatrolTaskIn:(NSArray*) patrolTaskIdArray userId:(NSNumber *)userId{
    BOOL res = NO;
    if(patrolTaskIdArray && [patrolTaskIdArray count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskIdArray, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            NSNumber * taskId = patrolTask.patrolTaskId;
            NSNumber * userId = patrolTask.userId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    }
    return res;
}

//删除 id 值不在 patrolTaskIdArray 中的巡检任务,如果数组为空则删除该用户所有任务
- (BOOL) deletePatrolTaskNotIn:(NSArray*) patrolTaskIdArray userId:(NSNumber *)userId{
    BOOL res = NO;
    if(patrolTaskIdArray && [patrolTaskIdArray count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
        NSDictionary * idParam = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskIdArray, @"patrolTaskId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSString* strIdParam = [super getSqlStringByNot:idParam];
        strParam = [[NSString alloc] initWithFormat:@"%@ and %@", strParam, strIdParam];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            NSNumber * taskId = patrolTask.patrolTaskId;
            NSNumber * userId = patrolTask.userId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    } else {
        res = [self deleteAllPatrolTaskOfUser:userId];
    }
    return res;
}

- (BOOL) deleteAllPatrolTaskOfUser:(NSNumber *) userId {
    BOOL res = NO;
    {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            
            NSNumber * taskId = patrolTask.patrolTaskId;
            NSNumber * userId = patrolTask.userId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllPatrolTask {
    BOOL res = NO;
    {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            
            NSNumber * taskId = patrolTask.patrolTaskId;
            NSNumber * userId = patrolTask.userId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    }
    return res;
}


- (BOOL) deletePatrolTaskEndedByTime:(NSNumber *) timeEnd userId:(NSNumber *) userId {
    BOOL res = NO;
    if(userId && ![FMUtils isNumberNullOrZero:timeEnd])
    {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        strParam = [super getSqlStringByNot:param];
        NSString * timeParam  = [[NSString alloc] initWithFormat:@"endDate < %lld", timeEnd.longLongValue];
        
        strParam = [[NSString alloc] initWithFormat:@"%@ and %@", strParam, timeParam];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolTask* patrolTask in mutableFetchResult) {
            
            NSNumber * taskId = patrolTask.patrolTaskId;
            NSNumber * userId = patrolTask.userId;
            [self deleteSpotCheckContentPictureOf:taskId andUserId:userId];
            [self deleteSpotCheckContentOf:taskId];
            [self deletePatrolDeviceOf:taskId];
            [self deletePatrolSpotOf:taskId];
            
            [self.managedObjectContext deleteObject:patrolTask];
        }
        
        res = [self save];
    }
    return res;
}


- (BOOL) updatePatrolTask:(DBPatrolTask*) newPatrolTask condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newPatrolTask) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        //更新age后要进行保存，否则没更新
        for (DBPatrolTask* dbPatrolTask in mutableFetchResult) {
            
            [dbPatrolTask setFinishStartDate:newPatrolTask.finishStartDate];
            [dbPatrolTask setFinishEndDate:newPatrolTask.finishEndDate];
            
            [dbPatrolTask setFinish:newPatrolTask.finish];      //未完成
            [dbPatrolTask setEdit:newPatrolTask.edit];          //未同步
            [dbPatrolTask setException:newPatrolTask.exception];//无异常
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updatePatrolTaskById:(NSNumber*) patrolTaskId userId:(NSNumber*) userId patrolTask:(DBPatrolTask*) patrolTask{
    BOOL res = NO;
    if(patrolTaskId && patrolTask) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        res = [self updatePatrolTask:patrolTask condition:param];
    }
    return res;
}

//更新巡检任务状态
- (BOOL) updatePatrolTaskStatus:(PatrolStatusType) status byId:(NSNumber *) patrolTaskId userId:(NSNumber *) userId{
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        //更新后要进行保存，否则没更新
        for (DBPatrolTask* dbPatrolTask in mutableFetchResult) {
            [dbPatrolTask setStatus:[NSNumber numberWithInteger:status]];
        }
        res = [self save];
    }
    return res;
}

- (DBPatrolTask*) queryDBPatrolTaskById:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId{
    DBPatrolTask* res = nil;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId",userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult[0];
        }
    }
    return res;
}


- (NSMutableArray*) queryAllDBPatrolTasksBy:(NSNumber *) userId {
    
    NSMutableArray* objArray;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    
    NSSortDescriptor * sortStartTime = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSSortDescriptor * sortFinishTime = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortStartTime, sortFinishTime, nil]];
    
    NSError* error=nil;
    objArray=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    for(DBPatrolTask * task in objArray) {
        NSNumber * startTime = [task.finishStartDate copy];
        [tmpArray addObject:startTime];
    }
    return objArray;
}

//查询用户当前所有有效的巡检任务，依据任务时间来判断是否有效
- (NSMutableArray*) queryAllValidDBPatrolTasksBy:(NSNumber *) userId {
    
    NSMutableArray* objArray;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSNumber * timeNow = [FMUtils getTimeLongNow];
    
//    NSString * strFormat = [[NSString alloc] initWithFormat:@"userId==%lld and projectId==%lld and startDate<%lld and endDate>%lld", userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, timeNow.longLongValue];
    NSString * strFormat = [[NSString alloc] initWithFormat:@"userId==%lld and projectId==%lld and (endDate>%lld or status==%ld)", userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, PATROL_STATUS_INPROGRESS];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strFormat];
    
    NSSortDescriptor * sortStartTime = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSSortDescriptor * sortFinishTime = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    [request setPredicate:predicate];
    [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortStartTime, sortFinishTime, nil]];
    
    NSError* error=nil;
    objArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    for(DBPatrolTask * task in objArray) {
        NSNumber * startTime = [task.finishStartDate copy];
        [tmpArray addObject:startTime];
    }
    return objArray;
}

//查询 id 值在 idArray 中的巡检任务
- (NSMutableArray*) queryAllDBPatrolTasksByIds:(NSMutableArray *) idArray andUserId:(NSNumber *) userId {
    NSMutableArray* objArray;
    if(idArray && [idArray count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_TASK inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:idArray, @"patrolTaskId", userId, @"userId", projectId, @"projectId",  nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSSortDescriptor * sortStartTime = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
        NSSortDescriptor * sortFinishTime = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortStartTime, sortFinishTime, nil]];
        
        NSError* error=nil;
        objArray=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
        for(DBPatrolTask * task in objArray) {
            NSNumber * startTime = [task.startDate copy];
            [tmpArray addObject:startTime];
        }
    }
    return objArray;
}

#pragma mark - 巡检点位
//巡检点位
- (NSNumber *) getAnAvaliablePatrolSpotId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_PATROL_SOPT andKey:@"id"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}


- (BOOL) isPatrolSpotExist:(NSNumber*) spotId {
    BOOL res = NO;
    if(spotId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:spotId, @"id", nil];
        res = [super isDataExist:DB_ENTITY_NAME_PATROL_SOPT condition:dict];
    }
    return res;
}
- (BOOL) addPatrolkSpot:(PatrolTaskSpot*) patrolSpot withPatrolTaskId:(NSNumber *) patrolTaskId taskName:(NSString *) taskName andUserId:(NSNumber *) userId task:(DBPatrolTask *) task{
    BOOL res = NO;
    if(patrolSpot) {
        DBPatrolSpot * objData = (DBPatrolSpot*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSNumber * recordId = [self getAnAvaliablePatrolSpotId];
        [objData setId:recordId];
        [objData setSpotId:patrolSpot.spot.spotId];
        [objData setPatrolSpotId:patrolSpot.patrolSpotId];
        [objData setName:patrolSpot.spot.name];
        [objData setCode:patrolSpot.spot.qrCode];
        [objData setPlace:patrolSpot.spot.spotLocation];
        [objData setSpotCheckNumber:[NSNumber numberWithInteger:[patrolSpot getCompisiteCount]]];
        [objData setDeviceCheckNumber:[NSNumber numberWithInteger:[patrolSpot getDeviceCount]]];
        [objData setPatrolTaskName:taskName];
        
        [objData setCityId:patrolSpot.spot.location.cityId];    //点位所处的位置
        [objData setSiteId:patrolSpot.spot.location.siteId];
        [objData setBuildingId:patrolSpot.spot.location.buildingId];
        [objData setFloorId:patrolSpot.spot.location.floorId];
        [objData setRoomId:patrolSpot.spot.location.roomId];
        
        [objData setFinish:[NSNumber numberWithBool:NO]];   //未完成
        [objData setEdit:nil];     //未同步
        [objData setException:[NSNumber numberWithBool:NO]];//无异常
        [objData setMarkFinish:[NSNumber numberWithBool:NO]];   //未标记完成
        
        [objData setFinishStartDateTime:patrolSpot.finishStartTime];//
        [objData setFinishEndDateTime:patrolSpot.finishEndTime];//
        
        [objData setPatrolTaskId:patrolTaskId]; //
        [objData setUserId:userId];             //
        [objData setProjectId:projectId];
        
        objData.patrolTask = task;
        
        res =  [self save];;
        
        if(res) { //如果点位信息添加成功 把综合项和设备的数据添加到数据库
            //综合项
            if(patrolSpot.contents && [patrolSpot.contents count] > 0) {
                Equipment * equip = [[Equipment alloc] init];
                equip.eqId = [NSNumber numberWithLong:0];
                equip.contents = [patrolSpot.contents copy];
                [self addPatrolDevice:equip withSpotId:recordId andSpotCode:patrolSpot.spot.qrCode andPatrolTaskId:patrolTaskId andUserId:userId task:task];
            }
            
            //巡检设备
            [self addPatrolDevices:patrolSpot.equipments withSpotId:recordId andSpotCode:patrolSpot.spot.qrCode andPatrolTaskId:patrolTaskId andUserId:userId task:task];
        }
    }
    return res;
}

//添加点位到数据库
- (BOOL) addPatrolSpots:(NSArray *) spotArray withPatrolTaskId:(NSNumber *) patrolTaskId taskName:(NSString *) taskName andUserId:(NSNumber *) userId task:(DBPatrolTask *) task{
    BOOL res = YES;
    for(PatrolTaskSpot * spot in spotArray) {
        res = res && [self addPatrolkSpot:spot withPatrolTaskId:patrolTaskId taskName:taskName andUserId:userId task:task];
    }
    return res;
}
//删除任务相关点位
- (BOOL) deletePatrolSpotOf:(NSNumber*) patrolTaskId {
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolSpot=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolSpot];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", projectId, @"projectId", nil];
        NSString * strParam = [self getSqlStringBy:param];
        NSPredicate* predicate= [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolSpot* spot in mutableFetchResult) {
            [self.managedObjectContext deleteObject:spot];
        }
        
        res = [self save];
    }
    return res;
}

//删除任务相关点位
- (BOOL) deleteAllPatrolSpot {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* patrolSpot=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
    [request setEntity:patrolSpot];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBPatrolSpot* spot in mutableFetchResult) {
        [self.managedObjectContext deleteObject:spot];
    }
    
    res = [self save];
    
    return res;
}

- (BOOL) updatePatrolSpot:(DBPatrolSpot*) newSpot condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newSpot) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        //更新age后要进行保存，否则没更新
        for (DBPatrolSpot* objData in mutableFetchResult) {
            
           
            [objData setFinish:newSpot.finish];
            [objData setEdit:newSpot.edit];
            [objData setException:newSpot.exception];
            
            [objData setFinishStartDateTime:newSpot.finishStartDateTime];//
            [objData setFinishEndDateTime:newSpot.finishEndDateTime];//
            
        }
        res = [self save];;
    }
    return res;
}
- (BOOL) updatePatrolSpotById:(NSNumber*) spotId patrolSpot:(DBPatrolSpot*) patrolTaskSpot {
    BOOL res = NO;
    if(spotId && patrolTaskSpot) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:spotId, @"id", nil];
        res = [self updatePatrolSpot:patrolTaskSpot condition:param];
    }
    return res;
}
- (BOOL) updatePatrolSpotSynStateById:(NSNumber*) recordId {
    BOOL res = NO;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolSpot* objData in mutableFetchResult) {
            [objData setEdit:[NSNumber numberWithBool:YES]];
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updatePatrolSpotSynStateByIds:(NSMutableArray*) idArray {
    BOOL res = NO;
    if(idArray && [idArray count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:idArray, @"id", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolSpot* objData in mutableFetchResult) {
            [objData setEdit:[NSNumber numberWithBool:YES]];
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updatePatrolSpotSynStateByTask:(NSNumber*) patrolTaskId {
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolSpot* objData in mutableFetchResult) {
            [objData setEdit:[NSNumber numberWithBool:YES]];
        }
        res = [self save];
    }
    return res;
}
//查询任务相关的所有点位
- (NSMutableArray*) queryAllDBPatrolSpotsOf:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId{
    NSMutableArray * res = [NSMutableArray new];
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
//        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            
            res = mutableFetchResult;
        }
    }
    return res;
}
//依据点位记录的 ID 查询巡检点位
- (DBPatrolSpot*) queryDBPatrolSpotById:(NSNumber*) spotId {
    DBPatrolSpot * res;
    if(spotId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:spotId, @"id", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult[0];
        }
    }
    return res;
}
//依据点位的编码查询所有的点位
- (NSMutableArray *) queryAllDBPatrolSpotsByCode:(NSString *) code andUserId:(NSNumber *) userId {
    NSMutableArray * res;
    if(![FMUtils isStringEmpty:code]) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        
//        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:code, @"code", nil];
//        NSString* strSql = [self getSqlStringBy:dict];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSString* strSql = [[NSString alloc] initWithFormat:@"code LIKE[cd] '%@*' and userId==%lld and projectId==%lld", code, userId.longLongValue, projectId.longLongValue];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
        
    }
    return res;
}

//查询用户相关的点位下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *) queryAllValidDBPatrolSpotsByCode:(NSString *) code andUserId:(NSNumber *) userId {
    NSArray * res;
    if(![FMUtils isStringEmpty:code]) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * timeNow = [FMUtils getTimeLongNow];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSString* strSql = [[NSString alloc] initWithFormat:@"code LIKE[cd] '%@*' and userId==%lld and projectId==%lld and (patrolTask.endDate > %lld or patrolTask.status==%ld)", code, userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, PATROL_STATUS_INPROGRESS];   //未结束的或者时正在进行中的
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}
    
    //查询用户相关的点位下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *) queryAllValidDBPatrolSpotsById:(NSNumber *) spotId andUserId:(NSNumber *) userId {
    NSArray * res;
    if(![FMUtils isNumberNullOrZero:spotId]) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * timeNow = [FMUtils getTimeLongNow];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSString* strSql = [[NSString alloc] initWithFormat:@"spotId==%lld and userId==%lld and projectId==%lld and (patrolTask.endDate > %lld or patrolTask.status==%ld)", spotId.longLongValue, userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, PATROL_STATUS_INPROGRESS];   //未结束的或者时正在进行中的
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}

//查询用户相关的车站下的所有有效的点位任务，依据相关巡检任务时间判断是否有效
- (NSArray *)queryAllValidDBPatrolSpotsByBuildingId:(NSNumber *)buildingId andUserId:(NSNumber *) userId {
    NSArray * res;
    if(![FMUtils isNumberNullOrZero:buildingId]) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber * timeNow = [FMUtils getTimeLongNow];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSString* strSql = [[NSString alloc] initWithFormat:@"buildingId==%lld and userId==%lld and projectId==%lld and (patrolTask.endDate > %lld or patrolTask.status==%ld)", buildingId.longLongValue, userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, PATROL_STATUS_INPROGRESS];   //未结束的或者时正在进行中的
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}

//查询所有的巡检点位巡检点位
- (NSMutableArray*) queryAllDBPatrolSpots {
    NSMutableArray * res;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* patrolTask=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_SOPT inManagedObjectContext:self.managedObjectContext];
    [request setEntity:patrolTask];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = mutableFetchResult;
    }
    return res;
}

#pragma mark - 巡检设备
//获取一个可用的巡检设备记录 ID
- (NSNumber *) getAnAvaliablePatrolDeviceRecordId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_PATROL_DEVICE andKey:@"id"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isPatrolDeviceExist:(NSNumber*) recordId {
    BOOL res = NO;
    if(recordId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        res = [super isDataExist:DB_ENTITY_NAME_PATROL_DEVICE condition:dict];
    }
    return res;
}
- (BOOL) addPatrolDevice:(Equipment*) equip withSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId task:(DBPatrolTask *) dbtask {
    BOOL res = NO;
    if(equip) {
        DBPatrolDevice *objData = (DBPatrolDevice*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:super.managedObjectContext];
        NSNumber *projectId = [SystemConfig getCurrentProjectId];
        NSNumber *recordId = [self getAnAvaliablePatrolDeviceRecordId];
        [objData setId:recordId];
        [objData setDeviceId:[equip.eqId copy]];
        [objData setName:[equip.name copy]];
        [objData setCode:[equip.code copy]];
        [objData setSpotCode:spotCode];
        
        [objData setCheckNumber:[NSNumber numberWithInteger:[equip.contents count]]];
        [objData setFinish:[NSNumber numberWithBool:NO]];
        [objData setException:[NSNumber numberWithBool:NO]];
        
        [objData setSpotId:spotId]; //
        [objData setPatrolTaskId:patrolTaskId]; //
        [objData setUserId:userId];             //
        [objData setProjectId:projectId];
        
        [objData setPatrolTask:dbtask];
        
        res = [self save];
        
        if(res) {//如果设备添加成功 把巡检内容加添加到数据库中
            [self addSpotCheckContents:equip.contents withDeviceId:recordId andSpotId:spotId andSpotCode:spotCode andPatrolTaskId:patrolTaskId andUserId:userId];
        }
    }
    return res;
}
- (BOOL) addPatrolDevices:(NSArray *) devArray withSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId task:(DBPatrolTask *) dbtask {
    BOOL res = YES;
    for(Equipment * equip in devArray) {   //遇到新任务就加到数据库中
        res = res && [self addPatrolDevice:equip withSpotId:spotId andSpotCode:spotCode andPatrolTaskId:patrolTaskId andUserId:userId task:dbtask];
    }
    return res;
}
//删除任务相关设备
- (BOOL) deletePatrolDeviceOf:(NSNumber*) patrolTaskId {
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolDevice];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", projectId, @"projectId",  nil];
        NSString * strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolDevice* equip in mutableFetchResult) {
            [self.managedObjectContext deleteObject:equip];
        }
        
        res = [self save];
    }
    return res;
}
//删除任务相关设备
- (BOOL) deleteAllPatrolDevice {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:patrolDevice];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBPatrolDevice* equip in mutableFetchResult) {
        [self.managedObjectContext deleteObject:equip];
    }
    
    res = [self save];
    
    return res;
}
- (BOOL) updatePatrolDevice:(DBPatrolDevice*) newEquip condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newEquip) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBPatrolDevice* objData in mutableFetchResult) {
            
            [objData setFinish:newEquip.finish];
            [objData setException:newEquip.exception];
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updatePatrolDeviceById:(NSNumber*) id patrolDevice:(DBPatrolDevice*) equip {
    BOOL res = NO;
    if(id && equip) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:id, @"id", nil];
        res = [self updatePatrolDevice:equip condition:param];
    }
    return res;
}

//查询任务相关的所有设备
- (NSMutableArray*) queryAllDBPatrolDevicesOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolDevice];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}



//查询点位相关的所有设备（依据点位ID）
- (NSMutableArray*) queryAllDBPatrolDevicesOfSpot:(NSNumber *) spotId {
    NSMutableArray * res;
    if(spotId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolDevice];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:spotId, @"spotId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}

//查询点位相关的所有设备（依据点位编码）
- (NSMutableArray*) queryAllDBPatrolDevicesOfSpotByCode:(NSString *) spotCode andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(spotCode) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolDevice];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:spotCode, @"spotCode", userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}

- (DBPatrolDevice*) queryDBPatrolDeviceById:(NSNumber*) recordId {
    DBPatrolDevice * res;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolDevice];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult[0];
        }
    }
    return res;
}

//查询用户相关的点位下的所有有效的设备任务，依据相关巡检任务时间判断是否有效
- (NSMutableArray *) queryAllValidDBPatrolDevicesById:(NSNumber *) deviceId andUserId:(NSNumber *) userId {
    NSMutableArray *res;
    if(![FMUtils isNumberNullOrZero:deviceId]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *patrolTask = [NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:patrolTask];
        NSNumber *timeNow = [FMUtils getTimeLongNow];
        NSNumber *projectId = [SystemConfig getCurrentProjectId];
        NSString *strSql = [[NSString alloc] initWithFormat:@"deviceId==%lld and userId==%lld and projectId==%lld and (patrolTask.endDate > %lld or patrolTask.status==%ld)", deviceId.longLongValue, userId.longLongValue, projectId.longLongValue, timeNow.longLongValue, PATROL_STATUS_INPROGRESS];   //未结束的或者时正在进行中的
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    
//    NSFetchRequest* request=[[NSFetchRequest alloc] init];
//    NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_PATROL_DEVICE inManagedObjectContext:self.managedObjectContext];
//    [request setEntity:spotCheckContent];
//    
//    NSNumber *projectId = [SystemConfig getCurrentProjectId];
//    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:deviceId, @"deviceId", projectId, @"projectId", nil];
//    NSString* strSql = [self getSqlStringBy:dict];
//    
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
//    [request setPredicate:predicate];
//    
//    NSError* error=nil;
//    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    if([mutableFetchResult count] > 0) {
//        res = mutableFetchResult;
//    }
    return res;
}

#pragma mark - 巡检项
//获取一个可用 ID
- (NSNumber *) getAnAvaliableSpotCheckContentRecordId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_SPOT_CHECK_CONTENT andKey:@"id"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}
- (BOOL) isSpotCheckContentExist:(NSNumber*) recordId {
    BOOL res = NO;
    if(recordId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SPOT_CHECK_CONTENT condition:dict];
    }
    return res;
}

- (BOOL) addSpotCheckContent:(PatrolTaskItemDetail*) content withDeviceId:(NSNumber*) devId andSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId {
    BOOL res = NO;
    if(content) {
        DBSpotCheckContent * objData = (DBSpotCheckContent*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSNumber * recordId = [self getAnAvaliableSpotCheckContentRecordId];
        [objData setId:recordId];
        [objData setSpotCheckContentId:content.spotContentId];
        [objData setStatus:[NSNumber numberWithInteger:0]];
        [objData setContent:content.content];
        [objData setSelectEnum:content.selectEnums];
        [objData setContentType:content.contentType];
        [objData setResultType:content.resultType];
        [objData setSelectRightValue:content.selectRightValue];
        [objData setInputUpper:content.inputUpper];
        [objData setInputFloor:content.inputFloor];
        [objData setDefaultInputValue:content.defaultInputValue];
        [objData setDefaultSelectValue:content.defaultSelectValue];
        [objData setExceptions:content.exceptions];
        [objData setUnit:content.unit];
        [objData setValidStatus:[NSNumber numberWithInteger:content.validStatus]];
        
        [objData setResultSelect:@""];
        [objData setResultInput:@""];
        [objData setComment:@""];
        [objData setFinish:[NSNumber numberWithBool:NO]];
        [objData setFinishStartDate:[NSNumber numberWithLongLong:0]];
        [objData setFinishEndDate:[NSNumber numberWithLongLong:0]];
        
        [objData setDeviceId:devId];            //
        [objData setSpotId:spotId];             //
        [objData setSpotCode:spotCode];         //
        [objData setPatrolTaskId:patrolTaskId]; //
        [objData setUserId:userId];             //
        [objData setProjectId:projectId];             //
        
        res = [self save];
        
        if(res) {
            [self addSpotCheckContentPictures:content.pictures withSpotContentId:content.spotContentId andContentId:recordId andUserId:userId];
        }
    }
    return res;
}
- (BOOL) addSpotCheckContents:(NSArray *) contentArray withDeviceId:(NSNumber*) devId andSpotId:(NSNumber *) spotId andSpotCode:(NSString *) spotCode andPatrolTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId {
    BOOL res = YES;
    NSInteger count = [contentArray count];
    NSInteger index = 0;
    for(index = 0;index<count;index++) {
        PatrolTaskItemDetail * content = contentArray[index];
        res = res && [self addSpotCheckContent:content withDeviceId:devId andSpotId:spotId andSpotCode:spotCode andPatrolTaskId:patrolTaskId andUserId:userId];
    }
    return res;
}
//删除任务相关检查项
- (BOOL) deleteSpotCheckContentOf:(NSNumber*) patrolTaskId {
    BOOL res = NO;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:super.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", projectId, @"projectId", nil];
        NSString * strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSpotCheckContent* content in mutableFetchResult) {
            [self.managedObjectContext deleteObject:content];
        }
        
        res = [self save];
    }
    return res;
}
//删除任务相关检查项
- (BOOL) deleteAllSpotCheckContent {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:super.managedObjectContext];
    [request setEntity:spotCheckContent];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSpotCheckContent* content in mutableFetchResult) {
        [self.managedObjectContext deleteObject:content];
    }
    
    res = [self save];
    
    return res;
}
- (BOOL) updateSpotCheckContent:(DBSpotCheckContent*) newContent condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newContent) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        
        for (DBSpotCheckContent* objData in mutableFetchResult) {
            
            [objData setResultSelect:newContent.resultSelect];
            [objData setResultInput:newContent.resultInput];
            [objData setComment:newContent.comment];
            [objData setFinish:newContent.finish];
            [objData setFinishStartDate:newContent.finishStartDate];
            [objData setFinishEndDate:newContent.finishEndDate];
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateSpotCheckContentById:(NSNumber*) recordId checkContent:(DBSpotCheckContent*) checkContent {
    BOOL res = NO;
    if(recordId && checkContent) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        res = [self updateSpotCheckContent:checkContent condition:param];
    }
    return res;
}
//查询任务相关的所有检查项
- (NSMutableArray*) queryAllDBSpotCheckContentOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(patrolTaskId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:patrolTaskId, @"patrolTaskId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}
//查询设备相关的所有检查项
- (NSMutableArray*) queryAllDBSpotCheckContentOfDevice:(NSNumber *) devId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(devId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:devId, @"deviceId", userId, @"userId", projectId, @"projectId", nil];
        
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}
//查询设备相关的所有检查项 --- 按状态查
- (NSMutableArray*) queryAllDBSpotCheckContentOfDevice:(NSNumber *) devId byValidStatus:(PatrolItemContentValidStatus) validStatus andUserId:(NSNumber *) userId {
    NSMutableArray * res;
    if(devId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:devId, @"deviceId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        strSql = [[NSString alloc] initWithFormat:@"%@ and (validStatus==%ld or validStatus==%ld)", strSql, PATROL_ITEM_CONTENT_VALID_STATUS_ALL, validStatus];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult;
        }
    }
    return res;
}
- (DBSpotCheckContent*) queryDBSpotCheckContentById:(NSNumber*) recordId {
    DBSpotCheckContent * res;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSArray* mutableFetchResult=[self.managedObjectContext executeFetchRequest:request error:&error] ;
        if([mutableFetchResult count] > 0) {
            res = mutableFetchResult[0];
        }
    }
    return res;
}

#pragma mark - 巡检项图片
//巡检检查项图片
//获取一个可用 ID
- (NSNumber *) getAnAvaliableSpotCheckContentPictureRecordId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE andKey:@"id"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}
- (BOOL) isSpotCheckContentPictureExist:(NSNumber*) recordId {
    BOOL res = NO;
    if(recordId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE condition:dict];
    }
    return res;
}
- (BOOL) addSpotCheckContentPicture:(NSString*) url withSpotContentId:(NSNumber *) spotContentId andContentId:(NSNumber *) contentId andUserId:(NSNumber *) userId {
    BOOL res = NO;
    if(url && ![url isEqualToString:@""]) {
        DBSpotCheckContentPicture * objData = (DBSpotCheckContentPicture*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSNumber * recordId = [self getAnAvaliableSpotCheckContentPictureRecordId];
        [objData setId:recordId];
        [objData setUrl:url];
        [objData setUserId:userId];
        [objData setSpotCheckContentId:spotContentId];
        [objData setContentId:contentId];
        [objData setUploaded:[NSNumber numberWithBool:NO]];
        
        [objData setProjectId:projectId];
        res = [self save];
    
    }
    return res;
}
- (BOOL) addSpotCheckContentPictures:(NSArray *) urlArray withSpotContentId:(NSNumber *) spotContentId andContentId:(NSNumber *) contentId andUserId:(NSNumber *) userId {
    BOOL res = YES;
    for(NSString * url in urlArray) {
        res = res && [self addSpotCheckContentPicture:url withSpotContentId:spotContentId andContentId:contentId andUserId:userId];
    }
    return res;
}
//删除巡检任务相关图片，会将文件从缓存中删除
- (BOOL) deleteSpotCheckContentPictureById:(NSNumber*) picId {
    BOOL res = NO;
    if(picId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:picId, @"id", nil];
        NSString * strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSpotCheckContentPicture* picture in mutableFetchResult) {
            [self.managedObjectContext deleteObject:picture];
        }
        
        res = [self save];
        
    }
    return res;
}

- (BOOL) deleteSpotCheckContentPictureOf:(NSNumber*) patrolTaskId andUserId:(NSNumber *) userId{
    BOOL res = NO;
    if(patrolTaskId) {
        NSMutableArray * contentArray = [self queryAllDBSpotCheckContentOfTask:patrolTaskId andUserId:userId];
        if(contentArray && [contentArray count] > 0) {
            NSMutableArray *ids = [[NSMutableArray alloc] init];
            for(DBSpotCheckContent * content in contentArray) {
                [ids addObject:content.id];
            }
            NSFetchRequest* request=[[NSFetchRequest alloc] init];
            NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
            [request setEntity:spotCheckContent];
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"contentId", nil];
            NSString * strParam = [self getSqlStringBy:param];
            NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
            [request setPredicate:predicate];
            NSError* error=nil;
            NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            if (mutableFetchResult==nil) {
                NSLog(@"Error:%@",error);
            }
            for (DBSpotCheckContentPicture* picture in mutableFetchResult) {
                [self.managedObjectContext deleteObject:picture];
            }
            if (![self save]) {
                NSLog(@"Error:%@,%@",error,[error userInfo]);
            }
        }
    }
    return res;
}

//删除巡检任务相关图片，会将文件从缓存中删除
- (BOOL) deleteAllSpotCheckContentPicture {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:spotCheckContent];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSpotCheckContentPicture* picture in mutableFetchResult) {
        [self.managedObjectContext deleteObject:picture];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updatePictureStateOfSpotCheckContent:(NSNumber*) contentId andTaskId:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId{
    BOOL res = NO;
    if(contentId) {
//        NSMutableArray * contentArray = [self queryAllDBSpotCheckContentOfTask:patrolTaskId andUserId:userId];
//        if(contentArray && [contentArray count] > 0) {
//            for(DBSpotCheckContent * content in contentArray) {
//                if([content.spotCheckContentId isEqualToNumber:spotContentId] ) {
//                    contentId = content.id;
//                    break;
//                }
//            }
//        }
//        if(!contentId) {
//            return NO;
//        }
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:contentId, @"contentId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSpotCheckContentPicture* objData in mutableFetchResult) {
            [objData setUploaded:[NSNumber numberWithBool:YES]];
        }
        res = [self save];
    }
    return res;
}

//更新图片的 ID（从远程服务器上获取的ID）
- (BOOL) updateImageId:(NSNumber *) imgId ofPicture:(NSNumber *) picId {
    BOOL res = NO;
    if(imgId && picId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:picId, @"id", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSpotCheckContentPicture* objData in mutableFetchResult) {
            [objData setImageId:imgId];
        }
        res = [self save];

    }
    return res;
}

//查询任务相关的所有检查项
- (NSMutableArray*) queryAllPictureOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(patrolTaskId) {
        NSMutableArray * contentArray = [self queryAllDBSpotCheckContentOfTask:patrolTaskId andUserId:userId];
        if(contentArray && [contentArray count] > 0) {
            NSMutableArray *ids = [[NSMutableArray alloc] init];
            for(DBSpotCheckContent * content in contentArray) {
                [ids addObject:content.id];
            }
            NSFetchRequest* request=[[NSFetchRequest alloc] init];
            NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
            [request setEntity:spotCheckContent];
            NSNumber * projectId = [SystemConfig getCurrentProjectId];
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"contentId", userId, @"userId", projectId, @"projectId", nil];
            NSString * strParam = [self getSqlStringBy:param];
            NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
            [request setPredicate:predicate];
            NSError* error=nil;
            res = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            
            if (![self save]) {
                NSLog(@"Error:%@,%@",error,[error userInfo]);
            }
        }
        
    }
    return res;
}

//查询任务相关的所有待上传的图片
- (NSMutableArray*) queryAllPictureUnUploadedOfTask:(NSNumber *) patrolTaskId andUserId:(NSNumber *) userId {
    NSMutableArray * res;
    if(patrolTaskId) {
        NSMutableArray * contentArray = [self queryAllDBSpotCheckContentOfTask:patrolTaskId andUserId:userId];
        if(contentArray && [contentArray count] > 0) {
            NSMutableArray *ids = [[NSMutableArray alloc] init];
            for(DBSpotCheckContent * content in contentArray) {
                [ids addObject:content.id];
            }
            NSFetchRequest* request=[[NSFetchRequest alloc] init];
            NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:super.managedObjectContext];
            [request setEntity:spotCheckContent];
            NSNumber * projectId = [SystemConfig getCurrentProjectId];
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"contentId", userId, @"userId", [NSNumber numberWithBool:NO], @"uploaded", projectId, @"projectId", nil];
            NSString * strParam = [self getSqlStringBy:param];
            NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
            [request setPredicate:predicate];
            NSError* error=nil;
            res = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            
            [self save];
        }
        
    }
    return res;
}

//查询设备相关的所有检查项
- (NSMutableArray*) queryAllPictureOfSpotCheckContent:(NSNumber *) spotCheckContentId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(spotCheckContentId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:spotCheckContentId, @"contentId", userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        res = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    }
    return res;
}

//查询巡检项相关的所有待上传的图片
- (NSMutableArray*) queryAllPictureUnUploadOfSpotCheckContent:(NSNumber *) contentId andUserId:(NSNumber *) userId{
    NSMutableArray * res;
    if(contentId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:contentId, @"contentId",userId, @"userId", [NSNumber numberWithBool:NO], @"uploaded", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        res = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    }
    return res;
}

//查询巡检项相关的所有图片的ID
- (NSMutableArray*) queryAllImageIdOfSpotCheckContent:(NSNumber *) contentId andUserId:(NSNumber *) userId {
    NSMutableArray * res;
    if(contentId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContent = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContent];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:contentId, @"contentId",userId, @"userId", [NSNumber numberWithBool:YES], @"uploaded", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray * resultArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if(resultArray && [resultArray count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBSpotCheckContentPicture * dbObj in resultArray) {
                if(dbObj.imageId) {
                    [res addObject:dbObj.imageId];
                }
            }
        }
    }
    return res;
}

- (DBSpotCheckContentPicture*) queryDBSpotCheckContentPictureById:(NSNumber*) recordId {
    DBSpotCheckContentPicture * res;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* spotCheckContentPicture = [NSEntityDescription entityForName:DB_ENTITY_NAME_SPOT_CHECK_CONTENT_PICTURE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:spotCheckContentPicture];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray * resultArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if(resultArray && [resultArray count] > 0) {
            res = resultArray[0];
        }
    }
    return res;
}

#pragma mark - 清除巡检任务数据
- (void) deleteAllPatrolData {
    [self deleteAllSpotCheckContentPicture];
    [self deleteAllSpotCheckContent];
    [self deleteAllPatrolDevice];
    [self deleteAllPatrolSpot];
    [self deleteAllPatrolTask];
}

@end

