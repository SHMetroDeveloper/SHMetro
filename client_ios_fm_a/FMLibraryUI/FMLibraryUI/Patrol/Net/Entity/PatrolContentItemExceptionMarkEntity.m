//
//  PatrolContentItemExceptionMarkEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolContentItemExceptionMarkEntity.h"
#import "PatrolServerConfig.h"
#import "SystemConfig.h"

@implementation PatrolContentItemExceptionMarkEntity

@end


@implementation PatrolContentItemExceptionMarkRequestParam

- (instancetype) initWithContentId:(NSNumber *) contentId {
    self = [super init];
    if(self) {
        _contentId = [contentId copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_CONTENT_ITEM_EXCEPTION_MARK];
    return res;
}

@end
