//
//  MissionDetailViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyTaskContentViewController.h"
#import "FMUtilsPackages.h"
#import "BaseTextView.h"
#import "CaptionTextField.h"
#import "BaseBundle.h"

@interface EnergyTaskContentViewController ()
@property (nonatomic, strong) UIView *mainContentView;
@property (nonatomic, strong) CaptionTextField *meterReadingTF;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, strong) NSString * content;   //抄表项
@property (nonatomic, strong) NSString * unit;   //抄表项
@property (nonatomic, strong) NSString * result;   //抄表项结果
@property (nonatomic, strong) NSNumber *meterId;

@property (nonatomic, assign) CGFloat defaultItemHeight;

@property(readwrite,nonatomic,strong) id<OnMessageHandleListener> resultHandler;

@end

@implementation EnergyTaskContentViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"energy_task_content_title" inTable:nil]];
    NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]];
    [self setMenuWithArray:menuArray];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initLayout {
    if (!_mainContentView) {
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _defaultItemHeight = 92;
        
        CGFloat originY = 0;
        
        CGFloat itemHeight = _defaultItemHeight;
        _meterReadingTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_meterReadingTF setDetegate:self];
        [_meterReadingTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"energy_parameter_read" inTable:nil]];
        
        [_meterReadingTF setShowMark:NO];
        _meterReadingTF.keyboardType = UIKeyboardTypeDecimalPad;
        
        
        _mainContentView = [[UIView alloc] initWithFrame:frame];
        _mainContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_mainContentView addSubview:_meterReadingTF];
        
        [self.view addSubview:_mainContentView];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self saveParameter];
    }
}

- (void) saveParameter {
    [self handleResult];
}

- (void)setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _resultHandler = handler;
}

- (void) handleResult {
    if (_resultHandler) {
        NSString *result = [_meterReadingTF text];
        if (![FMUtils isStringEmpty:result]) {
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            [msg setValue:@"MissionDetailViewController" forKey:@"msgOrigin"];
            [msg setValue:result forKey:@"result"];
            [msg setValue:_meterId forKey:@"meterId"];
            [_resultHandler handleMessage:msg];
            [self finish];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"energy_parameter_input_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (NSString *) getContent {
    NSString * res = @"";
    if (![FMUtils isStringEmpty:_content]) {
        res = [_content copy];
    }
    return res;
}

- (NSString *) getDesc {
    NSString * res = @"";
    if(![FMUtils isStringEmpty:_unit]) {
        res = [[NSString alloc] initWithFormat:@"(%@ %@)", [[BaseBundle getInstance] getStringByKey:@"energy_parameter_unit" inTable:nil] , _unit];
    }
    return res;
}

- (void) updateContent {
    [_meterReadingTF setTitle:[self getContent]];
    [_meterReadingTF setDesc:[self getDesc]];
    if(![FMUtils isStringEmpty:_result]) {
        [_meterReadingTF setText:_result];
    }
}

- (void) setInfoWithTitile:(NSString *)title andUnit:(NSString *)unit andResult:(NSString *) result andMeterId:(NSNumber *)meterId {
    _content = title;
    _meterId = meterId;
    _unit = unit;
    _result = result;
    
    [self updateContent];
}


@end
