//
//  ServerInfoEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ServerInfoEntity.h"
#import "SystemConfig.h"
#import "BaseDataServerConfig.h"

@interface ServerInfoRequestParam ()

@property (readwrite, nonatomic, strong) NSNumber * userId;

@end

@implementation ServerInfoRequestParam

- (instancetype) initWith:(NSNumber *)userId {

    self = [super init];
   if(self) {

        _userId = [userId copy];

    }

    return self;

}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_SERVER_ID_URL];

    return res;

}

@end

@implementation ServerInfoEntity

@end
