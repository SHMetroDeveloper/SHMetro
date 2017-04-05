//
//  UploadService.h
//  hello
//
//  Created by 杨帆 on 15/4/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileUploadListener.h"

typedef NS_ENUM(NSInteger, FileUploadType) {
    FILE_TYPE_COMMON,   //普通文件
    FILE_TYPE_IMAGE,    //图片
    FILE_TYPE_AUDIO,    //音频文件
    FILE_TYPE_VIDEO,    //视频文件
    FILE_TYPE_VIDEO_SHORT,  //视频流
};

@interface FileUploadService : NSObject

+ (instancetype) getInstance;

/**
 * 上传图片到指定路径
 * @param: url  ------  上传路径
 * @param: files------  图片数组(UIImage对象数组)
 * @listener: 监听器，用于回调处理图片上传结果
 *
 */
//- (void) uploadImageFiles:(NSString*) url  images:(NSArray*) imgs listener: (NSObject <FileUploadListener> *) listener;

//上传图片
- (void) uploadImageFiles:(NSArray*) imgs listener: (id <FileUploadListener>) listener;

//上传音频文件
- (void) uploadAudioFiles:(NSArray*) audios listener: (id <FileUploadListener>) listener;

//上传视频文件
- (void) uploadVideoFiles:(NSArray*) videos listener: (id <FileUploadListener>) listener;

/**
 * 上传图片到指定路径
 * @param: url  ------  上传路径
 * @param: files------  文件路径数组(存储文件的 fullPath)
 * @param: type ------  文件类型(FileUploadType)
 * @listener: 监听器，用于回调处理图片上传结果
 *
 */

// 方法1 --------用于上传.mp3
- (void) uploadMp3Files: (NSString*) url
                  files: (NSArray*) filePathArray
                   type: (FileUploadType) fileType
               listener: (NSObject <FileUploadListener> *) listener;

// 方法2 ---------用于上传.mov
- (void) uploadVideoFiles:(NSString*) url
                    files:(NSArray*) filePathArray
                     type:(FileUploadType) fileType
                 listener: (NSObject <FileUploadListener> *) listener;

// 方法3 ---------用于上传
- (void) uploadFiles: (NSString *) url
       filesUrlArray: (NSArray*) fileUrlArray
                type: (FileUploadType) fileType
            listener: (NSObject <FileUploadListener> *) listener;
@end






