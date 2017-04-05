//
//  NodeList.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//

#import "NodeList.h"
#import "FMUtils.h"

NSInteger const PARENT_ID_ROOT = -1;

NSInteger const LEVEL_ROOT = -1;
NSInteger const LEVEL_DEFAULT = 0;
NSInteger const LEVEL_LEAF = 0x10000;
NSInteger const LEVEL_UNKNOW = -2;

NSInteger const FILTER_TYPE_KEY = 0x100;                        //按  key 过滤
NSInteger const FILTER_TYPE_NAME_FIRST_LETTER = 0x200;          //按名字的首字母过滤
NSInteger const FILTER_TYPE_DESC_FIRST_LETTER = 0x300;          //按描述的首字母过滤
NSInteger const FILTER_TYPE_NAME_OR_DESC_FIRST_LETTER = 0x400;  //按名字或者描述的首字母过滤


@implementation NodeFilterItem
@end

@interface NodeItem ()

@property (readwrite, nonatomic, assign) NSInteger lParentKey;  //父节点ID
@property (readwrite, nonatomic, assign) NSInteger lkey;        //节点 ID
@property (readwrite, nonatomic, strong) NSString* value;         //节点值，描述
@property (readwrite, nonatomic, strong) NSString* desc;        //节点值，附带说明，辅助用
@property (readwrite, nonatomic, assign) NSInteger level;       //级别，辅助用

@end

@implementation NodeItem

- (instancetype) init {
    self = [super init];
    if(self) {
        _lParentKey = PARENT_ID_ROOT;
        _value = @"没有数据";
        _level = LEVEL_UNKNOW;
    }
    return self;
}

- (instancetype) initWith:(NSInteger) parent
                      key:(NSInteger) key
                    value:(NSString*) value {
    self = [super init];
    if(self) {
        if(parent == 0) {
            _lParentKey = PARENT_ID_ROOT;
        } else {
            _lParentKey = parent;
        }
        if(key == 0) {
            _lkey = PARENT_ID_ROOT;
        } else {
            _lkey = key;
        }
        _value = value;
        _level = LEVEL_DEFAULT;
        _desc = @"";
    }
    return self;
    
}
- (instancetype) initWith:(NSInteger) parent
                      key:(NSInteger) key
                    value:(NSString*) value
                     desc:(NSString*) desc {
    self = [super init];
    if(self) {
        if(parent == 0) {
            _lParentKey = PARENT_ID_ROOT;
        } else {
            _lParentKey = parent;
        }
        if(key == 0) {
            _lkey = PARENT_ID_ROOT;
        } else {
            _lkey = key;
        }
        _value = value;
        _level = LEVEL_DEFAULT;
        _desc = desc;
    }
    return self;
}
- (instancetype) initWith:(NSInteger) parent
                      key:(NSInteger) key
                    value:(NSString*) value
                    level:(NSInteger) level {
    self = [super init];
    if(self) {
        if(parent == 0) {
            _lParentKey = PARENT_ID_ROOT;
        } else {
            _lParentKey = parent;
        }
        if(key == 0) {
            _lkey = PARENT_ID_ROOT;
        } else {
            _lkey = key;
        }
        _value = value;
        _level = level;
        _desc = @"";
    }
    return self;
}
- (instancetype) initWith:(NSInteger) key
                    value:(NSString*) value {
    self = [super init];
    if(self) {
        _lParentKey = PARENT_ID_ROOT;
        if(key == 0) {
            _lkey = PARENT_ID_ROOT;
        } else {
            _lkey = key;
        }
        _value = value;
        _level = LEVEL_DEFAULT;
        _desc = @"";
    }
    return self;
}
- (instancetype) initWith:(NSInteger) key
                    value:(NSString*) value
                    level:(NSInteger) level {
    self = [super init];
    if(self) {
        _lParentKey = PARENT_ID_ROOT;
//        if(key == 0) {
//            _lkey = PARENT_ID_ROOT;
//        } else {
//            _lkey = key;
//        }
        
        _lkey = key;
        
        _value = value;
        _level = level;
        _desc = @"";
    }
    return self;
}

- (NSInteger) getParentKey {
    return _lParentKey;
}
- (void) setParentKey:(NSInteger) pKey {
    _lParentKey = pKey;
}
- (NSInteger) getKey {
    return _lkey;
}
- (void) setKey:(NSInteger) key {
    _lkey = key;
}
- (NSString*) getVal {
    return _value;
}
- (void) setVal:(NSString*) value {
    _value = value;
}
- (NSInteger) getLevel {
    return _level;
}
- (void) setLevel:(NSInteger) level {
    _level = level;
}
- (NSString*) getDesc {
    return _desc;
}
- (void) setDesc:(NSString*) desc {
    _desc = desc;
}
+ (NSInteger) getParentIdOfRoot {
    return PARENT_ID_ROOT;
}
+ (NSInteger) getParentLevelOfRoot {
    return LEVEL_ROOT;
}

