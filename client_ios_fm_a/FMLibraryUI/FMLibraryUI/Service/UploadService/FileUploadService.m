//
//  UploadService.m
//  hello
//
//  Created by 杨帆 on 15/4/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FileUploadService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "FileUploadResponse.h"



static FileUploadService * instance = nil;

NSString * const FILE_UPLOAD_URL_IMAGE = @"/m/v1/files/upload/picture";
NSString * const FILE_UPLOAD_URL_AUDIO = @"/m/v1/files/upload/voicemedia";
NSString * const FILE_UPLOAD_URL_VIDEO = @"/m/v1/files/upload/videomedia";
NSString * const FILE_UPLOAD_URL_FILE = @"/m/v1/files/upload/attachment";   //附件



@implementation FileUploadService

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[FileUploadService alloc] init];
    }
    return instance;
}

- (NSString *) getUploadUrlByType:(FileUploadType) type{
    NSString * url = nil;
    NSString * mainUrl = @"";
    switch (type) {
        case FILE_TYPE_IMAGE:
            mainUrl = FILE_UPLOAD_URL_IMAGE;
            break;
        case FILE_TYPE_AUDIO:
            mainUrl = FILE_UPLOAD_URL_AUDIO;
            break;
        case FILE_TYPE_VIDEO:
            mainUrl = FILE_UPLOAD_URL_VIDEO;
            break;
        default:
            mainUrl = FILE_UPLOAD_URL_FILE;
            break;
    }
    url = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], mainUrl, [[SystemConfig getOauthFM] getToken].mAccessToken];
    return url;
}

- (NSString *) getMimeTypeByType:(FileUploadType) type {
    NSString * mime = @"";
    switch (type) {
        case FILE_TYPE_IMAGE:
            mime = @"image/png";
            break;
        case FILE_TYPE_AUDIO:
            mime = @"audio/mp3";
            break;
        case FILE_TYPE_VIDEO:
            mime = @"video/mpeg";
            break;
        default:
            mime = FILE_UPLOAD_URL_FILE;
            break;
    }
    return mime;
}

//- (void) uploadImageFiles:(NSString*) url  images:(NSArray*) imgs listener: (NSObject <FileUploadListener> *) listener{
//    NSError * error = nil;
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        NSInteger index = 0;
//        for(UIImage* image in imgs) {
//            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
//            NSString* filename = [[NSString alloc] initWithFormat:@"image%ld.jpg", index];
//            NSData * data = UIImageJPEGRepresentation(image, 0.5);
//            [formData appendPartWithFileData:data name:name fileName:filename mimeType:@"image/jpeg"];
//            index++;
//        }
//    } error:&error];
//    
//    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
//    [request setValue:@"android" forHTTPHeaderField:@"Device-Type"];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSProgress *progress = nil;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            if(listener) {
//                [listener onUploadFileError:response error:error];
//            }
//        } else {
//            if(listener) {
//                [listener onUploadFileFinished:response object:responseObject];
//            }
//        }
//    }];
//    [uploadTask resume];
//}

- (void) uploadImageFiles:(NSArray*) imgs listener: (id <FileUploadListener>) listener{
    NSError * error = nil;
    NSString * url = [self getUploadUrlByType:FILE_TYPE_IMAGE];
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
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                FileUploadResponse * res = [FileUploadResponse mj_objectWithKeyValues:responseObject];
                [listener onUploadFileFinished:response object:res.data];
            }
        }
    }];
    [uploadTask resume];
}

//上传音频文件
- (void) uploadAudioFiles:(NSArray*) audios listener: (id <FileUploadListener>) listener {
    NSError * error = nil;
    NSString * url = [self getUploadUrlByType:FILE_TYPE_AUDIO];
    NSString * mimeType = [FileUploadService getMimeTypeDescriptionBy:FILE_TYPE_AUDIO];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger index = 0;
        for (id path in audios) {
            if ([path isKindOfClass:[NSString class]]) {
                NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
                NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.mp3", index];
                
                NSData * data = [NSData dataWithContentsOfFile:path];
                [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
                index++;
            } else if ([path isKindOfClass:[NSURL class]]) {
                NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
                NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.mp3", index];
                NSData * data = [NSData dataWithContentsOfURL:path];
                [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
                index++;
            }
        }
    } error:&error];
    
    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
    [request setValue:@"android" forHTTPHeaderField:@"Device-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                FileUploadResponse * res = [FileUploadResponse mj_objectWithKeyValues:responseObject];
                [listener onUploadFileFinished:response object:res.data];
            }
        }
    }];
    [uploadTask resume];
}


