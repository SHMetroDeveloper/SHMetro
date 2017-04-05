//
//  AttendanceSettingLocationTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceSettingLocationTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSeperatorDotted;  //分割线 是否为虚线
@property (nonatomic, assign) BOOL isGapped;           //风格先 是否为全宽

@property (nonatomic, assign) BOOL isShowState;             //是否显示
@property (nonatomic, assign) BOOL enable;             //是否启用
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *locationDesc;

+ (CGFloat) calculateHeight;

@end
