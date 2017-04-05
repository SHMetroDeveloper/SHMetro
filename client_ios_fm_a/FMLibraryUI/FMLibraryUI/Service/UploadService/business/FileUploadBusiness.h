//
//  FileUploadBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseBusiness.h"

typedef NS_ENUM(NSInteger, FileUploadBusinessType) {
    BUSINESS_FILE_UPLOAD_UNKNOW,   //
    BUSINESS_FILE_UPLOAD_IMAGE,    //请求上传图片
    BUSINESS_FILE_UPLOAD_AUDIO,    //请求上传音频
    BUSINESS_FILE_UPLOAD_VIDEO,   //请求上传视频
    
};

@interface FileUploadBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//请求上传图片
- (void) requestUploadImages:(NSArray *) images Success:(business_success_block) success fail:(business_failure_block) fail;

//请求上传音频
- (void) requestUploadAudios:(NSArray *) audios Success:(business_success_block) success fail:(business_failure_block) fail;

//请求上传视频
- (void) requestUploadVideos:(NSArray *) videos Success:(business_success_block) success fail:(business_failure_block) fail;


@end
