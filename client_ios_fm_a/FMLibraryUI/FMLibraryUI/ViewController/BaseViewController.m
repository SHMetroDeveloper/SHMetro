//
//  BaseViewController.m
//  testa
//
//  Created by 杨帆 on 15/4/9.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FMNavigationView.h"
#import "FMUtils.h"
#import "MBProgressHUD.h"
#import "DXAlertView.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
//#import "MobClick.h"
 
#import "NotificationDbHelper.h"
#import "SystemConfig.h"
#import "NotificationBusiness.h"
#import "BaseAlertView.h"
#import "BaseNoticeView.h"
#import "FMTheme.h"

const CGFloat DIALOG_ALIVE_TIME_LONG = 3.0f;
const CGFloat DIALOG_ALIVE_TIME_SHORT = 1.5f;

const NSInteger NOTIFICATION_KEY_MASK = 100;

NSMutableArray * notificationHandlerArray;

const NSString * BASE_NOTIFICATION_LOGOUT_NAME = @"fm_notification_logout";

BaseViewController * currentBaseVC;

@interface BaseViewController ()

@property (readwrite, nonatomic, strong) UIView * navigationContainerView;
//@property (readwrite, nonatomic, strong) UIView * statusbarView;

@property (readwrite, nonatomic, assign) BOOL showNavigationBar;
@property (readwrite, nonatomic, assign) BOOL showBackButton;
@property (readwrite, nonatomic, strong) NSString * titleText;
@property (readwrite, nonatomic, strong) UIImage * titleImage;
@property (readwrite, nonatomic, strong) UIColor * curNavigationColor;

@property (readwrite, nonatomic, assign) BOOL enableSwipeToDismiss; //允许滑动返回

@property (readwrite, nonatomic, strong) UIView * backView; //返回键按钮
@property (readwrite, nonatomic, assign) CGFloat backWidth; //返回键宽度
@property (readwrite, nonatomic, assign) CGRect navigationBarFrame;




@property (readwrite, nonatomic, strong) FMNavigationView * mNavigationBar;
@property (readwrite, nonatomic, strong) NSArray * menusArray;


@property (readwrite, nonatomic, assign) CGFloat navigationHeight;
@property (readwrite, nonatomic, assign) CGFloat statusBarHeight;

@property (readwrite, nonatomic, strong) UITextField * focusedTextField;
@property (readwrite, nonatomic, assign) CGFloat movedHeight;
@property (readwrite, nonatomic, assign) CGFloat keyboardHeight;
@property (readonly, nonatomic, assign) CGFloat DEFAULT_KEYBOARD_HEIGHT;


@property (readwrite, nonatomic, strong) UIColor * statusbarBgColor;
@property (readwrite, nonatomic, strong) UIColor * navigationBgColor;
@property (readwrite, nonatomic, strong) UIColor * navigationTitleColor;


//@property (readwrite, nonatomic, strong) UIAlertController * autoDismisAlert;       //自动消失的提示信息窗体
@property (readwrite, nonatomic, strong) BaseAlertView * autoDismisAlert;
@property (readwrite, nonatomic, strong) BaseNoticeView * noticeView;

@property (readwrite, nonatomic, strong) NSMutableArray * alertArray;   //保存所有当前在使用中的autoDismisAlert

@property (readwrite, nonatomic, strong) MBProgressHUD * hud;
@property (readwrite, nonatomic, strong) NSString * mPageName;   //页面名字
@property (nonatomic) Reachability *hostReachability;

@property (nonatomic, strong) NetPage *msgPage;

@end

@implementation BaseViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _baseVcType = BASE_VC_TYPE_COMMON;
    }
    return self;
}
- (instancetype) initWithFrame: (CGRect) frame {
    self = [super init];
    if(self) {
        _baseVcType = BASE_VC_TYPE_COMMON;
        
        [self setFrame:frame];
    }
    return self;
}

- (instancetype) initWithVcType:(BaseVcType) vcType param:(NSDictionary *) param {
    self = [super init];
    if(self) {
        _baseVcType = vcType;
        _baseVcParam = [param copy];
    }
    return self;
}

