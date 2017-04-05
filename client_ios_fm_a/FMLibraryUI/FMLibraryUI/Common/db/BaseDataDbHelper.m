//
//  BaseDataDbHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/2.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseDataDbHelper.h"
#import "FMUtils.h"
#import "ReportServerConfig.h"
#import "SystemConfig.h"
#import "DBUser+CoreDataClass.h"

//实体名字
NSString * DB_ENTITY_NAME_USER = @"DBUser";                     //用户
NSString * DB_ENTITY_NAME_USER_GROUP = @"DBGroup";              //用户组
NSString * DB_ENTITY_NAME_ORG = @"DBOrg";                       //部门
NSString * DB_ENTITY_NAME_SERVICE_TYPE = @"DBStype";            //服务类型
NSString * DB_ENTITY_NAME_CITY = @"DBCity";                     //位置---城市
NSString * DB_ENTITY_NAME_SITE = @"DBSite";                     //位置---区域
NSString * DB_ENTITY_NAME_BUILDING = @"DBBuilding";             //位置---楼
NSString * DB_ENTITY_NAME_FLOOR = @"DBFloor";                   //位置---楼层
NSString * DB_ENTITY_NAME_ROOM = @"DBRoom";                     //位置---房间
NSString * DB_ENTITY_NAME_PRIORITY= @"DBPriority";              //优先级
NSString * DB_ENTITY_NAME_FLOW= @"DBFlow";                      //流程
NSString * DB_ENTITY_NAME_DEVICE= @"DBDevice";                  //设备
NSString * DB_ENTITY_NAME_DEVICE_TYPE= @"DBDeviceType";         //设备类型
NSString * DB_ENTITY_NAME_REQUIREMENT_TYPE= @"DBRequirementType";    //需求类型
NSString * DB_ENTITY_NAME_SATISFACTION_TYPE= @"DBSatisfactionType";   //满意度类型
NSString * DB_ENTITY_NAME_FAILURE_REASON = @"DBFailureReason";   //故障原因
NSString * DB_ENTITY_NAME_DOWNLOAD_RECORD= @"DBBaseDownloadRecord";  //基础数据的下载记录

static BaseDataDbHelper * instance;

@interface BaseDataDbHelper ()


@end

@implementation BaseDataDbHelper
- (instancetype) init {
    self = [super init];
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[BaseDataDbHelper alloc] init];
    }
    return instance;
}

#pragma mark - User
//User
- (BOOL) isUserExist:(NSString*) userName {
    BOOL res = NO;
    NSDictionary * userDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"loginName", userName, nil];
    res = [self isDataExist:DB_ENTITY_NAME_USER condition:userDict];
    return res;
    
}



- (BOOL) addUser:(UserInfo*) user {
    BOOL res = NO;
    if(user) {
        DBUser * objUser = (DBUser*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        
        [objUser setUserId:user.userId];
        [objUser setEmId:user.emId];
        [objUser setName:user.name];
        [objUser setLoginName:user.loginName];
        [objUser setPassword:user.password];
        [objUser setEmail:user.email];
        [objUser setPhone:user.phone];
        [objUser setPictureId:user.pictureId];
        [objUser setOrgId:user.organizationId];
        [objUser setOrgName:user.organizationName];
        [objUser setPosition:user.position];
        [objUser setEmDesc:user.emDescription];
        [objUser setProjectId:user.projectId];
        [objUser setLoginName:user.locationName];
        [objUser setCityId:user.location.cityId];
        [objUser setSiteId:user.location.siteId];
        [objUser setBuildingId:user.location.buildingId];
        [objUser setFloorId:user.location.floorId];
        [objUser setRoomId:user.location.roomId];
        [objUser setType:user.type];
        [objUser setQrcodeId:user.qrcodeId];
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteUserById:(NSNumber*) userId {
    BOOL res = NO;
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBUser* user in mutableFetchResult) {
            [self.managedObjectContext deleteObject:user];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有员工信息
- (BOOL) deleteAllUserInCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"projectId==%@",projectId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBUser* user in mutableFetchResult) {
            [self.managedObjectContext deleteObject:user];
        }
        
        res = [self save];
    }
    return res;
}

//删除所有员工信息
- (BOOL) deleteAllUser {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (DBUser* user in mutableFetchResult) {
        [self.managedObjectContext deleteObject:user];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateUser:(UserInfo*) newUser condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newUser) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //
        for (DBUser* dbuser in mutableFetchResult) {
            
            dbuser.emId = newUser.emId;
            dbuser.name =newUser.name;
            dbuser.loginName = newUser.loginName;
            dbuser.phone = newUser.phone;
            dbuser.email = newUser.email;
            dbuser.pictureId = newUser.pictureId;
            dbuser.orgId = newUser.organizationId;
            dbuser.orgName = newUser.organizationName;
            dbuser.position = newUser.position;
            dbuser.emDesc = newUser.emDescription;
            dbuser.projectId = newUser.projectId;
            if(newUser.password) {
                
                dbuser.password = newUser.password;
            }
            dbuser.projectId = newUser.projectId;
            dbuser.locationName = newUser.locationName;
            dbuser.cityId = newUser.location.cityId;
            dbuser.siteId = newUser.location.siteId;
            dbuser.buildingId = newUser.location.buildingId;
            dbuser.floorId = newUser.location.floorId;
            dbuser.roomId = newUser.location.roomId;
            dbuser.type = newUser.type;
            dbuser.qrcodeId = newUser.qrcodeId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateUserById:(NSNumber*) userId user:(UserInfo*) user {
    BOOL res = NO;
    if(userId && user) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
        res = [self updateUser:user condition:param];
    }
    return res;
}
- (BOOL) updateUserByLoginName:(NSString*) loginName user:(UserInfo*) user {
    BOOL res = NO;
    if(user) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:loginName, @"loginName", nil];
        res = [self updateUser:user condition:param];
    }
    return res;
}
- (BOOL) clearPasswordOfUser:(NSNumber *) userId {
    BOOL res = NO;
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        //
        for (DBUser* dbuser in mutableFetchResult) {
            dbuser.password = @"";
        }
        res = [self save];
    }
    return res;
}
- (UserInfo*) queryUserById:(NSNumber*) userId {
    UserInfo* res = nil;
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBUser * dbUser = mutableFetchResult[0];
            res = [[UserInfo alloc] init];
            
            res.userId = dbUser.userId;
            res.emId = dbUser.emId;
            res.name = dbUser.name;
            res.loginName = dbUser.loginName;
            res.password = dbUser.password;
            res.phone = dbUser.phone;
            res.email = dbUser.email;
            res.pictureId = dbUser.pictureId;
            res.organizationId = dbUser.orgId;
            res.organizationName = dbUser.orgName;
            res.position = dbUser.position;
            res.emDescription = dbUser.emDesc;
            res.projectId = dbUser.projectId;
            res.locationName = dbUser.locationName;
            res.location.cityId = dbUser.cityId;
            res.location.siteId = dbUser.siteId;
            res.location.buildingId = dbUser.buildingId;
            res.location.floorId = dbUser.floorId;
            res.location.roomId = dbUser.roomId;
            res.type = dbUser.type;
            res.qrcodeId = dbUser.qrcodeId;
        }
    }
    return res;
}

- (NSMutableArray*) queryAllUser {
    NSMutableArray* userArray = [[NSMutableArray alloc] init];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for(DBUser * dbUser in mutableFetchResult) {
        UserInfo * user = [[UserInfo alloc] init];
        
        user.userId = dbUser.userId;
        user.emId = dbUser.emId;
        user.name = dbUser.name;
        user.loginName = dbUser.loginName;
        user.phone = dbUser.phone;
        user.email = dbUser.email;
        user.pictureId = dbUser.pictureId;
        user.password = dbUser.password;
        user.organizationId = dbUser.orgId;
        user.organizationName = dbUser.orgName;
        user.position = dbUser.position;
        user.emDescription = dbUser.emDesc;
        user.projectId = dbUser.projectId;
        user.locationName = dbUser.locationName;
        user.location.cityId = dbUser.cityId;
        user.location.siteId = dbUser.siteId;
        user.location.buildingId = dbUser.buildingId;
        user.location.floorId = dbUser.floorId;
        user.location.roomId = dbUser.roomId;
        user.type = dbUser.type;
        user.qrcodeId = dbUser.qrcodeId;
        
        [userArray addObject:user];
    }
    return userArray;
}

- (NSMutableArray*) queryUserByLoginName:(NSString*) userName {
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
    [request setEntity:user];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"loginName==%@",userName];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    return mutableFetchResult;
}



//依据 ID 判断用户是否存在
- (BOOL) isUserIdExist:(NSNumber*) userId {
    BOOL res = NO;
    if(userId) {
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_USER condition:dict];
    }
    return res;
}

//依据登录名判断用户是否存在
- (BOOL) isLoginNameExist:(NSString*) loginName {
    BOOL res = NO;
    if(loginName) {
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:loginName, @"loginName", nil];
        res = [super isDataExist:DB_ENTITY_NAME_USER condition:dict];
    }
    return res;
}

//保存用户信息到数据库，如果不存在就插入，存在就更新
- (BOOL) saveUserInfo:(UserInfo *) newData {
    BOOL res = NO;
    if(newData) {
        BOOL isNew = YES;
        if([newData.userId integerValue] != 0) {
            if([self isUserIdExist:newData.userId]) {
                isNew = NO;
            }
        } else if(![FMUtils isStringEmpty:newData.loginName]) {
            if([self isLoginNameExist:newData.loginName]) {
                isNew = NO;
            }
        }
        if(isNew) {
            res = [self addUser:newData];
        } else {
            res = [self updateUserById:newData.userId user:newData];
//            [self updateUserByLoginName:newData.loginName user:newData];
        }
    }
    return res;
}


#pragma mark - 用户组
//获取一个可用 ID
- (NSNumber *) getAnAvaliableUserGroupId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_USER_GROUP andKey:@"recordId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