@end



//
@implementation NodeList

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initList];
    }
    return self;
}

- (void) initList {
    if(_list) {
        [_list removeAllObjects];
    } else {
        _list = [[NSMutableArray alloc] init];
    }
    if(_levelList) {
        [_levelList removeAllObjects];
    } else {
        _levelList = [[NSMutableArray alloc] init];
    }
    NSNumber * defaultLevel = [[NSNumber alloc] initWithInt:LEVEL_DEFAULT];
    [_levelList addObject:defaultLevel];
}
- (NSInteger) getCount {
    if(_list) {
        return [_list count];
    } else {
        return 0;
    }
}
- (NSInteger) getLevelCount {
    if(_levelList) {
        return [_levelList count];
    } else {
        return 0;
    }
}
- (void) clear {
    if(_list) {
        [_list removeAllObjects];
    }
}
- (void) setDesc:(NSString *)desc {
    _desc = desc;
}

- (void) addNodeByKey:(NSInteger) key node:(NodeItem*) node {
    [_list addObject:node];
}

- (void) addNode:(NodeItem *) item {
    if(![self nodeExist:item]) {
        [self addNodeByKey:item.lkey node:item];
    }
}
- (void) addNodeLevel:(NSInteger) level {
    NSNumber * objLevel = [[NSNumber alloc] initWithLong:level];
    if(!_levelList) {
        _levelList = [[NSMutableArray alloc] init];
    }
    if([_levelList count] == 0) {
        [_levelList addObject:objLevel];
    } else {
        [_levelList replaceObjectAtIndex:0 withObject:objLevel];
    }
}

- (NSInteger) getLevelDepth:(NSInteger) level {
    NSInteger res = -1;
    NSInteger count = [_levelList count];
    NSInteger i = 0;
    
    for(i=0;i<count;i++) {
        NSNumber * objLevel = _levelList[i];
        if(objLevel.intValue == level) {
            res = i;
            break;
        }
    }
    return res;
}

- (BOOL) levelExist:(NSInteger) level {
    BOOL res = NO;
    for(NSNumber * objLevel in _levelList) {
        if(objLevel.intValue == level) {
            res = YES;
            break;
        }
    }
    return res;
}

- (BOOL) levelDepthExist:(NSInteger) depth {
    BOOL res = NO;
    NSInteger count = [_levelList count];
    if(depth >=0 && depth < count) {
        res = YES;
    }
    return res;
}

- (void) addNodeLevel:(NSInteger)level parent:(NSInteger) parentLevel {
    NSInteger pos = [self getLevelDepth:parentLevel];
    NSNumber * objLevel = [[NSNumber alloc] initWithLong:level];
    if(![self levelExist:level]) {
        pos++;
        if([self levelDepthExist:pos]) {
            [_levelList replaceObjectAtIndex:pos withObject:objLevel];
        } else {
            [_levelList addObject:objLevel];
        }
    }
}
- (NSInteger) getParentLevel:(NSInteger) level {
    NSInteger res = 0;
    NSNumber * obj = nil;
    if(level == LEVEL_ROOT) {
        res = LEVEL_ROOT;
    }
    NSInteger depth = [self getLevelDepth:level];
    NSInteger count = [_levelList count];
    depth--;
    if(level == LEVEL_LEAF) {
        if(count > 0) {
            depth = count - 1;
        } else {
            res = LEVEL_ROOT;
            return res;
        }
        
    }
    if(depth < 0) {
        res = LEVEL_ROOT;
    } else {
        if(count > 0 && count > depth) {
            obj = [_levelList objectAtIndex:depth];
            res = [obj intValue];
        } else {
            res = LEVEL_UNKNOW;
        }
    }
    return res;
}
- (NSInteger) getChildrenLevel:(NSInteger) level {
    NSInteger res = 0;
    NSNumber * obj = nil;
    if(level == LEVEL_LEAF) {
        res = LEVEL_LEAF;
    }
    NSInteger depth = [self getLevelDepth:level];
    NSInteger count = [_levelList count];
    depth++;
    if(level == LEVEL_ROOT) {
        if(count > 0) {
            depth = 0;
        } else {
            res = LEVEL_LEAF;
            return res;
        }
    }
    if(depth >= count) {
        res = LEVEL_LEAF;
    } else {
        if(count >= 0 && count > depth) {
            obj = [_levelList objectAtIndex:depth];
            res = [obj intValue];
        } else {
            res = LEVEL_UNKNOW;
        }
    }
    return res;
}
- (NSInteger) getRootLevel {
    NSInteger res = LEVEL_ROOT;
    NSInteger count = [_levelList count];
    if(count > 0) {
        res = [[_levelList objectAtIndex:0] intValue];
    }
    return res;
}



//判断节点是否存在
- (BOOL) nodeExist:(NodeItem *) item {
    BOOL res = [self nodeExistByKey:item.lkey parent:item.lParentKey];
    return res;
}