- (void) setPageName:(NSString *) pageName {
    _mPageName = pageName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationHeight = 44;
    _statusBarHeight = [FMSize getInstance].statusbarHeight;
    _movedHeight = 0;
    
    _DEFAULT_KEYBOARD_HEIGHT = 216;
    _keyboardHeight = _DEFAULT_KEYBOARD_HEIGHT;
    
    _alertArray = [[NSMutableArray alloc] init];
    
    _statusbarBgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _navigationBgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _navigationTitleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_NAVIGATION_TITLE];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //防止UIScrollView 中内容不从顶部开始
    self.view.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    [self initNavigation];
    [self initLayout];
    [self initNetworkStateListener];
    if(self.showNavigationBar) {
        [self updateNavigationBar];
        if(_curNavigationColor){
            [_navigationContainerView setBackgroundColor: _curNavigationColor];
            [_mNavigationBar setBackgroundWith:_curNavigationColor];
        } else {
            [_navigationContainerView setBackgroundColor: _statusbarBgColor];
            _mNavigationBar.backgroundColor = _navigationBgColor;
        }
        
        [_navigationContainerView addSubview:_mNavigationBar];
        
        [self.view addSubview:_navigationContainerView];
    }
    
//    [self initSwipeGesture];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    currentBaseVC = self;
    if([FMUtils isStringEmpty:_mPageName]) {
        _mPageName = [NSString stringWithUTF8String:object_getClassName(self)];
    }
    [UIView setAnimationsEnabled:YES];  //预防页面切换动画消失
//    [MobClick beginLogPageView:_mPageNage];
    if(!_enableSwipeToDismiss) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    currentBaseVC = nil;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self registerForNetworkStateChangedNotifications];
    [self hideNavigationBar]; //默认不显示导航栏和标签栏
    [self hideTabBar];
    [self initAutoDismissAlert];
    if(_baseVcType == BASE_VC_TYPE_NOTIFICATION_TRANSIT) {
        [self handleNotification];
//        [self resetNotification];
    }
}

//TODO: 存在隐藏BUG，如果右滑，然后取消操作，事件监听就没了
- (void) viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unRegisterForNetworkStateChangedNotifications];
    [self unRegisterForKeyboardNotifications];
//    [MobClick endLogPageView:_mPageNage];
    if(!_enableSwipeToDismiss) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initNetworkStateListener {
    NSString * remoteHostName = [NSURL URLWithString:[SystemConfig getServerAddress]].host;
    if(!_hostReachability) {
        _hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [_hostReachability startNotifier];
    }
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    _hostReachability = reachability;
}

- (void) initAutoDismissAlert {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    if(![FMUtils isVerticalScreen]) {   //横屏的时候尺寸调整
        CGFloat tmp = width;
        width = height;
        height = tmp;
    }
    _autoDismisAlert = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [_autoDismisAlert setHidden:YES];
    
    CGFloat padding = 20;
    CGFloat itemHeight = [BaseNoticeView calculateSizeByTitle:@"" content:@"" width:width-padding*2].height;
    _noticeView = [[BaseNoticeView alloc] initWithFrame:CGRectMake(0, 0, width-padding*2, itemHeight)];
    _noticeView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_noticeView setHidden:YES];
    
    [_autoDismisAlert setContentView:_noticeView];
    [_autoDismisAlert setContentHeight:itemHeight];
    
    [self.tabBarController.view addSubview:_autoDismisAlert];
}

- (void) initSwipeGesture {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void) handleSwipeGesture:(id) sender {
    if (_enableSwipeToDismiss) {
        [self onBackButtonPressed];
    }
}

- (BaseVcType) getVcType {
    return _baseVcType;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//内部用来更新导航栏
- (void) updateNavigationBar {
    if(!_navigationContainerView) {
        _navigationContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _statusBarHeight + _navigationHeight)];
    }
    _navigationBarFrame = CGRectMake(0, _statusBarHeight, self.view.frame.size.width, _navigationHeight);
    
    
    if(!_mNavigationBar) {
        _mNavigationBar = [[FMNavigationView alloc] init];
    }
    [_mNavigationBar setFrame:self.navigationBarFrame];
    if(_titleImage) {
        [_mNavigationBar setTitleWithImage:_titleImage];
    } else if(![FMUtils isStringEmpty:_titleText]){
        [_mNavigationBar setTitle:_titleText];
    }
    [_mNavigationBar setOnFMNavigationViewListener:self];
    if(self.menusArray) {
        [_mNavigationBar setMenuWithArray:self.menusArray];
    } else {
        [_mNavigationBar setMenuWithArray:nil];
    }
    if(_backView) {
        [_mNavigationBar setBackBarWithView:_backView andbackWidth:_backWidth];
    } else {
        [_mNavigationBar setShowBackButton:self.showBackButton];
    }
}

