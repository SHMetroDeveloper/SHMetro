//
//  ChangePasswordViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  密码修改页面

#import "ChangePasswordViewController.h"
#import "FMTheme.h"
#import "BaseTextField.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "UserRequest.h"
#import "UserNetRequest.h"
#import "LoginViewController.h"
#import "PasswordUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BasePreference.h"
#import "BaseDataDBHelper.h"
#import "PasswordTextField.h"
#import "BaseBundle.h"


@interface ChangePasswordViewController ()

@property (readwrite, nonatomic, strong) UILabel * oldPwdLbl;
@property (readwrite, nonatomic, strong) PasswordTextField * oldPasswordBaseTf;
@property (readwrite, nonatomic, strong) UILabel * fnewPwdLbl;
@property (readwrite, nonatomic, strong) PasswordTextField * fnewPasswordBaseTf;
@property (readwrite, nonatomic, strong) UILabel * snewPwdLbl;
@property (readwrite, nonatomic, strong) PasswordTextField * snewPasswordBaseTf;

@property (readwrite, nonatomic, strong) UIButton * changeBtn;

@property (readwrite, nonatomic, strong) UIView * mainContainerView;        //主容器
@end

@implementation ChangePasswordViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"user_reset_password" inTable:nil]];
    [self setBackAble:YES];
}


- (void) initViews {
    
    CGRect frame = [self getContentFrame];
    CGFloat originY = 15;
    CGFloat sepHeight = 15;
    CGFloat itemHeight = 44;
    CGFloat labelHeight = 16;
    
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat paddingLeft = 20;
    CGFloat paddingRight = paddingLeft;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    _oldPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, labelHeight)];
    _oldPwdLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _oldPwdLbl.font = [FMFont getInstance].defaultFontLevel2;
    _oldPwdLbl.text = [[BaseBundle getInstance] getStringByKey:@"password_old_value" inTable:nil];
    originY += labelHeight;
    
    _oldPasswordBaseTf = [[PasswordTextField alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
//    [_oldPasswordBaseTf setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"password_old_value" inTable:nil]];
//    [_oldPasswordBaseTf setPaddingLeft:paddingLeft right:paddingLeft andLabelWidth:labelWidth];
//    _oldPasswordBaseTf.secureTextEntry = YES;
//    [_oldPasswordBaseTf setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"password_old_value" inTable:nil]];
    originY += itemHeight + sepHeight;
    
    _fnewPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, labelHeight)];
    _fnewPwdLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _fnewPwdLbl.font = [FMFont getInstance].defaultFontLevel2;
    _fnewPwdLbl.text = [[BaseBundle getInstance] getStringByKey:@"password_new_value" inTable:nil];
    originY += labelHeight;
    _fnewPasswordBaseTf = [[PasswordTextField alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    _snewPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, labelHeight)];
    _snewPwdLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _snewPwdLbl.font = [FMFont getInstance].defaultFontLevel2;
    _snewPwdLbl.text = [[BaseBundle getInstance] getStringByKey:@"password_new_value_confirm" inTable:nil];
    originY += labelHeight;
    _snewPasswordBaseTf = [[PasswordTextField alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
    originY += itemHeight + 20;
    
    itemHeight = [FMSize getInstance].btnBottomControlHeight;
    _changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
    [_changeBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
    [_changeBtn addTarget:self action:@selector(onChangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_changeBtn primaryStyle];
    _changeBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _changeBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] CGColor];
    [_changeBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] width:1 height:1] forState:UIControlStateHighlighted];
    _changeBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    
    [_oldPasswordBaseTf becomeFirstResponder];
    
    [_mainContainerView addSubview:_oldPwdLbl];
    [_mainContainerView addSubview:_oldPasswordBaseTf];
    [_mainContainerView addSubview:_fnewPwdLbl];
    [_mainContainerView addSubview:_fnewPasswordBaseTf];
    [_mainContainerView addSubview:_snewPwdLbl];
    [_mainContainerView addSubview:_snewPasswordBaseTf];
    [_mainContainerView addSubview:_changeBtn];
    
    [self.view addSubview:_mainContainerView];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}


- (void) onChangeButtonClicked {
    if([self checkPasswordValidate]) {
        [self work];
    }
}

- (BOOL) checkPasswordValidate {
    BOOL isValid = YES;
    NSString * oldPassword = _oldPasswordBaseTf.text;
    NSString * fnewPassword = _fnewPasswordBaseTf.text;
    NSString * snewPassword = _snewPasswordBaseTf.text;
    if([FMUtils isStringEmpty:fnewPassword] || [FMUtils isStringEmpty:snewPassword]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_notice_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return NO;
    }
    if(![fnewPassword isEqualToString:snewPassword]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_notice_not_the_same" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        
        return NO;
    }
    if([fnewPassword isEqualToString:oldPassword]) {    //新密码跟旧密码一样，不用修改
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_notice_no_need_change" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return NO;
    }
    return isValid;
}

- (void) work {
    [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"requesting" inTable:nil]];
    [self requestToChangePassword];
}

- (void) requestToChangePassword {
    NSString * password = _oldPasswordBaseTf.text;
    NSString * newPassword = _fnewPasswordBaseTf.text;
    UserNetRequest * userNetRequest = [UserNetRequest getInstance];
    UserChangePasswordRequest * param = [[UserChangePasswordRequest alloc] initWithPassword:password andNewPassword:newPassword];
    [userNetRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber * fmCode = [responseObject valueForKeyPath:@"fmcode"];
        if([fmCode isEqualToNumber:[NSNumber numberWithInteger:0]]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_reset_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self logout];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_reset_fail_note_value" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
        [self hideLoadingDialog];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"password_reset_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) logout {
    [BaseViewController notifyLogout];
}


- (void)keyboardWasShown:(NSNotification *)aNotification {
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    for (UITextField * target in [_oldPasswordBaseTf subviews]) {
        if ([firstResponder isEqual:target]) {
            NSLog(@"输入旧密码");
            [UIView animateWithDuration:0.3 animations:^{
                [_oldPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
                [_fnewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
                [_snewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
            }];
        }
    }
    
    for (UITextField * target in [_fnewPasswordBaseTf subviews]) {
        if ([firstResponder isEqual:target]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_oldPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
                [_fnewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
                [_snewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
            }];
        }
    }
    
    for (UITextField * target in [_snewPasswordBaseTf subviews]) {
        if ([firstResponder isEqual:target]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_oldPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
                [_fnewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
                [_snewPasswordBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
            }];
        }
    }
}

@end

