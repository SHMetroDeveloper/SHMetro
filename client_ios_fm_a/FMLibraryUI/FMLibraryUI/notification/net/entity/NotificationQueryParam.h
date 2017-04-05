//
//  NotificationQueryEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"
#import "NotificationServerConfig.h"
#import "NetPage.h"

@interface NotificationQueryParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * timeStart;
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;
@property (readwrite, nonatomic, assign) NSInteger read;
@property (readwrite, nonatomic, assign) NotificationItemType type;
@property (readwrite, nonatomic, strong) NetPageParam *page;

- (instancetype) init;
- (NSString*) getUrl;

- (void) setPage:(NetPageParam *)page;
@end

@interface NotificationQueryResponseData : NSObject
@property (readwrite, nonatomic, strong) NetPage *page;
@property (readwrite, nonatomic, strong) NSMutableArray *contents;
@end

@interface NotificationQueryResponse : BaseResponse
@property (readwrite, nonatomic, strong) NotificationQueryResponseData * data;
@end
