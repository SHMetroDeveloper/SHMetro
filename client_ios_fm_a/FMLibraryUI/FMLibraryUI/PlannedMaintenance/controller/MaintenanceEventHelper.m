//
//  EventHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceEventHelper.h"
#import "MaintenanceEntity.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface MaintenanceEventHelper ()

@property (readwrite, nonatomic, strong) NSMutableArray * array;

@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;
@property (readwrite, nonatomic, strong) NSMutableDictionary * indexDic;    //使用字典的好处在于不需要写额外的逻辑来判读是否存在

@end

@implementation MaintenanceEventHelper
- (instancetype) init {
    self = [super init];
    return self;
}

//初始化数据
- (void) setInfoWith:(NSMutableArray *) array {
    _array = array;
    NSLog(@"建立索引中。。。");
    [FMUtils printCurrentTime];
    [self generateIndexTable];  //建立索引
    [FMUtils printCurrentTime];
    NSLog(@"索引建立完成。。。");
}

//获取指定日期的任务数量
- (NSInteger) getTaskCountOfDay:(NSDate *) date {
    NSInteger count = 0;
    if(date && _indexDic) {
        NSString * strKey = [self getDescriptionOfKey:date];
        NSMutableArray * indexArray = [_indexDic valueForKeyPath:strKey];
        count = [indexArray count];
    }
    return count;
}

//获取指定日期的任务的描述信息
- (NSString *) getTaskDescriptionOfDay:(NSDate *) date {
    NSString * res = @"";
    NSInteger count = [self getTaskCountOfDay:date];
    if(count > 1) {
        res = [[NSString alloc] initWithFormat:@"%ld%@", count, [[BaseBundle getInstance] getStringByKey:@"maintenance_task_desc_multi" inTable:nil]];
    } else if(count > 0) {
        res = [[NSString alloc] initWithFormat:@"%ld%@", count, [[BaseBundle getInstance] getStringByKey:@"maintenance_task_desc" inTable:nil]];
    }
    return res;
}

//获取指定日期的任务
- (NSMutableArray *) getTaskOfDay:(NSDate *) date {
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    if(date && _indexDic) {
        NSString * strKey = [self getDescriptionOfKey:date];
        NSMutableArray * indexArray = [_indexDic valueForKeyPath:strKey];
        for(NSNumber * index in indexArray) {
            NSInteger position = index.integerValue;
            if(position >= 0 && position < [_array count]) {
                MaintenanceEntity * entity = _array[position];
                [tmpArray addObject:entity];
            }
        }
    }
    return tmpArray;
}

#pragma mark --- 解析数据
- (void) generateIndexTable {
    if(!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    } else {
        [_keyArray removeAllObjects];
    }
    if(!_indexDic) {
        _indexDic = [[NSMutableDictionary alloc] init];
    } else {
        [_indexDic removeAllObjects];
    }
    
    NSInteger index = 0;
    for(MaintenanceEntity * entity in _array) {
        if(entity.dateTodo) {
            NSDate * date = [FMUtils timeLongToDate:entity.dateTodo];
            NSString * strKey = [self getDescriptionOfKey:date];
            NSMutableArray * indexArray = [_indexDic valueForKeyPath:strKey];
            if(!indexArray) {       //键值不存在则表示还没建立索引
                indexArray = [[NSMutableArray alloc] init];
                [_indexDic setValue:indexArray forKeyPath:strKey];
            }
            [indexArray addObject:[NSNumber numberWithInteger:index]];
        }
        index++;
    }
}


//获取日期的描述信息，作为键值使用
- (NSString *) getDescriptionOfKey:(NSDate *) key {
    NSString * desc = [FMUtils getDayStr:key];
    return desc;
}

//清除所有数据
- (void) clearAll {
    _array = nil;
    if(_keyArray) {
        [_keyArray removeAllObjects];
    }
    if(_indexDic) {
        [_indexDic removeAllObjects];
    }
}
@end
