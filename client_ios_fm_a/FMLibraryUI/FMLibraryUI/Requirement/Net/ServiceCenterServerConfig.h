//
//  ServiceCenterConfig.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/21.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequirementRequestType) {  //列表类型
    REQUIREMENT_TYPE_APPROVAL,    //待审核
    REQUIREMENT_TYPE_PROCESS,   //待处理
    REQUIREMENT_TYPE_DONE,      //待评价
    REQUIREMENT_TYPE_MINE,      //我的需求
    REQUIREMENT_TYPE_HISTORY,   //需求查询
} ;

typedef NS_ENUM(NSInteger, RequirementStatus) {
    REQUIREMENT_STATUS_CREATE,  //已创建
    REQUIREMENT_STATUS_PROCESS,  //处理中
    REQUIREMENT_STATUS_FINISH,  //已完成
    REQUIREMENT_STATUS_EVALUATED,  //已评价
};

typedef NS_ENUM(NSInteger, RequirementOrigin) {  //需求来源
    REQUIREMENT_ORIGIN_WEB,     //web端
    REQUIREMENT_ORIGIN_MOBILE,  //移动端
    REQUIREMENT_ORIGIN_WECHAT,  //微信端
    REQUIREMENT_ORIGIN_MAIL,  //邮件   （因问题#5360而暂时新加的一个状态）
};

typedef NS_ENUM(NSInteger, RequirementRecordType) {  //处理记录的处理类型
    REQUIREMENT_RECORD_TYPE_CREATE,     //创建需求
    REQUIREMENT_RECORD_TYPE_APPROVAL,  //审核
    REQUIREMENT_RECORD_TYPE_ORDER,  //创建工单
    REQUIREMENT_RECORD_TYPE_PROCESS,  //跟进
    REQUIREMENT_RECORD_TYPE_FOLLOW_UP,  //回访
    REQUIREMENT_RECORD_TYPE_FINISH,  //结束
};


@interface ServiceCenterServerConfig : NSObject

//图片上传
+ (NSString *) getRequirementImageUploadUrl: (NSInteger) reqId
                                     token: (NSString*) token;
//音频上传
+ (NSString *)getRequirementAudioFileUploadUrl:(NSInteger)reqId
                                         token:(NSString *)token;
//视频上传
+ (NSString *)getRequirementVideoFileUploadUrl:(NSInteger)reqId
                                         token:(NSString *)token;
//图片
+ (NSString*) wrapPictureUrlById:(NSString*) token photoId:(NSNumber*) photoId;

//音频
+ (NSString *) wrapAudioUrlById:(NSString *)token audioId:(NSNumber *)audioId;

//视频
+ (NSString *) wrapVideoUrlById:(NSString *)token videoId:(NSNumber *)videoId;

//获取状态描述信息
+ (NSString *) getRequirementStatusDescriptionBy:(RequirementStatus) status;

//获取来源的描述信息
+ (NSString *) getRequirementOriginDescriptionBy:(RequirementOrigin) origin;

//获取需求详情处理记录的title
+ (NSString *) getRecordTitleStrByhandler:(NSString *) handler andRecordType:(RequirementRecordType) recordType;

//获取状态颜色
+ (UIColor *) getColorByStatus:(RequirementStatus) status;

@end


//创建新需求
extern NSString * const GET_SERVICE_CENTER_CREATE_URL;

//获取待审核、待完成、已完成需求列表
extern NSString * const GET_REQUIREMENT_LIST_URL;

//获取需求详情
extern NSString * const GET_REQUIREMENT_DETAIL_URL;

//需求处理
extern NSString * const OPERATE_REQUIREMENT_URL;

//需求评价
extern NSString * const EVALUATE_REQUIREMENT_URL;


extern NSString * const REQUIREMENT_UPLOAD_IMAGE_URL;
extern NSString * const REQUIREMENT_UPLOAD_IMAGE_URL_END;

extern NSString * const REQUIREMENT_UPLOAD_AUDIO_FILE_URL;
extern NSString * const REQUIREMENT_UPLOAD_AUDIO_FILE_URL_END;

extern NSString * const REQUIREMENT_UPLOAD_VIDEO_FILE_URL;
extern NSString * const REQUIREMENT_UPLOAD_VIDEO_FILE_URL_END;


