//
//  DBHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  多线程同时操作 managedObjectContext ，会导致 save 失败情况，目前尽量保证在同一个线程中操作
//  TODO: 寻找对应的解决方案（考虑用两个 context：mainContext 和 privateContext，一个用于主线程，另外一个用于后台执行）

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBHelper : NSObject

@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;//数据对象模型
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;//数据对象上下文
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;//持续化存储区

+ (instancetype) getInstance;
- (instancetype) init;

- (BOOL) isDataExist:(const NSString*) collectionName condition:(NSDictionary*) params;

- (NSString*) getSqlStringBy:(NSDictionary*) dict;
//依据 dictionary 获取查询 非 语句
- (NSString*) getSqlStringByNot:(NSDictionary*) dict;
//按条件从指定表中查询数据
- (NSMutableArray *) getDataOfCollection:(NSString *) collName andCondition:(NSDictionary *) condition;

//获取指定列表的 id 的最大值
- (NSNumber *) getMaxValueOfCollection:(NSString *) collName andKey:(NSString *) key;

//保存当前的数据改动
- (BOOL) save;

@end
