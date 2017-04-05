//
//  DBHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DBHelper.h"
#import "FMUtils.h"


static DBHelper * instance = nil;

@interface DBHelper ()

@end


@implementation DBHelper

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[DBHelper alloc] init];
    }
    return instance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initModel];
    }
    return self;
}

- (void) initModel {
    if(!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fmbase" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    if (_persistentStoreCoordinator==nil) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                           NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                           NSInferMappingModelAutomaticallyOption, nil];
        //指定存储路径
        NSString *storePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * storeFilePath = [storePath stringByAppendingPathComponent:@"fmbase.sqlite"];
        NSURL *storeUrl=[NSURL fileURLWithPath:storeFilePath];
        NSError *error=nil;
        //根据数据库模型初始化一个仓库
        _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
        //指定仓库的存储类型和村粗路径
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {  //如果出现模型不匹配的情况，删除原有数据库文件
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            BOOL deleted = NO;
            if([fileManager fileExistsAtPath:storeFilePath]){
                deleted = [fileManager removeItemAtPath:storeFilePath error:&error];
            }
            if(deleted) {
                //如果文件删除成功的话试着重新请求一次
                if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
                    NSLog(@"数据库出现未知错误 --- addPersistentStoreWithType");
                }
            }
        }
    }
    if (_managedObjectContext==nil) {
        //如果持续化存储区存在
        if (_persistentStoreCoordinator!=nil) {
            _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            //指定上下文关联的持续化存储区为上面创建的存储区
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    
}

//依据 dictionary 获取查询语句
- (NSString*) getSqlStringBy:(NSDictionary*) dict {
    NSString* conStr = @"";
    
    for(NSString* key in dict) {
        id value = [dict objectForKey:key];
        NSString * strSep = @"";
        NSString* subParam = nil;
        if([value isKindOfClass:[NSString class]]) {        //字符串
            subParam = [[NSString alloc] initWithFormat:@"%@=='%@'", key, value];
        } else if([value isKindOfClass:[NSNumber class]]) { //数字
            subParam = [[NSString alloc] initWithFormat:@"%@==%@", key, value];
        } else if([value isKindOfClass:[NSArray class]]) {
            NSString* strValue = @"";
            if(value && [value count] > 0) {
                subParam = [[NSString alloc] initWithFormat:@"%@ in {", key];
                NSInteger i = 0;
                NSString* subSep = @"";
                for(id subObj in value) {
                    NSString* quotation = @"";
                    if([subObj isKindOfClass:[NSString class]]) {
                        quotation = @"'";
                    }
                    if(i > 0) {
                        if(![FMUtils isStringEmpty:strValue]) {
                            subSep = @" , ";
                        }
                        strValue = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", strValue, subSep, quotation, subObj, quotation];
                    }
                    else {
                        strValue = [[NSString alloc] initWithFormat:@"%@%@%@", quotation, subObj, quotation];
                    }
                    i++;
                }
                subParam = [[NSString alloc] initWithFormat:@"%@%@}", subParam, strValue];
            }
        } else if([value isKindOfClass:[NSNull class]]) {
            subParam = [[NSString alloc] initWithFormat:@"%@==nil", key];
        }
        if(![FMUtils isStringEmpty:subParam]) {
            if(![FMUtils isStringEmpty:conStr]) {
                strSep = @" and ";
            }
            conStr = [[NSString alloc] initWithFormat:@"%@%@%@", conStr, strSep, subParam];
        }
        
        
    }
    return conStr;
}

//依据 dictionary 获取查询 非 语句
- (NSString*) getSqlStringByNot:(NSDictionary*) dict {
    NSString* conStr = @"";
    
    for(NSString* key in dict) {
        id value = [dict objectForKey:key];
        NSString * strSep = @"";
        NSString* subParam = nil;
        if([value isKindOfClass:[NSString class]]) {        //字符串
            subParam = [[NSString alloc] initWithFormat:@"%@!='%@'", key, value];
        } else if([value isKindOfClass:[NSNumber class]]) { //数字
            subParam = [[NSString alloc] initWithFormat:@"%@!=%@", key, value];
        } else if([value isKindOfClass:[NSArray class]]) {
            NSString* strValue = @"";
            if(value && [value count] > 0) {
                subParam = [[NSString alloc] initWithFormat:@"not (%@ in {", key];
                NSInteger i = 0;
                NSString* subSep = @"";
                for(id subObj in value) {
                    NSString* quotation = @"";
                    if([subObj isKindOfClass:[NSString class]]) {
                        quotation = @"'";
                    }
                    if(i > 0) {
                        if(![FMUtils isStringEmpty:strValue]) {
                            subSep = @" , ";
                        }
                        strValue = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", strValue, subSep, quotation, subObj, quotation];
                    }
                    else {
                        strValue = [[NSString alloc] initWithFormat:@"%@%@%@", quotation, subObj, quotation];
                    }
                    i++;
                }
                subParam = [[NSString alloc] initWithFormat:@"%@%@})", subParam, strValue];
            }
        } else if([value isKindOfClass:[NSNull class]]) {
            subParam = [[NSString alloc] initWithFormat:@"%@!=nil", key];
        }
        if(![FMUtils isStringEmpty:subParam]) {
            if(![FMUtils isStringEmpty:conStr]) {
                strSep = @" or ";
            }
            conStr = [[NSString alloc] initWithFormat:@"%@%@%@", conStr, strSep, subParam];
        }
    }
    return conStr;
}

- (BOOL) isDataExist:(NSString*) collectionName condition:(NSDictionary*) params {
    BOOL res = NO;
    if(params) {
        NSFetchRequest* request=[[NSFetchRequest alloc] init];
        NSEntityDescription* user=[NSEntityDescription entityForName:collectionName inManagedObjectContext:_managedObjectContext];
        [request setEntity:user];
        NSString* conStr = [self getSqlStringBy:params];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:conStr];
        [request setPredicate:predicate];
        
        NSError* error=nil;
        NSArray* mutableFetchResult = [_managedObjectContext executeFetchRequest:request error:&error];
        if([mutableFetchResult count] > 0) {
            res = YES;
        }

    }
    return res;
}



- (NSMutableArray *) getDataOfCollection:(NSString *) collName andCondition:(NSDictionary *) condition {
    NSMutableArray * dataArray;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* flow=[NSEntityDescription entityForName:collName inManagedObjectContext:_managedObjectContext];
    [request setEntity:flow];
    
    NSString* strSql = [self getSqlStringBy:condition];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:strSql];
    
    [request setPredicate:predicate];
    
    NSError* error=nil;
    dataArray = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    return dataArray;
}

- (NSNumber *) getMaxValueOfCollection:(NSString *) collName andKey:(NSString *) key {
    NSNumber * res;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:collName
                                   inManagedObjectContext:_managedObjectContext]];
    [request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:key];
    NSExpression *maxValueExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxIdValue"];
    [expressionDescription setExpression:maxValueExpression];
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError* error=nil;
    NSArray * dataArray = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (dataArray == nil) {
        // Handle the error.
    } else {
        if (0 < [dataArray count]) {
            res = [[dataArray objectAtIndex:0] valueForKey:@"maxIdValue"];
        }
    }
    return res;
}

//保存当前的数据改动
- (BOOL) save {
    BOOL res = NO;
    NSError* error;
    @synchronized(_managedObjectContext) {
        res = [_managedObjectContext save:&error];
    }
    if(!res) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    return res;
}

@end
