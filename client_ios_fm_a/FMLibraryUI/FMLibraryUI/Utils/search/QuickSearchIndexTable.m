//
//  QuickSearchIndexTable.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "QuickSearchIndexTable.h"
#import "FMUtils.h"

const NSInteger INDEX_UNKNOW = -1;

@interface QuickSearchIndexTable ()

@property (readwrite, nonatomic, strong) NSMutableArray * dataArray; //初始数据
@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;//分组信息, 既索引表的 key
@property (readwrite, nonatomic, strong) NSMutableDictionary * indexDic;    //索引表， 对应的每个索引项下面存索引数组

@property (readwrite, nonatomic, strong) NSString * filter; //

@end

@implementation QuickSearchIndexTable

- (instancetype) init {
    self = [super init];
    if(self) {
    
    }
    return self;
}

- (instancetype) initWithDataArray:(NSMutableArray *) array {
    self = [super init];
    if(self) {
        _dataArray = [array copy];
    }
    return self;
}

//获取组数量
- (NSInteger) getGroupCount {
    NSInteger count = [_keyArray count];
    return count;
}

//获取组名称
- (NSString *) getGroupNameAtIndex:(NSInteger) index {
    NSString * name = nil;
    if(index >= 0 && index < [_keyArray count]) {
        name = _keyArray[index];
    }
    return name;
}

//获取组名次数组
- (NSMutableArray *) getGoupNameArray {
    return _keyArray;
}

//排序
- (void) updateNameSortIndex {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSMutableArray *descriptors = [NSMutableArray arrayWithObject:descriptor];
    NSArray *resultArray = [_keyArray sortedArrayUsingDescriptors:descriptors];
    [_keyArray removeAllObjects];
    [_keyArray addObjectsFromArray:resultArray];
}

//获取组内项的数量
- (NSInteger) getItemCountByKey:(NSString *) key {
    NSInteger count = 0;
    if(_indexDic ) {
        NSMutableArray * indexArray = [_indexDic valueForKeyPath:key];
        count = [indexArray count];
    }
    return count;
}

//根据组和位置来获取索引，既需要展示的数据所在的位置
- (NSInteger) getIndexByGroup:(NSInteger) groupIndex andPosition:(NSInteger) position {
    NSInteger index = INDEX_UNKNOW;
    NSString * key = [self getGroupNameAtIndex:groupIndex];
    if(key && _indexDic) {
        NSMutableArray * indexArray = [_indexDic valueForKeyPath:key];
        NSNumber * tmpNumber = indexArray[position];
        index = tmpNumber.integerValue;
    }
    return index;
}

//设置需要建立索引的数据信息
- (void) setDataWithArray:(NSMutableArray *) array {
    _dataArray = [array copy];
    [self generateIndexTable];
}

#pragma mark - 分拣数据
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
    if(_dataArray) {
        NSInteger index = 0;
        NSInteger count = [_dataArray count];
        for(index = 0; index<count; index++) {
            NSString * data = _dataArray[index];
            if(![self isData:data matchWithFilter:_filter]) {
                continue;
            }
            NSString * key = [self getKeyOfString:data];
            NSMutableArray * indexTable;
            if(![self isKeyExist:key]) {
                [_keyArray addObject:key];
                indexTable = [[NSMutableArray alloc] init];
                [_indexDic setValue:indexTable forKeyPath:key];
            } else {
                indexTable = [_indexDic valueForKeyPath:key];
            }
            [indexTable addObject:[NSNumber numberWithInteger:index]];
        }
        [self updateNameSortIndex];
    }
    
}

//获取字符串数据所属的索引项
- (NSString *) getKeyOfString:(NSString *) data {
    NSString * key = [[FMUtils getFirstCharactorOf:data] uppercaseString];
    return key;
}

//判断key 是否存在
- (BOOL) isKeyExist:(NSString *) key {
    BOOL exist = NO;
    for(NSString * str in _keyArray) {
        if([str isEqualToString:key]) {
            exist = YES;
            break;
        }
    }
    return exist;
}

//设置过滤器
- (void) setFilter:(NSString *) filter {
    _filter = filter;
    [self generateIndexTable];
}

//判断数据是否满足条件
- (BOOL) isData:(NSString *) data matchWithFilter:(NSString *) filter {
    BOOL res = NO;
    if([FMUtils isStringEmpty:filter]) {
        res = YES;
    }
    //判断是否形如 “创新园”
    if(!res && [data containsString:filter]) {  //如果包含该字符串则满足条件
        res = YES;
    }
    if(!res) {  //判断是否形如 “chuangxinyuan”
        NSString * pinyin = [FMUtils getPinYinOf:data];
        pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * tmpFilter = [filter stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([pinyin containsString:[tmpFilter lowercaseString]]) {
            res = YES;
        }
    }
    if(!res) {  //判断是否形如 “CXY”
        NSString * firstCh = [FMUtils getFirstCharactorSpellOf:data];
        if([firstCh containsString:[filter lowercaseString]]) {
            res = YES;
        }
    }
    
    return res;
}




@end
