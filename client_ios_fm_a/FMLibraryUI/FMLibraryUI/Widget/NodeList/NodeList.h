//
//  NodeList.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+pinyin.h"

extern NSInteger const PARENT_ID_ROOT;

extern NSInteger const LEVEL_ROOT;
extern NSInteger const LEVEL_DEFAULT;
extern NSInteger const LEVEL_LEAF;
extern NSInteger const LEVEL_UNKNOW;

extern NSInteger const FILTER_TYPE_KEY;                        //按  key 过滤
extern NSInteger const FILTER_TYPE_NAME_FIRST_LETTER;          //按名字的首字母过滤
extern NSInteger const FILTER_TYPE_DESC_FIRST_LETTER;          //按描述的首字母过滤
extern NSInteger const FILTER_TYPE_NAME_OR_DESC_FIRST_LETTER;  //按名字或者描述的首字母过滤

#pragma mark - 模糊搜索服务
@interface NodeFilterItem : NSObject
@property (nonatomic, copy) NSString *name;             //搜索名字
@property (nonatomic, copy) NSString *namePinyin;       //搜索名字的拼音，应该在获取的时候就转为拼音
@property (nonatomic, copy) NSString *nameAcronyms;     //搜索名字的首字母缩写
@property (nonatomic, strong) id identification;        //要搜索的东西的唯一标识
@end

@interface NodeItem : NSObject
- (instancetype) init;
- (instancetype) initWith:(NSInteger) parent key:(NSInteger) key value:(NSString*) value;
- (instancetype) initWith:(NSInteger) parent key:(NSInteger) key value:(NSString*) value desc:(NSString*) desc;
- (instancetype) initWith:(NSInteger) parent key:(NSInteger) key value:(NSString*) value level:(NSInteger) level;
- (instancetype) initWith:(NSInteger) key value:(NSString*) value;
- (instancetype) initWith:(NSInteger) key value:(NSString*) value level:(NSInteger) level;

- (NSInteger) getParentKey;
- (void) setParentKey:(NSInteger) pKey;
- (NSInteger) getKey;
- (void) setKey:(NSInteger) key;
- (NSString*) getVal;
- (void) setVal:(NSString*) value;
- (NSInteger) getLevel;
- (void) setLevel:(NSInteger) level;
- (NSString*) getDesc;
- (void) setDesc:(NSString*) value;
+ (NSInteger) getParentIdOfRoot;
+ (NSInteger) getParentLevelOfRoot;
@end

@interface NodeList : NSObject

@property (readwrite, nonatomic, strong) NSString* desc;
@property (readwrite, nonatomic, strong) NSMutableArray* list;
@property (readwrite, nonatomic, strong) NSMutableArray* levelList;

- (instancetype) init;
- (void) initList;
- (NSInteger) getCount;
- (NSInteger) getLevelCount;
- (void) clear;
- (void) setDesc:(NSString *)desc;
- (void) addNode:(NodeItem *) item;
- (void) addNodeLevel:(NSInteger) level;
- (void) addNodeLevel:(NSInteger)level parent:(NSInteger) parentLevel;
- (NSInteger) getParentLevel:(NSInteger) level;
- (NSInteger) getChildrenLevel:(NSInteger) level;
- (NSInteger) getRootLevel;
- (BOOL) nodeExist:(NodeItem *) item;
- (BOOL) nodeExistByKey:(NSInteger) key;
- (NodeItem*) getNodeByKey:(NSInteger) key andLevel:(NSInteger) level;
- (NodeItem*) getNodeByPosition:(NSInteger) position;
- (NSMutableArray*) getChildren:(NSInteger) parent level:(NSInteger) level;
- (NSMutableArray*) getChildrenByFilter:(NSInteger) parent filterType:(NSInteger) filterType filter:(NSString*) strFilter level:(NSInteger) level;
- (NSMutableArray*) getRootChildren;
@end
