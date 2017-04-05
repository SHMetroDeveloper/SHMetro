//
//  AttendanceDbHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceDbHelper.h"
#import "SystemConfig.h"
#import "FMUtils.h"

static AttendanceDbHelper * instance;
static NSString * DB_ENTITY_NAME_SIGN_PERSON = @"DBSignPerson";
static NSString * DB_ENTITY_NAME_SIGN_WIFI = @"DBSignWifi";
static NSString * DB_ENTITY_NAME_SIGN_BLUETOOTH = @"DBSignBluetooth";
static NSString * DB_ENTITY_NAME_SIGN_LOCATION = @"DBSignLocation";

@interface AttendanceDbHelper ()

@end

@implementation AttendanceDbHelper
- (instancetype) init {
    self = [super init];
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[AttendanceDbHelper alloc] init];
    }
    return instance;
}


//签到人员
- (BOOL) isSignPersonExist:(NSNumber*) emId {
    BOOL res = NO;
    if(emId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_PERSON condition:dict];
    }
    return res;
}
- (BOOL) addSignPerson:(AttendanceConfigurePerson*) person {
    BOOL res = NO;
    if(person) {
        DBSignPerson * objData = (DBSignPerson*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        if(person.emId && ![person.emId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setEmId:person.emId];
            [objData setName:person.name];
            [objData setOrg:person.org];
            [objData setProjectId:projectId];
            NSLog(@"----添加了人员----");
            NSError* error;
            res = [self save];
        }
    }
    return res;
}
- (BOOL) addSignPersonWithArray:(NSArray *) array {
    BOOL res = YES;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self deleteAllSignPerson];
    for(AttendanceConfigurePerson * person in array) {
        if(![self isSignPersonExist:person.emId]) {
            res = res && [self addSignPerson:person];
        } else {
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:person.emId, @"emId", projectId, @"projectId", nil];
            res = res && [self updateSignPerson:person condition:param];
        }
    }
    return res;
}

- (BOOL) updateSignPerson:(AttendanceConfigurePerson*) newPerson condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newPerson) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:self.managedObjectContext];
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
        NSNumber * emId = [param valueForKeyPath:@"emId"];
        if(emId) {
            for (DBSignPerson* dbObj in mutableFetchResult) {
                
                dbObj.name = newPerson.name;
                dbObj.org = newPerson.org;
                
            }
            res = [self save];
        }
    }
    return res;
}

//设置签到人员的的类型和状态
- (BOOL) setSignType:(NSInteger) type status:(NSInteger) status ofPerson:(NSNumber *) emId {
    BOOL res = NO;
    if(emId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        if(emId) {
            for (DBSignPerson* dbObj in mutableFetchResult) {
                dbObj.type = [NSNumber numberWithInteger:type];
                dbObj.status = [NSNumber numberWithInteger:status];
            }
            res = [self save];
        }
    }
    return res;
}
//根据ID删除指定人员
- (BOOL) deleteSignPersonById:(NSNumber*) emId {
    BOOL res = NO;
    if(emId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:emId, @"emId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSignPerson* dObj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dObj];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//删除所有签到人员信息
- (BOOL) deleteAllSignPerson {
    BOOL res = NO;
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSignPerson* dObj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dObj];
    }
    
    if (![self save]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
    return res;
}

//查询所有的人员
- (NSMutableArray*) queryAllDbSignPerson {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* reportDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:self.managedObjectContext];
    [request setEntity:reportDevice];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignPerson * dobj in mutableFetchResult) {
            [res addObject:dobj];
        }
    }
    
    return res;
}

//查询所有的人员
- (NSMutableArray*) queryAllSignPerson {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* reportDevice=[NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_PERSON inManagedObjectContext:self.managedObjectContext];
    [request setEntity:reportDevice];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignPerson * dobj in mutableFetchResult) {
            AttendanceConfigurePerson * person = [[AttendanceConfigurePerson alloc] init];
            person.emId = [dobj.emId copy];
            person.name = [dobj.name copy];
            person.org = [dobj.org copy];
            
            [res addObject:person];
        }
    }
    
    return res;
}


