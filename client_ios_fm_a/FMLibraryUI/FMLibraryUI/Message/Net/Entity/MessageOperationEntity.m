//
//  MessageOperationEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 2017/2/10.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "MessageOperationEntity.h"
#import "MessageConfig.h"
#import "SystemConfig.h"
#import "MJExtension.h"

@implementation MessageOperationReadAllRrequestParam
- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], MESSAGE_READ_MARK_URL];
    return res;
}
@end


@implementation MessageOperationDeleteRrequestParam

- (instancetype)init {
    self = [super init];
    if (self) {
        _messages = [NSMutableArray new];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], MESSAGE_DELETE_MARK_URL];
    return res;
}
@end

