//
//  SettingViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "SettingViewController.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FunctionItemView.h"
#import "BaseGroupView.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"
#import "DXAlertView.h"
#import "BasePreference.h"
#import "LoginViewController.h"
#import "PrivacyViewController.h"
#import "SystemConfig.h"
#import "BaseItemView.h"
#import "OnClickListener.h"
#import "BaseDataDownloader.h"
#import "FMCache.h"
#import "DXAlertView.h"
 
#import "SystemConfig.h"
#import "LegalWebViewController.h"
#import "CacheViewController.h"


@interface SettingViewController () <OnClickListener>

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) BaseItemView * cacheView;       //缓存
@property (readwrite, nonatomic, strong) BaseGroupView * groupCache;
@property (readwrite, nonatomic, assign) float cacheSize;

@property (readwrite, nonatomic, strong) BaseItemView * pushView;       //隐私
@property (readwrite, nonatomic, strong) UILabel * pushDescLbl;
@property (readwrite, nonatomic, strong) BaseGroupView * groupPrivacy;

@property (readwrite, nonatomic, strong) BaseItemView * feedbackView;    //反馈
@property (readwrite, nonatomic, strong) BaseGroupView * groupFeedback;

@property (readwrite, nonatomic, strong) BaseItemView * aboutView;       //关于
//@property (readwrite, nonatomic, strong) BaseItemView * lawView;       //法律声明
@property (readwrite, nonatomic, strong) BaseGroupView * groupAbout;

//@property (readwrite, nonatomic, strong) BaseItemView * loginOutView;    //退出
//@property (readwrite, nonatomic, strong) BaseGroupView * groupLoginOut;

@property (readwrite, nonatomic, strong) UIButton * loginOutBtn;  //退出按钮

@property (readwrite, nonatomic, strong) NSString * pushDesc;

@property (readwrite, nonatomic, assign) CGFloat groupItemHeight;
@property (readwrite, nonatomic, assign) CGFloat groupSepHeight;

@end

@implementation SettingViewController

- (instancetype) init {
    self = [super init];
    return self;
}


- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateCacheSize];
}


