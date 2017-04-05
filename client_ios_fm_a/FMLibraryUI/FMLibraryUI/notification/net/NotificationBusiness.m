//
//  NotificationBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "NotificationBusiness.h"
#import "NotificationNetRequest.h"
#import "NotificationOperateParam.h"
#import "NotificationQueryParam.h"
#import "MJExtension.h"
#import "NotificationSummaryEntity.h"

NotificationBusiness * msgBusinessInstance;

@interface NotificationBusiness ()
@property (readwrite, nonatomic, strong) NotificationNetRequest * netRequest;
@end

@implementation NotificationBusiness
//获取推送业务的实例对象
+ (instancetype) getInstance {
    if(!msgBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            msgBusinessInstance = [[NotificationBusiness alloc] init];
        });
    }
    return msgBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [NotificationNetRequest getInstance];
    }
    return self;
}

//消息已读确认
- (void) markMessageRead:(NSNumber *) msgId success:(business_success_block) success fail:(business_failure_block) fail{
    if(_netRequest) {
        NotificationOperateParam * param  = [[NotificationOperateParam alloc] initWithMsg:msgId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                success(BUSINESS_NOTIFICATION_READ, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_NOTIFICATION_READ, error);
            }
        }];
    }
}

//消息全部标记已读
- (void) markMessageReadAll:(MessageOperationReadAllRrequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                success(BUSINESS_NOTIFICATION_READ_ALL, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_NOTIFICATION_READ_ALL, error);
            }
        }];
    }
}

//消息删除
- (void) markMessageDelete:(MessageOperationDeleteRrequestParam *)param success:(business_success_block)success fail:(business_failure_block)fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                success(BUSINESS_NOTIFICATION_DELETE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_NOTIFICATION_DELETE, error);
            }
        }];
    }
}

//获取推送消息列表
- (void) queryMessageListBy:(NotificationQueryParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                NotificationQueryResponse * response = [NotificationQueryResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_NOTIFICATION_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_NOTIFICATION_LIST, error);
            }
        }];
    }
    
}

//查询消息概览
- (void) queryMessageSummaryByTypeArray:(NSMutableArray *) typeArray count:(NSInteger) count success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        NotificationSummaryRequestParam * param  = [[NotificationSummaryRequestParam alloc] init];
        param.count = count;
        param.type = typeArray;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                NotificationSummaryRequestResponse * response = [NotificationSummaryRequestResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_NOTIFICATION_SUMMARY, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_NOTIFICATION_SUMMARY, error);
            }
        }];
    }
}
@end