//签到wifi
- (BOOL) isSignWifiExist:(NSNumber*) wifiId {
    BOOL res = NO;
    if(wifiId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:wifiId, @"wifiId", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_WIFI condition:dict];
    }
    return res;
}
- (BOOL) isSignWifiExistByMac:(NSString*) mac {
    BOOL res = NO;
    if(![FMUtils isStringEmpty:mac]) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:mac, @"mac", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_WIFI condition:dict];
    }
    return res;
}

- (BOOL) addSignWifi:(AttendanceConfigureWiFi*) wifi {
    BOOL res = NO;
    if(wifi) {
        DBSignWifi * objData = (DBSignWifi*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        if(wifi.wifiId && ![wifi.wifiId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setWifiId:wifi.wifiId];
            [objData setName:wifi.name];
            [objData setMac:wifi.mac];
            [objData setEnable:[NSNumber numberWithBool:wifi.enable]];
            
            [objData setProjectId:projectId];
            
            NSError* error;
            res = [self save];
        }
    }
    return res;
}
- (BOOL) addSignWifiWithArray:(NSArray *) array {
    BOOL res = YES;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self deleteAllSignWifi];
    for(AttendanceConfigureWiFi * wifi in array) {
        if(![self isSignWifiExist:wifi.wifiId]) {
            res = res && [self addSignWifi:wifi];
        } else {
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:wifi.wifiId, @"wifiId", projectId, @"projectId", nil];
            res = res && [self updateSignWifi:wifi condition:param];
        }
    }
    return res;
}
- (BOOL) updateSignWifi:(AttendanceConfigureWiFi*) newWifi condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newWifi) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:self.managedObjectContext];
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
        
        for (DBSignWifi* dbObj in mutableFetchResult) {
            dbObj.name = newWifi.name;
            dbObj.mac = newWifi.mac;
            dbObj.enable = [NSNumber numberWithBool:newWifi.enable];
        }
        res = [self save];
        
    }
    return res;
}


//设置签到wifi的状态
- (BOOL) setSignWifi:(NSNumber *) wifiId status:(BOOL) enable; {
    BOOL res = NO;
    if(wifiId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:wifiId, @"wifiId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        if(wifiId) {
            for (DBSignWifi* dbObj in mutableFetchResult) {
                dbObj.enable = [NSNumber numberWithInteger:enable];
            }
            res = [self save];
        }
    }
    return res;
}
//根据ID删除指定数据
- (BOOL) deleteSignWifiById:(NSNumber*) wifiId {
    BOOL res = NO;
    if(wifiId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:wifiId, @"wifiId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSignWifi* dObj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dObj];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//删除所有WiFi数据
- (BOOL) deleteAllSignWifi {
    BOOL res = NO;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSignWifi* dObj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dObj];
    }
    
    if (![self save]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
    return res;
}

//查询报障中的所有签到wifi(DBSignWifi)
- (NSMutableArray*) queryAllDBSignWifi {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignWifi * dobj in mutableFetchResult) {
            [res addObject:dobj];
        }
    }
    
    return res;
}
//查询报障中的所有签到wifi
- (NSMutableArray*) queryAllSignWifi {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_WIFI inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignWifi * dobj in mutableFetchResult) {
            AttendanceConfigureWiFi * wifi = [[AttendanceConfigureWiFi alloc] init];
            wifi.wifiId = dobj.wifiId;
            wifi.name = dobj.name;
            wifi.mac = dobj.mac;
            wifi.enable = dobj.enable.boolValue;
            [res addObject:wifi];
        }
    }
    
    return res;
}

//签到蓝牙
- (BOOL) isSignBluetoothExist:(NSNumber*) bluetoothId {
    BOOL res = NO;
    if(bluetoothId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:bluetoothId, @"bluetoothId", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_BLUETOOTH condition:dict];
    }
    return res;
}
- (BOOL) isSignBluetoothExistByMac:(NSString*) mac {
    BOOL res = NO;
    if(![FMUtils isStringEmpty:mac]) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:mac, @"mac", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_BLUETOOTH condition:dict];
    }
    return res;
}