//判断用户的组信息是否存在
- (BOOL) isUserGroupExist:(NSNumber *) emId group:(NSNumber *) groupId {
    BOOL res = NO;
    if(emId && groupId) {
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", groupId, @"groupId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_USER_GROUP condition:dict];
    }
    return res;
}
- (BOOL) addUserGroup:(UserGroup *) info {
    BOOL res = NO;
    if(info) {
        DBGroup * objUserGroup = (DBGroup*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];

        NSNumber * recordId = [self getAnAvaliableUserGroupId];
        
        [objUserGroup setRecordId:recordId];
        [objUserGroup setEmId:info.emId];
        [objUserGroup setGroupId:info.groupId];
        [objUserGroup setGroupName:info.groupName];
        
        res = [self save];
    }
    return res;
}
- (BOOL) updateUserGroup:(UserGroup *) info {
    BOOL res = NO;
    if(info) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:info.emId, @"emId", info.groupId, @"groupId", nil];
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        //
        for (DBGroup* dbObj in mutableFetchResult) {
            dbObj.groupName = info.groupName;
            
        }
        res = [self save];
    }
    return res;
    
}
//保存组信息
- (BOOL) saveUserGroupInfo:(UserGroup *) info{
    BOOL res = NO;
    NSNumber * groupId = info.groupId;
    NSNumber * emId = info.emId;
    if(groupId && emId) {
        if([self isUserGroupExist:emId group:groupId]) {
            res = res && [self updateUserGroup:info];
        } else {
            res = res && [self addUserGroup:info];
        }
    }
    return res;
}
- (BOOL) deleteUserGroupById:(NSNumber *) recordId {
    BOOL res = NO;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"recordId==%@",recordId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBGroup* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        res = [self save];
    }
    return res;
}
- (BOOL) deleteUserGroupByUserAndGroup:(NSNumber *) emId group:(NSNumber *) groupId {
    BOOL res = NO;
    if(emId && groupId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", groupId, @"groupId", nil];
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBGroup* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        res = [self save];
    }
    return res;
}
- (BOOL) deleteAllGroupOfUser:(NSNumber *) emId {
    BOOL res = NO;
    if(emId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
        [request setEntity:user];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", nil];
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBGroup* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        res = [self save];
    }
    return res;
}

//删除当前项目下所有组
- (BOOL) deleteAllGroupOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [self getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for (DBGroup* obj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:obj];
        }
        res = [self save];
    }
    return res;
}
//删除所有工作组
- (BOOL) deleteAllGroup {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];

    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (DBGroup* obj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:obj];
    }
    res = [self save];
    return res;
}


- (NSMutableArray *) QueryAllGroupOfUser:(NSNumber *) emId {
    NSMutableArray* res = nil;
    if(emId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBGroup * dbObj in mutableFetchResult) {
                UserGroup * group = [[UserGroup alloc] init];
                
                group.emId = [dbObj.emId copy];
                group.groupId = [dbObj.groupId copy];
                group.groupName = [dbObj.groupName copy];
                
                [res addObject:group];
            }
        }
    }
    return res;
}

//删除所有的用户组信息
- (BOOL) deleteAllUserGroup {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_USER_GROUP inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (DBGroup* obj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:obj];
    }
    
    res = [self save];
    return res;
}


#pragma mark - Org
- (BOOL) isOrgExist:(NSNumber*) orgId {
    BOOL res = NO;
    if(orgId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:orgId, @"orgId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_ORG condition:dict];
    }
    return res;
}

- (BOOL) addOrg:(Org*) org projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(org) {
        DBOrg * objData = (DBOrg*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:super.managedObjectContext];
        
        [objData setOrgId:org.orgId];
        [objData setName:org.name];
        [objData setCode:org.code];
        [objData setFullName:org.fullName];
        [objData setLevel:[NSNumber numberWithInteger:org.level]];
        [objData setParentId:org.parentOrgId];
        
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}

- (BOOL) addOrgs:(NSArray *) orgs projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(Org * org in orgs) {
        NSNumber * orgId = org.orgId;
        if(orgId) {
            if([self isOrgExist:orgId]) {
                res = res && [self updateOrgById:orgId org:org];
            } else {
                res = res && [self addOrg:org projectId:projectId];
            }
        }
    }
    return res;
}

- (BOOL) deleteOrgById:(NSNumber*) orgId {
    BOOL res = NO;
    if(orgId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* org=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:super.managedObjectContext];
        [request setEntity:org];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"orgId==%@",orgId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
 
        for (DBOrg* org in mutableFetchResult) {
            [self.managedObjectContext deleteObject:org];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteOrgByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* org=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:super.managedObjectContext];
        [request setEntity:org];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"orgId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBOrg* org in mutableFetchResult) {
            [self.managedObjectContext deleteObject:org];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllOrgsOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* org=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:super.managedObjectContext];
        [request setEntity:org];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBOrg* org in mutableFetchResult) {
            [self.managedObjectContext deleteObject:org];
        }
        res = [self save];
    }
    return res;
}

//批量删除
- (BOOL) deleteAllOrgs {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* org=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:super.managedObjectContext];
    [request setEntity:org];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBOrg* org in mutableFetchResult) {
        [self.managedObjectContext deleteObject:org];
    }
    res = [self save];
    return res;
}


- (BOOL) updateOrg:(Org*) newOrg condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newOrg) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBOrg* dbOrg in mutableFetchResult) {
            dbOrg.orgId = newOrg.orgId;
            dbOrg.name =newOrg.name;
            dbOrg.fullName = newOrg.fullName;
            dbOrg.code = newOrg.code;
            dbOrg.level = [NSNumber numberWithInteger:newOrg.level];
            dbOrg.parentId = newOrg.parentOrgId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateOrgById:(NSNumber*) orgId org:(Org*) org {
    BOOL res = NO;
    if(orgId && org) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:orgId, @"orgId", nil];
        res = [self updateOrg:org condition:param];
    }
    return res;
}

- (Org*) queryOrgById:(NSNumber*) orgId {
    Org* res = nil;
    if(orgId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* org=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:self.managedObjectContext];
        [request setEntity:org];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:orgId, @"orgId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBOrg * dbOrg = mutableFetchResult[0];
            res = [[Org alloc] init];
            
            res.orgId = [dbOrg.orgId copy];
            res.code = [dbOrg.code copy];
            res.name = [dbOrg.name copy];
            res.fullName = [dbOrg.fullName copy];
            res.level = [dbOrg.level integerValue];
            res.parentOrgId = [dbOrg.parentId copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllOrgsOfCurrentProject {
    NSMutableArray* orgArray = [[NSMutableArray alloc] init];
    
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ORG inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBOrg * dbOrg in mutableFetchResult) {
            Org * org = [[Org alloc] init];
            
            org.orgId = [dbOrg.orgId copy];
            org.code = [dbOrg.code copy];
            org.name = [dbOrg.name copy];
            org.fullName = [dbOrg.fullName copy];
            org.level = [dbOrg.level integerValue];
            org.parentOrgId = [dbOrg.parentId copy];
            
            [orgArray addObject:org];
        }
    }
    return orgArray;
}

#pragma mark - Service Type
- (BOOL) isServiceTypeExist:(NSNumber*) stypeId {
    BOOL res = NO;
    if(stypeId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SERVICE_TYPE condition:dict];
    }
    return res;
}

- (BOOL) addServiceType:(ServiceType *) stype projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(stype) {
        DBStype * objData = (DBStype*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        
        [objData setStypeId:stype.serviceTypeId];
        [objData setName:stype.name];
        [objData setFullName:stype.fullName];
        [objData setDesc:stype.stypeDesc];
        [objData setParentId:stype.parentId];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}

- (BOOL) addServiceTypes:(NSArray *) stypeArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(ServiceType * stype in stypeArray) {
        NSNumber * stypeId = stype.serviceTypeId;
        if(stypeId) {
            if([self isServiceTypeExist:stypeId]) {
                res = res && [self updateServiceTypeById:stypeId serviceType:stype];
            } else {
                res = res && [self addServiceType:stype projectId:projectId];
            }
        }
    }
    return res;
}

- (BOOL) deleteServiceTypeById:(NSNumber*) stypeId {
    BOOL res = NO;
    if(stypeId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* stype = [NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:stype];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"stypeId==%@",stypeId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBStype* dStype in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dStype];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteServiceTypeByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* stype=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:stype];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"stypeId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBStype* dStype in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dStype];
        }
        res = [self save];
    }
    return res;
}


//删除当前项目下所有服务类型
- (BOOL) deleteAllServiceTypeOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* stype=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:stype];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBStype* dStype in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dStype];
        }
        res = [self save];
    }
    
    return res;
}


- (BOOL) deleteAllServiceType {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* stype=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:stype];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBStype* dStype in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dStype];
    }
    res = [self save];
    return res;
}

- (BOOL) updateServiceType:(ServiceType*) newStype condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newStype) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBStype* dbStype in mutableFetchResult) {
            dbStype.stypeId = newStype.serviceTypeId;
            dbStype.name =newStype.name;
            dbStype.fullName = newStype.fullName;
            dbStype.desc = newStype.stypeDesc;
            dbStype.parentId = newStype.parentId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateServiceTypeById:(NSNumber*) stypeId serviceType:(ServiceType *) stype {
    BOOL res = NO;
    if(stypeId && stype) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", nil];
        res = [self updateServiceType:stype condition:param];
    }
    return res;
}

- (ServiceType*) queryServiceTypeById:(NSNumber*) stypeId {
    ServiceType* res = nil;
    if(stypeId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* stype=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:stype];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBStype * dbStype = mutableFetchResult[0];
            res = [[ServiceType alloc] init];
            
            res.serviceTypeId = [dbStype.stypeId copy];
            res.stypeDesc = [dbStype.desc copy];
            res.name = [dbStype.name copy];
            res.fullName = [dbStype.fullName copy];
            res.parentId = [dbStype.parentId copy];
        }
    }
    
    return res;
}
- (NSMutableArray*) queryAllServiceTypeOfCurrentProject {
    NSMutableArray* orgArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SERVICE_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBStype * dbStype in mutableFetchResult) {
            ServiceType * stype = [[ServiceType alloc] init];
            
            stype.serviceTypeId = [dbStype.stypeId copy];
            stype.stypeDesc = [dbStype.desc copy];
            stype.name = [dbStype.name copy];
            stype.fullName = [dbStype.fullName copy];
            stype.parentId = [dbStype.parentId copy];
            
            [orgArray addObject:stype];
        }
    }
    return orgArray;
}


#pragma mark - Priority
//优先级---Priority
- (BOOL) isPriorityExist:(NSNumber*) priorityId {
    BOOL res = NO;
    if(priorityId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:priorityId, @"priorityId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_PRIORITY condition:dict];
    }
    return res;
}

