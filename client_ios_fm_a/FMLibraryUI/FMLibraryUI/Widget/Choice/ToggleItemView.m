//
//  ToggleItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  带开关功能的 baseitemview


#import "ToggleItemView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "SeperatorView.h"

@interface ToggleItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UISwitch * toogleBtn;

@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;
@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) CGFloat toggltWidth;
@property (readwrite, nonatomic, assign) CGFloat toggltHeight;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) CGFloat scale;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> listener;
@end

@implementation ToggleItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        _scale = 0.8;
        _padding = [FMSize getInstance].defaultPadding;
        
        _nameLbl = [[UILabel alloc] init];
        _toogleBtn = [[UISwitch alloc] init];
        
        _topSeperator = [[SeperatorView alloc] init];
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [_topSeperator setHidden:YES];
        [_bottomSeperator setHidden:YES];
        
        [_nameLbl setFont:[FMFont getInstance].defaultFontLevel2];
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [_toogleBtn addTarget: self action:@selector(onSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
        _toogleBtn.transform = CGAffineTransformMakeScale(_scale, _scale);
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_nameLbl];
        [self addSubview:_toogleBtn];
        
        [self addSubview:_topSeperator];
        [self addSubview:_bottomSeperator];
    }
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    CGRect switchFrame = _toogleBtn.frame;
    CGFloat switchWidth = CGRectGetWidth(switchFrame) * _scale;
    CGFloat switchHeight = CGRectGetHeight(switchFrame) * _scale;
    if(switchWidth == 0 || switchHeight == 0) {
        return;
    }
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    [_topSeperator setFrame:CGRectMake(0, 0, width, seperatorHeight)];
    [_nameLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2 - switchWidth, height)];
    [_toogleBtn setFrame:CGRectMake(width-_padding-switchWidth, (height-switchHeight)/2, switchWidth, switchHeight)];
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
}

- (void) setStatus:(BOOL) on {
    [_toogleBtn setOn:on animated:YES];
}
- (BOOL) isToggleOn {
    return _toogleBtn.on;
}

- (void) switchChanged {
    
}

- (void) setShowTopSeperator:(BOOL) show {
    if(show) {
        [_topSeperator setHidden:NO];
    } else {
        [_topSeperator setHidden:YES];
    }
}

- (void) setShowBottomSeperator:(BOOL) show {
    if(show) {
        [_bottomSeperator setHidden:NO];
    } else {
        [_bottomSeperator setHidden:YES];
    }
}

- (void) setInfoWithName:(NSString *)name{
    _name = name;
    
    [self updateViews];
}

- (void) setPadding:(CGFloat)padding {
    _padding = padding;
    [self updateViews];
}

//设置名字字体
- (void) setNameFont:(UIFont *) font {
    [_nameLbl setFont:font];
}

- (void) onSwitchValueChanged {//开关按钮状态改变
    NSLog(@"当前的开关状态为:%@",([self isToggleOn]?@"YES":@"NO"));
    [self notifyValueChanged];
}

//设置事件监听
- (void) setOnValueChangedListener:(id<OnMessageHandleListener>) listener {
    _listener = listener;
}

- (void) notifyValueChanged {
    [self notifyEventWithValue:[self isToggleOn]];
}

- (void) notifyEventWithValue:(BOOL) value {
    if(_listener) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithBool:value] forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_listener handleMessage:msg];
    }
}
@end
