//
//  NewDemandEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "NewDemandEntity.h"
#import "SystemConfig.h"
#import "ServiceCenterServerConfig.h"
#import "FMUtils.h"

@implementation NewDemandRequestParam

- (instancetype) init {
    self = [super init];
    if (self) {
        _photoIds = [[NSMutableArray alloc] init];
        _audioIds = [[NSMutableArray alloc] init];
        _videoIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_SERVICE_CENTER_CREATE_URL];
    return res;
}
@end



@implementation NewDemandDetail
- (instancetype)init {
    self = [super init];
    if (self) {

    _imgs = [[NSMutableArray alloc] init];
    _pictures = [[NSMutableArray alloc] init];
    _audios = [[NSMutableArray alloc] init];
    _medias = [[NSMutableArray alloc] init];
    }
    return self;
}

@end