- (BOOL) addPriority:(Priority *) priority projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(priority) {
        DBPriority * objData = (DBPriority*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:super.managedObjectContext];
        
        [objData setPriorityId:priority.priorityId];
        [objData setName:priority.name];
        [objData setDesc:priority.desc];
        [objData setColor:priority.color];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}

- (BOOL) addPrioritys:(NSArray *) priorityArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(Priority * priority in priorityArray) {
        NSNumber * priorityId = priority.priorityId;
        if([self isPriorityExist:priorityId]) {
            res = res && [self updatePriorityById:priorityId priority:priority];
        } else {
            res = res && [self addPriority:priority projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deletePriorityById:(NSNumber*) priorityId {
    BOOL res = NO;
    if(priorityId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* priority = [NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:priority];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"priorityId==%@",priorityId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBPriority* dPriority in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dPriority];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deletePriorityByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"priorityId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBPriority* dPriority in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dPriority];
        }
        res = [self save];
    }
    return res;
}

//删除当前项目下所有优先级
- (BOOL) deleteAllPriorityOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBPriority* dPriority in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dPriority];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllPriority {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBPriority* dPriority in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dPriority];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updatePriority:(Priority*) newPriority condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newPriority) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBPriority* dbPriority in mutableFetchResult) {
            dbPriority.priorityId = newPriority.priorityId;
            dbPriority.name =newPriority.name;
            dbPriority.desc = newPriority.desc;
            dbPriority.color = newPriority.color;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updatePriorityById:(NSNumber*) priorityId priority:(Priority *) priority {
    BOOL res = NO;
    if(priorityId && priority) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:priorityId, @"priorityId", nil];
        res = [self updatePriority:priority condition:param];
    }
    return res;
}

- (Priority*) queryPriorityById:(NSNumber*) priorityId {
    Priority* res = nil;
    if(priorityId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* priority=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:priority];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:priorityId, @"priorityId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBPriority * dbPriority = mutableFetchResult[0];
            res = [[Priority alloc] init];
            
            res.priorityId = [dbPriority.priorityId copy];
            res.desc = [dbPriority.desc copy];
            res.name = [dbPriority.name copy];
            res.color = [dbPriority.color copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllPrioritysOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_PRIORITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBPriority * dbPriority in mutableFetchResult) {
            Priority * priority = [[Priority alloc] init];
            
            priority.priorityId = [dbPriority.priorityId copy];
            priority.desc = [dbPriority.desc copy];
            priority.name = [dbPriority.name copy];
            priority.color = [dbPriority.color copy];
            
            [dataArray addObject:priority];
        }
    }
    return dataArray;
}

- (NSMutableArray *) queryAllPriorityByFlow:(NSArray *) flowArray {
    NSMutableArray * dataArray;
    if(flowArray && [flowArray count] > 0) {
        NSMutableArray * ids = [[NSMutableArray alloc] init];
        for(Flow * flow in flowArray) {
            if(![ids containsObject:[flow.priorityId copy]]) {
                [ids addObject:flow.priorityId];
            }
        }
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"priorityId", nil];
        NSMutableArray * tmpArray = [super getDataOfCollection:DB_ENTITY_NAME_PRIORITY andCondition:dict];
        if(tmpArray && [tmpArray count] > 0) {
            dataArray = [[NSMutableArray alloc] init];
            for(DBPriority * dbPriority in tmpArray) {
                Priority * priority = [[Priority alloc] init];
                
                priority.priorityId = [dbPriority.priorityId copy];
                priority.desc = [dbPriority.desc copy];
                priority.name = [dbPriority.name copy];
                priority.color = [dbPriority.color copy];
                
                [dataArray addObject:priority];
            }
        }
    }
    return dataArray;
}

- (NSMutableArray *) queryAllPrioritiesWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andLocation:(Position *) pos andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    NSMutableArray * flowArray = [self queryAllFlowWithServiceType:stypeId andOrg:orgId andLocation:pos andOrderType:type];
    dataArray = [self queryAllPriorityByFlow:flowArray];
    return dataArray;
}

#pragma mark - Flow
//流程---Flow
- (BOOL) isFlowExist:(NSNumber*) flowId {
    BOOL res = NO;
    if(flowId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:flowId, @"flowId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_FLOW condition:dict];
    }
    return res;
}

- (BOOL) addFlow:(Flow *) flow {
    BOOL res = NO;
    if(flow) {
        DBFlow * objData = (DBFlow*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:super.managedObjectContext];
        
        [objData setFlowId:flow.wopId];
        [objData setOrgId:flow.organizationId];
        [objData setStypeId:flow.serviceTypeId];
        [objData setPriorityId:flow.priorityId];
        [objData setCityId:flow.position.cityId];
        [objData setSiteId:flow.position.siteId];
        [objData setBuildingId:flow.position.buildingId];
        [objData setFloorId:flow.position.floorId];
        [objData setRoomId:flow.position.roomId];
        [objData setOrderType:[NSNumber numberWithInteger:flow.type]];
        [objData setNotice:flow.notice];
        [objData setProjectId:flow.projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}

- (BOOL) addFlows:(NSArray *) flowArray {
    BOOL res = YES;
    for(Flow * flow in flowArray) {
        NSNumber * flowId = flow.wopId;
        if([self isFlowExist:flowId]) {
            res = res && [self updateFlowById:flowId flow:flow];
        } else {
            res = res && [self addFlow:flow];
        }
    }
    return res;
}

- (BOOL) deleteFlowById:(NSNumber*) flowId {
    BOOL res = NO;
    if(flowId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* flow = [NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:super.managedObjectContext];
        [request setEntity:flow];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"flowId==%@",flowId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBFlow* dFlow in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFlow];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteFlowByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"flowId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBFlow* dFlow in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFlow];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有流程
- (BOOL) deleteAllFlowOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBFlow* dFlow in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFlow];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllFlow {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBFlow* dFlow in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dFlow];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateFlow:(Flow*) newFlow condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newFlow) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBFlow* dbFlow in mutableFetchResult) {
            dbFlow.flowId = newFlow.wopId;
            dbFlow.orgId =newFlow.organizationId;
            dbFlow.stypeId = newFlow.serviceTypeId;
            dbFlow.priorityId = newFlow.priorityId;
            dbFlow.cityId = newFlow.position.cityId;
            dbFlow.siteId = newFlow.position.siteId;
            dbFlow.buildingId = newFlow.position.buildingId;
            dbFlow.floorId = newFlow.position.floorId;
            dbFlow.roomId = newFlow.position.roomId;
            dbFlow.notice = newFlow.notice;
            dbFlow.orderType = [NSNumber numberWithInteger:newFlow.type];
            dbFlow.projectId = newFlow.projectId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateFlowById:(NSNumber*) flowId flow:(Flow *) flow {
    BOOL res = NO;
    if(flowId && flow) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:flowId, @"flowId", nil];
        res = [self updateFlow:flow condition:param];
    }
    return res;
}

- (NSMutableArray *) queryFlowByCondition:(NSDictionary *) dict {
    NSMutableArray* dataArray ;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* flow=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:self.managedObjectContext];
    [request setEntity:flow];
    
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    
    //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        dataArray = [[NSMutableArray alloc] init];
        for(DBFlow * dbFlow in mutableFetchResult) {
            Flow * flow = [[Flow alloc] init];
            
            flow.wopId = [dbFlow.flowId copy];
            flow.priorityId = [dbFlow.priorityId copy];
            flow.serviceTypeId = [dbFlow.stypeId copy];
            flow.organizationId = [dbFlow.orgId copy];
            flow.position.cityId = [dbFlow.cityId copy];
            flow.position.siteId = [dbFlow.siteId copy];
            flow.position.buildingId = [dbFlow.buildingId copy];
            flow.position.floorId = [dbFlow.floorId copy];
            flow.position.roomId = [dbFlow.roomId copy];
            flow.type = [dbFlow.orderType integerValue];
            flow.notice = [dbFlow.notice copy];
            flow.projectId = [dbFlow.projectId copy];
            
            [dataArray addObject:flow];
        }
        
    }
    return dataArray;
}

- (Flow*) queryFlowById:(NSNumber*) flowId {
    Flow* res = nil;
    if(flowId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* flow=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:self.managedObjectContext];
        [request setEntity:flow];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:flowId, @"flowId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBFlow * dbFlow = mutableFetchResult[0];
            res = [[Flow alloc] init];
            
            res.wopId = [dbFlow.flowId copy];
            res.priorityId = [dbFlow.priorityId copy];
            res.serviceTypeId = [dbFlow.stypeId copy];
            res.organizationId = [dbFlow.orgId copy];
            res.position.cityId = [dbFlow.cityId copy];
            res.position.siteId = [dbFlow.siteId copy];
            res.position.buildingId = [dbFlow.buildingId copy];
            res.position.floorId = [dbFlow.floorId copy];
            res.position.roomId = [dbFlow.roomId copy];
            res.type = [dbFlow.orderType integerValue];
            res.projectId = [dbFlow.projectId copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllFlowsOfCurrentProject {
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOW inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBFlow * dbFlow in mutableFetchResult) {
            Flow * flow = [[Flow alloc] init];
            
            flow.wopId = [dbFlow.flowId copy];
            flow.organizationId = [dbFlow.orgId copy];
            flow.priorityId = [dbFlow.priorityId copy];
            flow.serviceTypeId = [dbFlow.stypeId copy];
            flow.position.cityId = [dbFlow.cityId copy];
            flow.position.siteId = [dbFlow.siteId copy];
            flow.position.buildingId = [dbFlow.buildingId copy];
            flow.position.floorId = [dbFlow.floorId copy];
            flow.position.roomId = [dbFlow.roomId copy];
            flow.type = [dbFlow.orderType integerValue];
            flow.projectId = [dbFlow.projectId copy];
            
            [dataArray addObject:flow];
        }
    }
    return dataArray;
}

/** 查询属于房间的所有流程 **/
- (NSMutableArray *) getAllFlowOfRoomWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andRoom:(NSNumber *) roomId andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    if(stypeId && roomId) {
        NSDictionary * dict;
        NSNumber * orderType = [NSNumber numberWithInteger:type];
        id org;
        if(orgId) {
            org = orgId;
        } else {
            org = [NSNull null];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", org, @"orgId", roomId, @"roomId", orderType, @"orderType",  nil];
        dataArray = [self queryFlowByCondition:dict];
    }
    return dataArray;
}

