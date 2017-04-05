//
//  EventHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceEventHelper : NSObject

- (instancetype) init;

//初始化数据
- (void) setInfoWith:(NSMutableArray *) array;

//获取指定日期的任务数量
- (NSInteger) getTaskCountOfDay:(NSDate *) date;

//获取指定日期的任务的描述信息
- (NSString *) getTaskDescriptionOfDay:(NSDate *) date;

//获取指定日期的任务
- (NSMutableArray *) getTaskOfDay:(NSDate *) date;

//清除所有数据
- (void) clearAll;

@end
