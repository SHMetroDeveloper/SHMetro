//
//  MaterialQueryContainerViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "MaterialQueryContainerViewController.h"
#import "MaterialQueryViewController.h"
#import "MaterialQueryFilterViewController.h"

@interface MaterialQueryContainerViewController ()
@property (nonatomic, strong) MaterialQueryViewController *center;
@property (nonatomic, strong) MaterialQueryFilterViewController *right;
@end

@implementation MaterialQueryContainerViewController

- (instancetype)initWithWarehouseId:(NSNumber *)warehouseId andWarehouseName:(NSString *)warehouseName {
    self = [super init];
    if (self) {
        _center = [[MaterialQueryViewController alloc] init];
        _center.warehouseId = warehouseId;
        _center.warehouseName = warehouseName;
        _right = [[MaterialQueryFilterViewController alloc] init];
        
        [_right setOnMessageHandleListener:_center];
        
        [self setContentViewController:_center];
        [self setMenuViewController:_right];
        
        self.direction = REFrostedViewControllerDirectionRight;
        self.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        self.liveBlur = NO;
    }
    return self;
}



@end
