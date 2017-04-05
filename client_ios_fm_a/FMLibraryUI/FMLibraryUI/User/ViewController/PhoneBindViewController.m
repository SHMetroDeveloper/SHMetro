//
//  PhoneBindViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  手机号绑定界面

#import "PhoneBindViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "BaseTextField.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "UserNetRequest.h"
#import "UserRequest.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseLabelView.h"
#import <SMS_SDK/SMSSDK.h>
#import "LineTextField.h"

typedef void(^selectBlock)(BOOL isSelected);

@interface PhoneBindViewController ()

@property (readwrite, nonatomic, strong) UILabel * oldPhoneLbl;   //旧手机提示

@property (readwrite, nonatomic, strong) LineTextField * phoneTextField;  //输入新的手机号

@property (readwrite, nonatomic, strong) LineTextField * captChaTextField; //输入验证码
@property (readwrite, nonatomic, strong) UIButton * captChaBtn;  //获取验证码按钮
@property (readwrite, nonatomic, strong) UILabel * delayLbl;   //延时获取读秒
@property (readwrite, nonatomic, strong) UIButton * bindBtn;

@property (readwrite, nonatomic, strong) UIView * mainContainerView;        //主容器

@property (readwrite, nonatomic, strong) NSTimer * timer;    //计时器
@property (readwrite, nonatomic, assign) NSInteger timeCount; //时间 60s倒数

@property (readwrite, nonatomic, strong) NSString * oldPhone;
@property (readwrite, nonatomic, strong) NSString * phone;

@property (readwrite, nonatomic, assign) BOOL isLoading;

@end

@implementation PhoneBindViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_bind_phone" inTable:nil]];
    [self setBackAble:YES];
}


- (void) initViews {
    
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat originY = 30;
    CGFloat sepHeight = 20;
    CGFloat itemHeight = 40;
    CGFloat captchaHeight = 30;
    CGFloat btnWidth = 70;
    
    CGFloat paddingLeft = 20;
    CGFloat paddingRight = paddingLeft;
    CGFloat btnHeight = [FMSize getInstance].btnBottomControlHeight;

    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
 
    //老手机号提示
    
    _oldPhoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, 0)];
    CGFloat lblHeight = [FMUtils heightForStringWith:_oldPhoneLbl value:@"test" andWidth:width-paddingLeft-paddingRight];
     [_oldPhoneLbl setFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, lblHeight)];
    _oldPhoneLbl.font = [FMFont fontWithSize:16];
    _oldPhoneLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    [_oldPhoneLbl setHidden:YES];
    _oldPhoneLbl.textAlignment = NSTextAlignmentCenter;
    originY += lblHeight + sepHeight * 2;
    
    //输入textfield
    _phoneTextField = [[LineTextField alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
    _phoneTextField.placeholder = [[BaseBundle getInstance] getStringByKey:@"bind_phone_input_new_telno" inTable:nil];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextField becomeFirstResponder];
    
    originY += itemHeight + sepHeight;
    
    //输入验证码
    _captChaTextField = [[LineTextField alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, itemHeight)];
    _captChaTextField.placeholder = [[BaseBundle getInstance] getStringByKey:@"bind_phone_input_code" inTable:nil];
    _captChaTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _captChaBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-btnWidth-paddingRight, originY + (itemHeight - captchaHeight)/2, btnWidth, captchaHeight)];  //获取验证码按钮
    [_captChaBtn addTarget:self action:@selector(onCaptChaBtnClicik) forControlEvents:UIControlEventTouchUpInside];
    _captChaBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] CGColor];
    _captChaBtn.layer.borderWidth = [FMSize getInstance].seperatorHeight;
    _captChaBtn.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    _captChaBtn.layer.masksToBounds = YES;
//    _captChaBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_captChaBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"bind_phone_request_code" inTable:nil] forState:UIControlStateNormal];
    [_captChaBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    [_captChaBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateHighlighted];
    [_captChaBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] width:1 height:1] forState:UIControlStateNormal];
    [_captChaBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] width:1 height:1] forState:UIControlStateHighlighted];
    _captChaBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel3;
    
    _delayLbl = [[UILabel alloc] initWithFrame:CGRectMake(width-btnWidth-paddingRight, originY+(itemHeight - captchaHeight)/2, btnWidth, captchaHeight)];
    _delayLbl.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5] CGColor];
    _delayLbl.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    _delayLbl.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    _delayLbl.layer.masksToBounds = YES;
    _delayLbl.font = [FMFont getInstance].defaultFontLevel2;
    _delayLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    _delayLbl.textAlignment = NSTextAlignmentCenter;
