//
//  NotificationServerConfig.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "NotificationServerConfig.h"

//消息已读确认
NSString * const OPERATE_NOTIFICATION_READ_URL = @"/m/v1/message/read";
//消息全部已读接口
NSString * const OPERATE_NOTIFICATION_READ_ALL_URL = @"/m/v1/message/readall";
//消息删除接口
NSString * const OPERATE_NOTIFICATION_DELETE_URL = @"/m/v1/message/delete";
//获取消息列表
NSString * const NOTIFICATION_QUERY_URL = @"/m/v2/message/query";
//获取消息概览
NSString * const NOTIFICATION_REQUEST_SUMMARY_URL = @"/m/v1/message/summary";


@implementation NotificationServerConfig

@end
