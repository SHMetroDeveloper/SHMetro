//
//  NotificationDbHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "NotificationDbHelper.h"
#import "SystemConfig.h"

static NSString * DB_ENTITY_NAME_NOTIFICATION = @"DBNotification";

static NotificationDbHelper * instance = nil;

@interface NotificationDbHelper ()

@property (readwrite, nonatomic, strong) DBHelper * dbHelper;

@end

@implementation NotificationDbHelper

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[NotificationDbHelper alloc] init];
    }
    return instance;
}

//通知记录

- (NSNumber *) getAnAvaliableNotificationId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_NOTIFICATION andKey:@"recordId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isNotificationExist:(NSNumber*) recordId withUser:(NSNumber *) userId {
    BOOL res = NO;
    if(recordId && userId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"recordId", userId, @"userId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_NOTIFICATION condition:dict];
    }
    return res;
}
- (BOOL) addNotification:(NotificationEntity*) notification withUserId:(NSNumber *) userId {
    BOOL res = NO;
    if(notification) {
        DBNotification * objData = (DBNotification*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:super.managedObjectContext];
        
//        NSNumber * recordId = [self getAnAvaliableNotificationId];
        
        [objData setRecordId:notification.msgId];
        [objData setTitle:notification.title];
        [objData setContent:notification.content];
        [objData setReceiveTime:notification.time];
        [objData setType:[NSNumber numberWithInteger:notification.type]];
        [objData setPatrolId:notification.patrolId];
        [objData setWoId:notification.woId];
        [objData setWoStatus:[NSNumber numberWithInteger:notification.woStatus]];
        [objData setAssetId:notification.assetId];
        [objData setPmId:notification.pmId];
        [objData setTodoId:notification.todoId];
        [objData setBulletinId:notification.bulletinId];
        [objData setReservationId:notification.reservationId];
        [objData setInventoryId:notification.inventoryId];
        
        [objData setUserId:userId];   //
        [objData setProjectId:notification.projectId];
        [objData setRead:[NSNumber numberWithBool:notification.read]];            //
        [objData setDeleted:[NSNumber numberWithBool:notification.deleted]];
        
        
        res = [self save];
    }
    return res;
}
- (BOOL) addNotifications:(NSArray *) notificationArray withUserId:(NSNumber *) userId {
    BOOL res = YES;
    NSMutableArray * idArray = [[NSMutableArray alloc] init];
    for(NotificationEntity * obj in notificationArray) {
        NSNumber * msgId = obj.msgId;
        [idArray addObject:msgId];
        if([self isNotificationExist:msgId withUser:userId]) {
//            res = res && [self updateNotificationById:msgId userId:userId notification:obj];
        } else {
            res = res && [self addNotification:obj withUserId:userId];
        }
    }
    res = res && [self markNotificationReadNotIn:idArray ofUser:userId];
    return res;
}
- (BOOL) deleteNotificationById:(NSNumber*) recordId andUserId:(NSNumber *) userId {
    BOOL res = NO;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolSpot=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolSpot];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"recordId==%@",recordId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBNotification* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        
        res = [self save];
    }

    return res;
}

//删除所有的巡检任务
- (BOOL) deleteAllNotificationOfUser:(NSNumber *) userId {
    BOOL res = NO;
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* patrolSpot=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:super.managedObjectContext];
        [request setEntity:patrolSpot];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"userId==%@",userId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBNotification* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        res = [self save];
    }
    return res;
}
//删除所有的巡检任务
- (BOOL) deleteAllNotification {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* patrolSpot=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:super.managedObjectContext];
    [request setEntity:patrolSpot];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBNotification* obj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:obj];
    }
    res = [self save];
    
    return res;
}

- (BOOL) updateNotification:(NotificationEntity*) newObj condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newObj) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
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
        for (DBNotification* objData in mutableFetchResult) {
            [objData setRead:[NSNumber numberWithBool:newObj.read]];  //一般更新的话就是更新是否已读的状态
        }
        res = [self save];
    }
    return res;
}

//更新单条数据的状态
- (BOOL) updateNotificationById:(NSNumber*) recordId userId:(NSNumber*) userId notification:(NotificationEntity*) notification {
    BOOL res = NO;
    if(recordId && userId && notification) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"recordId", userId, @"userId", nil];
        res = [self updateNotification:notification condition:param];
    }
    return res;
}

- (BOOL) markNotificationRead:(NSNumber *) recordId userId:(NSNumber *) userId {
    BOOL res = NO;
    if(recordId && userId) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"recordId", userId, @"userId", nil];
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
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
        for (DBNotification *objData in mutableFetchResult) {
            [objData setRead:[NSNumber numberWithBool:YES]];  //
        }
        res = [self save];
    }
    return res;
}

