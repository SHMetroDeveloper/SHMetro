//
//  NotificationOperateEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "NotificationOperateParam.h"
#import "SystemConfig.h"
#import "NotificationServerConfig.h"

@implementation NotificationOperateParam
- (instancetype) initWithMsg:(NSNumber *) msgId {
    self = [super init];
    if(self) {
        _msgId = [msgId copy];
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], OPERATE_NOTIFICATION_READ_URL];
    return res;
}
@end
