//
//  ContractQueryViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractQueryViewController.h"
#import "ContractQueryCenterViewController.h"
#import "ContractQueryFilterViewController.h"

@interface ContractQueryViewController ()
@property (readwrite, nonatomic, strong) ContractQueryCenterViewController * center;
@property (readwrite, nonatomic, strong) ContractQueryFilterViewController * right;
@end

@implementation ContractQueryViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _center = [[ContractQueryCenterViewController alloc] init];
        _right = [[ContractQueryFilterViewController alloc] init];
        
        [_right setOnMessageHandleListener:_center];
        
        [self setMenuViewController:_right];
        [self setContentViewController:_center];
        
        self.direction = REFrostedViewControllerDirectionRight;
        self.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        self.liveBlur = NO;
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_query" inTable:nil]];
    [self setBackAble:YES];
}


@end
