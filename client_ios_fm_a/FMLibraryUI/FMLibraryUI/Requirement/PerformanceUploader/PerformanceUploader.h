//
//  PerformanceUploader.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PerformanceFileUploadType) {
    PERFORMANCE_FILE_TYPE_COMMON,   //普通文件
    PERFORMANCE_FILE_TYPE_IMAGE,    //图片
    PERFORMANCE_FILE_TYPE_AUDIO,    //音频文件
    PERFORMANCE_FILE_TYPE_VIDEO,    //视频文件
    PERFORMANCE_FILE_TYPE_VIDEO_SHORT,  //视频流
};


@interface PerformanceFile : NSObject
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) PerformanceFileUploadType *fileType;
@end

@interface PerformanceFileResult : NSObject
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, assign) PerformanceFileUploadType *fileType;
@end


//定义两种block
typedef NSMutableArray<NSNumber *> *(^SingleUploadBlock)(NSMutableArray *dataArray, PerformanceFileUploadType fileType);

typedef NSMutableArray<PerformanceFileResult *> *(^GroupUploadBlock)(NSMutableArray <PerformanceFile *> *dataArray, PerformanceFileUploadType fileType);


@interface PerformanceUploader : NSObject

+ (instancetype) getInstance;

@property (nonatomic, copy) SingleUploadBlock SingleUploader;
@property (nonatomic, copy) GroupUploadBlock GroupUploader;

@end



