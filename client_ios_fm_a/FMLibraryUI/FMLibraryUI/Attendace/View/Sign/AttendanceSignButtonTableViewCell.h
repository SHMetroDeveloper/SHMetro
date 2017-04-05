//
//  AttendanceSignOutView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SignInButtonEventType) {
    SIGN_BUTTON_EVENT_TYPE_IN,  //签入
    SIGN_BUTTON_EVENT_TYPE_OUT  //签出
};

typedef void(^SignInActionBlock)(SignInButtonEventType type);

@interface AttendanceSignButtonTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isTopTimeLineShow;  //是否显示上时间线
@property (nonatomic, strong) NSNumber *queryTime;     //查询时间
@property (nonatomic, assign) NSInteger employeeType;  //员工权限
@property (nonatomic, assign) BOOL editable;           //是否可签到
@property (nonatomic, assign) BOOL isSignIn;           //签入还是签出
@property (nonatomic, strong) NSString *signStatusDesc;//签到描述

@property (nonatomic, copy) SignInActionBlock actionBlock;

+ (CGFloat) calculateHeight;

@end
