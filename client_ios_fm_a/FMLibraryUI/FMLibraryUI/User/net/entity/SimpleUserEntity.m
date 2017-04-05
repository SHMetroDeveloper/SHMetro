//
//  SimpleUserEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/13/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "SimpleUserEntity.h"
#import "SystemConfig.h"
#import "UserServerConfig.h"

@implementation SimpleUserEntity

@end


@implementation SimpleUserRequestParam
- (NSString *) getUrl {
    NSString* url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], USER_LIST_URL]];
    return url;
}
@end

@implementation SimpleUserRequestResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"SimpleUserEntity"
             };
}
@end
