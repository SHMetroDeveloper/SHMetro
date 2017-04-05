//
//  BaseViewController.h
//  testa
//
//  Created by 杨帆 on 15/4/9.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMNavigationView.h"
#import "Reachability.h"
#import "FMUtilsPackages.h"
#import "NotificationServerConfig.h"

extern const CGFloat DIALOG_ALIVE_TIME_LONG;
extern const CGFloat DIALOG_ALIVE_TIME_SHORT;

typedef NS_ENUM(NSInteger, BaseVcType) {
    BASE_VC_TYPE_COMMON,
    BASE_VC_TYPE_NOTIFICATION_TRANSIT,  //接收到通知消息，中转
};

typedef NS_ENUM(NSInteger, BaseNotificationType) {
    BASE_NOTIFICATION_UNKNOW,
    BASE_NOTIFICATION_LOGOUT,   //退出登录
    
};


@protocol OnViewControllerFinishedListener;

@interface BaseViewController : UIViewController <OnFMNavigationViewListener, UITextFieldDelegate>

@property (readwrite, nonatomic, assign) BaseVcType baseVcType;
@property (readwrite, nonatomic, strong) NSDictionary* baseVcParam;

- (instancetype) init;

- (instancetype) initWithFrame: (CGRect) frame;

- (instancetype) initWithVcType:(BaseVcType) vcType param:(NSDictionary *) param;


- (void) handleNotification;

//设置名字，用于统计时使用
- (void) setPageName:(NSString *) pageName;

//初始化导航栏 --- 子ViewController 的 返回按钮，title 以及 菜单需要通过重写本函数来设置
- (void) initNavigation;

//更新导航栏 --- 导航栏重绘（子类只可调用此方法，不可重写此方法）
- (void) updateNavigationBar;

- (void) setFrame: (CGRect) frame;
//设置菜单---文本数组
- (void) setMenuWithTextArray: (NSArray *) menuArray;

//设置自定义菜单, 可以是文字或者图片
- (void) setMenuWithArray: (NSArray *) menuArray;

//设置界面标题
- (void) setTitleWith: (NSString *) title;

//设置图片标题
- (void) setTitleWithImage:(UIImage *) imgTitle;

//设置返回按钮
- (void) setBackBarWithView:(UIView *) backView andbackWidth:(CGFloat) backWidth;

//设置是否显示导航栏
- (void) setShowNavigation: (BOOL) show;

//设置导航栏背景色
- (void) setNavigationColor:(UIColor *) color;

//隐藏tabbar
- (void)hideTabBar;

//显示tabbar
- (void) showTabBar;

//设置是否显示返回键
- (void) setBackAble: (BOOL) backAble;

//子类必须通过重写本方法来实现布局，否则可能引起不必要的麻烦
- (void) initLayout;

//设置背景色
- (void) setBackGroundColorWith: (UIColor *) backgroundColor;


//获取导航栏所占高度
- (CGFloat) getNavigationBarHeight;

//获取除导航栏之外的窗体大小
- (CGRect) getContentFrame;

//按返回键
- (void) onBackButtonPressed;

//关闭当前窗体
- (void) finish;

//在 seconds 秒后关闭窗口
- (void) finishAfterSeconds:(NSInteger) seconds;

//马上关闭当前窗口，不带动画效果
- (void) finishRightNow;

//回退指定层级的界面, backLevel --- 回退的等级
- (void) backToParentWithLevel:(NSInteger) backLevel;


//显示加载对话框
- (void) showLoadingDialog;

//显示指定信息加载对话框
- (void) showLoadingDialogwith:(NSString *) msg;

//隐藏加载对话框
- (void) hideLoadingDialog;

//显示网络设置对话框
- (void) showNetworkSettingDialog;

//显示可以自动消失的信息提示框
- (void) showAutoDismissMessageWith:(NSString *) title
                         andMessage:(NSString *) message
                               time:(CGFloat) timeAlive;


//界面切换
- (void) gotoViewController:(UIViewController *) targetVC;

//键盘事件监听
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

//通知系统去服务器取新消息
- (void) notifyNotificationNeedUpdate;
//收到通知之后会回调本方法
- (void) didReceivedNotification;
//本地消息记录更新了
- (void) didNotificationUpdated;
//通知处理
- (void) handleNotificationOfType:(NSInteger) key withParam:(NSDictionary *) param;

//获取当前类的名字
- (NSString*) getClassName;

//判断服务器连接状态
- (BOOL) isServerReachable;

//获取网络状态
- (NetworkStatus) getServerStatus;

//注册一个通知处理代理
+ (void) registerNotificationType:(NSInteger) key targetVC:(BaseViewController *) baseHanlderVC;
//获取通知类型的 key
+ (NSInteger) getKeyByMainType:(NSInteger) type andSubType:(NSInteger) subType;
+ (NSInteger) getKeyByType:(NSInteger) type;

//获取主类型
+ (NSInteger) getMainTypeOfKey:(NSInteger) key;
//获取子类型
+ (NSInteger) getSubTypeOfKey:(NSInteger) key;

//缩回键盘
- (void)retractKeyboard;

//更新应用图标右上角数字
+ (void) updateAppBageIcon:(NSInteger) count;

//通知系统退出
+ (void) notifyLogout;

//根据通知类型获取通知名称
+ (NSString *) getBaseNotificationNameByType:(BaseNotificationType) type;
@end


extern BaseViewController * currentBaseVC;
