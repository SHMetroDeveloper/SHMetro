//
//  WorkOrderHistoryViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WorkOrderHistoryViewController.h"
#import "WorkOrderHistoryQueryViewController.h"
#import "WorkOrderHistoryFilterViewController.h"
#import "BaseBundle.h"

@interface WorkOrderHistoryViewController ()
@property (readwrite, nonatomic, strong) WorkOrderHistoryQueryViewController * center;
@property (readwrite, nonatomic, strong) WorkOrderHistoryFilterViewController * right;
@end

@implementation WorkOrderHistoryViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _center = [[WorkOrderHistoryQueryViewController alloc] init];
        _right = [[WorkOrderHistoryFilterViewController alloc] init];
        
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