- (BOOL) addSignBluetooth:(AttendanceConfigureBluetooth*) bluetooth  {
    BOOL res = NO;
    if(bluetooth) {
        DBSignBluetooth * objData = (DBSignBluetooth*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        if(bluetooth.bluetoothId && ![bluetooth.bluetoothId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setBluetoothId:bluetooth.bluetoothId];
            [objData setName:bluetooth.name];
            [objData setMac:bluetooth.mac];
            [objData setEnable:[NSNumber numberWithBool:bluetooth.enable]];
            
            [objData setProjectId:projectId];
            
            NSError* error;
            res = [self save];
        }
    }
    return res;
}

- (BOOL) addSignBluetoothWithArray:(NSArray *) array{
    BOOL res = YES;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self deleteAllSignBluetooth];
    for(AttendanceConfigureBluetooth * bluetooth in array) {
        if(![self isSignBluetoothExist:bluetooth.bluetoothId]) {
            res = res && [self addSignBluetooth:bluetooth];
        } else {
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:bluetooth.bluetoothId, @"bluetoothId", projectId, @"projectId", nil];
            res = res && [self updateSignBluetooth:bluetooth condition:param];
        }
        
    }
    return res;
}

- (BOOL) updateSignBluetooth:(AttendanceConfigureBluetooth*) newBluetooth condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newBluetooth) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:self.managedObjectContext];
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
        
        for (DBSignBluetooth* dbObj in mutableFetchResult) {
            dbObj.name = newBluetooth.name;
            dbObj.mac = newBluetooth.mac;
            dbObj.enable = [NSNumber numberWithBool:newBluetooth.enable];
        }
        res = [self save];
        
    }
    return res;
}

//设置签到蓝牙的状态
- (BOOL) setSignBluetooth:(NSNumber *) bluetoothId status:(BOOL) enable {
    BOOL res = NO;
    if(bluetoothId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:bluetoothId, @"bluetoothId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        if(bluetoothId) {
            for (DBSignBluetooth* dbObj in mutableFetchResult) {
                dbObj.enable = [NSNumber numberWithInteger:enable];
            }
            res = [self save];
        }
    }
    return res;
}
//根据ID删除指定数据
- (BOOL) deleteSignBluetoothById:(NSNumber*) bluetoothId {
    BOOL res = NO;
    if(bluetoothId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:bluetoothId, @"bluetoothId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSignBluetooth* dObj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dObj];
        }
        
        if (![self save]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//删除所有蓝牙数据
- (BOOL) deleteAllSignBluetooth{
    BOOL res = NO;
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSignBluetooth* dObj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dObj];
    }
    
    if (![self save]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
    return res;
}

//查询报障中的所有签到蓝牙(DBSignBluetooth)
- (NSMutableArray*) queryAllDBSignBluetooth {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignBluetooth * dobj in mutableFetchResult) {
            [res addObject:dobj];
        }
    }
    
    return res;
}
//查询报障中的所有签到蓝牙
- (NSMutableArray*) queryAllSignBluetooth {
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_BLUETOOTH inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignBluetooth * dobj in mutableFetchResult) {
            AttendanceConfigureBluetooth * bluetooth = [[AttendanceConfigureBluetooth alloc] init];
            bluetooth.bluetoothId = dobj.bluetoothId;
            bluetooth.name = dobj.name;
            bluetooth.mac = dobj.mac;
            bluetooth.enable = dobj.enable.boolValue;
            [res addObject:bluetooth];
        }
    }
    
    return res;
}

//签到位置
- (BOOL) isSignLocationExist:(NSNumber*) locationId {
    BOOL res = NO;
    if(locationId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:locationId, @"locationId", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_LOCATION condition:dict];
    }
    return res;
}

- (BOOL) isSignLocationExistByLat:(NSString*) lat lon:(NSString *) lon andLocationName:(NSString *) name {
    BOOL res = NO;
    if(![FMUtils isStringEmpty:lat] && ![FMUtils isStringEmpty:lon]) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", lat, @"lat", lon, @"lon", projectId, @"projectId", nil];
        res = [super isDataExist:DB_ENTITY_NAME_SIGN_LOCATION condition:dict];
    }
    return res;
}

