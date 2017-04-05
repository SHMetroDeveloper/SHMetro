//
//  LoginViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ClearableEditText.h"
 
#import "FMTheme.h"
#import "FMImage.h"
#import "UIButton+Bootstrap.h"
#import "SystemConfig.h"
#import "OAuthFM.h"
#import "FMUtils.h"
#import "DXAlertView.h"
#import "DBHelper.h"
#import "UserEntity.h"
#import "BasePreference.h"
#import "BaseTextField.h"
#import "BaseDataDbHelper.h"
#import "ServerAddressEditView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseDataDownloader.h"
#import "ProjectsViewController.h"
#import "FloatTextField.h"
#import "BaseDataNetRequest.h"
#import "ServerInfoEntity.h"
#import "BaseAlertView.h"
#import "LoginListener.h"
#import "BaseBundle.h"
#import "TokenConvertBusines.h"
#import "AccessTokenKeeper.h"
#import "FMToken.h"


static OAuthFM * testOauth = nil;

@interface LoginViewController () <LoginListener, OnItemClickListener, UIGestureRecognizerDelegate>

//@property (readwrite, nonatomic, strong) UIImageView* logoImgView;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) FloatTextField* usernameClearEt;
@property (readwrite, nonatomic, strong) FloatTextField* passwordClearEt;
@property (readwrite, nonatomic, strong) UIButton* loginBtn;
@property (readwrite, nonatomic, strong) UILabel* noteLbl;

@property (readwrite, nonatomic, strong) BaseAlertView * alertView;
@property (readwrite, nonatomic, strong) ServerAddressEditView * addressView; //地址输入框

@property (readwrite, nonatomic, strong) UIImage * logoTitleImg;

@property (readwrite, nonatomic, strong) NSString* mLoginName;
@property (readwrite, nonatomic, strong) NSString* mPassword;
@property (readwrite, nonatomic, assign) CGFloat defaultWidth;

@property (readwrite, atomic, assign) BOOL isLogining;
@property (readwrite, nonatomic, strong) NSCondition * mlock;
@property (readwrite, nonatomic, strong) UserInfo * user;
@property (readwrite, nonatomic, strong) BaseDataDbHelper* dbHelper;
@property (readwrite, nonatomic, strong) NSString *primaryToken;
@end


@implementation LoginViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithVcType:(BaseVcType)vcType param:(NSDictionary *)param {
    self = [super initWithVcType:vcType param:param];
    if(self) {
        [self showNitificationNotice];
    }
    return self;
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _usernameClearEt = [[FloatTextField alloc] init];
        _passwordClearEt = [[FloatTextField alloc] init];
        
        _mainContainerView = [[UIView alloc] init];
        _loginBtn = [[UIButton alloc] init];
        _noteLbl = [[UILabel alloc] init];
        
        _noteLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _noteLbl.text = @"FacilityONE Technology";
        _noteLbl.textAlignment = NSTextAlignmentCenter;
        _noteLbl.font = [FMFont getInstance].defaultFontLevel3;
        
        //    [_usernameClearEt setTextFont:[FMFont getInstance].defaultFontLevel1];
        //    [_passwordClearEt setTextFont:[FMFont getInstance].defaultFontLevel1];
        
        _mlock = [[NSCondition alloc] init];
        
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [_mainContainerView addSubview:_usernameClearEt];
        [_mainContainerView addSubview:_passwordClearEt];
        
        [_mainContainerView addSubview:_loginBtn];
        [_mainContainerView addSubview:_noteLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"login_btn_title" inTable:nil]];
//    _logoTitleImg = [UIImage imageNamed:@"logo_facilityone"];
    [self setTitleWithImage:_logoTitleImg];
    
