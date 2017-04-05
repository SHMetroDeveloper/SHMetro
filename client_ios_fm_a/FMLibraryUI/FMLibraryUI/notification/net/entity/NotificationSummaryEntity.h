//
//  NotificationSummaryEntity.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "NotificationEntity.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NotificationServerConfig.h"

@interface NotificationSummaryRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSMutableArray *type;   //消息类型数组
@property (readwrite, nonatomic, assign) NSInteger count;      //

- (instancetype) init;
- (NSString*) getUrl;
@end

@interface NotificationSummaryRequestResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray *data;
@end