/** 查询属于楼层的所有流程 **/
- (NSMutableArray *) getAllFlowOfFloorWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andFloor:(NSNumber *) floorId andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    if(stypeId && floorId) {
        NSNumber * orderType = [NSNumber numberWithInteger:type];
        NSDictionary * dict;
        id org;
        if(orgId) {
            org = orgId;
        } else {
            org = [NSNull null];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", org, @"orgId", floorId, @"floorId", [NSNull null], @"roomId", orderType, @"orderType",  nil];
        dataArray = [self queryFlowByCondition:dict];
    }
    return dataArray;
}

/** 查询属于单元的所有流程 **/
- (NSMutableArray *) getAllFlowOfBuildingWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andBuilding:(NSNumber *) buildingId andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    if(stypeId && buildingId) {
        NSNumber * orderType = [NSNumber numberWithInteger:type];
        NSDictionary * dict;
        id org;
        if(orgId) {
            org = orgId;
        } else {
            org = [NSNull null];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", org, @"orgId", buildingId, @"buildingId", [NSNull null], @"floorId", [NSNull null], @"roomId", orderType, @"orderType",  nil];
        dataArray = [self queryFlowByCondition:dict];
    }
    return dataArray;
}


/** 查询属于区域的所有流程 **/
- (NSMutableArray *) getAllFlowOfSiteWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andSite:(NSNumber *) siteId andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    if(stypeId && siteId) {
        NSDictionary * dict;
        NSNumber * orderType = [NSNumber numberWithInteger:type];
        id org;
        if(orgId) {
            org = orgId;
        } else {
            org = [NSNull null];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", org, @"orgId", siteId, @"siteId", [NSNull null], @"buildingId", [NSNull null], @"floorId", [NSNull null], @"roomId", orderType, @"orderType",  nil];
        dataArray = [self queryFlowByCondition:dict];
    }
    return dataArray;
}


/** 查询属于城市的所有流程 **/
- (NSMutableArray *) getAllFlowOfCityWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andCity:(NSNumber *) cityId andOrderType:(NSInteger) type{
    NSMutableArray * dataArray;
    if(stypeId) {
        NSDictionary * dict;
        NSNumber * orderType = [NSNumber numberWithInteger:type];
        id org;
        id city;
        if(orgId && ![orgId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            org = orgId;
        } else {
            org = [NSNull null];
        }
        if(cityId && ![cityId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            city = cityId;
        } else {
            city = [NSNull null];
        }
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:stypeId, @"stypeId", org, @"orgId", city, @"cityId", [NSNull null], @"siteId", [NSNull null], @"buildingId", [NSNull null], @"floorId", [NSNull null], @"roomId", orderType, @"orderType",  nil];
        dataArray = [self queryFlowByCondition:dict];
    }
    return dataArray;
}


/** 依据条件查询流程信息 --- 部门和服务类型固定，按位置查找，如果找不到往上级匹配 **/
- (NSMutableArray *) getAllFlowInPositionWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andLocation:(Position *) pos andOrderType:(NSInteger) type{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSInteger level = [Positions getPositionLevel:pos];
    switch(level) {
        case LEVEL_ROOM:
            dataArray = [self getAllFlowOfRoomWithServiceType:stypeId andOrg:orgId andRoom:pos.roomId andOrderType:type];
            if(!dataArray || [dataArray count] == 0) {  //如果没有匹配到就去找混合类型的
                dataArray = [self getAllFlowOfRoomWithServiceType:stypeId andOrg:orgId andRoom:pos.roomId andOrderType:REPORT_ORDER_TYPE_MIX];
            }
            if(dataArray && [dataArray count] > 0) {
                break;
            }
        case LEVEL_FLOOR:
            dataArray = [self getAllFlowOfFloorWithServiceType:stypeId andOrg:orgId andFloor:pos.floorId andOrderType:type];
            if(!dataArray || [dataArray count] == 0) {  //如果没有匹配到就去找混合类型的
                dataArray = [self getAllFlowOfFloorWithServiceType:stypeId andOrg:orgId andFloor:pos.floorId andOrderType:REPORT_ORDER_TYPE_MIX];
            }
            if(dataArray && [dataArray count] > 0) {
                break;
            }
        case LEVEL_BUILDING:
            dataArray = [self getAllFlowOfBuildingWithServiceType:stypeId andOrg:orgId andBuilding:pos.buildingId andOrderType:type];
            if(!dataArray || [dataArray count] == 0) {  //如果没有匹配到就去找混合类型的
                dataArray = [self getAllFlowOfBuildingWithServiceType:stypeId andOrg:orgId andBuilding:pos.buildingId andOrderType:REPORT_ORDER_TYPE_MIX];
            }
            if(dataArray && [dataArray count] > 0) {
                break;
            }
        case LEVEL_SITE:
            dataArray = [self getAllFlowOfSiteWithServiceType:stypeId andOrg:orgId andSite:pos.siteId andOrderType:type];
            if(!dataArray || [dataArray count] == 0) {  //如果没有匹配到就去找混合类型的
                dataArray = [self getAllFlowOfSiteWithServiceType:stypeId andOrg:orgId andSite:pos.siteId andOrderType:REPORT_ORDER_TYPE_MIX];
            }
            if(dataArray && [dataArray count] > 0) {
                break;
            }
        case LEVEL_CITY:
            dataArray = [self getAllFlowOfCityWithServiceType:stypeId andOrg:orgId andCity:pos.cityId andOrderType:type];
            if(!dataArray || [dataArray count] == 0) {  //如果没有匹配到就去找混合类型的
                dataArray = [self getAllFlowOfCityWithServiceType:stypeId andOrg:orgId andCity:pos.cityId andOrderType:REPORT_ORDER_TYPE_MIX];
            }
            if(dataArray && [dataArray count] > 0) {
                break;
            }
    }
    return dataArray;
}

//查询满足条件的所有流程
- (NSMutableArray *) queryAllFlowWithServiceType:(NSNumber *) stypeId andOrg:(NSNumber *) orgId andLocation:(Position *) pos andOrderType:(NSInteger)type{
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * curOrgId = [orgId copy];
    while(true) {
        dataArray = [self getAllFlowInPositionWithServiceType:stypeId andOrg:curOrgId andLocation:pos andOrderType:type];
        if(dataArray && [dataArray count] > 0) {
            break;
        }
        Org * org = [self queryOrgById:curOrgId];
        if(!org) {
            break;
        }
        curOrgId = [org.parentOrgId copy];
    }
    return dataArray;
}

#pragma mark - Device
//设备---Device
- (BOOL) isDeviceExist:(NSNumber*) deviceId {
    BOOL res = NO;
    if(deviceId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:deviceId, @"deviceId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_DEVICE condition:dict];
    }
    return res;
}

- (BOOL) addDevice:(Device *) device {
    BOOL res = NO;
    if(device) {
        DBDevice * objData = (DBDevice*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:super.managedObjectContext];
        
        [objData setDeviceId:device.eqId];
        [objData setCode:device.code];
        [objData setDeviceTypeId:device.equSystem];
        [objData setName:device.name];
        [objData setQrcode:device.qrcode];
        [objData setCityId:device.position.siteId];
        [objData setSiteId:device.position.siteId];
        [objData setBuildingId:device.position.buildingId];
        [objData setFloorId:device.position.floorId];
        [objData setRoomId:device.position.roomId];
        [objData setProjectId:device.projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}

- (BOOL) addDevices:(NSArray *) deviceArray {
    BOOL res = YES;
    for(Device * device in deviceArray) {
        NSNumber * deviceId = device.eqId;
        if([self isDeviceExist:deviceId]) {
            res = res && [self updateDeviceById:deviceId device:device];
        } else {
            res = res && [self addDevice:device];
        }
    }
    return res;
}

- (BOOL) deleteDeviceById:(NSNumber*) deviceId {
    BOOL res = NO;
    if(deviceId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* device = [NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:device];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"deviceId==%@",deviceId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBDevice* dDevice in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDevice];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteDeviceByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"deviceId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBDevice* dDevice in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDevice];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有设备信息
- (BOOL) deleteAllDevicesOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBDevice* dDevice in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDevice];
        }
        
        res = [self save];
    }
    
    return res;
}

- (BOOL) deleteAllDevices {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBDevice* dDevice in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dDevice];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateDevice:(Device*) newDevice condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newDevice) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBDevice* dbDevice in mutableFetchResult) {
            dbDevice.deviceId = newDevice.eqId;
            dbDevice.deviceTypeId =newDevice.equSystem;
            dbDevice.code = newDevice.code;
            dbDevice.name = newDevice.name;
            dbDevice.qrcode = newDevice.qrcode;
            dbDevice.cityId = newDevice.position.cityId;
            dbDevice.siteId = newDevice.position.siteId;
            dbDevice.buildingId = newDevice.position.buildingId;
            dbDevice.floorId = newDevice.position.floorId;
            dbDevice.roomId = newDevice.position.roomId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateDeviceById:(NSNumber*) deviceId device:(Device *) device {
    BOOL res = NO;
    if(deviceId && device) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:deviceId, @"deviceId", nil];
        res = [self updateDevice:device condition:param];
    }
    return res;
}

- (Device*) queryDeviceById:(NSNumber*) deviceId {
    Device* res = nil;
    if(deviceId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* device=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:device];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:deviceId, @"deviceId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBDevice * dbDevice = mutableFetchResult[0];
            res = [[Device alloc] init];
            
            res.eqId = [dbDevice.deviceId copy];
            res.name = [dbDevice.name copy];
            res.code = [dbDevice.code copy];
            res.equSystem = [dbDevice.deviceTypeId copy];
            res.qrcode = [dbDevice.qrcode copy];
            res.position.cityId = [dbDevice.cityId copy];
            res.position.siteId = [dbDevice.siteId copy];
            res.position.buildingId = [dbDevice.buildingId copy];
            res.position.floorId = [dbDevice.floorId copy];
            res.position.roomId = [dbDevice.roomId copy];
        }
    }
    return res;
}

