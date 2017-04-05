//
//  BulletinDetailEntity.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface BulletinDetailRequestParam : BaseRequest

@property (nonatomic, strong) NSNumber *bulletinId;

- (NSString *) getUrl;

@end

@interface BulletinAttachment : NSObject
@property (nonatomic, strong) NSNumber *attachmentId;
@property (nonatomic, strong) NSString *name;
@end

@interface BulletinDetail : NSObject

@property (nonatomic, strong) NSNumber *bulletinId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger type; //公告类型 0-项目级 1-公司级 2-系统级
@property (nonatomic, strong) NSString *creator; //公告作者
@property (nonatomic, strong) NSNumber *createTime;  //公告创建时间
@property (nonatomic, strong) NSNumber *startTime;  //开始展示时间
@property (nonatomic, strong) NSNumber *endTime;  //停止展示时间
@property (nonatomic, strong) NSNumber *imageId;  //公告图片ID
@property (nonatomic, assign) BOOL top;  //是否置顶
@property (nonatomic, strong) NSString *content;  //公告内容
@property (nonatomic, assign) NSInteger read;  //已读人数
@property (nonatomic, assign) NSInteger unRead;  //未读人数
@property (nonatomic, strong) NSMutableArray *attachment;  //附件

@end

@interface BulletinDetailResponse : BaseResponse
@property (nonatomic, strong) BulletinDetail *data;
@end

NS_ASSUME_NONNULL_END

