//
//  ReportDbHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportDbHelper.h"
#import "FMUtils.h"
#import "SystemConfig.h"

static ReportDbHelper * instance;
static NSString * DB_ENTITY_NAME_REPORT = @"DBReport";
static NSString * DB_ENTITY_NAME_REPORT_DEVICE = @"DBReportDevice";
static NSString * DB_ENTITY_NAME_REPORT_IMAGE = @"DBReportImage";

@interface ReportDbHelper ()

@end

@implementation ReportDbHelper

- (instancetype) init {
    self = [super init];
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[ReportDbHelper alloc] init];
    }
    return instance;
}

//报障设备
- (NSNumber *) getAnAvaliableReportDeviceId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_REPORT_DEVICE andKey:@"reportDeviceId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isReportDeviceExist:(NSNumber*) rdevId {
    BOOL res = NO;
    if(rdevId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:rdevId, @"reportDeviceId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_REPORT_DEVICE condition:dict];
    }
    return res;
}
- (BOOL) addReportDevice:(ReportDevice*) dev withReport:(NSNumber *) reportId {
    BOOL res = NO;
    if(dev) {
        DBReportDevice * objData = (DBReportDevice*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_REPORT_DEVICE inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * rdevId = [self getAnAvaliableReportDeviceId];
        
        if(reportId && ![reportId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setReportId:reportId];
            [objData setReportDeviceId:rdevId];
            [objData setDeviceId:dev.deviceId];
            
            NSError* error;
            res = [self save];
        }
    }
    return res;
}
- (BOOL) addReportDevices:(NSArray *) devs withReport:(NSNumber *) reportId {
    BOOL res = NO;
    for(ReportDevice * rdev in devs) {
        [self addReportDevice:rdev withReport:reportId];
    }
    return res;
}
//根据ID删除指定报障设备
- (BOOL) deleteReportDeviceById:(NSNumber*) rdevId {
    BOOL res = NO;
    if(rdevId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:reportDevice];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reportDeviceId==%@",rdevId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReportDevice* dreportDevice in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dreportDevice];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//删除跟指定报障相关报障设备
- (BOOL) deleteReportDeviceByReport:(NSNumber *)reportId {
    BOOL res = NO;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_DEVICE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:reportDevice];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reportId==%@",reportId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReportDevice* dreportDevice in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dreportDevice];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//查询报障中的所有报障设备
- (NSMutableArray*) queryAllDeviceByReport:(NSNumber *) reportId {
    NSMutableArray * res;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_DEVICE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:reportDevice];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBReportDevice * drdev in mutableFetchResult) {
                ReportDevice * rdev = [[ReportDevice alloc] init];
                rdev.deviceId = [drdev.deviceId copy];
                [res addObject:rdev];
            }
        }
    }
    return res;
}

//报障图片
- (NSNumber *) getAnAvaliableReportImageId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_REPORT_IMAGE andKey:@"reportImageId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}

- (BOOL) isReportImageExist:(NSNumber*) rimgId {
    BOOL res = NO;
    if(rimgId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:rimgId, @"reportImageId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_REPORT_IMAGE condition:dict];
    }
    return res;
}
- (BOOL) addReportImage:(NSString*) imgPath withReport:(NSNumber *) reportId {
    BOOL res = NO;
    if(![FMUtils isStringEmpty:imgPath]) {
        DBReportImage * objData = (DBReportImage*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:super.managedObjectContext];
        
        NSNumber * rimgId = [self getAnAvaliableReportImageId];
        
        if(reportId && ![reportId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setReportId:reportId];
            [objData setReportImageId:rimgId];
            [objData setPath:imgPath];
            
            NSError* error;
            res = [self save];
        }
    }
    return res;
}
- (BOOL) addReportImages:(NSArray *) pathArray withReport:(NSNumber *) reportId {
    BOOL res = NO;
    for(NSString * path in pathArray) {
        [self addReportImage:path withReport:reportId];
    }
    return res;
}
//根据ID删除指定报障图片
- (BOOL) deleteReportImageById:(NSNumber*) rimgId {
    BOOL res = NO;
    if(rimgId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportImage=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:reportImage];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reportImageId==%@",rimgId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReportImage* dreportImage in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dreportImage];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}
//删除跟指定报障相关报障图片
- (BOOL) deleteReportImageByReport:(NSNumber *)reportId {
    BOOL res = NO;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportImage=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:reportImage];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reportId==%@",reportId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReportImage* dreportImage in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dreportImage];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//删除指定报障部分相关的图片
- (BOOL) deleteReportImages:(NSArray *) images ofReport:(NSNumber *)reportId {
    BOOL res = NO;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportImage=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:super.managedObjectContext];
        [request setEntity:reportImage];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", images, @"path", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReportImage* dreportImage in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dreportImage];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//查询报障中的所有报障设备
- (NSMutableArray*) queryAllImageByReport:(NSNumber *) reportId {
    NSMutableArray * res;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportImage=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:reportImage];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBReportImage * drimg in mutableFetchResult) {
                NSString * path = [drimg.path copy];
                UIImage * image = [FMUtils getImageWithName:path];
                if(image) {
                    [res addObject:image];
                }
                
            }
        }
    }
    return res;
}