- (Device*) queryDeviceByCode:(NSString*) code {
    Device* res = nil;
    if(code) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* device=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:device];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:code, @"code", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBDevice * dbDevice = mutableFetchResult[0];
            res = [[Device alloc] init];
            
            res.eqId = [dbDevice.deviceId copy];
            res.name = [dbDevice.name copy];
            res.code = [dbDevice.code copy];
            res.equSystem = [dbDevice.deviceTypeId copy];
            res.qrcode = [dbDevice.qrcode copy];
            res.position.cityId = [dbDevice.cityId copy];
            res.position.siteId = [dbDevice.siteId copy];
            res.position.buildingId = [dbDevice.buildingId copy];
            res.position.floorId = [dbDevice.floorId copy];
            res.position.roomId = [dbDevice.roomId copy];
        }
    }
    return res;
}

- (NSMutableArray*) queryAllDevicesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBDevice * dbDevice in mutableFetchResult) {
            Device * device = [[Device alloc] init];
            
            device.eqId = [dbDevice.deviceId copy];
            device.name = [dbDevice.name copy];
            device.code = [dbDevice.code copy];
            device.equSystem = [dbDevice.deviceTypeId copy];
            device.qrcode = [dbDevice.qrcode copy];
            device.position.cityId = [dbDevice.cityId copy];
            device.position.siteId = [dbDevice.siteId copy];
            device.position.buildingId = [dbDevice.buildingId copy];
            device.position.floorId = [dbDevice.floorId copy];
            device.position.roomId = [dbDevice.roomId copy];
            
            [dataArray addObject:device];
        }
    }
    return dataArray;
}

- (NSMutableArray*) queryAllDevicesByPosition:(Position *) pos {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    PositionLevelType level = [Positions getPositionLevel:pos];
    for(DBDevice * dbDevice in mutableFetchResult) {
        BOOL isOK = NO;
        if(pos) {
            switch(level) {
                case LEVEL_ROOM:
                    if(dbDevice.roomId && [dbDevice.roomId isEqualToNumber:pos.roomId]) {
                        isOK = YES;
                    }
                    break;
                case LEVEL_FLOOR:
                    if(dbDevice.floorId && [dbDevice.floorId isEqualToNumber:pos.floorId]) {
                        isOK = YES;
                    }
                    break;
                case LEVEL_BUILDING:
                    if(dbDevice.buildingId && [dbDevice.buildingId isEqualToNumber:pos.buildingId]) {
                        isOK = YES;
                    }
                    break;
                case LEVEL_SITE:
                    if(dbDevice.siteId && [dbDevice.siteId isEqualToNumber:pos.siteId]) {
                        isOK = YES;
                    }
                    break;
                case LEVEL_CITY:
                    isOK = YES;
                    break;
            }
        }
        if(!isOK) {
            continue;
        }
        Device * device = [[Device alloc] init];
        
        device.eqId = [dbDevice.deviceId copy];
        device.name = [dbDevice.name copy];
        device.code = [dbDevice.code copy];
        device.equSystem = [dbDevice.deviceTypeId copy];
        device.qrcode = [dbDevice.qrcode copy];
        device.position.cityId = [dbDevice.cityId copy];
        device.position.siteId = [dbDevice.siteId copy];
        device.position.buildingId = [dbDevice.buildingId copy];
        device.position.floorId = [dbDevice.floorId copy];
        device.position.roomId = [dbDevice.roomId copy];
        
        [dataArray addObject:device];
    }
    return dataArray;
}

#pragma mark - Device Type
//设备类型---DeviceType
- (BOOL) isDeviceTypeExist:(NSNumber*) deviceTypeId {
    BOOL res = NO;
    if(deviceTypeId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:deviceTypeId, @"deviceTypeId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_DEVICE_TYPE condition:dict];
    }
    return res;
}

- (BOOL) addDeviceType:(DeviceType *) deviceType projectId:(NSNumber *)projectId{
    BOOL res = NO;
    if(deviceType) {
        DBDeviceType * objData = (DBDeviceType*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        
        [objData setDeviceTypeId:deviceType.equSysId];
        [objData setCode:deviceType.equSysCode];
        [objData setName:deviceType.equSysName];
        [objData setDesc:deviceType.equSysDescription];
        [objData setFullName:deviceType.equSysFullName];
        [objData setLevel:[NSNumber numberWithInteger:deviceType.level]];
        [objData setParentId:deviceType.equSysParentSystemId];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addDeviceTypes:(NSArray *) deviceTypeArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(DeviceType * deviceType in deviceTypeArray) {
        NSNumber * deviceTypeId = deviceType.equSysId;
        if([self isDeviceTypeExist:deviceTypeId]) {
            res = res && [self updateDeviceTypeById:deviceTypeId deviceType:deviceType];
        } else {
            res = res && [self addDeviceType:deviceType projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteDeviceTypeById:(NSNumber*) deviceTypeId {
    BOOL res = NO;
    if(deviceTypeId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* deviceType = [NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:deviceType];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"deviceTypeId==%@",deviceTypeId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBDeviceType* dDeviceType in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDeviceType];
        }
        
        res = [self save];
    }
    return res;
}
//依据 ID 批量删除
- (BOOL) deleteDeviceTypeByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"deviceTypeId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBDeviceType* dDeviceType in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDeviceType];
        }
        
        res = [self save];
    }
    return res;
}
//删除当前项目下所有设备类型
- (BOOL) deleteAllDeviceTypeOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBDeviceType* dDeviceType in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dDeviceType];
        }
        
        res = [self save];
    }
    return res;
}


- (BOOL) deleteAllDeviceType {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBDeviceType* dDeviceType in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dDeviceType];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateDeviceType:(DeviceType*) newDeviceType condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newDeviceType) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:self.managedObjectContext];
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
        for (DBDeviceType* dbDeviceType in mutableFetchResult) {
            dbDeviceType.deviceTypeId = newDeviceType.equSysId;
            dbDeviceType.code = newDeviceType.equSysCode;
            dbDeviceType.desc = newDeviceType.equSysDescription;
            dbDeviceType.name = newDeviceType.equSysName;
            dbDeviceType.fullName = newDeviceType.equSysFullName;
            dbDeviceType.level = [NSNumber numberWithInteger:newDeviceType.level];
            dbDeviceType.parentId = newDeviceType.equSysParentSystemId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateDeviceTypeById:(NSNumber*) deviceTypeId deviceType:(DeviceType *) deviceType {
    BOOL res = NO;
    if(deviceTypeId && deviceType) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:deviceTypeId, @"deviceTypeId", nil];
        res = [self updateDeviceType:deviceType condition:param];
    }
    return res;
}

- (DeviceType*) queryDeviceTypeById:(NSNumber*) deviceTypeId {
    DeviceType* res = nil;
    if(deviceTypeId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* deviceType=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:deviceType];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:deviceTypeId, @"deviceTypeId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBDeviceType * dbDeviceType = mutableFetchResult[0];
            res = [[DeviceType alloc] init];
            
            res.equSysId = [dbDeviceType.deviceTypeId copy];
            res.equSysName = [dbDeviceType.name copy];
            res.equSysCode = [dbDeviceType.code copy];
            res.equSysDescription = [dbDeviceType.desc copy];
            res.equSysFullName = [dbDeviceType.fullName copy];
            res.level = [dbDeviceType.level integerValue];
            res.equSysParentSystemId = [dbDeviceType.parentId copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllDeviceTypesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DEVICE_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBDeviceType * dbDeviceType in mutableFetchResult) {
            DeviceType * deviceType = [[DeviceType alloc] init];
            
            deviceType.equSysId = [dbDeviceType.deviceTypeId copy];
            deviceType.equSysName = [dbDeviceType.name copy];
            deviceType.equSysCode = [dbDeviceType.code copy];
            deviceType.equSysDescription = [dbDeviceType.desc copy];
            deviceType.equSysFullName = [dbDeviceType.fullName copy];
            deviceType.level = [dbDeviceType.level integerValue];
            deviceType.equSysParentSystemId = [dbDeviceType.parentId copy];
            
            [dataArray addObject:deviceType];
        }
    }
    return dataArray;
}


#pragma mark - City
//城市---City
- (BOOL) isCityExist:(NSNumber*) cityId {
    BOOL res = NO;
    if(cityId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:cityId, @"cityId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_CITY condition:dict];
    }
    return res;
}

- (BOOL) addCity:(City *) city projectId:(NSNumber *) projectId {
    BOOL res = NO;
    if(city) {
        DBCity * objData = (DBCity*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:super.managedObjectContext];
        
        [objData setCityId:city.cityId];
        [objData setName:city.name];
        [objData setTimeZone:city.timezoneId];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addCities:(NSArray *) cityArray projectId:(NSNumber *) projectId {
    BOOL res = YES;
    for(City * city in cityArray) {
        NSNumber * cityId = city.cityId;
        if([self isCityExist:cityId]) {
            res = res && [self updateCityById:cityId city:city];
        } else {
            res = res && [self addCity:city projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteCityById:(NSNumber*) cityId {
    BOOL res = NO;
    if(cityId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* city = [NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:city];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"cityId==%@",cityId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBCity* dCity in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dCity];
        }
        
        res = [self save];
    }
    return res;
}
//依据 ID 批量删除
- (BOOL) deleteCityByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"cityId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBCity* dCity in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dCity];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有城市
- (BOOL) deleteAllCitiesOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBCity* dCity in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dCity];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllCities {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBCity* dCity in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dCity];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateCity:(City*) newCity condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newCity) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBCity* dbCity in mutableFetchResult) {
            dbCity.cityId = newCity.cityId;
            dbCity.name = newCity.name;
            dbCity.timeZone = newCity.timezoneId;
            
        }
        res = [self save];
    }
    return res;
}

- (BOOL) updateCityById:(NSNumber*) cityId city:(City *) city {
    BOOL res = NO;
    if(cityId && city) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:cityId, @"cityId", nil];
        res = [self updateCity:city condition:param];
    }
    return res;
}

- (City*) queryCityById:(NSNumber*) cityId {
    City* res = nil;
    if(cityId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* city=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:city];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:cityId, @"cityId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBCity * dbCity = mutableFetchResult[0];
            res = [[City alloc] init];
            
            res.cityId = [dbCity.cityId copy];
            res.name = [dbCity.name copy];
            res.timezoneId = [dbCity.timeZone copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllCitiesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_CITY inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBCity * dbCity in mutableFetchResult) {
            City * city = [[City alloc] init];
            
            city.cityId = [dbCity.cityId copy];
            city.name = [dbCity.name copy];
            city.timezoneId = [dbCity.timeZone copy];
            
            [dataArray addObject:city];
        }
    }
    return dataArray;
}

