//
//  FileUploadBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FileUploadBusiness.h"
#import "FileUploadResponse.h"
#import "FileUploadService.h"
#import "MJExtension.h"

FileUploadBusiness * fileUploadBusinessInstance;

@interface FileUploadBusiness () <FileUploadListener>

@property (readwrite, nonatomic, strong) FileUploadService * fileUploadInstance;

@end

@implementation FileUploadBusiness

+ (instancetype) getInstance {
    if(!fileUploadBusinessInstance) {
        fileUploadBusinessInstance = [[FileUploadBusiness alloc] init];
    }
    return fileUploadBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _fileUploadInstance = [FileUploadService getInstance];
    }
    return self;
}

//请求上传图片
- (void) requestUploadImages:(NSArray *) images Success:(business_success_block) success fail:(business_failure_block) fail {
    [_fileUploadInstance uploadImageFiles:images listener:self];
}

//请求上传音频
- (void) requestUploadAudios:(NSArray *) audios Success:(business_success_block) success fail:(business_failure_block) fail {
    
}

//请求上传视频
- (void) requestUploadVideos:(NSArray *) videos Success:(business_success_block) success fail:(business_failure_block) fail {
    
}

#pragma mark - 文件上传结果监听
- (void) onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    NSLog(@"文件上传失败:%@", error);
    
}

- (void) onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    NSLog(@"文件上传上传成功。");
    FileUploadResponse * res = [FileUploadResponse mj_objectWithKeyValues:responseObject];
}

@end
