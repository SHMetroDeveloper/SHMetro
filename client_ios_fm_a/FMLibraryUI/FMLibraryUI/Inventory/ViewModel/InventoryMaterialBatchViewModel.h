//
//  InventoryMaterialBatchViewModel.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InventoryMaterialBatchViewModel : NSObject
@property (nonatomic, strong) NSNumber *providerId;   //供应商ID
@property (nonatomic, strong) NSString *name;  //供应商名字
@property (nonatomic, strong) NSNumber *dueDate;   //过期时间
@property (nonatomic, strong) NSString *price;  //单价
@property (nonatomic, strong) NSString *inventoryNumber;  //库存数量
@property (nonatomic, strong) NSString *number;  //入库数量

@end