//查询报障中的所有报障图片
- (NSMutableArray*) queryAllImagePathByReport:(NSNumber *) reportId {
    NSMutableArray * res;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* reportImage=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT_IMAGE inManagedObjectContext:self.managedObjectContext];
        [request setEntity:reportImage];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            res = [[NSMutableArray alloc] init];
            for(DBReportImage * drimg in mutableFetchResult) {
                NSString * path = [drimg.path copy];
                [res addObject:path];
            }
        }
    }
    return res;
}


//Report
- (BOOL) isReportExist:(NSNumber*) reportId {
    BOOL res = NO;
    if(reportId) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_REPORT condition:dict];
    }
    return res;
    
}

- (NSNumber *) getAnAvaliableReportId {
    NSNumber * res;
    res = [super getMaxValueOfCollection:DB_ENTITY_NAME_REPORT andKey:@"reportId"];
    if(!res || [res isEqualToNumber:[NSNumber numberWithLong:0]]) {
        res = [NSNumber numberWithLong:1];
    } else {
        res = [NSNumber numberWithLong:(res.longValue + 1)];
    }
    return res;
}


- (BOOL) addReport:(Report*) report andImages:(NSMutableArray *) imgs{
    BOOL res = NO;
    if(report) {
        DBReport * objData = (DBReport*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_REPORT inManagedObjectContext:super.managedObjectContext];

        NSNumber * reportId = [self getAnAvaliableReportId];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        if(reportId && ![reportId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setReportId:reportId];
            [objData setUserId:report.userId];
            [objData setName:report.name];
            [objData setPhone:report.phone];
            [objData setOrgId:report.orgId];
            [objData setStypeId:report.stypeId];
            [objData setPriorityId:report.priorityId];
            [objData setDesc:report.desc];
            
            [objData setCityId:report.position.cityId];
            [objData setSiteId:report.position.siteId];
            [objData setBuildingId:report.position.buildingId];
            [objData setFloorId:report.position.floorId];
            [objData setRoomId:report.position.roomId];
            
            [objData setProcessId:report.processId];
            [objData setReqId:report.reqId];
            [objData setPatrolItemDetailId:report.patrolItemDetailId];
            
            [objData setProjectId:projectId];
            
            NSError* error;
            res = [self save];
            if(res && report.devices && [report.devices count] > 0) {
                [self addReportDevices:report.devices withReport:reportId];
            }
            if(res && imgs && [imgs count] > 0) {
                [self addReportImages:imgs withReport:reportId];
            }
        }
    }
    return res;
    
}


