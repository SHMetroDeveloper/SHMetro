//
//  MainLoginViewController.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 24/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "MainLoginViewController.h"
#import "TestMainViewController.h"
#import "ClearableEditText.h"

#import "FMTheme.h"
#import "FMImage.h"
#import "UIButton+Bootstrap.h"
#import "SystemConfig.h"
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
#import "TransLogin.h"

@interface MainLoginViewController () <LoginListener>
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

@property (readwrite, nonatomic, strong) TransLogin * transLogin ;

@end

@implementation MainLoginViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void) login {
    //    [self isReachable];
    if([self isServerReachable]) {
        [self testOauth];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"net_reachable_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
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
        
        _mlock = [[NSCondition alloc] init];
        
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [_mainContainerView addSubview:_usernameClearEt];
        [_mainContainerView addSubview:_passwordClearEt];
        
        [_mainContainerView addSubview:_loginBtn];
        [_mainContainerView addSubview:_noteLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (BOOL) isUserLogined {
//    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
//    BOOL res = NO;
//    if(![FMUtils isStringEmpty:accessToken]) {
//        res = YES;
//    }
    return NO;
}


- (void) testOauth {
    [_mlock lock];
    if(!_isLogining) {
        _isLogining = YES;
        [_mlock unlock];
        _mLoginName = [self.usernameClearEt getText];
        _mPassword = [self.passwordClearEt getText];
        [self showLoadingDialog];
        _transLogin = [[TransLogin alloc] init:_mLoginName strPassword:_mPassword];
        [_transLogin request:^{
            [self gotoMain];
        } onFailer:^{
            [self onLoginFailer];
        }];
    } else {
        [_mlock unlock];
    }
}

- (void) onLoginFailer {
    
};

- (void) gotoMain {
    CGRect frame = self.view.frame;
    TestMainViewController * mainVC = [[TestMainViewController alloc] init];
    [self gotoViewController:mainVC];
}



- (void) getUserInfoLocal {
    
    _usernameClearEt.text = @"01030004078";
    _passwordClearEt.text = @"111111";
    
//    _usernameClearEt.text = @"01030000054";
//    _passwordClearEt.text = @"111111";
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
    

    CGFloat noteHeight = [FMUtils heightForStringWith:_noteLbl value:_noteLbl.text andWidth:width];
    [_noteLbl setFrame:CGRectMake(0, height-noteHeight-paddingBottom, width, noteHeight)];
}


- (void) showNitificationNotice {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"notification_need_login" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
