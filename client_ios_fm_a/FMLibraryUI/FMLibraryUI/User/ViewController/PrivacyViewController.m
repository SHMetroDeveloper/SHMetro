//
//  PrivacyViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "PrivacyViewController.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "SystemConfig.h"
#import "FunctionItemView.h"
#import "BaseGroupView.h"
#import "MarkedListHeaderView.h"

@interface PrivacyViewController ()

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) MarkedListHeaderView *pushView;       //消息通知
@property (readwrite, nonatomic, strong) BaseGroupView * groupPush;

@property (readwrite, nonatomic, strong) UILabel * pushDescLbl;
@property (readwrite, nonatomic, strong) NSString * pushDesc;

@property (readwrite, nonatomic, assign) CGFloat groupItemHeight;
@property (readwrite, nonatomic, assign) CGFloat groupSepHeight;

@end

@implementation PrivacyViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting_notification" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) initUI{
    CGRect frame = [self getContentFrame];
    
    _groupItemHeight = 50;
    _groupSepHeight = 20;
    
    CGFloat originY = 20;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    frame.size.height = height;
    
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    NSInteger groupItemCount = 1;
    //缓存
    _groupPush = [[BaseGroupView alloc] initWithFrame:CGRectMake(0, originY, width, _groupItemHeight * groupItemCount)];
    [_groupPush setItemHeight:_groupItemHeight];
    _pushView = [[MarkedListHeaderView alloc] init];
    [_pushView setShowMark:NO];
    [_pushView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"function_notification_alert" inTable:nil] desc:[self getPushStatusStr] andDescStyle:LIST_HEADER_DESC_STYLE_BOUND_CIRCLE];
    [_groupPush addMember:_pushView];
    [_groupPush setBoundsType:BOUNDS_TYPE_RECT];
    originY += _groupItemHeight * groupItemCount + padding/2;
    
    _pushDesc = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"notification_notice_setting" inTable:nil], [SystemConfig getProductName]];
    _pushDescLbl = [[UILabel alloc] init];
    _pushDescLbl.numberOfLines = 0;
    [_pushDescLbl setFont:[FMFont getInstance].defaultFontLevel2];
    [_pushDescLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
    CGFloat pushHeight = [FMUtils heightForStringWith:_pushDescLbl value:_pushDesc andWidth:width-padding*2];
    [_pushDescLbl setFrame:CGRectMake(padding, originY, width-padding*2, pushHeight)];
    [_pushDescLbl setText:_pushDesc];
    
    [_mainContainerView addSubview:_groupPush];
    [_mainContainerView addSubview:_pushDescLbl];
    
    
    [self.view addSubview:_mainContainerView];
    
}

//获取通知的开启状态
- (NSString *) getPushStatusStr {
    NSString * str = @"";
    if([FMUtils isAllowedNotification]) {
        str = [[BaseBundle getInstance] getStringByKey:@"notification_status_on" inTable:nil];
    } else {
        str = [[BaseBundle getInstance] getStringByKey:@"notification_status_off" inTable:nil];
    }
    return str;
}

@end
