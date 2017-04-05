//
//  QuickSearchIndexTable.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/25.
//  Copyright © 2016年 flynn. All rights reserved.
//
//
//  快速搜索的索引表

#import <Foundation/Foundation.h>

@interface QuickSearchIndexTable : NSObject

- (instancetype) init;

- (instancetype) initWithDataArray:(NSMutableArray *) array;

//获取组数量
- (NSInteger) getGroupCount;

//获取组名称
- (NSString *) getGroupNameAtIndex:(NSInteger) index;

//获取组名次数组
- (NSMutableArray *) getGoupNameArray;

//获取组内项的数量
- (NSInteger) getItemCountByKey:(NSString *) key;

//根据组和位置来获取索引，既需要展示的数据所在的位置
- (NSInteger) getIndexByGroup:(NSInteger) groupIndex andPosition:(NSInteger) position;

//设置需要建立索引的数据信息
- (void) setDataWithArray:(NSMutableArray *) array;

//设置过滤器
- (void) setFilter:(NSString *) filter;

@end
