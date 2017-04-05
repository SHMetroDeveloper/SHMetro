//
//  QuickReportCreateEntity.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseDataEntity.h"

@interface QuickReportCreateRequestParam : BaseRequest

@property (nonatomic, strong) NSString *requester;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *serviceTypeId;
@property (nonatomic, strong) Position *location;

@property (nonatomic, strong) NSMutableArray *equipment; //故障设备ID数组
@property (nonatomic, strong) NSMutableArray *photoIds; //需求图片ID数组
@property (nonatomic, strong) NSMutableArray *audioIds; //需求音频ID数组
@property (nonatomic, strong) NSMutableArray *videoIds; //需求视频ID数组

- (instancetype)init;
- (NSString *)getUrl;
@end


@interface QuickReportCreateResponse : BaseResponse

@end