- (void) initNavigation {
}

- (void) setMenuWithTextArray: (NSArray *) menuArray {
    _menusArray = menuArray;
}

- (void) setMenuWithArray: (NSArray *) menuArray {
    self.menusArray = menuArray;
}

- (void) setTitleWith: (NSString *) title {
    self.title = title;
    self.titleText = title;
    self.showNavigationBar = YES;
}

//设置图片标题
- (void) setTitleWithImage:(UIImage *) imgTitle {
    _titleImage = imgTitle;
    _showNavigationBar = YES;
}

//设置返回按钮
- (void) setBackBarWithView:(UIView *) backView andbackWidth:(CGFloat) backWidth {
    _backView = backView;
    _backWidth = backWidth;
    _showNavigationBar = YES;
}

- (void) setShowNavigation: (BOOL) show {
    self.showNavigationBar = show;
}

- (void) setBackAble: (BOOL) backAble {
    self.showBackButton = backAble;
    _enableSwipeToDismiss = backAble;
}

//设置导航栏背景色
- (void) setNavigationColor:(UIColor *) color {
    _curNavigationColor = color;
    
}

//设置 statusbar 的背景色
- (void) setStatusBarColor:(UIColor *) color {
    _navigationContainerView.backgroundColor = color;
}

- (void) initLayout {
    
}

//回退指定层级的界面
- (void) backToParentWithLevel:(NSInteger) backLevel {
    NSInteger count = [self.navigationController.viewControllers count];
    NSInteger index = 0;
    NSInteger cur = count - 1;
    if(cur > backLevel) {
        index = cur - backLevel;      //回退两级
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}

- (void) finish {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    else {
//        [self dismissViewControllerAnimated:NO completion:^{
//            
//        }];
//    }
}

//在 seconds 秒后关闭窗口
- (void) finishAfterSeconds:(NSInteger) seconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finish];
    });
}

- (void) finishRightNow {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void) onBackButtonPressed {
    [self finish];
}
- (void) onMenuItemClicked: (NSInteger) position {
}

- (void) setBackGroundColorWith: (UIColor *) backgroundColor {
    self.view.backgroundColor = backgroundColor;
}

- (CGFloat) getNavigationBarHeight {
    CGFloat height = 0;
    if(self.showNavigationBar) {
        height = self.navigationHeight + self.statusBarHeight;
    } else {
        height = self.statusBarHeight;
    }
    return height;
}

- (CGRect) getContentFrame {
    CGRect frame = self.view.frame;
    CGFloat height = [self getNavigationBarHeight];
    if(self.showNavigationBar) {
        frame.size.height = self.view.frame.size.height - height;
        frame.origin.y = height;
    }
    return frame;
}

- (void) setFrame: (CGRect) frame {
    self.view.frame = frame;
    if(self.showNavigationBar) {
        [self updateNavigationBar];
        [_navigationContainerView addSubview:_mNavigationBar];
        [self.view addSubview:_navigationContainerView];
    }
}

#pragma - 文本框的输入事件处理
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if(_focusedTextField) {
        [self resetCurTextField];
        _focusedTextField = textField;
        [self moveCurTextField];
    } else {
        _focusedTextField = textField;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *) theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    return YES;
}

//根据键盘位置移动 文本框
- (void) moveCurTextField{
    if(_focusedTextField) {
        CGRect frame = _focusedTextField.frame;
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[_focusedTextField convertRect: _focusedTextField.bounds toView:window];
        CGFloat y = rect.origin.y;
        CGFloat moveHeight = y + rect.size.height - (self.view.frame.size.height - _keyboardHeight);
        self.movedHeight = 0;
        if(moveHeight > 0) {
            frame.origin.y -= moveHeight;
            self.movedHeight = moveHeight;
            [UIView animateWithDuration:0.3 animations:^{
                _focusedTextField.frame = frame;
            }];
        }
    }
}

