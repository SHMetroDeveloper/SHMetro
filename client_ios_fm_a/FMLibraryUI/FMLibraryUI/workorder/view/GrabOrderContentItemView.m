//
//  GrabOrderContentItemView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "GrabOrderContentItemView.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "UIButton+Bootstrap.h"
#import "OnClickListener.h"

@interface GrabOrderContentItemView() <OnClickListener>
@property (readwrite, nonatomic, strong) BaseLabelView * estimatedTimeLbl;
@property (readwrite, nonatomic, strong) UIButton * doBtn;
@property (readwrite, nonatomic, strong) UIButton * cancelBtn;

@property (readwrite, nonatomic, strong) NSNumber * estimatedTime;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@end

@implementation GrabOrderContentItemView

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
        
        _labelWidth = 100;
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        
        _estimatedTimeLbl = [[BaseLabelView alloc] init];
        
        _doBtn = [[UIButton alloc] init];
        _cancelBtn = [[UIButton alloc] init];
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        
        _estimatedTimeLbl.tag = GRAB_ORDER_CONTENT_ITEM_OPERATE_SELECT_TIME;
        
        [_estimatedTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_estimate_arrive_time" inTable:nil] andLabelWidth:_labelWidth];
        [_estimatedTimeLbl setOnClickListener:self];
        [_estimatedTimeLbl setShowBounds:YES];
        _estimatedTimeLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_estimatedTimeLbl setLabelFont:font andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        [_doBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_grab" inTable:nil] forState:UIControlStateNormal];
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        
        [_doBtn.titleLabel setFont:font];
        [_cancelBtn.titleLabel setFont:font];
        
        _doBtn.tag = GRAB_ORDER_CONTENT_ITEM_OPERATE_OK;
        _cancelBtn.tag = GRAB_ORDER_CONTENT_ITEM_OPERATE_CANCEL;
        
        [_doBtn addTarget:self action:@selector(onGrabBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn addTarget:self action:@selector(onCancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_estimatedTimeLbl];
        [self addSubview:_doBtn];
        [self addSubview:_cancelBtn];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 40;
    CGFloat originY = padding * 2;
    CGFloat btnWidth = (width-padding * 3) / 2;
    
    [_estimatedTimeLbl setFrame:CGRectMake(padding, originY, width-padding*2, itemHeight)];
    
    
    originY = height - padding - _btnHeight;
    [_doBtn setFrame:CGRectMake(padding, originY, btnWidth, _btnHeight)];
    [_doBtn primaryStyle];
    
    [_cancelBtn setFrame:CGRectMake(width-padding-btnWidth, originY, btnWidth, _btnHeight)];
    [_cancelBtn primaryStyle];
    
    
    
    [self updateInfo];
}

- (void) updateInfo {
    NSString * strTime = [FMUtils timeLongToDateString:_estimatedTime];
    [_estimatedTimeLbl setContent:strTime];
}

- (void) setInfoWith:(NSNumber *) time {
    _estimatedTime = [time copy];
    [self updateViews];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    if(!_listener) {
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesturRecognizer];
    }
    _listener = listener;
}

- (void) onClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self  subView:nil];
    }
}

- (void) onTimeLblClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_estimatedTimeLbl];
    }
}

- (void) onGrabBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_doBtn];
    }
}

- (void) onCancelBtnClicked {
    if(_listener) {
        [_listener onItemClick:self subView:_cancelBtn];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _estimatedTimeLbl) {
        [self onTimeLblClicked];
    }
}
@end
