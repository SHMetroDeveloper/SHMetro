//
//  WifiDetailTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/9.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WiFiEnableActionBlock)(BOOL enable);

@interface WifiDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) BOOL isEnable;

@property (nonatomic, assign) BOOL isLast;//最后一条记录

@property (nonatomic, copy) WiFiEnableActionBlock actionBlock;

+ (CGFloat) calculateHeight;

@end