//把用户相关的所有消息置为已读
- (BOOL) markAllNotificationReadByUser:(NSNumber *) userId {
    BOOL res = YES;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
    [request setEntity:userEntity];
    //查询条件
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    //更新age后要进行保存，否则没更新
    for (DBNotification *objData in mutableFetchResult) {
        [objData setRead:[NSNumber numberWithBool:YES]];  //
    }
    res = [self save];
    return res;
}

//把 id 值不在数组之内的
- (BOOL) markNotificationReadNotIn:(NSMutableArray *) idArray ofUser:(NSNumber *) userId {
    BOOL res = NO;
    if(idArray && [idArray count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
        NSDictionary * idParam = [[NSDictionary alloc] initWithObjectsAndKeys:idArray, @"recordId", nil];
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
        for (DBNotification* obj in mutableFetchResult) {
            [obj setRead:[NSNumber numberWithBool:YES]];  //
        }
        res = [self save];
    } else {
        res = [self markAllNotificationReadByUser:userId];
    }
    return res;
}

//把用户相关的所有指定类型消息置为已读
- (BOOL) markAllNotificationReadByUser:(NSNumber *) userId andType:(NSInteger) type {
    BOOL res = YES;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
    [request setEntity:userEntity];
    //查询条件
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", [NSNumber numberWithInteger:type], @"type", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    //更新age后要进行保存，否则没更新
    for (DBNotification *objData in mutableFetchResult) {
        [objData setRead:[NSNumber numberWithBool:YES]];  //
    }
    res = [self save];
    return res;
}

//把用户的相关消息标记为已删除
- (BOOL) deleteAllNotificationByUser:(NSNumber *) userId {
    BOOL res = YES;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
    [request setEntity:userEntity];
    //查询条件
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    //更新age后要进行保存，否则没更新
    for (DBNotification *objData in mutableFetchResult) {
        [objData setDeleted:[NSNumber numberWithBool:YES]];  //
    }
    res = [self save];
    return res;
}

//把当前用户的相关消息标记为已删除
- (BOOL) deleteAllNotificationOfCurrentUser {
    BOOL res = NO;
    NSNumber * userId = [SystemConfig getUserId];
    res = [self deleteAllNotificationByUser:userId];
    return res;
}


//把该用户相关的所有指定类型消息标记为已删除
- (BOOL) deleteAllNotificationByUser:(NSNumber *) userId andType:(NSInteger) type {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        res = YES;
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", [NSNumber numberWithInteger:type], @"type", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        //更新age后要进行保存，否则没更新
        for (DBNotification *objData in mutableFetchResult) {
            [objData setDeleted:[NSNumber numberWithBool:YES]];  //
        }
        res = [self save];
    }
    
    return res;

}


//查询消息记录，默认以时间排序（接收时间递减）
- (NSMutableArray*) queryAllNotificationBy:(NSNumber *) userId {
    NSMutableArray *res;
    if(userId) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];  //默认获取当前项目信息
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", [NSNumber numberWithBool:NO], @"deleted",  nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSSortDescriptor * sortReceiveTime = [[NSSortDescriptor alloc] initWithKey:@"receiveTime" ascending:NO];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortReceiveTime, nil]];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBNotification * dbObj in mutableFetchResult) {
                NotificationEntity * notification = [[NotificationEntity alloc] init];
                
                notification.msgId = dbObj.recordId;
                notification.title = dbObj.title;
                notification.content = dbObj.content;
                notification.time = dbObj.receiveTime;
                notification.type = dbObj.type.integerValue;
                notification.patrolId = dbObj.patrolId;
                notification.woId = dbObj.woId;
                notification.woStatus = dbObj.woStatus.integerValue;
                notification.assetId = dbObj.assetId;
                notification.pmId = dbObj.pmId;
                notification.todoId = dbObj.todoId;
                notification.bulletinId = dbObj.bulletinId;
                notification.reservationId = dbObj.reservationId;
                notification.inventoryId = dbObj.inventoryId;
                
                notification.projectId = dbObj.projectId;
                notification.read = dbObj.read.boolValue;
                notification.deleted = dbObj.deleted.boolValue;
                
                [res addObject:notification];
            }
        }
    }
    return res;
}

