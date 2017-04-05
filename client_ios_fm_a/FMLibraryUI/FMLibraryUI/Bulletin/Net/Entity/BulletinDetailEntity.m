//
//  BulletinDetailEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinDetailEntity.h"
#import "BulletinConfig.h"
#import "SystemConfig.h"
#import "MJExtension.h"

@implementation BulletinDetailRequestParam
- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BULLETIN_HISTORY_DETAIL_URL];
    return res;
}
@end


@implementation BulletinAttachment
@end


@implementation BulletinDetail

- (instancetype)init {
    self = [super init];
    if (self) {
        _attachment = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attachment" : @"BulletinAttachment"
             };
}

@end


@implementation BulletinDetailResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[BulletinDetail alloc] init];
    }
    return self;
}
@end


