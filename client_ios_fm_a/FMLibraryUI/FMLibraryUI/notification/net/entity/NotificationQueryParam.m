//
//  NotificationQueryEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "NotificationQueryParam.h"
#import "SystemConfig.h"
#import "NotificationEntity.h"
#import "MJExtension.h"


@implementation NotificationQueryParam
- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], NOTIFICATION_QUERY_URL];
    return res;
}

- (void) setPage:(NetPageParam *)page {
    if(!_page) {
        _page = [[NetPageParam alloc] init];
    }
    _page.pageNumber = [page.pageNumber copy];
    _page.pageSize = [page.pageSize copy];
}
@end

@implementation NotificationQueryResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"NotificationEntity"
             };
}
@end

@implementation NotificationQueryResponse
@end
