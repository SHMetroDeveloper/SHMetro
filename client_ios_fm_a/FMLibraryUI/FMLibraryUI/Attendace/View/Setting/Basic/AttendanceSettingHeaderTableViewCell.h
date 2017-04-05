//
//  AttendanceSettingHeaderTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SettingBtnActionBlock)();

@interface AttendanceSettingHeaderTableViewCell : UITableViewCell

@property (nonatomic, copy) SettingBtnActionBlock actionBlock;

+ (CGFloat) calculateHeight;

@end