#pragma mark - Site
//区域---Site
- (BOOL) isSiteExist:(NSNumber*) siteId {
    BOOL res = NO;
    if(siteId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:siteId, @"siteId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SITE condition:dict];
    }
    return res;
    
}

- (BOOL) addSite:(Site *) site projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(site) {
        DBSite * objData = (DBSite*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:super.managedObjectContext];
        
        [objData setSiteId:site.siteId];
        [objData setCode:site.code];
        [objData setName:site.name];
        [objData setCityId:site.cityId];
        [objData setProjectId:projectId];
        
        res = [self save];
    }
    return res;
    
}

- (BOOL) addSites:(NSArray *) siteArray projectId:(NSNumber *)projectId{
    BOOL res = YES;
    for(Site * site in siteArray) {
        NSNumber * siteId = site.siteId;
        if([self isSiteExist:siteId]) {
            res = res && [self updateSiteById:siteId site:site];
        } else {
            res = res && [self addSite:site projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteSiteById:(NSNumber*) siteId {
    BOOL res = NO;
    if(siteId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* site = [NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:site];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"siteId==%@",siteId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSite* dSite in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dSite];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteSiteByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"siteId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBSite* dSite in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dSite];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有区域信息
- (BOOL) deleteAllSitesOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBSite* dSite in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dSite];
        }
        
        res = [self save];
    }
    
    return res;
}

- (BOOL) deleteAllSites {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBSite* dSite in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dSite];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateSite:(Site*) newSite condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newSite) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBSite* dbSite in mutableFetchResult) {
            dbSite.siteId = newSite.siteId;
            dbSite.cityId = newSite.cityId;
            dbSite.name = newSite.name;
            dbSite.code = newSite.code;
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateSiteById:(NSNumber*) siteId site:(Site *) site {
    BOOL res = NO;
    if(siteId && site) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:siteId, @"siteId", nil];
        res = [self updateSite:site condition:param];
    }
    return res;
}

- (Site*) querySiteById:(NSNumber*) siteId {
    Site* res = nil;
    if(siteId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* site=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:site];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:siteId, @"siteId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBSite * dbSite = mutableFetchResult[0];
            res = [[Site alloc] init];
            
            res.siteId = [dbSite.siteId copy];
            res.cityId = [dbSite.cityId copy];
            res.name = [dbSite.name copy];
            res.code = [dbSite.code copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllSitesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SITE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBSite * dbSite in mutableFetchResult) {
            Site * site = [[Site alloc] init];
            
            site.siteId = [dbSite.siteId copy];
            site.cityId = [dbSite.cityId copy];
            site.name = [dbSite.name copy];
            site.code = [dbSite.code copy];
            
            [dataArray addObject:site];
        }
    }
    return dataArray;
}

#pragma mark - Building
//建筑---Building
- (BOOL) isBuildingExist:(NSNumber*) buildingId {
    BOOL res = NO;
    if(buildingId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:buildingId, @"buildingId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_BUILDING condition:dict];
    }
    return res;
    
}

- (BOOL) addBuilding:(Building *) building projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(building) {
        DBBuilding * objData = (DBBuilding*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:super.managedObjectContext];
        
        [objData setBuildingId:building.buildingId];
        [objData setSiteId:building.siteId];
        [objData setCode:building.code];
        [objData setName:building.name];
        [objData setProjectId:projectId];
        [objData setFullName:building.fullName];
        [objData setType:[NSNumber numberWithInteger:building.type]];
        [objData setRelatedBuildingId:building.relatedBuildingId];
        [objData setIsThisStation:[NSNumber numberWithBool:building.isThisStation]];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addBuildings:(NSArray *) buildingArray projectId:(NSNumber *)projectId{
    BOOL res = YES;
    for(Building * building in buildingArray) {
        NSNumber * buildingId = building.buildingId;
        if([self isBuildingExist:buildingId]) {
            res = res && [self updateBuildingById:buildingId building:building];
        } else {
            res = res && [self addBuilding:building projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteBuildingById:(NSNumber*) buildingId {
    BOOL res = NO;
    if(buildingId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* building = [NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:super.managedObjectContext];
        [request setEntity:building];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"buildingId==%@",buildingId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBBuilding* dBuilding in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dBuilding];
        }
        
        res = [self save];
    }
    return res;
}

//依据 ID 批量删除
- (BOOL) deleteBuildingByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"buildingId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBBuilding* dBuilding in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dBuilding];
        }
        
        res = [self save];
    }
    return res;
}
//删除当前项目下所有单元信息
- (BOOL) deleteAllBuildingsOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBBuilding* dBuilding in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dBuilding];
        }
        
        res = [self save];
    }
    
    return res;
}

- (BOOL) deleteAllBuildings {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBBuilding* dBuilding in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dBuilding];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateBuilding:(Building*) newBuilding condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newBuilding) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:self.managedObjectContext];
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
        for (DBBuilding* dbBuilding in mutableFetchResult) {
            dbBuilding.buildingId = newBuilding.buildingId;
            dbBuilding.siteId = newBuilding.siteId;
            dbBuilding.name = newBuilding.name;
            dbBuilding.code = newBuilding.code;
            
            dbBuilding.fullName = newBuilding.fullName;
            dbBuilding.type = [NSNumber numberWithInteger:newBuilding.type];
            dbBuilding.relatedBuildingId = newBuilding.relatedBuildingId;
            dbBuilding.projectId = newBuilding.projectId;
            dbBuilding.isThisStation = [NSNumber numberWithBool:newBuilding.isThisStation];
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateBuildingById:(NSNumber*) buildingId building:(Building *) building {
    BOOL res = NO;
    if(buildingId && building) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:buildingId, @"buildingId", nil];
        res = [self updateBuilding:building condition:param];
    }
    return res;
}

- (Building*) queryBuildingById:(NSNumber*) buildingId {
    Building* res = nil;
    if(buildingId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* building=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:self.managedObjectContext];
        [request setEntity:building];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:buildingId, @"buildingId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBBuilding * dbBuilding = mutableFetchResult[0];
            res = [[Building alloc] init];
            
            res.buildingId = [dbBuilding.buildingId copy];
            res.siteId = [dbBuilding.siteId copy];
            res.name = [dbBuilding.name copy];
            res.code = [dbBuilding.code copy];
            res.fullName = [dbBuilding.fullName copy];
            res.type = dbBuilding.type.integerValue;
            res.relatedBuildingId = [dbBuilding.relatedBuildingId copy];
            res.projectId = [dbBuilding.projectId copy];
            res.isThisStation = dbBuilding.isThisStation.boolValue;
        }
    }
    return res;
}
- (NSMutableArray*) queryAllBuildingsOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_BUILDING inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBBuilding * dbBuilding in mutableFetchResult) {
            Building * building = [[Building alloc] init];
            
            building.buildingId = [dbBuilding.buildingId copy];
            building.siteId = [dbBuilding.siteId copy];
            building.name = [dbBuilding.name copy];
            building.code = [dbBuilding.code copy];
            building.fullName = [dbBuilding.fullName copy];
            building.type = dbBuilding.type.integerValue;
            building.relatedBuildingId = [dbBuilding.relatedBuildingId copy];
            building.projectId = [dbBuilding.projectId copy];
            building.isThisStation = dbBuilding.isThisStation.boolValue;
            
            [dataArray addObject:building];
        }
    }
    return dataArray;
}

#pragma mark - Floor
//楼层---Floor
- (BOOL) isFloorExist:(NSNumber*) floorId {
    BOOL res = NO;
    if(floorId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:floorId, @"floorId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_FLOOR condition:dict];
    }
    return res;
    
}

- (BOOL) addFloor:(Floor *) floor projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(floor) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        DBFloor * objData = (DBFloor*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:super.managedObjectContext];
        
        [objData setFloorId:floor.floorId];
        [objData setBuildingId:floor.buildingId];
        [objData setCode:floor.code];
        [objData setName:floor.name];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addFloors:(NSArray *) floorArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(Floor * floor in floorArray) {
        NSNumber * floorId = floor.floorId;
        if([self isFloorExist:floorId]) {
            res = res && [self updateFloorById:floorId floor:floor];
        } else {
            res = res && [self addFloor:floor projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteFloorById:(NSNumber*) floorId {
    BOOL res = NO;
    if(floorId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* floor = [NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:super.managedObjectContext];
        [request setEntity:floor];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"floorId==%@",floorId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBFloor* dFloor in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFloor];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteFloorByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"floorId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBFloor* dFloor in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFloor];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有楼层信息
- (BOOL) deleteAllFloorOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBFloor* dFloor in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dFloor];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllFloor {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBFloor* dFloor in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dFloor];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateFloor:(Floor*) newFloor condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newFloor) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBFloor* dbFloor in mutableFetchResult) {
            dbFloor.floorId = newFloor.floorId;
            dbFloor.buildingId = newFloor.buildingId;
            dbFloor.name = newFloor.name;
            dbFloor.code = newFloor.code;
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateFloorById:(NSNumber*) floorId floor:(Floor *) floor {
    BOOL res = NO;
    if(floorId && floor) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:floorId, @"floorId", nil];
        res = [self updateFloor:floor condition:param];
    }
    return res;
}

- (Floor*) queryFloorById:(NSNumber*) floorId {
    Floor* res = nil;
    if(floorId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* floor=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:self.managedObjectContext];
        [request setEntity:floor];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:floorId, @"floorId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBFloor * dbFloor = mutableFetchResult[0];
            res = [[Floor alloc] init];
            
            res.floorId = [dbFloor.floorId copy];
            res.buildingId = [dbFloor.buildingId copy];
            res.name = [dbFloor.name copy];
            res.code = [dbFloor.code copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllFloorsOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FLOOR inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBFloor * dbFloor in mutableFetchResult) {
            Floor * floor = [[Floor alloc] init];
            
            floor.floorId = [dbFloor.floorId copy];
            floor.buildingId = [dbFloor.buildingId copy];
            floor.name = [dbFloor.name copy];
            floor.code = [dbFloor.code copy];
            
            [dataArray addObject:floor];
        }
    }
    return dataArray;
}

#pragma mark - Room
//房间---Room
- (BOOL) isRoomExist:(NSNumber*) roomId {
    BOOL res = NO;
    if(roomId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:roomId, @"roomId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_ROOM condition:dict];
    }
    return res;
    
}

