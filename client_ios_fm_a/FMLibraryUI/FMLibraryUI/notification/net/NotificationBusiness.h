//
//  NotificationBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseBusiness.h"
#import "NotificationServerConfig.h"
#import "MessageOperationEntity.h"
#import "NotificationQueryParam.h"

typedef NS_ENUM(NSInteger, NotificationBusinessType) {
    BUSINESS_NOTIFICATION_UNKNOW,   //
    BUSINESS_NOTIFICATION_READ,    //消息已读确认
    BUSINESS_NOTIFICATION_READ_ALL,    //消息全部标记已读
    BUSINESS_NOTIFICATION_DELETE,    //消息删除
    BUSINESS_NOTIFICATION_LIST,    //获取推送消息列表
    BUSINESS_NOTIFICATION_SUMMARY,    //获取推送消息概览
};

@interface NotificationBusiness : BaseBusiness

//获取推送业务的实例对象
+ (instancetype) getInstance;

//消息已读确认
- (void) markMessageRead:(NSNumber *) msgId  success:(business_success_block) success fail:(business_failure_block) fail;

//消息全部标记已读
- (void) markMessageReadAll:(MessageOperationReadAllRrequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//消息删除
- (void) markMessageDelete:(MessageOperationDeleteRrequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail;

//获取推送消息列表
- (void) queryMessageListBy:(NotificationQueryParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//查询消息概览
- (void) queryMessageSummaryByTypeArray:(NSMutableArray *) typeArray count:(NSInteger) count success:(business_success_block) success fail:(business_failure_block) fail;

@end
