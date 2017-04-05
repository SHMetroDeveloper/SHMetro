//
//  MenuAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, MenuAlertViewType) {
    MENU_ALERT_TYPE_NORMAL,
    MENU_ALERT_TYPE_CANCEL,
};

typedef void (^ActionHandler) (UIAlertAction * action);

@interface MenuAlertContentView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置菜单
- (void) setMenuWithArray:(NSMutableArray *) array;

- (void) setFont:(UIFont *) font;

//设置是否显示取消按钮
- (void) setShowCancelMenu:(BOOL) show;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;


+ (CGFloat) calculateHeightByCount:(NSInteger) menuCount showCancel:(BOOL) showCancel;

@end