//    _delayLbl.text = @"60S";
    _delayLbl.hidden = YES;
    
    originY += itemHeight + sepHeight * 2;
    
    //审核按钮
    _bindBtn = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, originY, width-paddingLeft-paddingRight, btnHeight)];
    [_bindBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"bind_btn_bind" inTable:nil] forState:UIControlStateNormal];
    [_bindBtn addTarget:self action:@selector(onChangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bindBtn primaryStyle];
    _bindBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _bindBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] CGColor];
    [_bindBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] width:1 height:1] forState:UIControlStateHighlighted];
    _bindBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;

    
    [_mainContainerView addSubview:_oldPhoneLbl];
    
    [_mainContainerView addSubview:_phoneTextField];
    
    [_mainContainerView addSubview:_captChaTextField];
    [_mainContainerView addSubview:_captChaBtn];
    [_mainContainerView addSubview:_delayLbl];
    
    [_mainContainerView addSubview:_bindBtn];
    
    [self.view addSubview:_mainContainerView];
}

- (void) updateViews {
    if (_isLoading) {
        _captChaBtn.hidden = YES;
        _delayLbl.hidden = NO;
    } else {
        _captChaBtn.hidden = NO;
        _delayLbl.hidden = YES;
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self updatePhoneLabel];
}

//更新手机号状态
- (void) updatePhoneLabel {
    if(![FMUtils isStringEmpty:_oldPhone]) {
        NSString * strInfo = [[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"bind_phone_old_telno" inTable:nil], [FMUtils getFormatMobile:_oldPhone]];
        [_oldPhoneLbl setText:strInfo];
        [_oldPhoneLbl setHidden:NO];
    } else {
        [_oldPhoneLbl setHidden:YES];
    }
}

//设置手机号
- (void) setPhone:(NSString *) phone {
    if (phone) {
        _oldPhone = [phone copy];
    }
    [self updatePhoneLabel];
}

- (void) onChangeButtonClicked {
    
    NSString * code = _captChaTextField.text;
    if([FMUtils isStringEmpty:_phone] || ![FMUtils isMobile:_phone]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_verify" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        if(![FMUtils isStringEmpty:code]) {
            [self requestVerifyCode:code];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_phone_input_code" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
    
    
    
//    NSString * phone = _phoneTextField.text;
//    
//    
//    if(![FMUtils isStringEmpty:phone]) {
//        if([FMUtils isMobile:phone]) {
//            [self work];
//        } else {
//            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_telno_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//        }
//    } else {
//        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_input" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//    }
    
}

- (void) work {
    [self showLoadingDialog];
    [self requestToBindPhone];
}

- (void) requestToBindPhone {
    NSNumber* userId = [SystemConfig getEmployeeId];
    UserNetRequest * userNetRequest = [UserNetRequest getInstance];
    UserBindPhoneRequest * request = [[UserBindPhoneRequest alloc] initWithUserId:userId andPhone:_phone];
    [userNetRequest request:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self hideLoadingDialog];
        [self finish];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
    }];
}

#pragma mark Private method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"---------------------------");
}

- (CGSize) getLabelSizeByFont:(UIFont *) font andString:(NSString *) content {
    UILabel * testLbl = [[UILabel alloc] init];
    [testLbl setFont:font];
    [testLbl setText:content];
    [testLbl sizeToFit];
    CGSize realSize = testLbl.frame.size;
    return realSize;
}

- (void) onCaptChaBtnClicik {
    NSString * newPhone = _phoneTextField.text;
    if(![FMUtils isStringEmpty:newPhone]) {
        if([FMUtils isMobile:newPhone]) {
            if(_oldPhone && [newPhone isEqualToString:_oldPhone]) {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_telno_inuse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            } else {
                _phone = [newPhone copy];
                [self requestSendVerificationCodeTo];
            }
        }else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_telno_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_telno_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//请求发送验证码
- (void) requestSendVerificationCodeTo{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error)
     {
         //477 --- 短信条数超过限制，
         //2.0版本运营商限制：同一个号码12小时内发送5条文本验证码，语音验证码24小时内发送10条
         if(!error) {
             NSLog(@"获取验证码成功。");
         } else {
             NSLog(@"获取验证码失败。");
         }
     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _timeCount = 60;
        _isLoading = YES;
        [self updateViews];
        [self timeCounter];
    });  //因为nstime启动会延时1秒所以在这里加一个 dispatch；
    [self startTimeCounter];
}

- (void) requestVerifyCode:(NSString *) code {
    
    [SMSSDK commitVerificationCode:code phoneNumber:_phone zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            [self work];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"bind_notice_verify_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            
        }
    }];

}

- (void) timeCounter {
    _delayLbl.text = [NSString stringWithFormat:@"%02ldS",_timeCount];
    if (_timeCount > 0) {
        _timeCount -= 1;
    } else {
        _isLoading = NO;
        [self updateViews];
        [self endTimeCounter];
    }
}

- (void) startTimeCounter {
    _timer = [[NSTimer alloc] init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCounter) userInfo:nil repeats:YES];
}

- (void) endTimeCounter {
    _timeCount = 60;
    _delayLbl.text = [NSString stringWithFormat:@"%02ldS",_timeCount];
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isEqual:_phoneTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            [_phoneTextField setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
            [_captChaTextField setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
        }];
    }
    if ([firstResponder isEqual:_captChaTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            [_phoneTextField setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
            [_captChaTextField setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
        }];
    }
}

@end

