//
//  InventoryMaterialDetailViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InventoryMaterialDetailViewController : BaseViewController

//用code来展示详情
@property (nonatomic, assign) BOOL fromQrcode;
@property (nonatomic, strong) NSString *inventoryCode;
@property (nonatomic, strong) NSNumber *warehouseId;

//用id来展示详情
@property (nonatomic, strong) NSNumber *inventoryId;

@property (nonatomic, assign) __block BOOL isEditAble;

@end
