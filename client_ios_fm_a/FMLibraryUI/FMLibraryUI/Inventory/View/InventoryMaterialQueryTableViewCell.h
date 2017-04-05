//
//  InventoryMaterialTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryMaterialQueryTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;

- (void)setInfoWithName:(NSString *)name
                   code:(NSString *)code
          warehouseName:(NSString *)warehouseName
                  brand:(NSString *)brand
                  model:(NSString *)model
         previewImageId:(NSNumber *)previewImageId
            totalNumber:(CGFloat)totalNumber
              minNumber:(CGFloat)minNumber;

+ (CGFloat)getItemHeight;

@end