//查询所有公司级公告
- (NSMutableArray*) queryAllNotificationOfCompanyBy:(NSNumber *) userId {
    NSMutableArray *res;
    if(userId) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        id projectId = [NSNull null];  //
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", [NSNumber numberWithBool:NO], @"deleted",  nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSSortDescriptor * sortReceiveTime = [[NSSortDescriptor alloc] initWithKey:@"receiveTime" ascending:NO];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortReceiveTime, nil]];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBNotification * dbObj in mutableFetchResult) {
                NotificationEntity * notification = [[NotificationEntity alloc] init];
                
                notification.msgId = dbObj.recordId;
                notification.title = dbObj.title;
                notification.content = dbObj.content;
                notification.time = dbObj.receiveTime;
                notification.type = dbObj.type.integerValue;
                notification.patrolId = dbObj.patrolId;
                notification.woId = dbObj.woId;
                notification.woStatus = dbObj.woStatus.integerValue;
                notification.assetId = dbObj.assetId;
                notification.pmId = dbObj.pmId;
                notification.todoId = dbObj.todoId;
                notification.bulletinId = dbObj.bulletinId;
                notification.reservationId = dbObj.reservationId;
                notification.inventoryId = dbObj.inventoryId;
                
                notification.projectId = dbObj.projectId;
                notification.read = dbObj.read.boolValue;
                notification.deleted = dbObj.deleted.boolValue;
                
                [res addObject:notification];
            }
        }
    }
    return res;
}

//查询指定类型消息记录，默认以时间排序（接收时间递减）
- (NSMutableArray*) queryAllNotificationByType:(NSInteger) type ofUser:(NSNumber *) userId {
    NSMutableArray *res;
    if(userId) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];  //默认获取当前项目信息
        NSNumber * typeNumber = [NSNumber numberWithInteger:type];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId",typeNumber, @"type", projectId, @"projectId", [NSNumber numberWithBool:NO], @"deleted",  nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSSortDescriptor * sortReceiveTime = [[NSSortDescriptor alloc] initWithKey:@"receiveTime" ascending:NO];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sortReceiveTime, nil]];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBNotification * dbObj in mutableFetchResult) {
                NotificationEntity * notification = [[NotificationEntity alloc] init];
                
                notification.msgId = dbObj.recordId;
                notification.title = dbObj.title;
                notification.content = dbObj.content;
                notification.time = dbObj.receiveTime;
                notification.type = dbObj.type.integerValue;
                notification.patrolId = dbObj.patrolId;
                notification.woId = dbObj.woId;
                notification.woStatus = dbObj.woStatus.integerValue;
                notification.assetId = dbObj.assetId;
                notification.pmId = dbObj.pmId;
                notification.todoId = dbObj.todoId;
                notification.bulletinId = dbObj.bulletinId;
                notification.reservationId = dbObj.reservationId;
                notification.inventoryId = dbObj.inventoryId;
                
                notification.projectId = dbObj.projectId;
                notification.read = dbObj.read.boolValue;
                notification.deleted = dbObj.deleted.boolValue;
                
                [res addObject:notification];
            }
        }
    }
    return res;
}

//查询指定项目未读消息记录的条数, 如果projectId 为 nil 则查询所有未读记录
- (NSInteger) queryAllNotificationUnReadBy:(NSNumber *) userId project:(NSNumber *) projectId {
    NSInteger count = 0;
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * dict;
        if(projectId) {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", [NSNumber numberWithBool:NO], @"read",[NSNumber numberWithBool:NO], @"deleted", nil];
        } else {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", [NSNumber numberWithBool:NO], @"read", nil];
        }
        
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        count = [mutableFetchResult count];
    }

    return count;
}

- (NotificationEntity*) queryNotificationById:(NSNumber*) recordId andUserId:(NSNumber *) userId {
    NotificationEntity * res;
    if(recordId && userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_NOTIFICATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"recordId", userId, @"userId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBNotification * dbObj = mutableFetchResult[0];
            res = [[NotificationEntity alloc] init];
            res.msgId = dbObj.recordId;
            res.title = dbObj.title;
            res.content = dbObj.content;
            res.time = dbObj.receiveTime;
            res.type = dbObj.type.integerValue;
            res.patrolId = dbObj.patrolId;
            res.woId = dbObj.woId;
            res.woStatus = dbObj.woStatus.integerValue;
            res.assetId = dbObj.assetId;
            res.pmId = dbObj.pmId;
            res.todoId = dbObj.todoId;
            res.bulletinId = dbObj.bulletinId;
            res.reservationId = dbObj.reservationId;
            res.inventoryId = dbObj.inventoryId;
            
            res.projectId = dbObj.projectId;
            res.read = dbObj.read.boolValue;
        }
    }
    return res;
}

@end
