//
//  BulletinBusiness.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinBusiness.h"
#import "BulletinNetRequest.h"
#import "MJExtension.h"

BulletinBusiness *bulletinBusinessInstance;

@interface BulletinBusiness ()
@property (readwrite, nonatomic, strong) BulletinNetRequest *netRequest;
@end

@implementation BulletinBusiness

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [BulletinNetRequest getInstance];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!bulletinBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bulletinBusinessInstance = [[BulletinBusiness alloc] init];
        });
    }
    return bulletinBusinessInstance;
}

//获取公告记录
- (void) getBulletinHistoryByParam:(BulletinHistoryRequestParam *)param Success:(business_success_block) success Fail:(business_failure_block)fail{
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BulletinHistoryResponse *response = [BulletinHistoryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_BULLETIN_HISTORY, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_BULLETIN_HISTORY, error);
            }
        }];
    }
}

//获取公告详情
- (void) getBulletinDetailByParam:(BulletinDetailRequestParam *)param Success:(business_success_block) success Fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BulletinDetailResponse *response = [BulletinDetailResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_BULLETIN_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_BULLETIN_DETAIL, error);
            }
        }];
    }
}

//获取公告的已读未读状态
- (void) getBulletinReadStateByParam:(BulletinReceiverRequestParam *)param Success:(business_success_block)success Fail:(business_failure_block)fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BulletinReceiverResponse *response = [BulletinReceiverResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_BULLETIN_RECEIVER_READ_STATE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_BULLETIN_RECEIVER_READ_STATE, error);
            }
        }];
    }
}

@end
