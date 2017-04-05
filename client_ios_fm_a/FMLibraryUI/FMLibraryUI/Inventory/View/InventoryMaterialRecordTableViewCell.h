//
//  InventoryMaterialRecordTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryMaterialRecordTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;

- (void) setInfoWithCode:(NSString *) code    //入库单号
                provider:(NSString *) provider  //供应商
                   price:(NSString *) price   //单价(元)
                  amount:(NSNumber *) amount  //入库数量
              realNumber:(NSNumber *) realNumber  //有效数量
           storageInTime:(NSNumber *) storageInTime  //入库时间
                 dueTime:(NSNumber *) dueTime;  //过期时间

+ (CGFloat)getItemHeight;

@end
