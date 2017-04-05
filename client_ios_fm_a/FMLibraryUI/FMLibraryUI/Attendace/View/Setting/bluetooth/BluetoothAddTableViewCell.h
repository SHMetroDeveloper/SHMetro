//
//  BluetoothAddTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothAddTableViewCell : UITableViewCell

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * desc;
@property (nonatomic, assign) BOOL checked; //是否被选中
@property (nonatomic, assign) BOOL isLast;  //是否为最后一条数据

//计算需要的高度
+ (CGFloat) calculateHeight;
@end