- (void) initLayout{
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        
        _groupItemHeight = [FMSize getInstance].settingItemHeight;
        _groupSepHeight = [FMSize getInstance].settingItemSepHeight;
        
        CGFloat originY = _groupSepHeight;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        frame.size.height = height;
        
        CGFloat paddingLeft = [FMSize getInstance].settingPaddingLeft;
        CGFloat paddingRight = [FMSize getInstance].settingPaddingRight;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        CGFloat iconHeight = [FMSize getInstance].userItemLogoWidth;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _mainContainerView.showsVerticalScrollIndicator = FALSE;
        _mainContainerView.delaysContentTouches = NO;
        
        NSInteger groupItemCount = 1;
        //缓存
        _groupCache = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
        [_groupCache setBoundsType:BOUNDS_TYPE_NONE];
        [_groupCache setItemHeight:_groupItemHeight];
        _cacheView = [[BaseItemView alloc] init];
        [_cacheView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_setting_cache" inTable:nil]  andImage:[[FMTheme getInstance] getImageByName:@"setting_function_clearcache"] andDesc:nil];
        [_cacheView addTarget:self action:@selector(goToClearCache) forControlEvents:UIControlEventTouchUpInside];
        [_cacheView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        [_cacheView setLogoImageWidth:iconHeight];
        [_cacheView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
        [_cacheView setDescFont:[FMFont getInstance].font38];
        [_cacheView setShowMore:YES];
        [_groupCache addMember:_cacheView];
        originY += _groupItemHeight * groupItemCount + _groupSepHeight;
        
        //隐私
        groupItemCount = 1;
        _groupPrivacy = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
        [_groupPrivacy setBoundsType:BOUNDS_TYPE_NONE];
        [_groupPrivacy setItemHeight:_groupItemHeight];
        _pushView = [[BaseItemView alloc] init];
        [_pushView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
        [_pushView setDescFont:[FMFont getInstance].font38];
        [_pushView setLogoImageWidth:iconHeight];
        [_pushView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_setting_notification" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"setting_function_receivenotification"] andDesc:[self getPushStatusStr]];
        //    [_pushView setShowMore:YES];
        //    [_pushView addTarget:self action:@selector(goToPrivacy) forControlEvents:UIControlEventTouchUpInside];
        [_pushView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        
        [_groupPrivacy addMember:_pushView];
        originY += _groupItemHeight * groupItemCount + _groupSepHeight;
        
        _pushDesc = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"notification_notice_setting" inTable:nil], [SystemConfig getProductName], [SystemConfig getProductName]];
        _pushDescLbl = [[UILabel alloc] init];
        _pushDescLbl.numberOfLines = 0;
        [_pushDescLbl setFont:[FMFont getInstance].defaultFontLevel3];
        [_pushDescLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        CGFloat pushWidth = width - padding * 2;
        CGFloat pushHeight = [FMUtils heightForStringWith:_pushDescLbl value:_pushDesc andWidth:pushWidth];
        [_pushDescLbl setFrame:CGRectMake(padding, originY, pushWidth, pushHeight)];
        [_pushDescLbl setText:_pushDesc];
        originY += pushHeight + _groupSepHeight * 2;
        
        
        //反馈
        groupItemCount = 2;
        _groupFeedback = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
        [_groupFeedback setBoundsType:BOUNDS_TYPE_NONE];
        [_groupFeedback setItemHeight:_groupItemHeight];
        _feedbackView = [[BaseItemView alloc] init];
        [_feedbackView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
        [_feedbackView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_setting_feedback" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"setting_function_feedback"] andDesc:nil];
        [_feedbackView setShowMore:YES];
        [_feedbackView addTarget:self action:@selector(goToFeedback) forControlEvents:UIControlEventTouchUpInside];
        [_feedbackView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        [_feedbackView setLogoImageWidth:iconHeight];
        _aboutView = [[BaseItemView alloc] init];
        [_aboutView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2]];
        [_aboutView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_setting_about" inTable:nil] andImage:[[FMTheme getInstance] getImageByName:@"setting_function_about"] andDesc:nil];
        [_aboutView setShowMore:YES];
        [_aboutView addTarget:self action:@selector(goToAbout) forControlEvents:UIControlEventTouchUpInside];
        [_aboutView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        [_aboutView setLogoImageWidth:iconHeight];
        
        [_groupFeedback addMember:_feedbackView];
        [_groupFeedback addMember:_aboutView];
        originY += _groupItemHeight * groupItemCount + _groupSepHeight * 5;
        
        
        //关于
        //    groupItemCount = 1;
        //    _groupAbout = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
        //    [_groupAbout setBoundsType:BOUNDS_TYPE_NONE];
        //    [_groupAbout setItemHeight:_groupItemHeight];
        //    _aboutView = [[BaseItemView alloc] init];
        //    [_aboutView setInfoWithName:@"关于" andImage:[UIImage imageNamed:@"setting_function_about"] andDesc:nil];
        //    [_aboutView setShowMore:YES];
        //    [_aboutView addTarget:self action:@selector(goToAbout) forControlEvents:UIControlEventTouchUpInside];
        //    [_aboutView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        //    [_groupAbout addMember:_aboutView];
        //    originY += _groupItemHeight * groupItemCount + _groupSepHeight;
        
        
        //退出按钮
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight)];
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [_loginOutBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"user_logout" inTable:nil] forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
        _loginOutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _loginOutBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
        [_loginOutBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_LOGOUT] forState:UIControlStateNormal];
        _loginOutBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        //退出
        //    groupItemCount = 1;
        //    _groupLoginOut = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
        //    [_groupLoginOut setBoundsType:BOUNDS_TYPE_NONE];
        //    [_groupLoginOut setItemHeight:_groupItemHeight];
        //    _loginOutView = [[BaseItemView alloc] init];
        //    [_loginOutView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"user_logout" inTable:nil] andImage:[UIImage imageNamed:@"setting_function_logout"] andDesc:nil];
        //    [_loginOutView setPaddingLeft:paddingLeft andPaddingRight:paddingRight];
        //    [_loginOutView addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        //    [_groupLoginOut addMember:_loginOutView];
        //    originY += _groupItemHeight * groupItemCount + _groupSepHeight;
        
        
        
        
        
        [_mainContainerView addSubview:_groupCache];
        [_mainContainerView addSubview:_groupPrivacy];
        [_mainContainerView addSubview:_pushDescLbl];
        [_mainContainerView addSubview:_groupFeedback];
        [_mainContainerView addSubview:_groupAbout];
        //    [_mainContainerView addSubview:_groupLoginOut];
        [_mainContainerView addSubview:_loginOutBtn];
        
        _mainContainerView.contentSize = CGSizeMake(frame.size.width, originY);
        
        [self.view addSubview:_mainContainerView];
    }
    
    
}

//获取通知的开启状态
- (NSString *) getPushStatusStr {
    NSString * str = @"";
    if([FMUtils isAllowedNotification]) {
        str = [[BaseBundle getInstance] getStringByKey:@"notification_status_on" inTable:nil];
        [_pushView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
    } else {
        str = [[BaseBundle getInstance] getStringByKey:@"notification_status_off" inTable:nil];
        [_pushView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
    }
    return str;
}

- (NSString *) getCachedSizeStr {
    NSString * strCacheSize = @"0KB";
    if(_cacheSize > 1024) {
        _cacheSize = _cacheSize / 1024.0;
        strCacheSize = [[NSString alloc] initWithFormat:@"%.1fMB", _cacheSize];
        _cacheSize = _cacheSize * 1024.0;
    } else if(_cacheSize >= 1 && _cacheSize <= 1024) {
        strCacheSize = [[NSString alloc] initWithFormat:@"%.1fKB", _cacheSize];
    }
    return strCacheSize;
}

- (void) updateCacheSize {  //鉴于目前无法计算数据库中数据所占空间大小，此处具体尺寸大小暂时先不展示
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _cacheSize = [[FMCache getInstance] getFileCacheSize];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString * strCacheSize = [self getCachedSizeStr];
//            [_cacheView updateDesc:strCacheSize];
//        });
//    });
}

#pragma --- onClick
- (void) onClick:(UIView *)view {
    if(view == _cacheView) {
        [self goToClearCache];
    } else if(view == _pushView) {
        [self goToPrivacy];
    } else if(view == _feedbackView) {
        [self goToFeedback];
    } else if(view == _aboutView) {
        [self goToAbout];
    }
//    else if(view == _loginOutView) {
//        [self logout];
//    }
}



#pragma --- 页面跳转
//清除缓存
- (void) goToClearCache {
    CacheViewController * vc = [[CacheViewController alloc] init];
    [self gotoViewController:vc];
    
//    NSString * strCacheSize = [self getCachedSizeStr];
//    if(_cacheSize >= 1) {
//        NSString * notice = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"setting_notice_cache_size" inTable:nil], strCacheSize];
//        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:notice leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
//        [alert showIn:self];
//        alert.leftBlock = ^() {
//            //        [[BaseDataDownloadloader getInstance] clearBaseData];
//            [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_ALL];
//            [self updateCacheSize];
//        };
//        alert.rightBlock = ^() {
//            
//        };
//        alert.dismissBlock = ^() {
//        };
//    } else {
//        NSString * notice = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"setting_notice_cache_size_ok" inTable:nil], strCacheSize];
//        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:notice time:DIALOG_ALIVE_TIME_SHORT];
//    }
    
}
//隐私
- (void) goToPrivacy {
    PrivacyViewController * privacyVC = [[PrivacyViewController alloc] init];
    [self gotoViewController:privacyVC];
}

//法律声明
- (void) goToLegal {
    LegalWebViewController * legalVC = [[LegalWebViewController alloc] init];
    [self gotoViewController:legalVC];
}

//意见反馈
- (void) goToFeedback {
    FeedbackViewController * viewController = [[FeedbackViewController alloc] init];
    [self gotoViewController:viewController];
}
//关于
- (void) goToAbout {
    AboutUsViewController * viewController = [[AboutUsViewController alloc] init];
    [self gotoViewController:viewController];
}

//退出
- (void) logout {
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"user_logout_notice" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"user_btn_logout" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
    [alert showIn:self];
    alert.leftBlock = ^() {
        [BaseViewController notifyLogout];
    };
    alert.rightBlock = ^() {
        
    };
    alert.dismissBlock = ^() {
    };
}

@end
