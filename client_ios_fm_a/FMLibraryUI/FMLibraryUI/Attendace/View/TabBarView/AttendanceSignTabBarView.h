//
//  AttendanceSignTabBarView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SignTabBarActionType) {
    SIGN_ACTION_BUTTON_SIGN,      //签到
    SIGN_ACTION_BUTTON_SETTING,   //设置
};

typedef void(^SignTabBarActionBlock)(SignTabBarActionType type);

@interface AttendanceSignTabBarView : UIView

@property (nonatomic, copy) SignTabBarActionBlock actionBlock;

+ (CGFloat) getItemHeight;
@end