- (BOOL) addRoom:(Room *) room projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(room) {
        DBRoom * objData = (DBRoom*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:super.managedObjectContext];
        
        [objData setRoomId:room.roomId];
        [objData setFloorId:room.floorId];
        [objData setCode:room.code];
        [objData setName:room.name];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addRooms:(NSArray *) roomArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(Room * room in roomArray) {
        NSNumber * roomId = room.roomId;
        if([self isRoomExist:roomId]) {
            res = res && [self updateRoomById:roomId room:room];
        } else {
            res = res && [self addRoom:room projectId:projectId];
        }
    }
    return res;
}


- (BOOL) deleteRoomById:(NSNumber*) roomId {
    BOOL res = NO;
    if(roomId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* room = [NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:super.managedObjectContext];
        [request setEntity:room];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"roomId==%@",roomId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBRoom* dRoom in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dRoom];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteRoomByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"roomId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBRoom* dRoom in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dRoom];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下的所有房间信息
- (BOOL) deleteAllRoomOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBRoom* dRoom in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dRoom];
        }
        
        res = [self save];
    }
    
    return res;
}

- (BOOL) deleteAllRoom {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBRoom* dRoom in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dRoom];
    }
    
    res = [self save];
    return res;
}

- (BOOL) updateRoom:(Room*) newRoom condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newRoom) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:self.managedObjectContext];
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
        for (DBRoom* dbRoom in mutableFetchResult) {
            dbRoom.roomId = newRoom.roomId;
            dbRoom.floorId = newRoom.floorId;
            dbRoom.name = newRoom.name;
            dbRoom.code = newRoom.code;
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateRoomById:(NSNumber*) roomId room:(Room *) room {
    BOOL res = NO;
    if(roomId) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:roomId, @"roomId", nil];
        res = [self updateRoom:room condition:param];
    }
    return res;
}

- (Room*) queryRoomById:(NSNumber*) roomId {
    Room* res = nil;
    if(roomId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* room = [NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:self.managedObjectContext];
        [request setEntity:room];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:roomId, @"roomId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBRoom * dbRoom = mutableFetchResult[0];
            res = [[Room alloc] init];
            
            res.roomId = [dbRoom.roomId copy];
            res.floorId = [dbRoom.floorId copy];
            res.name = [dbRoom.name copy];
            res.code = [dbRoom.code copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllRoomsOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_ROOM inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBRoom * dbRoom in mutableFetchResult) {
            Room * room = [[Room alloc] init];
            
            room.roomId = [dbRoom.roomId copy];
            room.floorId = [dbRoom.floorId copy];
            room.name = [dbRoom.name copy];
            room.code = [dbRoom.code copy];
            
            [dataArray addObject:room];
        }
    }
    return dataArray;
}

- (NSString *) getLocationBy:(Position *) pos {
    NSString * res;
    PositionLevelType level = [Positions getPositionLevel:pos];
    NSNumber * cityId = pos.cityId;
    NSNumber * siteId = pos.siteId;
    NSNumber * buildingId = pos.buildingId;
    NSNumber * floorId = pos.floorId;
    NSNumber * roomId = pos.roomId;
    Room * room;
    Floor * floor;
    Building * building;
    Site * site;
    City * city;
    NSString * cityName = @"";
    NSString * siteName = @"";
    NSString * buildingName = @"";
    NSString * floorName = @"";
    NSString * roomName = @"";
    
    NSString * sepRoom = @"";
    NSString * sepFloor = @"";
    NSString * sepBuilding = @"";
    NSString * sepSite = @"";
    
    switch(level) {
        case LEVEL_ROOM:
            room = [self queryRoomById:roomId];
            floorId = room.floorId;
            if(room) {
                roomName = room.name;
            }
        case LEVEL_FLOOR:
            floor = [self queryFloorById:floorId];
            buildingId = floor.buildingId;
            if(floor) {
                floorName = floor.name;
                if(room) {
                    sepRoom = @"/";
                }
            }
        case LEVEL_BUILDING:
            building = [self queryBuildingById:buildingId];
            siteId = building.siteId;
            if(building) {
                buildingName = building.name;
                if(floor) {
                    sepFloor = @"/";
                }
                
            }
        case LEVEL_SITE:
            site = [self querySiteById:siteId];
            cityId = site.cityId;
            if(site) {
                siteName = site.name;
                if(building) {
                    sepBuilding = @"/";
                }
                
            }
        case LEVEL_CITY:
            city = [self queryCityById:cityId];
            if(city) {
                cityName = city.name;
                if(site) {
                    sepSite = @"/";
                }
            }
            break;
        default:
            break;
    }
    res = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@", cityName, sepSite, siteName, sepBuilding, buildingName, sepFloor, floorName, sepRoom, roomName];
    return res;
}

//获取默认位置
- (Position *) getDefaultPosition {
    Position * pos = nil;
    NSMutableArray * sites = [self queryAllSitesOfCurrentProject];
    if(sites && [sites count] > 0) {
        pos = [[Position alloc] init];
        DBSite * dbSite = sites[0];
        pos.siteId = [dbSite.siteId copy];
    }
    return pos;
}

#pragma mark - RequirementType
//获取一个可用 ID
- (NSNumber *) getAnAvaliableRequirementId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_REQUIREMENT_TYPE andKey:@"recordId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isRequirementTypeExist:(NSNumber*) typeId {
    BOOL res = NO;
    if(typeId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"typeId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_REQUIREMENT_TYPE condition:dict];
    }
    return res;
    
}