//    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dbHelper = [BaseDataDbHelper getInstance];
    [self initViews];
    [self getUserInfoLocal];
    BOOL autoLogin = [BasePreference getUserInfoNumber:@"autoLogin"].boolValue;
    if(autoLogin) {
        if([self isUserLogined]) {
            [self performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUserInfoLocal];
}

- (void) initViews {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    
    CGFloat etHeight = 50;
    CGFloat itemHeight = 40;
    CGFloat paddingBottom = padding;
    CGFloat sepHeight = 35;
    CGFloat originY = height / 10;
    CGFloat btnHeight = itemHeight;
    
    _defaultWidth = width - padding*2;
    
    [_mainContainerView setFrame:[self getContentFrame]];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    [_usernameClearEt setFrame:CGRectMake(padding, originY, width-padding*2, etHeight)];
    originY += etHeight + sepHeight/2;
    [_passwordClearEt setFrame:CGRectMake(padding, originY, width-padding*2, etHeight)];
    originY += etHeight + sepHeight;
    
    [_usernameClearEt setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"login_username" inTable:nil]];
    
    [_usernameClearEt addTarget:self action:@selector(onUserNameChanged) forControlEvents:UIControlEventEditingChanged];
    
    [_passwordClearEt setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"login_password" inTable:nil]];
    [_passwordClearEt setSecureTextEntry:YES];
    
    
    [_loginBtn setFrame:CGRectMake(padding, originY, width-padding*2, btnHeight)];
    [_loginBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"login_btn_title" inTable:nil] forState:UIControlStateNormal];
    originY += etHeight + sepHeight;
    
    [_loginBtn primaryStyle];
    _loginBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _loginBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] CGColor];
    [_loginBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] width:1 height:1] forState:UIControlStateHighlighted];
    [_loginBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
    
    [self setServerAddressEditable];
    [self initAddressSetDialog];
    
    CGFloat noteHeight = [FMUtils heightForStringWith:_noteLbl value:_noteLbl.text andWidth:width];
    [_noteLbl setFrame:CGRectMake(0, height-noteHeight-paddingBottom, width, noteHeight)];
}

- (void) showNitificationNotice {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"notification_need_login" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}


- (void) handleNotificationOfType:(NSInteger) key withParam:(NSDictionary *) param{
    //    NSString * strTmp = [[NSString alloc] initWithFormat:@"---type:%@", param];
    //    [self showAutoDismissMessageWith:@"消息" andMessage:strTmp time:DIALOG_ALIVE_TIME_LONG];
    
//    BaseViewController * targetVC = [BaseViewController getNotificationTargetOfType:key];
//    [targetVC setBaseVcParam:param];
//    [targetVC handleNotification];
//    [BaseViewController removeAppIconBadge];
//    if(![targetVC isKindOfClass:[self class]]) {
//        [self gotoViewController:targetVC];
//    }
    if(param) {
        self.baseVcType = BASE_VC_TYPE_NOTIFICATION_TRANSIT;
        self.baseVcParam = [param copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNitificationNotice];
        });
    }
    
}


//初始化服务器地址的设置对话框
- (void) initAddressSetDialog {
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat itemWidth = self.view.frame.size.width - paddingLeft * 2;
    CGFloat itemHeight = 170;
    
    _alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
    [_alertView setHidden:YES];
    
    _addressView = [[ServerAddressEditView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
    _addressView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_addressView setHidden:YES];
    [_addressView setDelegate:self];
    [_addressView setOnItemClickListener:self];
    [_addressView setShowCorner:YES];
    
    [_alertView setContentView:_addressView];
    [_alertView setPadding:paddingLeft];
    [_alertView setContentHeight:itemHeight];
    
    
    [self.view addSubview:_alertView];
    
    // And launch the dialog
    
}

//仪电对接token获取接口
- (void)setPrimaryToken:(NSString *)token {
    _primaryToken = [token copy];
}

- (void) onUserNameChanged {
    NSString * newName = [_usernameClearEt getText];
    if([FMUtils isStringEmpty:newName]) {
        [_passwordClearEt setText:@""];
    }
}

//设置地址可编辑，使logo处于可响应长按状态
- (void) setServerAddressEditable {
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleTableviewCellLongPressed:)];
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    _noteLbl.userInteractionEnabled = YES;
    [_noteLbl addGestureRecognizer:longPress];
}

//长按事件的实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        [self showAddressEditDialog];
    }
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
    }
    
}

- (void) showAddressEditDialog {
    NSString * address = [SystemConfig getServerAddress];
    [_addressView setDefaultAddress:address];
    [_addressView setAddress:address];
    [_alertView show];
}


- (BOOL) isUserLogined {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    BOOL res = NO;
    if(![FMUtils isStringEmpty:accessToken]) {
        res = YES;
    }
    return res;
}