//复位移动的文本框
- (void) resetCurTextField {
    if(_focusedTextField) {
        if(self.movedHeight > 0) {
            CGRect frame = _focusedTextField.frame;
            frame.origin.y += self.movedHeight;
            [UIView animateWithDuration:0.3 animations:^{
                _focusedTextField.frame = frame;
            }];
        }
    }
}


- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    [self resetCurTextField];
    _focusedTextField = nil;
    return YES;
}

#pragma - 对话框
//显示加载对话框
- (void) showLoadingDialog {
    if(!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = [[BaseBundle getInstance] getStringByKey:@"loading" inTable:nil];
    }
    [self.view addSubview:_hud];
    [_hud show:YES];
}

//显示加载对话框
- (void) showLoadingDialogwith:(NSString *) msg {
    if(!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = msg;
    }
    [self.view addSubview:_hud];
    [_hud show:YES];
}

//隐藏加载对话框
- (void) hideLoadingDialog {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//显示网络设置对话框
- (void) showNetworkSettingDialog {
    DXAlertView * dialog = [[DXAlertView alloc] initWithTitle:@"网络设置" contentText:@"网络连接失败,是否现在进行设置" leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] rightButtonTitle:@"现在设置" viewController:self];
    dialog.leftBlock = ^(){
        
    };
    dialog.rightBlock = ^(){
        [self performSelectorOnMainThread:@selector(gotoNetworkSetting) withObject:nil waitUntilDone:NO];
    };
    dialog.dismissBlock = ^(){
        
    };
    [dialog showIn:self];
}
- (void) gotoNetworkSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}



- (void) gotoViewController:(UIViewController *) targetVC {
    [self performSelectorOnMainThread:@selector(gotoViewControllerD:) withObject:targetVC waitUntilDone:NO];
}

- (void) gotoViewControllerD:(UIViewController *) targetVC {
    if(self.navigationController) {
        targetVC.hidesBottomBarWhenPushed = YES;//用于隐藏 tabbar
        [self.navigationController pushViewController:targetVC animated:YES];
    }
//    else {
//        [self presentViewController:targetVC animated:NO completion:^{
//        }];
//    }
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [super performSegueWithIdentifier:identifier sender:sender];
    self.hidesBottomBarWhenPushed = NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    }
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)showTabBar {
    if (self.tabBarController.tabBar.hidden == NO) {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    }
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void) hideNavigationBar {
    if(self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void) reLogin {
}

#pragma mark - keyboardHight
//-(void)viewWillAppear:(BOOL)animated
//{
//    
//}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) unRegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    CGFloat keyboardhight = 0;
    if(kbSize.height == 216) {
        keyboardhight = 0;
    } else {
        keyboardhight = 36;   //252 - 216 系统键盘的两个不同高度
    }
    _keyboardHeight = kbSize.height;
    [self moveCurTextField];
}

//当键盘隐藏的时候
- (void) keyboardWillBeHidden:(NSNotification*) aNotification {
    //do something
    [self resetCurTextField];
}


//判断当前输入法
-(void)textViewDidChangeSelection:(UITextView *)textView {
    /*
     if ([[UITextInputMode currentInputMode] primaryLanguage] == @"en-US") {
     NSLog(@"en-US");
     }
     else
     {
     NSLog(@"zh-hans");
     }
     */
}

- (void) showAutoDismissMessageWith:(NSString *) title andMessage:(NSString *) message time:(CGFloat) timeAlive {
        [NSTimer scheduledTimerWithTimeInterval:timeAlive target:self selector:@selector(autoHideMessage)  userInfo:nil repeats:NO];
        
        CGFloat padding = 20;
        CGFloat width =CGRectGetWidth(self.view.frame);
        CGFloat itemWidth = width - padding * 2;
        CGSize size = [BaseNoticeView calculateSizeByTitle:title content:message width:itemWidth];
        CGRect frame = _noticeView.frame;
        frame.size = size;
        [_noticeView setInfoWithTitle:title message:message];
        [_noticeView setFrame:frame];
        
        
        [_autoDismisAlert setPadding:padding];
        [_autoDismisAlert setContentHeight:size.height];
        
        [_autoDismisAlert show];
}

