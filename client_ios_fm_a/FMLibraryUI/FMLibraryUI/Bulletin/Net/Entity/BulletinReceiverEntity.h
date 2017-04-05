//
//  BulletinReceiverEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"

@interface BulletinReceiverRequestParam : BaseRequest
@property (nonatomic, strong) NSNumber *bulletinId;  //公告ID
@property (nonatomic, assign) BOOL read;  //已读状态
@property (nonatomic, strong) NetPageParam * page;
- (NSString *)getUrl;
@end


@interface BulletinReceiver : NSObject
@property (nonatomic, strong) NSNumber *emId;  //执行人ID
@property (nonatomic, strong) NSString *name;  //接收者姓名
@property (nonatomic, strong) NSNumber *photoId;  //接收者头像ID
@property (nonatomic, strong) NSNumber *projectId;    //所属项目ID
@property (nonatomic, strong) NSString *projectName;  //所属项目名字
@end

@interface BulletinReceiverResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end

@interface BulletinReceiverResponse : BaseResponse
@property (nonatomic, strong) BulletinReceiverResponseData *data;
@end

