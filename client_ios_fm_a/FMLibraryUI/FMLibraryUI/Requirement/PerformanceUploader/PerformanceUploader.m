//
//  PerformanceUploader.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "PerformanceUploader.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "SystemConfig.h"
#import "FMUtilsPackages.h"

static PerformanceUploader * instance = nil;

NSString * const PREFORMANCE_FILE_UPLOAD_URL_IMAGE = @"/m/v1/files/upload/picture";
NSString * const PREFORMANCE_FILE_UPLOAD_URL_AUDIO = @"/m/v1/files/upload/voicemedia";
NSString * const PREFORMANCE_FILE_UPLOAD_URL_VIDEO = @"/m/v1/files/upload/videomedia";
NSString * const PREFORMANCE_FILE_UPLOAD_URL_FILE = @"/m/v1/files/upload/attachment";   //附件


@implementation PerformanceFile
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
    }
    return self;
}
@end


@implementation PerformanceFileResult

@end


@implementation PerformanceUploader

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[PerformanceUploader alloc] init];
    }
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (SingleUploadBlock) SingleUploader {
    if (!_SingleUploader) {
        __weak id weakSelf = self;
        __block NSMutableArray * array = [NSMutableArray new];
        _SingleUploader = ^(NSMutableArray *dataArray, PerformanceFileUploadType fileType){
            switch (fileType) {
                case PERFORMANCE_FILE_TYPE_IMAGE:
                    array = [weakSelf uploadImageFiles:dataArray];
                    break;
                    
                case PERFORMANCE_FILE_TYPE_AUDIO:
                    break;
                    
                case PERFORMANCE_FILE_TYPE_VIDEO:
                    break;
                    
                case PERFORMANCE_FILE_TYPE_COMMON:
                    break;
                default:
                    break;
            }
            
            return array;
        };
    }
    return _SingleUploader;
}



- (GroupUploadBlock)GroupUploader {
    if (!_GroupUploader) {
        _GroupUploader = ^(NSMutableArray <PerformanceFile *> *dataArray, PerformanceFileUploadType fileType) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dataArray];
            return array;
        };
    }
    return _GroupUploader;
}


- (NSMutableArray <NSNumber *> *)uploadSingeFile:(NSMutableArray *) data andType:(PerformanceFileUploadType) fileType {
    NSMutableArray *fileIdArray = [NSMutableArray new];
    
    
    return fileIdArray;
}


//图片上传
- (NSMutableArray *) uploadImageFiles:(NSArray*) imgs {
    __block NSMutableArray *resultArray;
    if (!resultArray) {
        resultArray = [NSMutableArray new];
    } else {
        [resultArray removeAllObjects];
    }
    
    NSError * error = nil;
    NSString * url = [self getUploadUrlByType:PERFORMANCE_FILE_TYPE_IMAGE];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSInteger index = 0;
        for(UIImage* image in imgs) {
            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
            NSString* filename = [[NSString alloc] initWithFormat:@"image%ld.jpg", index];
            NSData * data = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:@"image/jpeg"];
            index++;
        }
    } error:&error];
    
    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
    [request setValue:@"android" forHTTPHeaderField:@"Device-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"upload failed");
        } else {
            NSLog(@"upload success");
            NSNumber *imgId = (NSNumber *) responseObject;
            [resultArray addObject:imgId];
        }
    }];
    [uploadTask resume];
    return resultArray;
}

//音频上传
- (void) uploadAudioFiles:(NSArray*) audios {
    
}

//视频上传
- (void) uploadMediaFiles:(NSArray*) medias {
    
}

- (NSString *) getUploadUrlByType:(PerformanceFileUploadType) type{
    NSString * url = nil;
    NSString * mainUrl = @"";
    switch (type) {
        case PERFORMANCE_FILE_TYPE_IMAGE:
            mainUrl = PREFORMANCE_FILE_UPLOAD_URL_IMAGE;
            break;
        case PERFORMANCE_FILE_TYPE_AUDIO:
            mainUrl = PREFORMANCE_FILE_UPLOAD_URL_AUDIO;
            break;
        case PERFORMANCE_FILE_TYPE_VIDEO:
            mainUrl = PREFORMANCE_FILE_UPLOAD_URL_VIDEO;
            break;
        default:
            mainUrl = PREFORMANCE_FILE_UPLOAD_URL_FILE;
            break;
    }
    url = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], mainUrl, [[SystemConfig getOauthFM] getToken].mAccessToken];
    return url;
}

@end
