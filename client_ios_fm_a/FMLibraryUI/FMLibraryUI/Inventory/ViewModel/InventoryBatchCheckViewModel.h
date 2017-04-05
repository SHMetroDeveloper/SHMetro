//
//  InventoryBatchCheckViewModel.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetPage.h"
#import <UIKit/UIKit.h>

@interface InventoryBatchCheckViewModel : NSObject
@property (nonatomic, strong) NSNumber *inventoryId;   //物资ID
@property (nonatomic, strong) NSNumber *batchId;   //批次ID
@property (nonatomic, strong) NSNumber *providerId;   //供应商ID
@property (nonatomic, strong) NSString *providerName;  //供应商名字
@property (nonatomic, strong) NSNumber *storageDate;   //入库时间
@property (nonatomic, strong) NSNumber *dueDate;   //过期时间
@property (nonatomic, strong) NSString *price;  //单价
@property (nonatomic, strong) NSNumber * inventoryNumber;  //库存数量（有效数量）
@property (nonatomic, strong) NSNumber * checkNumber;  //盘点数量
@property (nonatomic, assign) BOOL isChecked;  //是否已经盘点

@property (nonatomic, strong) NetPage *netPage;
@end
