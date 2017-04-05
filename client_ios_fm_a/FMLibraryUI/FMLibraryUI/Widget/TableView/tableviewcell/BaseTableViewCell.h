//
//  AttendanceSettingWifiTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;

@property (nonatomic, assign) BOOL isLast;//最后一条记录

- (void)setName:(NSString *)name;
- (void)setDesc:(NSString *)desc;
- (void) setIsLast:(BOOL)isLast;

@end
