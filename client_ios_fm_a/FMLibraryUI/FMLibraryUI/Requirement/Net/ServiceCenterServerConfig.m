//
//  ServiceCenterConfig.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/21.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ServiceCenterServerConfig.h"
#import "SystemConfig.h"
#import "BaseDataDbHelper.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
//创建新需求
NSString * const GET_SERVICE_CENTER_CREATE_URL = @"/m/v2/servicecenter/create";

//获取待审核、待完成、已完成需求列表
NSString * const GET_REQUIREMENT_LIST_URL = @"/m/v1/servicecenter/list";

//获取需求详情
NSString * const GET_REQUIREMENT_DETAIL_URL = @"/m/v2/servicecenter/detail";

//需求处理
NSString * const OPERATE_REQUIREMENT_URL = @"/m/v1/servicecenter/operation";

//需求评价
NSString * const EVALUATE_REQUIREMENT_URL = @"/m/v1/servicecenter/evaluate";

NSString * const REQUIREMENT_UPLOAD_IMAGE_URL = @"/m/v1/files/upload/picture/servicecenter/";
NSString * const REQUIREMENT_UPLOAD_IMAGE_URL_END = @"/img/";

NSString * const REQUIREMENT_UPLOAD_AUDIO_FILE_URL = @"/m/v1/files/upload/voicemedia/Requirement/";
NSString * const REQUIREMENT_UPLOAD_AUDIO_FILE_URL_END = @"/audio/";

NSString * const REQUIREMENT_UPLOAD_VIDEO_FILE_URL = @"/m/v1/files/upload/videomedia/Requirement/";
NSString * const REQUIREMENT_UPLOAD_VIDEO_FILE_URL_END = @"/video/";

@implementation ServiceCenterServerConfig

+ (NSString*) getRequirementImageUploadUrl: (NSInteger) reqId
                                     token: (NSString*) token {
    NSString * url = [[NSString alloc] initWithFormat:@"%@%@%ld%@?access_token=%@",[SystemConfig getServerAddress],REQUIREMENT_UPLOAD_IMAGE_URL,reqId,REQUIREMENT_UPLOAD_IMAGE_URL_END,token];

    return url;
}

+ (NSString *)getRequirementAudioFileUploadUrl:(NSInteger)reqId
                                         token:(NSString *)token {
    NSString * url = [[NSString alloc] initWithFormat:@"%@%@%ld%@?access_token=%@",[SystemConfig getServerAddress],REQUIREMENT_UPLOAD_AUDIO_FILE_URL,reqId,REQUIREMENT_UPLOAD_AUDIO_FILE_URL_END,token];
    return url;
}

+ (NSString *)getRequirementVideoFileUploadUrl:(NSInteger)reqId
                                         token:(NSString *)token {
    NSString * url = [[NSString alloc] initWithFormat:@"%@%@%ld%@?access_token=%@",[SystemConfig getServerAddress],REQUIREMENT_UPLOAD_VIDEO_FILE_URL,reqId,REQUIREMENT_UPLOAD_VIDEO_FILE_URL_END,token];
    return url;
}

+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/files/id/%lld/img", [photoId longLongValue]];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], url, token];
    return res;
}

//音频
+ (NSString *) wrapAudioUrlById:(NSString *)token audioId:(NSNumber *)audioId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/media/%lld", [audioId longLongValue]];
    NSString * devId = [FMUtils getDeviceIdString];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], url, devId, token];
//        res = @"http://www.w3school.com.cn/i/song.mp3";
    return res;
}

//视频
+ (NSString *) wrapVideoUrlById:(NSString *)token videoId:(NSNumber *)videoId {
    NSString * url = [[NSString alloc] initWithFormat:@"/common/media/%lld", [videoId longLongValue]];
    NSString * devId = [FMUtils getDeviceIdString];
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], url, devId, token];
    //    res = @"http://www.w3school.com.cn/i/movie.mp4";
    return res;
}


+ (NSString *) getRequirementStatusDescriptionBy:(RequirementStatus) status {
    NSString * res = @"";
    switch(status) {
        case REQUIREMENT_STATUS_CREATE:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_status_create" inTable:nil];
            break;
        case REQUIREMENT_STATUS_PROCESS:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_status_process" inTable:nil];
            break;
        case REQUIREMENT_STATUS_FINISH:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_status_finish" inTable:nil];
            break;
        case REQUIREMENT_STATUS_EVALUATED:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_status_evaluate" inTable:nil];
            break;
        default:
            break;
    }
    return res;
}

//获取状态颜色
+ (UIColor *) getColorByStatus:(RequirementStatus) status {
    UIColor * color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    switch(status) {
        case REQUIREMENT_STATUS_CREATE:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
        case REQUIREMENT_STATUS_PROCESS:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
        case REQUIREMENT_STATUS_FINISH:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        case REQUIREMENT_STATUS_EVALUATED:
            color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
        default:
            break;
    }
    return color;
}

+ (NSString *) getRequirementOriginDescriptionBy:(RequirementOrigin) origin {
    NSString * res = @"";
    switch(origin) {
        case REQUIREMENT_ORIGIN_WEB:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_origin_web" inTable:nil];
            break;
        case REQUIREMENT_ORIGIN_MOBILE:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_origin_phone" inTable:nil];
            break;
        case REQUIREMENT_ORIGIN_WECHAT:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_origin_wechat" inTable:nil];
            break;
        case REQUIREMENT_ORIGIN_MAIL:
            res = [[BaseBundle getInstance] getStringByKey:@"requirement_origin_email" inTable:nil];
            break;
    }
    return res;
}

+ (NSString *) getRecordTitleStrByhandler:(NSString *) handler andRecordType:(RequirementRecordType) recordType {
    NSString *res = @"";
    switch (recordType) {
        case REQUIREMENT_RECORD_TYPE_CREATE:
            
            break;
            
        case REQUIREMENT_RECORD_TYPE_APPROVAL:
            
            break;
            
        case REQUIREMENT_RECORD_TYPE_ORDER:
            
            break;
            
        case REQUIREMENT_RECORD_TYPE_PROCESS:
            
            break;
            
        case REQUIREMENT_RECORD_TYPE_FOLLOW_UP:
            
            break;
            
        case REQUIREMENT_RECORD_TYPE_FINISH:
            
            break;
    }
    
    return res;
}
@end