- (BOOL) deleteReportById:(NSNumber*) reportId {
    BOOL res = NO;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* report=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT inManagedObjectContext:super.managedObjectContext];
        [request setEntity:report];
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"reportId==%@",reportId];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBReport* dreport in mutableFetchResult) {
            [self deleteReportDeviceByReport:dreport.reportId];
            [self deleteReportImageByReport:dreport.reportId];
            [self.managedObjectContext deleteObject:dreport];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

- (BOOL) updateReport:(Report*) newReport condition:(NSDictionary*) param withImages:(NSArray *) pathArray{
    BOOL res = NO;
    if(newReport) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* userEntity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT inManagedObjectContext:self.managedObjectContext];
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
        NSNumber * reportId = [param valueForKeyPath:@"reportId"];
        NSArray * images = pathArray;
        if(reportId) {
            for (DBReport* dbReport in mutableFetchResult) {
                
                dbReport.userId =newReport.userId;
                dbReport.phone = newReport.phone;
                dbReport.orgId = newReport.orgId;
                dbReport.stypeId = newReport.stypeId;
                dbReport.priorityId = newReport.priorityId;
                dbReport.desc = newReport.desc;
                dbReport.processId = newReport.processId;
                dbReport.cityId = newReport.position.cityId;
                dbReport.siteId = newReport.position.siteId;
                dbReport.buildingId = newReport.position.buildingId;
                dbReport.floorId = newReport.position.floorId;
                dbReport.roomId = newReport.position.roomId;
                dbReport.reqId = newReport.reqId;
                dbReport.patrolItemDetailId = newReport.patrolItemDetailId;
            }
            
            [self deleteReportDeviceByReport:reportId]; //设备
            if(newReport.devices && [newReport.devices count] > 0) {
                [self addReportDevices:newReport.devices withReport:reportId];
            }
            
//            [self deleteReportImageByReport:reportId];  //图片
            NSArray * oldImages = [self queryAllImagePathByReport:reportId];
            NSMutableArray * unUsedImages = [[NSMutableArray alloc] init];
            NSMutableArray * newImages = [[NSMutableArray alloc] init];
            for(NSString * path in oldImages) {
                if(!images || ![images containsObject:path]) {
                    [unUsedImages addObject:path];
                }
            }
            if([unUsedImages count] > 0) {
                [self deleteReportImages:unUsedImages ofReport:reportId];
            }
            for(NSString * imgPath in images) {
                if(!oldImages || ![oldImages containsObject:imgPath]) {
                    [newImages addObject:imgPath];
                }
            }
            if(newImages && [newImages count] > 0) {
                [self addReportImages:newImages withReport:reportId];
            }
            
            res = [self save];
        }
    }
    return res;
}
- (BOOL) updateReportById:(NSNumber*) reportId report:(Report*) report withImages:(NSArray *) pathArray{
    BOOL res = NO;
    if(reportId && report) {
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        res = [self updateReport:report condition:param withImages:pathArray];
    }
    return res;
}

- (Report*) queryReportById:(NSNumber*) reportId {
    Report* res = nil;
    if(reportId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* report=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT inManagedObjectContext:self.managedObjectContext];
        [request setEntity:report];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportId, @"reportId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id==%@",userId];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if([mutableFetchResult count] > 0) {
            DBReport * dbReport = mutableFetchResult[0];
            res = [[Report alloc] init];
            
            res.userId = [dbReport.userId copy];
            res.name = [dbReport.name copy];
            res.phone = [dbReport.phone copy];
            res.orgId = [dbReport.orgId copy];
            res.stypeId = [dbReport.stypeId copy];
            res.priorityId = [dbReport.priorityId copy];
            res.processId = [dbReport.processId copy];
            res.position.cityId = [dbReport.cityId copy];
            res.position.siteId = [dbReport.siteId copy];
            res.position.buildingId = [dbReport.buildingId copy];
            res.position.floorId = [dbReport.floorId copy];
            res.position.roomId = [dbReport.roomId copy];
            res.desc = dbReport.desc;
            res.reqId = dbReport.reqId;
            res.patrolItemDetailId = dbReport.patrolItemDetailId;
            
            res.devices = [self queryAllDeviceByReport:reportId];
            
        }
    }
    return res;
}

- (NSMutableArray *) queryAllDBReportsByUser:(NSNumber *) userId {
    NSMutableArray* reportArray = [[NSMutableArray alloc] init];
    if(userId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity=[NSEntityDescription entityForName:DB_ENTITY_NAME_REPORT inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", projectId, @"projectId", nil];
        NSString* strSql = [self getSqlStringBy:dict];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        reportArray = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    }
    return reportArray;
}

- (NSMutableArray*) queryAllReportsByUser:(NSNumber *) userId{
    
    NSMutableArray* reportArray = [[NSMutableArray alloc] init];

    NSMutableArray* mutableFetchResult = [self queryAllDBReportsByUser:userId];
    
    for(DBReport * dbReport in mutableFetchResult) {
        Report * report = [[Report alloc] init];
//        NSNumber * reportId = dbReport.reportId;
        
        report.userId = [dbReport.userId copy];
        report.phone = [dbReport.phone copy];
        report.orgId = [dbReport.orgId copy];
        report.stypeId = [dbReport.stypeId copy];
        report.priorityId = [dbReport.priorityId copy];
        report.processId = [dbReport.processId copy];
        report.position.cityId = [dbReport.cityId copy];
        report.position.siteId = [dbReport.siteId copy];
        report.position.buildingId = [dbReport.buildingId copy];
        report.position.floorId = [dbReport.floorId copy];
        report.position.roomId = [dbReport.roomId copy];
        report.desc = dbReport.desc;
        report.reqId = dbReport.reqId;
        report.patrolItemDetailId = dbReport.patrolItemDetailId;
        
        [reportArray addObject:report];
    }
    return reportArray;
}


@end
