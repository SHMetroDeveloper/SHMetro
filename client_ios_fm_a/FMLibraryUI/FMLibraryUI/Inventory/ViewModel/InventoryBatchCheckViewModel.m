//
//  InventoryBatchCheckViewModel.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryBatchCheckViewModel.h"

@implementation InventoryBatchCheckViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _netPage = [[NetPage alloc] init];
    }
    return self;
}

@end
