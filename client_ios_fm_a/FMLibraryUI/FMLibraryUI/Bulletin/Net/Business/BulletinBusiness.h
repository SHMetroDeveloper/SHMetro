//
//  BulletinBusiness.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletinHistoryEntity.h"
#import "BulletinDetailEntity.h"
#import "BulletinReceiverEntity.h"
#import "BaseBusiness.h"

typedef NS_ENUM(NSInteger, BulletinBusinessType) {
    BUSINESS_BULLETIN_UNKNOW,  //
    BUSINESS_BULLETIN_HISTORY,  //公告历史记录
    BUSINESS_BULLETIN_DETAIL,   //公告详情
    BUSINESS_BULLETIN_RECEIVER_READ_STATE  //公告已读状态
};

@interface BulletinBusiness : BaseBusiness

//获取业务的实例对象
+ (instancetype) getInstance;

//获取公告记录
- (void) getBulletinHistoryByParam:(BulletinHistoryRequestParam *)param Success:(business_success_block) success Fail:(business_failure_block)fail;

//获取公告详情
- (void) getBulletinDetailByParam:(BulletinDetailRequestParam *)param Success:(business_success_block) success Fail:(business_failure_block)fail;

//获取公告的已读未读状态
- (void) getBulletinReadStateByParam:(BulletinReceiverRequestParam *)param Success:(business_success_block) success Fail:(business_failure_block)fail;

@end


