//
//  AssetUndoWorkOrderEntity.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetUndoWorkOrderEntity.h"
#import "SystemConfig.h"
#import "AssetManagementConfig.h"
#import "MJExtension.h"
#import "FMUtils.h"

@implementation AssetUndoWorkOrderRequestParam

- (NSString *)getUrl {
    NSString * url = [self wrapUrl:[NSString stringWithFormat:@"%@%@",[SystemConfig getServerAddress],ASSET_UNDO_WORK_ORDER_LIST_URL]];
    return url;
}

@end

@implementation AssetUndoWorkOrderEntity

@end

@implementation AssetUndoWorkOrderResponse
- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"AssetUndoWorkOrderEntity"
             };
}

@end