- (void) login {
    if([self isServerReachable]) {
        if (![FMUtils isStringEmpty:_primaryToken]) {
            [self testConvertToken];
        } else {
            [self testOauth];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"net_reachable_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void)testConvertToken {
    TokenConvertBusines *business = [[TokenConvertBusines alloc] init];
   // _primaryToken = @"56de86a0-7069-4fc6-bf4f-fcbbac549bc2";
    __weak typeof(self) weakSelf = self;
    [business tokenConvert:_primaryToken success:^(NSInteger key, id object) {
        FMToken *token = [[FMToken alloc] initWithJsonObject:object];
        AccessTokenKeeper *mKeeper = [[AccessTokenKeeper alloc] initWithName: @"OAuthConfig"];
        [mKeeper keepAccessToken:token];
        [weakSelf testOauth];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"login_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        
    }];
}

- (void) testOauth {
    [_mlock lock];
    if(!_isLogining) {
        _isLogining = YES;
        [_mlock unlock];
        _mLoginName = [self.usernameClearEt getText];
        _mPassword = [self.passwordClearEt getText];
        testOauth = [[OAuthFM alloc] initWithAppKey:APP_KEY appScrete:APP_SCRETE serverUrl: [SystemConfig getServerAddress] deviceId:[FMUtils getDeviceIdString]];
        [self showLoadingDialog];
        [testOauth startOauthByName:_mLoginName password:_mPassword listener:self];
    } else {
        [_mlock unlock];
    }
}

- (void) gotoMain {
    CGRect frame = self.view.frame;
    MainViewController * mainVC;
//    NSString * strVcType = [[NSString alloc] initWithFormat:@"---type:%@", [self.baseVcParam valueForKeyPath:@"type"]];
//     NSString * strVcType = [[NSString alloc] initWithFormat:@"---type:%@", self.baseVcParam];
//    [self showAutoDismissMessageWith:@"消息" andMessage:strVcType time:DIALOG_ALIVE_TIME_SHORT];
    if(self.baseVcType == BASE_VC_TYPE_NOTIFICATION_TRANSIT) {
        mainVC = [[MainViewController alloc] initWithType:self.baseVcType param:self.baseVcParam];
    } else {
        mainVC = [[MainViewController alloc] initWithFrame:frame];
    }
    [self gotoViewController:mainVC];
}

//项目选择页面
- (void) gotoProjectSelect {
    ProjectsViewController * projectsVC = [[ProjectsViewController alloc] initWithType:PROJECT_BACK_TYPE_NEW];
    [self gotoViewController:projectsVC];
}


//请求服务器的ID
- (void) requestServerId {
    NSNumber * userId = [SystemConfig getUserId];
    ServerInfoRequestParam * param = [[ServerInfoRequestParam alloc] initWith:userId];
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    BaseDataNetRequest * netRequest = [BaseDataNetRequest getInstance];
    [netRequest request:param token:token deviceId:devId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取服务器ID成功。");
        [self hideLoadingDialog];
        NSString * data = [responseObject valueForKeyPath:@"data"];
        if([data isKindOfClass:[NSNull class]]) {
            data = nil;
        } else {
            [SystemConfig saveServerId:data];
            [self checkPushAcount];
        }
        if(projectId) {
            [self performSelectorOnMainThread:@selector(gotoMain) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(gotoProjectSelect) withObject:nil waitUntilDone:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取服务器ID失败。");
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"login_notice_request_serverid_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelectorOnMainThread:@selector(gotoProjectSelect) withObject:nil waitUntilDone:NO];
    }];
}

- (void) checkPushAcount {
//    NSString * lastLoginUser = [SystemConfig getPushAccount];
//    if([FMUtils isStringEmpty:lastLoginUser] || ![lastLoginUser isEqualToString:_mLoginName]) {
        [SystemConfig savePushAccount:_mLoginName];
        [self tryToRegisterPushDevice]; //注册通知设备
//    }
}

- (void) isReachable {
    [self showLoadingDialog];
    //1.开始监控网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //2.判断网络状态
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{  //无网络
                [weakSelf hideLoadingDialog];
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"net_reachable_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                break;
            }
            case AFNetworkReachabilityStatusUnknown: {  //未知网络
                [weakSelf hideLoadingDialog];
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"net_reachable_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{  //Wi-Fi
                [weakSelf hideLoadingDialog];
                [weakSelf testOauth];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{  //蜂窝数据
                [weakSelf hideLoadingDialog];
                [weakSelf testOauth];
                break;
            }
        }
    }];
}

- (void) tryToRegisterPushDevice {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate registerDevice];
}

- (void) tryToUnRegisterPushDevice {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate unRegisterDevice];
}

- (void) saveUserInfo {
    _user.loginName = _mLoginName;
    _user.password = _mPassword;
    [self saveUserInfoLocal:_user];
}

