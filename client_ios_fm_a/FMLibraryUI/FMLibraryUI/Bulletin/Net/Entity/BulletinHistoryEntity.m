//
//  BulletinHistoryEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinHistoryEntity.h"
#import "BulletinConfig.h"
#import "SystemConfig.h"
#import "MJExtension.h"

@implementation BulletinHistoryRequestParam
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
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BULLETIN_HISTORY_QUERY_URL];
    return res;
}
@end

@implementation BulletinHistory
@end

@implementation BulletinHistoryResponseData
- (instancetype)init {
    self = [super init];
    if (self) {
        _contents = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"BulletinHistory"
             };
}
@end

@implementation BulletinHistoryResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[BulletinHistoryResponseData alloc] init];
    }
    return self;
}
@end

