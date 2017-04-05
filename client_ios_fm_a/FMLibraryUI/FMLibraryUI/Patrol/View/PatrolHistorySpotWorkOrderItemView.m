//
//  PatrolHistorySpotWorkOrderItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistorySpotWorkOrderItemView.h"
#import "FMUtils.h"

@interface PatrolHistorySpotWorkOrderItemView ()


@property (readwrite, nonatomic, strong) NSString * code;    //单号
@property (readwrite, nonatomic, strong) NSString * time;    //时间
@property (readwrite, nonatomic, strong) NSString * state;   //工单状态

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * stateLbl;


@property (readwrite, nonatomic, strong) UIFont * mFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;


@property (readwrite, nonatomic, assign) CGFloat stateWidth;
@property (readwrite, nonatomic, assign) CGFloat timeWidth;

@end

@implementation PatrolHistorySpotWorkOrderItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        if(!_mFont) {
            _mFont  = [UIFont fontWithName:@"Helvetica" size:14];
        }
        _stateWidth = 60;
        _timeWidth = 100;
        
        _codeLbl = [[UILabel alloc] init];
        _timeLbl = [[UILabel alloc] init];
        _stateLbl = [[UILabel alloc] init];
        [self updateSubViews];
        [self addSubview:_codeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_stateLbl];
    }
    return self;
}

- (void) updateSubViews {
    if(!_mFont) {
        _mFont  = [UIFont fontWithName:@"Helvetica" size:14];
    }
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [_codeLbl setFrame:CGRectMake(_paddingLeft, 0, (width - _paddingLeft - _paddingRight) - _stateWidth - _timeWidth, height)];
    [_timeLbl setFrame:CGRectMake(width - _paddingRight - _stateWidth - _timeWidth  , 0, _timeWidth, height)];
    [_stateLbl setFrame:CGRectMake(width - _paddingRight - _stateWidth, 0, _stateWidth, height)];
    
    
    [_codeLbl setFont:_mFont];
    [_timeLbl setFont:_mFont];
    [_stateLbl setFont:_mFont];
    
    [self updateInfo];
    
}

- (void) setInfoWithCode:(NSString*) code
                    time:(NSString*) time
                   state:(NSString*) state {
    _code = code;
    _time = time;
    _state = state;
    [self updateSubViews];
}

- (void) updateInfo {
    if(_code) {
        _codeLbl.text = _code;
    }
    if(_time) {
        _timeLbl.text = _time;
    }
    if(_state) {
        _stateLbl.text = _state;
    }
}



- (void) setFont:(UIFont*) font {
    _mFont = font;
    _codeLbl.font = _mFont;
    _timeLbl.font = _mFont;
    _stateLbl.font = _mFont;
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right {
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubViews];
}

@end

