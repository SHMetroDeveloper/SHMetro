//
//  FMCache.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/20.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FMCache.h"
#import "FMUtils.h"
#import "SDImageCache.h"

#import "BaseDataDbHelper.h"
#import "PatrolDBHelper.h"
#import "NotificationDbHelper.h"

#import "BaseDataDownloader.h"
#import "SystemConfig.h"

static FMCache * instance;


@interface FMCache () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) NSString * path;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation FMCache

- (instancetype) init {
    self = [super init];
    if(self) {
        _path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[FMCache alloc] init];
    }
    return instance;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener {
    _handler = listener;
}

- (NSPredicate *) getPredicateByType:(FMCacheType) type {
    NSPredicate * predicate;
    
    switch(type) {
        case FM_CACHE_TYPE_ALL: //默认清除所有的跟清除文件一致
        case FM_CACHE_TYPE_FILE:
            predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH[cd] '.png' or self ENDSWITH[cd] '.jpg' or self ENDSWITH[cd] '.amr' or self ENDSWITH[cd] '.mp3' or self ENDSWITH[cd] '.MOV' or self ENDSWITH[cd] '.mov'"];
            break;
        case FM_CACHE_TYPE_IMG:
            predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH[cd] '.png'"];
            break;
        case FM_CACHE_TYPE_AUDIO:
            predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH[cd] '.mp3' or self ENDSWITH[cd] '.amr'"];
            break;
        case FM_CACHE_TYPE_VIDEO:
            predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH[cd] '.mov'"];
            break;
        case FM_CACHE_TYPE_BASE_DATA:
            break;
        case FM_CACHE_TYPE_NET_IMG:
            break;
        case FM_CACHE_TYPE_USER_PREFERENCE:
            break;
        case FM_CACHE_TYPE_USER_NOTIFICATION:
            break;
        default:
            break;
    }
    return predicate;
}

//获取所有缓存的总大小
- (float) getAllCacheSize {
    float cacheSize = 0;
    NSPredicate * predicate = [self getPredicateByType:FM_CACHE_TYPE_ALL];
    cacheSize = [FMUtils folderSizeAtPath:_path withPredicate:predicate];
    return cacheSize;
}

//获取所有缓存文件的总大小
- (float) getFileCacheSize {
    float cacheSize = 0;
    NSPredicate * predicate = [self getPredicateByType:FM_CACHE_TYPE_FILE];
    cacheSize = [FMUtils folderSizeAtPath:_path withPredicate:predicate];
    return cacheSize;
}

//获取图片缓存大小
- (float) getImgCacheSize {
    float cacheSize = 0;
    NSPredicate * predicate = [self getPredicateByType:FM_CACHE_TYPE_IMG];
    cacheSize = [FMUtils folderSizeAtPath:_path withPredicate:predicate];
    return cacheSize;
}

//获取音频缓存大小
- (float) getAudioCacheSize {
    float cacheSize = 0;
    NSPredicate * predicate = [self getPredicateByType:FM_CACHE_TYPE_AUDIO];
    cacheSize = [FMUtils folderSizeAtPath:_path withPredicate:predicate];
    return cacheSize;
}

//获取视频缓存大小
- (float) getVideoCacheSize {
    float cacheSize = 0;
    NSPredicate * predicate = [self getPredicateByType:FM_CACHE_TYPE_VIDEO];
    cacheSize = [FMUtils folderSizeAtPath:_path withPredicate:predicate];
    return cacheSize;
}

- (float) getSDImageCacheSize {
    float cacheSize = 0;
    //SDWebImage框架自身计算缓存的实现
    cacheSize += [[SDImageCache sharedImageCache] getSize] / 1024.0;
    return cacheSize;
}

//获取基础数据大小
- (float) getBaseDataCacheSize {
    float cacheSize = 0;
    return cacheSize;
}

//获取个人配置缓存大小
- (float) getPreferenceCacheSize {
    float cacheSize = 0;
    return cacheSize;
}

//获取指定类型的缓存的大小
- (float) getCacheSizeByType:(FMCacheType) type {
    float cacheSize = 0;
    return cacheSize;
}


- (void) clearCacheSizeByType:(FMCacheType) type {
    BOOL isFile = NO;
    switch (type) {
        case FM_CACHE_TYPE_IMG:
            isFile = YES;
            break;
        case FM_CACHE_TYPE_AUDIO:
            isFile = YES;
            break;
        case FM_CACHE_TYPE_VIDEO:
            isFile = YES;
            break;
        case FM_CACHE_TYPE_FILE:
            isFile = YES;
            break;
        
        case FM_CACHE_TYPE_BASE_DATA:
            [[BaseDataDownloader getInstance] setTaskListener:self withType:BASE_TASK_TYPE_CLEAR_BASE_DATA];
            [[BaseDataDownloader getInstance] clearBaseData];
            break;
        case FM_CACHE_TYPE_USER_NOTIFICATION:
            [[NotificationDbHelper getInstance] deleteAllNotificationOfCurrentUser];
            [self notifyDataCleared:type];
            break;
        case FM_CACHE_TYPE_PATROL_TASK:
            [[LocalTaskManager getInstance] setTaskListener:self withType:BASE_TASK_TYPE_CLEAR_PATROL_TASK];
            [[LocalTaskManager getInstance] clearPatrolTaskOfCurrentUser];
            break;
            
        case FM_CACHE_TYPE_USER_PREFERENCE:
            [SystemConfig clearCurrentUserSetting];
            [self notifyDataCleared:type];
            break;
            
        default:
            break;
    }
    if(isFile) {    //清除文件数据
        NSPredicate * predicate = [self getPredicateByType:type];
        [FMUtils clearFile:_path withPredicate:predicate];
        [self notifyDataCleared:type];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([BaseDataDownloader class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"taskType"];
            BaseTaskType taskType = [tmpNumber integerValue];
            
            tmpNumber = [msg valueForKeyPath:@"taskStatus"];
            BaseTaskStatus taskStatus = [tmpNumber integerValue];
            
            switch (taskType) {
                case BASE_TASK_TYPE_CLEAR_PATROL_TASK:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        [self notifyDataCleared:FM_CACHE_TYPE_PATROL_TASK];
                    }
                    break;
                case BASE_TASK_TYPE_CLEAR_BASE_DATA:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        [self notifyDataCleared:FM_CACHE_TYPE_BASE_DATA];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void) notifyDataCleared:(FMCacheType) type {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"resultType"];
        [msg setValue:[NSNumber numberWithBool:YES] forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
    
}

@end