//上传视频文件
- (void) uploadVideoFiles:(NSArray*) videos listener: (id <FileUploadListener>) listener {
    NSError * error = nil;
    NSString * url = [self getUploadUrlByType:FILE_TYPE_VIDEO];
    NSString * mimeType = [FileUploadService getMimeTypeDescriptionBy:FILE_TYPE_VIDEO];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger index = 0;
        for(NSString* path in videos) {
            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
            NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.mp4", index];
            NSData * data = [NSData dataWithContentsOfFile:path];
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
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
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                FileUploadResponse * res = [FileUploadResponse mj_objectWithKeyValues:responseObject];
                [listener onUploadFileFinished:response object:res.data];
            }
        }
    }];
    [uploadTask resume];
}

/**
 *  iOS文件上传
 * @param: url  ------  上传路径
 * @param: files------  文件路径数组(存储文件的 fullPath)
 * @param: type ------  文件类型(FileUploadType)
 * @listener: 监听器，用于回调处理图片上传结果
 */

// iOS文件上传1 ---------用于上传.mp3
- (void) uploadMp3Files: (NSString*) url
                  files: (NSArray*) filePathArray
                   type: (FileUploadType) fileType
               listener: (NSObject <FileUploadListener> *) listener {
    NSError * error = nil;
    NSString * mimeType;
    mimeType = [FileUploadService getMimeTypeDescriptionBy:fileType];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger index = 0;
        for(NSString* path in filePathArray) {
            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
            NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.mp3", index];
            
            NSData * data = [NSData dataWithContentsOfFile:path];
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
            index++;
        }
    } error:&error];
    
    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
    [request setValue:[SystemConfig getDeviceType] forHTTPHeaderField:@"Device-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                [listener onUploadFileFinished:response object:responseObject];
            }
        }
    }];
    [uploadTask resume];
}
// iOS文件上传2 ---------用于上传.mov
- (void) uploadVideoFiles:(NSString*) url
                    files:(NSArray*) filePathArray
                     type:(FileUploadType) fileType
                 listener: (NSObject <FileUploadListener> *) listener {
    NSError * error = nil;
    NSString * mimeType;
    mimeType = [FileUploadService getMimeTypeDescriptionBy:fileType];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger index = 0;
        for(NSString* path in filePathArray) {
            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
            NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.mov", index];
            
            NSData * data = [NSData dataWithContentsOfFile:path];
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
            index++;
        }
    } error:&error];
    
    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
    [request setValue:[SystemConfig getDeviceType] forHTTPHeaderField:@"Device-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                [listener onUploadFileFinished:response object:responseObject];
            }
        }
    }];
    [uploadTask resume];
}


// iOS文件上传方法3 用于上传pcm录音文件
- (void) uploadFiles: (NSString *) url
       filesUrlArray: (NSArray*) fileUrlArray
                type: (FileUploadType) fileType
            listener: (NSObject <FileUploadListener> *) listener {
    NSError * error = nil;
    NSString * mimeType;
    mimeType = [FileUploadService getMimeTypeDescriptionBy:fileType];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSInteger index = 0;
        for(NSURL* path in fileUrlArray) {
            NSString* name = [[NSString alloc] initWithFormat:@"file%ld", index];
            NSString* filename = [[NSString alloc] initWithFormat:@"file%ld.pcm", index];
            
//            NSData * data = [NSData dataWithContentsOfFile:path];
            NSData *data = [NSData dataWithContentsOfURL:path];
            [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
            index++;
        }
    } error:&error];
    
    [request setValue:[FMUtils getDeviceIdString] forHTTPHeaderField:@"Device-Id"];
    [request setValue:[SystemConfig getDeviceType] forHTTPHeaderField:@"Device-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(listener) {
                [listener onUploadFileError:response error:error];
            }
        } else {
            if(listener) {
                [listener onUploadFileFinished:response object:responseObject];
            }
        }
    }];
    [uploadTask resume];
    
}

+ (NSString *) getMimeTypeDescriptionBy:(FileUploadType) type {
    NSString * mime = @"";
    switch (type) {
        case FILE_TYPE_IMAGE:
            mime = @"image/jpeg";
            break;
        case FILE_TYPE_AUDIO:
            mime = @"audio/mpeg";
            break;
        case FILE_TYPE_VIDEO:
            mime = @"video/mpeg";
            break;
        case FILE_TYPE_VIDEO_SHORT:
            mime = @"video/mpeg";
            break;
        default:
            break;
    }
    return mime;
}
@end