- (BOOL) nodeExistByKey:(NSInteger) key parent:(NSInteger) parentKey{
    BOOL res = false;
    for(NodeItem* node  in _list) {
        if(node.getKey == key && node.lParentKey == parentKey) {
            res = true;
            break;
        }
    }
    return res;
}
- (NodeItem*) getNodeByKey:(NSInteger) key andLevel:(NSInteger) level {
    NodeItem * res = nil;
    for(NodeItem* node  in _list) {
        if(node.lkey == key && node.level == level) {
            res = node;
            break;
        }
    }
    return res;
}
- (NodeItem*) getNodeByPosition:(NSInteger) position {
    NodeItem * res = nil;
    NSInteger count = [_list count];
    if(position >= 0 && position < count) {
        res = [_list objectAtIndex:position];
    }
    return res;
}
- (NSMutableArray*) getChildren:(NSInteger) parent level:(NSInteger) level {
    NSMutableArray* children = [[NSMutableArray alloc] init];
    for(NodeItem* node  in _list) {
        if(node.lParentKey == parent && node.level == level) {
            [children addObject:node];
        }
    }
    return children;
}

/** 判断节点的 value 数据是否符合精确匹配条件 **/
- (BOOL) isItemValueBeginWith:(NodeItem*) item filter:(NSString*) filter {
    BOOL res = NO;
    if(item && [item.value hasPrefix:filter]) {
        res = YES;
    }
    return res;
}

/** 判断节点的 value 数据是否符合精确匹配条件 **/
- (BOOL) isItemDescBeginWith:(NodeItem*) item filter:(NSString*) filter {
    BOOL res = NO;
    if(item && [item.desc hasPrefix:filter]) {
        res = YES;
    }
    return res;
}

/** 判断节点的 value 或者 desc 数据是否符合精确匹配条件 **/
- (BOOL) isItemValueOrDescBeginWith:(NodeItem*) item filter:(NSString*) filter {
    BOOL res = NO;
    NodeFilterItem *nodeFiter = [[NodeFilterItem alloc] init];  //为模糊搜索做准备
    nodeFiter.name = item.value;
    nodeFiter.namePinyin = [item.value transformToPinyin];
    nodeFiter.nameAcronyms = [item.value transformToPinyinFirstLetter];
    NSString *key = filter.lowercaseString;
    //以防万一在这里再转换小写一次
    NSString *name = nodeFiter.name.lowercaseString;
    NSString *namePinyin = nodeFiter.namePinyin.lowercaseString;
    NSString *nameAcronyms = nodeFiter.nameAcronyms.lowercaseString;
    
    NSRange rang1 = [name rangeOfString:key];
    if (rang1.length>0) {
        res = YES;
    } else {
        if ([nameAcronyms containsString:key]) {
            res = YES;
        } else {
            if ([nameAcronyms containsString:[key substringToIndex:1]]) {
                if ([namePinyin containsString:key] ) {
                    res = YES;
                }
            }
        }
    }
//    if(item && ([item.value hasPrefix:filter] || [item.desc hasPrefix:filter])) {
//        res = YES;
//    }
    if(!res && item && ([item.value containsString:filter] || [item.desc containsString:filter])) {
        res = YES;
    }
    return res;
}

- (BOOL) isItemBeginWith:(NodeItem*) item filterType:(NSInteger) filterType filter:(NSString*) filter{
    BOOL res = NO;
    switch(filterType) {
        case FILTER_TYPE_NAME_FIRST_LETTER:
            res = [self isItemValueBeginWith:item filter:filter];
            break;
        case FILTER_TYPE_DESC_FIRST_LETTER:
            res = [self isItemDescBeginWith:item filter:filter];
            break;
        case FILTER_TYPE_NAME_OR_DESC_FIRST_LETTER:
            res = [self isItemValueOrDescBeginWith:item filter:filter];
            break;
    }
    return res;
}

/** 判断节点是否符合指定类型的过滤条件 **/
- (BOOL) isItemOK:(NodeItem*) item filterType:(NSInteger) filterType filter:(NSString*) filter {
    BOOL res = NO;
    
    return res;
}

- (NSMutableArray*) getChildrenByFilter:(NSInteger) parent filterType:(NSInteger) filterType filter:(NSString*) strFilter level:(NSInteger) level {
    NSMutableArray* children = [[NSMutableArray alloc] init];
    NSInteger count = [self getCount];
    NSInteger i =0;
    for(i=0;i<count;i++) {
        NodeItem * node = _list[i];
        if(parent == [node getParentKey] && level == [node getLevel] && [self isItemBeginWith:node filterType:filterType filter:strFilter]) {
            [children addObject:node];
        }
    }
    return children;
}
- (NSMutableArray*) getRootChildren {
    NSMutableArray* children = [[NSMutableArray alloc] init];
    for(NodeItem * node in _list) {
        if([node getParentKey] == [NodeItem getParentLevelOfRoot]) {
            [children addObject:node];
        }
    }
    return children;
}

@end
