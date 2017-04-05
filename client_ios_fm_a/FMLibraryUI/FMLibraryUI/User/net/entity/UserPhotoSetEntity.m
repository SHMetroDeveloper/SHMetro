//
//  UserPhotoSetEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/13/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "UserPhotoSetEntity.h"
#import "SystemConfig.h"
#import "UserServerConfig.h"

@implementation UserPhotoSetParam

- (instancetype) init {
    self = [super init];
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],USER_PHOTO_SET_URL];
    return res;
}
@end
