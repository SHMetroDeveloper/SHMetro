//
//  PatrolTaskSpotItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskSpotItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "PatrolTaskEntity.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"


@interface PatrolTaskSpotItemView ()

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * taskName;
@property (readwrite, nonatomic, strong) NSString * position;
@property (readwrite, nonatomic, assign) NSInteger compositeCount;
@property (readwrite, nonatomic, assign) NSInteger deviceCount;
@property (readwrite, nonatomic, strong) NSString * state;
@property (readwrite, nonatomic, strong) NSString * notice;
@property (readwrite, nonatomic, assign) BOOL isException;

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * compositeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * deviceLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * positionLbl;

@property (readwrite, nonatomic, strong) ColorLabel * stateLbl;   //点位的完成状态
@property (readwrite, nonatomic, strong) ColorLabel * synLbl;     //数据的同步状态
@property (readwrite, nonatomic, strong) ColorLabel * exceptionLbl; //数据的异常状态

@property (readwrite, nonatomic, assign) CGFloat stateWidth;
@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation PatrolTaskSpotItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews {
    if(!_isInited) {
        _isInited = YES;
        
        _stateWidth = 0;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font44;
        _nameLbl.textColor = contentColor;
        
        
        _positionLbl = [[BaseLabelView alloc] init];
        [_positionLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_location" inTable:nil] andLabelWidth:0];
        [_positionLbl setLabelFont:mFont andColor:labelColor];
        [_positionLbl setLabelAlignment:NSTextAlignmentLeft];
        [_positionLbl setContentFont:mFont];
        [_positionLbl setContentColor:contentColor];
        [_positionLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _compositeLbl = [[BaseLabelView alloc] init];
        [_compositeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive_amount" inTable:nil] andLabelWidth:0];
        [_compositeLbl setLabelFont:mFont andColor:labelColor];
        [_compositeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_compositeLbl setContentFont:mFont];
        [_compositeLbl setContentColor:contentColor];
        [_compositeLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        
        _deviceLbl = [[BaseLabelView alloc] init];
        [_deviceLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_amount" inTable:nil] andLabelWidth:0];
        [_deviceLbl setLabelFont:mFont andColor:labelColor];
        [_deviceLbl setLabelAlignment:NSTextAlignmentLeft];
        [_deviceLbl setContentFont:mFont];
        [_deviceLbl setContentColor:contentColor];
        [_deviceLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _stateLbl = [[ColorLabel alloc] init];
        _synLbl = [[ColorLabel alloc] init];
        _exceptionLbl = [[ColorLabel alloc] init];
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_positionLbl];
        [self addSubview:_compositeLbl];
        [self addSubview:_deviceLbl];
        [self addSubview:_stateLbl];
        [self addSubview:_synLbl];
        [self addSubview:_exceptionLbl];
    }
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat originX = 0;

    
    CGFloat nameHeight = [FMSize getInstance].listItemInfoHeight + 10;
    CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].listItemPaddingLeft;
    CGFloat itemHeight = 0;
    CGFloat originY = 0;
    CGFloat sepWidth = 10;
    CGSize stateSize;
    CGFloat stateWidth;
    CGSize synSize = CGSizeMake(0, 0);
    CGSize exceptionSize = CGSizeMake(0, 0);
    
    
    CGFloat sepHeight = (height - nameHeight - msgHeight * 2)/4;
    originY = sepHeight;
    
    stateSize = [ColorLabel calculateSizeByInfo:_state];
    if(![FMUtils isStringEmpty:_notice]) {
        synSize = [ColorLabel calculateSizeByInfo:_notice];
    }
    if(_isException) {
        exceptionSize = [ColorLabel calculateSizeByInfo:@"异常"];
    }
    
    stateWidth = stateSize.width;
    itemHeight = nameHeight;
    [_nameLbl setFrame:CGRectMake(padding, originY, width - padding*2 - stateWidth-sepWidth-synSize.width, itemHeight)];
    originX = width-padding;
    if(stateWidth > 0) {
        [_stateLbl setFrame:CGRectMake(originX-stateWidth, originY + (itemHeight - stateSize.height)/2, stateWidth, stateSize.height)];
        originX -= stateWidth + sepWidth;
    }
    if(exceptionSize.width > 0) {
        [_exceptionLbl setFrame:CGRectMake(originX - exceptionSize.width, originY + (itemHeight - exceptionSize.height)/2, exceptionSize.width, exceptionSize.height)];
        originX -= exceptionSize.width + sepWidth;
    }
    if(synSize.width > 0) {
        [_synLbl setFrame:CGRectMake(originX - synSize.width, originY + (itemHeight - synSize.height)/2, synSize.width, synSize.height)];
        originX -= synSize.width + sepWidth;
    }
    
    
    originY += itemHeight + sepHeight;
    
    itemHeight = msgHeight;
    [_compositeLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_deviceLbl setFrame:CGRectMake(width/2, originY, width/2-padding, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = msgHeight;
    [_positionLbl setFrame:CGRectMake(0, originY, width - padding, itemHeight)];
    originY += itemHeight + sepHeight;
}

- (void) setInfoWithName:(NSString*) name
                position:(NSString*) position
               composite:(NSInteger) compositeCount
                  device:(NSInteger) deviceCount
                   state:(NSString*) state
                  notice:(NSString*) notice {
    _name = name;
    _taskName = nil;
    _position = position;
    _compositeCount = compositeCount;
    _deviceCount = deviceCount;
    _state = state;
    _notice = notice;
    
    [self updateInfo];
}

- (void) setInfoWithName:(NSString*) name
                taskName:(NSString *) taskName
                position:(NSString*) position
               composite:(NSInteger) compositeCount
                  device:(NSInteger) deviceCount
                   state:(NSString*) state
                  notice:(NSString*) notice {
    _name = name;
    _taskName = taskName;
    _position = position;
    _compositeCount = compositeCount;
    _deviceCount = deviceCount;
    _state = state;
    _notice = notice;
    
    [self updateInfo];
}

- (void) updateInfo {
    if(!_taskName) {
        [_nameLbl setText:_name];
    } else {
        [_nameLbl setText: _taskName];
    }
    
    [_positionLbl setContent:_position];
    [_compositeLbl setContent:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive_amount_format" inTable:nil], _compositeCount]];
    [_deviceLbl setContent:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_amount_foramt" inTable:nil], _deviceCount]];
    
    [_stateLbl setContent:_state];
    if(![FMUtils isStringEmpty:_state]) {
        [_stateLbl setHidden:NO];
        if([_state isEqualToString:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil]]) {            //完成
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        } else if([_state isEqualToString:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_exception" inTable:nil]]) {  //异常
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        } else {                                                                //其它
            [_stateLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        }
    } else {
        [_stateLbl setHidden:YES];
    }
    
    if(_notice) {
        [_synLbl setHidden:NO];
        [_synLbl setContent:_notice];
        [_synLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
    } else {
        [_synLbl setHidden:YES];
    }
    
    [self updateSubViews];
}

@end
