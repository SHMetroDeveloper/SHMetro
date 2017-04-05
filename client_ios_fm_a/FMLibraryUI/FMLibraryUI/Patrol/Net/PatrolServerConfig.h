//
//  PatrolServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PatrolEquipmentExceptionStatus) {
    PATROL_EQUIPMENT_EXCEPTION_STATUS_IDLE,
    PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP,
    PATROL_EQUIPMENT_EXCEPTION_STATUS_USING,
    PATROL_EQUIPMENT_EXCEPTION_STATUS_REPAIRING,
    PATROL_EQUIPMENT_EXCEPTION_STATUS_SCRAP,
};

//巡检任务类型
typedef NS_ENUM(NSInteger, PatrolTaskType) {
    PATROL_TASK_TYPE_INSPECTION = 0,    //巡检
    PATROL_TASK_TYPE_PATROL= 1,         //巡视
};

//巡检项有效状态
typedef NS_ENUM(NSInteger, PatrolItemContentValidStatus) {
    PATROL_ITEM_CONTENT_VALID_STATUS_ALL = 100,   //不限
    PATROL_ITEM_CONTENT_VALID_STATUS_STOP = 1,    //停用
    PATROL_ITEM_CONTENT_VALID_STATUS_WORKING = 2,      //使用
};

@interface PatrolServerConfig : NSObject

//+ (NSString*) getPatrolImageUploadUrl:(NSNumber*) spotCheckContentId token:(NSString*) accessToken;
//
//+ (NSString*) wrapPictureUrl:(NSString*) token url:(NSString*) url;
//
//+ (NSString*) wrapPictureUrlById:(NSString*) token id:(NSNumber*) photoId;

+ (NSString *) getEquipmentStatusDescription:(PatrolEquipmentExceptionStatus) status;

+ (NSString *) getTaskTypeDescription:(PatrolTaskType) taskType;

@end


extern NSString * const UNDO_PATROL_TASK_URL;
extern NSString * const PATROL_TASK_URL;
extern NSString * const PATROL_SUBMIT_PATROL_TASK_URL;
//extern NSString * const PATROL_SUBMIT_SPOT_TASK_URL;
extern NSString * const PATROL_UPLOAD_IMAGE_URL;
extern NSString * const PATROL_UPLOAD_IMAGE_URL_END;
extern NSString * const PATROL_QUERY_LIST;
extern NSString * const PATROL_QUERY_DETAIL;
extern NSString * const PATROL_CONTENT_ITEM_EXCEPTION_MARK;