- (void) autoHideMessage {
    [_autoDismisAlert close];
}

#pragma - statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;    //设置为白色
//    return UIStatusBarStyleDefault;         //默认为黑色
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma --- 通知处理机制

//提示收到了通知
- (void) didReceivedNotification {
    [self requestUnReadMsgFromServer];
}
//消息记录更新了
- (void) didNotificationUpdated:(NSNumber *) count {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationBadgeUpdate" object:count];
}
//子 ViewController 通过重写本方法实现对通知的处理
- (void) handleNotification {
    
}

//通知需要更新消息
- (void) notifyNotificationNeedUpdate {
    [self requestUnReadMsgFromServer];
}
//通知需要加载更多消息
- (void) notifyNotificationNeedLoadMore {
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        if([_msgPage haveMorePage]) {
            [_msgPage nextPage];
            [self requestUnReadMsgFromServerPage];
        } else {
            [self didNotificationUpdated:_msgPage.totalCount];
        }
    });
}


- (void) requestUnReadMsgFromServerPage {
    NotificationQueryParam *param = [[NotificationQueryParam alloc] init];
    param.read = NOTIFICATION_READ_TYPE_UNREAD;
    param.type = NOTIFICATION_ITEM_TYPE_UNKNOW; //所有类型的消息
    [param setPage:_msgPage];
    
    [[NotificationBusiness getInstance] queryMessageListBy:param success:^(NSInteger key, id object) {
        NotificationQueryResponseData * data = object;
        _msgPage = data.page;
        NSMutableArray * msgs = data.contents;
        NSNumber * userId = [SystemConfig getUserId];
        if([msgs count] > 0) {
            [[NotificationDbHelper getInstance] addNotifications:msgs withUserId:userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                [BaseViewController updateAppBageIcon:_msgPage.totalCount.integerValue];
                [self didNotificationUpdated:_msgPage.totalCount];
            });
        }
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"获取消息失败");
    }];
//    [[NotificationBusiness getInstance] queryMessageListWithTimeStart:nil timeEnd:nil read:NOTIFICATION_READ_TYPE_UNREAD page:_msgPage success:^(NSInteger key, id object) {
//        NSNumber * userId = [SystemConfig getUserId];
//        //        [[NotificationDbHelper getInstance] markAllNotificationReadByUser:userId];
//        if(object) {
//            NotificationQueryResponseData * data = object;
//            NSMutableArray * msgs = data.contents;
//            [_msgPage setPage:data.page];
//            [[NotificationDbHelper getInstance] addNotifications:msgs withUserId:userId];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [BaseViewController updateAppBageIcon:_msgPage.totalCount.integerValue];
//                [self didNotificationUpdated:_msgPage.totalCount];
//            });
//        }
//    } fail:^(NSInteger key, NSError *error) {
//        NSLog(@"获取未读消息列表失败：%@", error);
//        [self didNotificationUpdated:[NSNumber numberWithInteger:0]];
//    }];
}

//从服务器拉取推送消息
- (void) requestUnReadMsgFromServer {
    _msgPage = [[NetPage alloc] init];
    __weak id weakSelf = self;
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [weakSelf requestUnReadMsgFromServerPage];
    //    });
}


//清除通知状态
- (void) resetNotification {
    _baseVcType = BASE_VC_TYPE_COMMON;
    _baseVcParam = nil;
}



- (void) handleNotificationOfType:(NSInteger) key withParam:(NSDictionary *) param{
//    NSString * strTmp = [[NSString alloc] initWithFormat:@"---type:%@", param];
//    [self showAutoDismissMessageWith:@"消息" andMessage:strTmp time:DIALOG_ALIVE_TIME_LONG];
    BaseViewController * targetVC = [BaseViewController getNotificationTargetOfType:key];
    [targetVC setBaseVcParam:param];
    [targetVC handleNotification];
//    [BaseViewController updateAppBageIcon];
    if(![targetVC isKindOfClass:[self class]]) {
        [self gotoViewController:targetVC];
    }
}