- (BOOL) addRequirementType:(RequirementType *) type projectId:(NSNumber *)projectId {
    BOOL res = NO;
    if(type) {
        DBRequirementType * objData = (DBRequirementType*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * recordId = [self getAnAvaliableRequirementId];
        [objData setRecordId:recordId];
        [objData setTypeId:type.typeId];
        [objData setParentTypeId:type.parentTypeId];
        [objData setName:type.name];
        [objData setFullName:type.fullName];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addRequirementTypes:(NSArray *) array projectId:(NSNumber *)projectId{
    BOOL res = YES;
    for(RequirementType * type in array) {
        NSNumber * typeId = type.typeId;
        if([self isRequirementTypeExist:typeId]) {
            res = res && [self updateRequirementTypeById:typeId requirementType:type];
        } else {
            res = res && [self addRequirementType:type projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteRequirementTypeById:(NSNumber*) typeId {
    BOOL res = NO;
    if(typeId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"typeId==%@",typeId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBRequirementType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        res = [self save];
        if (res) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//依据 ID 批量删除
- (BOOL) deleteRequirementTypeByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"typeId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBRequirementType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下所有需求类型信息
- (BOOL) deleteAllRequirementTypeOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBRequirementType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        
        res = [self save];
    }
    
    return res;
}

- (BOOL) deleteAllRequirementType {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBRequirementType* type in mutableFetchResult) {
        [self.managedObjectContext deleteObject:type];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateRequirementType:(RequirementType*) newRequirementType condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newRequirementType) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:self.managedObjectContext];
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
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        //更新age后要进行保存，否则没更新
        for (DBRequirementType* dbType in mutableFetchResult) {
            dbType.typeId = newRequirementType.typeId;
            dbType.parentTypeId = newRequirementType.parentTypeId;
            dbType.name = newRequirementType.name;
            dbType.fullName = newRequirementType.fullName;
            dbType.projectId = projectId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateRequirementTypeById:(NSNumber*) typeId requirementType:(RequirementType *) type {
    BOOL res = NO;
    if(typeId && type) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"typeId", nil];
        res = [self updateRequirementType:type condition:param];
    }
    return res;
}

- (RequirementType*) queryRequirementTypeById:(NSNumber*) typeId {
    RequirementType* res = nil;
    if(typeId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"typeId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBRequirementType * dbType = mutableFetchResult[0];
            res = [[RequirementType alloc] init];
            
            res.typeId = [dbType.typeId copy];
            res.parentTypeId = [dbType.parentTypeId copy];
            res.name = [dbType.name copy];
            res.fullName = [dbType.fullName copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllRequirementTypesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REQUIREMENT_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBRequirementType * dbType in mutableFetchResult) {
            RequirementType * type = [[RequirementType alloc] init];
            
            
            type.typeId = [dbType.typeId copy];
            type.parentTypeId = [dbType.parentTypeId copy];
            type.name = [dbType.name copy];
            type.fullName = [dbType.fullName copy];
            
            [dataArray addObject:type];
        }
    }
    return dataArray;
}

#pragma mark - 满意度类型
//获取一个可用 ID
- (NSNumber *) getAnAvaliableSatisfactionId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_SATISFACTION_TYPE andKey:@"recordId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isSatisfactionTypeExist:(NSNumber*) typeId {
    BOOL res = NO;
    if(typeId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"sdId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SATISFACTION_TYPE condition:dict];
    }
    return res;
    
}

- (BOOL) addSatisfactionType:(SatisfactionType *) type projectId:(NSNumber *)projectId{
    BOOL res = NO;
    if(type) {
        DBSatisfactionType * objData = (DBSatisfactionType*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * recordId = [self getAnAvaliableSatisfactionId];
        
        [objData setRecordId:recordId];
        [objData setSdId:type.sdId];
        [objData setDegree:type.degree];
        [objData setSdValue:type.sdValue];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
    
}

- (BOOL) addSatisfactionTypes:(NSArray *) array projectId:(NSNumber *)projectId{
    BOOL res = YES;
    for(SatisfactionType * type in array) {
        NSNumber * typeId = type.sdId;
        if([self isSatisfactionTypeExist:typeId]) {
            res = res && [self updateSatisfactionTypeById:typeId satisfactionType:type];
        } else {
            res = res && [self addSatisfactionType:type projectId:projectId];
        }
    }
    return res;
}

- (BOOL) deleteSatisfactionTypeById:(NSNumber*) typeId {
    BOOL res = NO;
    if(typeId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"sdId==%@",typeId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSatisfactionType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        res = [self save];
        if (res) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//依据 ID 批量删除
- (BOOL) deleteSatisfactionTypeByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"sdId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBSatisfactionType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下的所有满意度信息
- (BOOL) deleteAllSatisfactionTypeOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBSatisfactionType* type in mutableFetchResult) {
            [self.managedObjectContext deleteObject:type];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllSatisfactionType {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBSatisfactionType* type in mutableFetchResult) {
        [self.managedObjectContext deleteObject:type];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateSatisfactionType:(SatisfactionType*) newSatisfactionType condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newSatisfactionType) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        //更新age后要进行保存，否则没更新
        for (DBSatisfactionType* dbType in mutableFetchResult) {
            dbType.sdId = newSatisfactionType.sdId;
            dbType.degree = newSatisfactionType.degree;
            dbType.sdValue = newSatisfactionType.sdValue;
            dbType.projectId = projectId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateSatisfactionTypeById:(NSNumber*) typeId satisfactionType:(SatisfactionType *) type {
    BOOL res = NO;
    if(typeId && type) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"sdId", nil];
        res = [self updateSatisfactionType:type condition:param];
    }
    return res;
}

- (SatisfactionType*) querySatisfactionTypeById:(NSNumber*) typeId {
    SatisfactionType* res = nil;
    if(typeId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:typeId, @"sdId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBSatisfactionType * dbType = mutableFetchResult[0];
            res = [[SatisfactionType alloc] init];
            
            res.sdId = [dbType.sdId copy];
            res.degree = [dbType.degree copy];
            res.sdValue = [dbType.sdValue copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllSatisfactionTypesOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_SATISFACTION_TYPE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBSatisfactionType * dbType in mutableFetchResult) {
            SatisfactionType * type = [[SatisfactionType alloc] init];
            
            
            type.sdId = [dbType.sdId copy];
            type.degree = [dbType.degree copy];
            type.sdValue = [dbType.sdValue copy];
            
            [dataArray addObject:type];
        }
    }
    return dataArray;
}


#pragma mark - 故障原因

- (BOOL) isFailureReasonExist:(NSNumber*) reasonId {
    BOOL res = NO;
    if(reasonId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reasonId, @"reasonId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_FAILURE_REASON condition:dict];
    }
    return res;
    
}

- (BOOL) addFailureReason:(FailureReason *) reason {
    BOOL res = NO;
    if(reason) {
        DBFailureReason * objData = (DBFailureReason*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:super.managedObjectContext];
        
        
        [objData setReasonId:reason.reasonId ];
        [objData setReasonCode:reason.reasonCode];
        [objData setName:reason.name];
        [objData setParentId:reason.parentId];
        
        res = [self save];
    }
    return res;
    
}

- (BOOL) addFailureReasons:(NSArray *) array {
    BOOL res = YES;
    for(FailureReason * reason in array) {
        NSNumber * reasonId = reason.reasonId;
        if([self isFailureReasonExist:reasonId]) {
            res = res && [self updateFailureReasonById:reasonId reason:reason];
        } else {
            res = res && [self addFailureReason:reason];
        }
    }
    return res;
}

- (BOOL) deleteFailureReasonById:(NSNumber*) reasonId {
    BOOL res = NO;
    if(reasonId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reasonId==%@",reasonId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBFailureReason* reason in mutableFetchResult) {
            [self.managedObjectContext deleteObject:reason];
        }
        res = [self save];
        if (res) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//依据 ID 批量删除
- (BOOL) deleteFailureReasonByIds:(NSArray *) ids {
    BOOL res = NO;
    if(ids && [ids count] > 0) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:ids, @"reasonId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBFailureReason* reason in mutableFetchResult) {
            [self.managedObjectContext deleteObject:reason];
        }
        
        res = [self save];
    }
    return res;
}


- (BOOL) deleteAllFailureReason {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBFailureReason* obj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:obj];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateFailureReason:(FailureReason*) newReason condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newReason) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        
        for (DBFailureReason* dbReason in mutableFetchResult) {
            dbReason.reasonId = newReason.reasonId;
            dbReason.reasonCode = newReason.reasonCode;
            dbReason.name = newReason.name;
            dbReason.parentId = newReason.parentId;
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateFailureReasonById:(NSNumber*) reasonId reason:(FailureReason *) reason {
    BOOL res = NO;
    if(reasonId && reason) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:reasonId, @"reasonId", nil];
        res = [self updateFailureReason:reason condition:param];
    }
    return res;
}

- (FailureReason*) queryFailureReasonById:(NSNumber*) reasonId {
    FailureReason* res = nil;
    if(reasonId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reasonId, @"reasonId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBFailureReason * dbReason = mutableFetchResult[0];
            res = [[FailureReason alloc] init];
            
            res.reasonId = [dbReason.reasonId copy];
            res.reasonCode = [dbReason.reasonCode copy];
            res.name = [dbReason.name copy];
            res.parentId = [dbReason.parentId copy];
        }
    }
    return res;
}
- (NSMutableArray*) queryAllFailureReason {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_FAILURE_REASON inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for(DBFailureReason * dbReason in mutableFetchResult) {
        FailureReason * reason = [[FailureReason alloc] init];
        
        reason.reasonId = [dbReason.reasonId copy];
        reason.reasonCode = [dbReason.reasonCode copy];
        reason.name = [dbReason.name copy];
        reason.parentId = [dbReason.parentId copy];
        
        [dataArray addObject:reason];
    }
    
    return dataArray;
}


#pragma mark - 数据下载记录
//获取一个可用 ID
- (NSNumber *) getAnAvaliableDownloadRecordId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_DOWNLOAD_RECORD andKey:@"id"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}
- (BOOL) isDownloadRecordExist:(NSInteger) recordType {
    BOOL res = NO;
    NSNumber * type = [NSNumber numberWithInteger:recordType];
    if(recordType) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:type, @"dataType", projectId, @"projectId",  nil];
        res = [super isDataExist:DB_ENTITY_NAME_DOWNLOAD_RECORD condition:dict];
    }
    return res;
}
- (BOOL) addDownloadRecord:(DownloadRecord*) record projectId:(NSNumber *) projectId{
    BOOL res = NO;
    if(record) {
        DBBaseDownloadRecord * objData = (DBBaseDownloadRecord*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * recordId = [self getAnAvaliableDownloadRecordId];
        
        [objData setId:recordId];
        [objData setDataType:[NSNumber numberWithInteger:record.dataType]];
        [objData setPreRequestDate:record.preRequestDate];
        [objData setProjectId:projectId];
        
        NSError* error;
        res = [self.managedObjectContext save:&error];
    }
    return res;
}
- (BOOL) addDownloadRecords:(NSArray *) recordArray projectId:(NSNumber *)projectId {
    BOOL res = YES;
    for(DownloadRecord * record in recordArray) {
        if([self isDownloadRecordExist:record.dataType]) {
            res = res && [self updateDownloadRecordByType:record.dataType downloadRecord:record];
        } else {
            res = res && [self addDownloadRecord:record projectId:projectId];
        }
    }
    return res;
}
- (BOOL) deleteDownloadRecordById:(NSNumber*) recordId {
    BOOL res = NO;
    if(recordId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* record = [NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:super.managedObjectContext];
        [request setEntity:record];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"id==%@",recordId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        for (DBBaseDownloadRecord* dRecord in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dRecord];
        }
        
        res = [self save];
    }
    return res;
}

//删除当前项目下的所有下载记录
- (BOOL) deleteAllDownloadRecordOfCurrentProject {
    BOOL res = NO;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* record = [NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:super.managedObjectContext];
        [request setEntity:record];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        for (DBBaseDownloadRecord* dRecord in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dRecord];
        }
        
        res = [self save];
    }
    return res;
}

- (BOOL) deleteAllDownloadRecord {
    BOOL res = NO;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* record = [NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:super.managedObjectContext];
    [request setEntity:record];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (DBBaseDownloadRecord* dRecord in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dRecord];
    }
    
    res = [self save];
    return res;
}


- (BOOL) updateDownloadRecord:(DownloadRecord*) newRecord condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newRecord) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:self.managedObjectContext];
        [request setEntity:userEntity];
        //查询条件
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

        //更新age后要进行保存，否则没更新
        for (DBBaseDownloadRecord* dbRecord in mutableFetchResult) {
            dbRecord.preRequestDate = newRecord.preRequestDate;
            
        }
        res = [self save];
    }
    return res;
}
- (BOOL) updateDownloadRecordByType:(NSInteger) recordType downloadRecord:(DownloadRecord*) record {
    BOOL res = NO;
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:recordType], @"dataType", nil];
    res = [self updateDownloadRecord:record condition:param];
    
    return res;
}
- (NSMutableArray*) queryAllDownloadRecordOfCurrentProject {
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        for(DBBaseDownloadRecord * dbRecord in mutableFetchResult) {
            DownloadRecord * record = [[DownloadRecord alloc] init];
            
            record.dataType = [dbRecord.dataType integerValue];
            record.preRequestDate = [dbRecord.preRequestDate copy];
            
            [dataArray addObject:record];
        }
    }
    return dataArray;
}
- (DownloadRecord*) queryDownloadRecordById:(NSNumber*) recordId {
    DownloadRecord* res = nil;
    if(recordId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* record = [NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:self.managedObjectContext];
        [request setEntity:record];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:recordId, @"id", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBBaseDownloadRecord * dbRecord = mutableFetchResult[0];
            res = [[DownloadRecord alloc] init];
            
            res.dataType = [dbRecord.dataType integerValue];
            res.preRequestDate = [dbRecord.preRequestDate copy];
        }
    }
    return res;
}
- (DownloadRecord*) queryDownloadRecordByType:(NSInteger) recordType {
    DownloadRecord* res = nil;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* record = [NSEntityDescription entityForName:DB_ENTITY_NAME_DOWNLOAD_RECORD inManagedObjectContext:self.managedObjectContext];
    [request setEntity:record];
    
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:recordType], @"dataType", projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        DBBaseDownloadRecord * dbRecord = mutableFetchResult[0];
        res = [[DownloadRecord alloc] init];
        
        res.dataType = [dbRecord.dataType integerValue];
        res.preRequestDate = [dbRecord.preRequestDate copy];
    }

    return res;
}

#pragma mark - 数据清除
//清除所有基础数据
- (void) deleteAllBaseData {
    [self deleteAllUser];
    [self deleteAllGroup];
    [self deleteAllOrgs];
    [self deleteAllFlow];
    [self deleteAllServiceType];
    [self deleteAllPriority];
    [self deleteAllCities];
    [self deleteAllSites];
    [self deleteAllBuildings];
    [self deleteAllFloor];
    [self deleteAllRoom];
    [self deleteAllDeviceType];
    [self deleteAllDevices];
    [self deleteAllRequirementType];
    [self deleteAllSatisfactionType];
    [self deleteAllDownloadRecord];
}

@end
