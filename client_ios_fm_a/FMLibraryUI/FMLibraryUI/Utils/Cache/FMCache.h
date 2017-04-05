//
//  FMCache.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/20.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, FMCacheType) {
    FM_CACHE_TYPE_ALL,    //所有缓存
    FM_CACHE_TYPE_IMG,    //图片
    FM_CACHE_TYPE_AUDIO,  //音频
    FM_CACHE_TYPE_VIDEO,  //视频
    FM_CACHE_TYPE_FILE,  //图片 + 音频 + 视频
    FM_CACHE_TYPE_BASE_DATA,     //基础数据
    FM_CACHE_TYPE_NET_IMG,     //网络图片缓存
    FM_CACHE_TYPE_USER_PREFERENCE,  //个人配置
    FM_CACHE_TYPE_USER_NOTIFICATION,  //个人推送记录
    FM_CACHE_TYPE_PATROL_TASK,  //巡检任务
};

@interface FMCache : NSObject

- (instancetype) init;
+ (instancetype) getInstance;

//获取所有缓存的总大小,单位为 KB
- (float) getAllCacheSize;

//获取所有缓存文件的总大小
- (float) getFileCacheSize;

//获取图片缓存大小,单位为 KB
- (float) getImgCacheSize;

//获取音频缓存大小,单位为 KB
- (float) getAudioCacheSize;

//获取视频缓存大小,单位为 KB
- (float) getVideoCacheSize;

//获取网络缓存图片数据大小,单位为 KB
- (float) getSDImageCacheSize;

//获取基础数据大小,单位为 KB
- (float) getBaseDataCacheSize;

//获取个人配置缓存大小,单位为 KB
- (float) getPreferenceCacheSize;


//获取指定类型的缓存数据大小,单位为 KB
- (float) getCacheSizeByType:(FMCacheType) type;

//清除指定类型的缓存的数据
- (void) clearCacheSizeByType:(FMCacheType) type;

//设置事件监听处理
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener;

@end