- (NSString *) getClassName {
    NSString * name = NSStringFromClass([self class]);
    return name;
}

//网络状态发生改变
- (BOOL) isServerReachable {
    BOOL res = YES;
    NetworkStatus netStatus = [_hostReachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            res = NO;
            break;
            
        default:
            break;
    }
    return res;
}

//获取网络状态
- (NetworkStatus) getServerStatus {
    NetworkStatus status = [_hostReachability currentReachabilityStatus];
    return status;
}



- (void)registerForNetworkStateChangedNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    
}

- (void) unRegisterForNetworkStateChangedNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

//网络状态改变
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

//注册一个通知处理代理
+ (void) registerNotificationType:(NSInteger) key targetVC:(BaseViewController *) baseHanlderVC{
    if(!notificationHandlerArray) {
        notificationHandlerArray = [[NSMutableArray alloc] init];
    }
    NSInteger position = [BaseViewController getHandlerPositionOfNotificationType:key];
    NSInteger count = [notificationHandlerArray count];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:key], @"type", baseHanlderVC, @"target", nil];
    if(position >= 0 && position < count) {
        notificationHandlerArray[position] = dic;
    } else {
        [notificationHandlerArray addObject:dic];
    }
}

+ (NSInteger) getHandlerPositionOfNotificationType:(NSInteger) key {
    NSInteger position = -1;
    if(notificationHandlerArray && [notificationHandlerArray count] > 0) {
        NSInteger count = [notificationHandlerArray count];
        NSInteger index = 0;
        NSNumber * tmpNumber;
        for(index=0;index<count;index++) {
            NSMutableDictionary * dic = notificationHandlerArray[index];
            tmpNumber = [dic valueForKeyPath:@"type"];
            if(tmpNumber && tmpNumber.integerValue == key) {
                position = index;
                break;
            }
        }
    }
    return position;
}

+ (BaseViewController *) getNotificationTargetOfType:(NSInteger) key {
    BaseViewController * targetVC;
    NSInteger position = [BaseViewController getHandlerPositionOfNotificationType:key];
    if(position >= 0) {
        NSDictionary * dic = notificationHandlerArray[position];
        targetVC = [dic valueForKeyPath:@"target"];
    }
    return targetVC;
}

//根据通知类型获取相应的 key
+ (NSInteger) getKeyByType:(NSInteger) type {
    NSInteger key = type * NOTIFICATION_KEY_MASK;
    return key;
}

+ (NSInteger) getKeyByMainType:(NSInteger) type andSubType:(NSInteger) subType {
    NSInteger key = type * NOTIFICATION_KEY_MASK + subType;
    return key;
}

+ (NSInteger) getMainTypeOfKey:(NSInteger) key {
    NSInteger type = key / NOTIFICATION_KEY_MASK;
    return type;
}

+ (NSInteger) getSubTypeOfKey:(NSInteger) key {
    NSInteger type = key % NOTIFICATION_KEY_MASK;
    return type;
}

- (void)retractKeyboard {
    //获取第一响应者
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [(UITextField *)firstResponder resignFirstResponder];
    } else if ([firstResponder isKindOfClass:[UITextView class]]) {
        [(UITextView *)firstResponder resignFirstResponder];
    }
}


//更新应用图标数字
+ (void) updateAppBageIcon:(NSInteger) count {
    if(count > 99) {    //超过99的时候只显示99
        count = 99;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
}

//通知系统退出
+ (void) notifyLogout {
    [[NSNotificationCenter defaultCenter] postNotificationName:[BaseViewController getBaseNotificationNameByType:BASE_NOTIFICATION_LOGOUT] object:nil];
}

//根据通知类型获取通知名称
+ (NSString *) getBaseNotificationNameByType:(BaseNotificationType) type {
    NSString * res;
    switch (type) {
        case BASE_NOTIFICATION_LOGOUT:
            res = [BASE_NOTIFICATION_LOGOUT_NAME copy];
            break;
            
        default:
            break;
    }
    return res;
}


@end
