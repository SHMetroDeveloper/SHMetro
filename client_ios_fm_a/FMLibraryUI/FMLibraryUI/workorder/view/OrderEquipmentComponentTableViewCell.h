//
//  OrderEquipmentComponentTableViewCell.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/5.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface OrderEquipmentComponentTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *code;//组件编码
@property (nonatomic, strong) NSString *name;//组件名称

@property (nonatomic, assign) BOOL isLast;  //是否为最后一条记录

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需高度
+ (CGFloat) getCellHeight;

@end
