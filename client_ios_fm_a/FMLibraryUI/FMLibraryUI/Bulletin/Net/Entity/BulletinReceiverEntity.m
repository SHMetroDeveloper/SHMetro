//
//  BulletinReceiverEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinReceiverEntity.h"
#import "BulletinConfig.h"
#import "SystemConfig.h"
#import "MJExtension.h"

@implementation BulletinReceiverRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (void)setPage:(NetPageParam *)page {
    if (!_page) {
        _page = [[NetPageParam alloc] init];
    }
    _page.pageNumber = [page.pageNumber copy];
    _page.pageSize = [page.pageSize copy];
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BULLETIN_HISTORY_READ_STATE_URL];
    return res;
}
@end


@implementation BulletinReceiver
@end


@implementation BulletinReceiverResponseData
- (instancetype)init {
    self = [super init];
    if (self) {
        _contents = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"BulletinReceiver"
             };
}
@end

@implementation BulletinReceiverResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[BulletinReceiverResponseData alloc] init];
    }
    return self;
}
@end

