//
//  BulletinHistoryEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NetPage.h"


@interface BulletinHistoryRequestParam : BaseRequest
@property (nonatomic, assign) NSInteger type; //请求类型，0-置顶 1-未读 2-已读
@property (nonatomic, strong) NetPageParam *page;
- (instancetype)init;
- (NSString *)getUrl;
@end


@interface BulletinHistory : NSObject

@property (nonatomic, strong) NSNumber *bulletinId;  //公告记录ID
@property (nonatomic, strong) NSString *title;  //公告标题
@property (nonatomic, strong) NSString *creator;  //公告作者
@property (nonatomic, strong) NSNumber *time;  //公告时间
@property (nonatomic, strong) NSNumber *imageId;  //公告图片
@property (nonatomic, assign) BOOL top;  //是否置顶
@property (nonatomic, assign) NSInteger type;  //公告类型， 0-项目级 1-公司级 2-系统级

@end

@interface BulletinHistoryResponseData : NSObject
@property (nonatomic, strong) NetPage *page;
@property (nonatomic, strong) NSMutableArray *contents;
@end

@interface BulletinHistoryResponse : BaseResponse
@property (nonatomic, strong) BulletinHistoryResponseData *data;
@end
