//
//  InventoryStorageInTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableViewType) {
    TABLEVIEW_TYPE_STORAGE,
    TABLEVIEW_TYPE_CHECK
};

@interface InventoryStorageInTableViewCell : UITableViewCell

@property (nonatomic, assign) TableViewType tableViewType;

- (void) setInfoWithCode:(NSString *) code
                    name:(NSString *) name
                   brand:(NSString *) brand
                   model:(NSString *) model
              realNumber:(NSNumber *) realNumber  //账面数量
                  number:(NSNumber *) number;     //入库数量

- (void) setSeperatorGapped:(BOOL) isGapped;

+ (CGFloat) getItemHeight;

@end
