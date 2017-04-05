//
//  EquipmentQueryViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "EquipmentQueryViewController.h"

#import "EquipmentListViewController.h"
#import "EquipmentListFilterViewController.h"
#import "BaseBundle.h"

@interface EquipmentQueryViewController ()
@property (readwrite, nonatomic, strong) EquipmentListViewController * center;
@property (readwrite, nonatomic, strong) EquipmentListFilterViewController * right;
@end

@implementation EquipmentQueryViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _center = [[EquipmentListViewController alloc] init];
        _right = [[EquipmentListFilterViewController alloc] init];
        
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