- (void) saveUserInfoLocal:(UserInfo*) user {
    [SystemConfig setLoginName:_mLoginName];
    [_dbHelper saveUserInfo:user];
}

- (void) getUserInfoLocal {
    NSNumber * userId = [BasePreference getUserInfoNumber:@"lastUser"];
    NSArray* userArray = [_dbHelper queryAllUser];
    for(UserInfo* user  in userArray) {
        if(user && userId && [user.userId isEqualToNumber:userId]) {
            _usernameClearEt.text = user.loginName;
            _passwordClearEt.text = user.password;
        }
    }
}

#pragma - 登陆事件响应处理
- (void) onLoginSuccess: (Token*) token {
    [SystemConfig setOauthFM:testOauth];
    //    BOOL autoLogin = [BasePreference getUserInfoNumber:@"autoLogin"].boolValue;
    _user = [[UserInfo alloc] init];
    _user.loginName = _mLoginName;
    _user.password = _mPassword;    //记住密码
    [BasePreference saveUserInfoKey:@"autoLogin" numberValue:[NSNumber numberWithBool:YES]];
    
    NSNumber * lastUser = [BasePreference getUserInfoNumber:@"lastUser"];
    
    _user.userId = [NSNumber numberWithInteger:[token.mUid integerValue]];
    if(!lastUser || ![lastUser isEqualToNumber:_user.userId]) { //如果不是同一个用户的话就清除保存的项目信息
        [SystemConfig setCurrentProjectId:nil];
        [SystemConfig setCurrentProjectName:@""];
    }
    [BasePreference saveUserInfoKey:@"lastUser" numberValue:_user.userId];
    
    [self requestServerId];
    [self saveUserInfoLocal:_user];
    
    
    [_mlock lock];
    _isLogining = NO;
    [_mlock unlock];
}


- (void) onLoginError: (NSError *) error {
    NSLog(@"ERROR: %@", error);
    [self hideLoadingDialog];
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"login_fail" inTable:nil] leftButtonTitle:nil rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_i_know" inTable:nil] viewController:self];
    [alert showIn:self];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
    
    [_mlock lock];
    _isLogining = NO;
    [_mlock unlock];
}
- (void) onLoginCancel {
    [self hideLoadingDialog];
    [_mlock lock];
    _isLogining = NO;
    [_mlock unlock];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) showSaveMessageDialog {
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"login_notice_remember_password" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_no" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_all_right" inTable:nil] viewController:self];
    [alert showIn:self];
    alert.leftBlock = ^() {
        [BasePreference saveUserInfoKey:@"autoLogin" numberValue:[NSNumber numberWithBool:NO]];
        if(_user){
            _user.loginName = _mLoginName;
            _user.password = @"";
            [self saveUserInfoLocal:_user];
        }
    };
    alert.rightBlock = ^() {
        [BasePreference saveUserInfoKey:@"autoLogin" numberValue:[NSNumber numberWithBool:YES]];
        if(_user){
            _user.loginName = _mLoginName;
            _user.password = _mPassword;
            [self saveUserInfoLocal:_user];
        }
    };
    alert.dismissBlock = ^() {
        [self performSelectorOnMainThread:@selector(gotoProjectSelect) withObject:nil waitUntilDone:NO];
    };
}

#pragma mark - 地址编辑
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _addressView) {
        if(subView) {
            NSString * address;
            ServerAddressEditType type = subView.tag;
            switch(type) {
                case SERVER_ADDRESS_EDIT_CANCEL:
                    break;
                case SERVER_ADDRESS_EDIT_OK:
                    address = [_addressView getAddressInput];
                    if([address containsString:@" "]) {
                        address = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    [self saveServerAddress:address];
                    break;
            }
        }
        [_alertView close];
    }
}

//保存信息
- (void) saveServerAddress:(NSString *) address {
    if(![FMUtils isStringEmpty:address] && ![address isEqualToString:[SystemConfig getServerAddress]]) {
        [SystemConfig savePushAccount:@""]; //服务器切换之后账户需要重新绑定
        [[BaseDataDownloader getInstance] resetDbData];
        [BasePreference saveUserInfoKey:@"lastUser" numberValue:[NSNumber numberWithLongLong:0]];
        [SystemConfig setServerAddress:address];
        [SystemConfig setCurrentProjectId:nil];
        [_addressView clearInput];
        
    }
}


- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    [_addressView updateViews];
}

@end
