//
//  MaterialQueryViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface MaterialQueryViewController : BaseViewController<OnMessageHandleListener>

@property (nonatomic, strong) NSNumber *warehouseId;

@property (nonatomic, strong) NSString *warehouseName;

@end