- (BOOL) addSignLocation:(AttendanceLocation*) location{
    BOOL res = NO;
    if(location) {
        DBSignLocation * objData = (DBSignLocation*)[NSEntityDescription insertNewObjectForEntityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:super.managedObjectContext];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        if(location.locationId && ![location.locationId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [objData setLocationId:location.locationId];
            [objData setName:location.name];
            [objData setDesc:location.desc];
            [objData setLat:location.lat];
            [objData setLon:location.lon];
            [objData setEnable:[NSNumber numberWithBool:location.enable]];
            
            [objData setProjectId:projectId];
            
            NSError* error;
            res = [self save];
        }
    }
    return res;
}

- (BOOL) addSignLocationWithArray:(NSArray *) array{
    BOOL res = YES;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    [self deleteAllSignLocation];
    for(AttendanceLocation * location in array) {
        if(![self isSignLocationExist:location.locationId]) {
            res = res && [self addSignLocation:location];
        } else {
            NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:location.locationId, @"locationId", projectId, @"projectId", nil];
            res = res && [self updateSignLocation:location condition:param];
        }
        
    }
    return res;
}

- (BOOL) updateSignLocation:(AttendanceLocation*) newLocation condition:(NSDictionary*) param {
    BOOL res = NO;
    if(newLocation) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:self.managedObjectContext];
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
        
        for (DBSignLocation* dbObj in mutableFetchResult) {
            dbObj.name = newLocation.name;
            dbObj.desc = newLocation.desc;
            dbObj.lat = newLocation.lat;
            dbObj.lon = newLocation.lon;
            
            dbObj.enable = [NSNumber numberWithBool:newLocation.enable];
        }
        res = [self save];
        
    }
    return res;
}

//设置签到位置的状态
- (BOOL) setSignLocation:(NSNumber *) locationId status:(BOOL) enable{
    BOOL res = NO;
    if(locationId) {
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        //查询条件
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:locationId, @"locationId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        
        for (DBSignLocation* dbObj in mutableFetchResult) {
            dbObj.enable = [NSNumber numberWithInteger:enable];
        }
        res = [self save];
        
    }
    return res;
}
//根据ID删除指定数据
- (BOOL) deleteSignLocationById:(NSNumber*) locationId {
    BOOL res = NO;
    if(locationId) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:super.managedObjectContext];
        [request setEntity:entity];
        NSNumber * projectId = [SystemConfig getCurrentProjectId];
        NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:locationId, @"locationId", projectId, @"projectId", nil];
        NSString* strParam = [super getSqlStringBy:param];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
        [request setPredicate:predicate];
        NSError* error=nil;
        NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResult==nil) {
            NSLog(@"Error:%@",error);
        }
        for (DBSignLocation* dObj in mutableFetchResult) {
            [self.managedObjectContext deleteObject:dObj];
        }
        
        res = [self save];
        if (!res) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
    }
    return res;
}

//删除所有的地理位置信息
- (BOOL) deleteAllSignLocation{
    BOOL res = NO;
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:super.managedObjectContext];
    [request setEntity:entity];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSDictionary * param = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strParam = [super getSqlStringBy:param];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strParam];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[super.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    for (DBSignLocation* dObj in mutableFetchResult) {
        [self.managedObjectContext deleteObject:dObj];
    }
    
    if (![self save]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
    return res;
}

//查询报障中的所有签到位置
- (NSMutableArray*) queryAllDBSignLocation{
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignLocation * dobj in mutableFetchResult) {
            [res addObject:dobj];
        }
    }
    return res;
}

//查询报障中的所有签到位置
- (NSMutableArray*) queryAllSignLocation{
    NSMutableArray * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:DB_ENTITY_NAME_SIGN_LOCATION inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:projectId, @"projectId", nil];
    NSString* strSql = [self getSqlStringBy:dict];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if([mutableFetchResult count] > 0) {
        res = [[NSMutableArray alloc] init];
        for(DBSignLocation * dobj in mutableFetchResult) {
            AttendanceLocation * location = [[AttendanceLocation alloc] init];
            location.locationId = dobj.locationId;
            location.name = dobj.name;
            location.desc = dobj.desc;
            location.lat = dobj.lat;
            location.lon = dobj.lon;
            location.enable = dobj.enable.boolValue;
            
            [res addObject:location];
        }
    }
    return res;
}

@end
