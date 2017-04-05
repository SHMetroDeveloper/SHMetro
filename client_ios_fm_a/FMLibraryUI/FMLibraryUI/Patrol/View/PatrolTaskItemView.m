//
//  PatrolTaskItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskItemView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "UIButton+BootStrap.h"
#import "FMUtils.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"
#import "PatrolTaskEntity.h"

@interface PatrolTaskItemView ()

@property (readwrite, nonatomic, strong) NSString * name;       //任务名
@property (readwrite, nonatomic, strong) NSString * startTime;  //开始时间
@property (readwrite, nonatomic, strong) NSString * endTime;    //结束时间

@property (readwrite, nonatomic, assign) NSInteger spotCount;   //点位数
@property (readwrite, nonatomic, assign) NSInteger deviceCount; //设备数
@property (readwrite, nonatomic, assign) BOOL isFinish;         //完成
@property (readwrite, nonatomic, strong) NSNumber * syn;         //同步
@property (readwrite, nonatomic, assign) BOOL showSubmit;
@property (readwrite, nonatomic, assign) PatrolTaskType taskType;


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * startTimeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * endTimeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * spotLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * deviceLbl;
@property (readwrite, nonatomic, strong) ColorLabel * synLbl;
@property (readwrite, nonatomic, strong) ColorLabel * finishLbl;
@property (nonatomic, strong) ColorLabel *typeLbl;
//@property (readwrite, nonatomic, strong) UIButton* submitBtn;

@property (readwrite, nonatomic, strong) id<OnItemClickListener> listener;

@property (readwrite, nonatomic, assign) CGFloat stateWidth;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation PatrolTaskItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _stateWidth = 0;
        _btnWidth = [FMSize getInstance].btnWidth;
        _btnHeight = [FMSize getInstance].listItemBtnHeight;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font42;
        _nameLbl.textColor = contentColor;
        
        
        _spotLbl = [[BaseLabelView alloc] init];
        [_spotLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_content_spot" inTable:nil] andLabelWidth:0];
        [_spotLbl setLabelFont:mFont andColor:labelColor];
        [_spotLbl setLabelAlignment:NSTextAlignmentLeft];
        [_spotLbl setContentAlignment:NSTextAlignmentLeft];
        [_spotLbl setContentFont:mFont];
        [_spotLbl setContentColor:contentColor];
        
        
        _deviceLbl = [[BaseLabelView alloc] init];
        [_deviceLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_content_device" inTable:nil] andLabelWidth:0];
        [_deviceLbl setLabelFont:mFont andColor:labelColor];
        [_deviceLbl setLabelAlignment:NSTextAlignmentLeft];
        [_deviceLbl setContentAlignment:NSTextAlignmentLeft];
        [_deviceLbl setContentFont:mFont];
        [_deviceLbl setContentColor:contentColor];
        
        
        
        
        _startTimeLbl = [[BaseLabelView alloc] init];
        [_startTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"time_start_estimate" inTable:nil] andLabelWidth:0];
        [_startTimeLbl setLabelFont:mFont andColor:labelColor];
        [_startTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_startTimeLbl setContentAlignment:NSTextAlignmentLeft];
        [_startTimeLbl setContentFont:mFont];
        [_startTimeLbl setContentColor:contentColor];
        
        
        
        
        _endTimeLbl = [[BaseLabelView alloc] init];
        [_endTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"time_end_estimate" inTable:nil] andLabelWidth:0];
        [_endTimeLbl setLabelFont:mFont andColor:labelColor];
        [_endTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_endTimeLbl setContentAlignment:NSTextAlignmentLeft];
        [_endTimeLbl setContentFont:mFont];
        [_endTimeLbl setContentColor:contentColor];
        
        
        
        _synLbl = [[ColorLabel alloc] init];
        [_synLbl setShowCorner:YES];
        [_synLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        _finishLbl = [[ColorLabel alloc] init];
        [_finishLbl setShowCorner:YES];
        [_finishLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        _typeLbl = [[ColorLabel alloc] init];
        [_typeLbl setShowCorner:YES];
    
        [self addSubview:_nameLbl];
        [self addSubview:_startTimeLbl];
        [self addSubview:_endTimeLbl];
        [self addSubview:_spotLbl];
        [self addSubview:_deviceLbl];
        [self addSubview:_synLbl];
        [self addSubview:_finishLbl];
        [self addSubview:_typeLbl];
        
//        [self updateViews];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat padding = 14;
    CGFloat msgHeight = 16;
    CGFloat nameHeight = 19;
    
    CGFloat orginX = [FMSize getInstance].defaultPadding;
    CGFloat originY = padding;
    
    CGSize statusSize = CGSizeZero;
    CGSize synSize = CGSizeZero;
    CGSize typeSize = CGSizeZero;
    
    if (_isFinish) {
        statusSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil]];
    } else {
        statusSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil]];
    }
    
    if (_syn) {
        if (_syn.boolValue) {
            synSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_syned" inTable:nil]];
        } else {
            synSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_un_syned" inTable:nil]];
        }
    }
    
    NSString * strType = [PatrolServerConfig getTaskTypeDescription:_taskType];
    typeSize = [ColorLabel calculateSizeByInfo:strType];
    
    [_nameLbl setFrame:CGRectMake(orginX, originY, width-padding*4-statusSize.width-synSize.width-typeSize.width, nameHeight)];
    
    orginX = width-padding-statusSize.width;
    [_finishLbl setFrame:CGRectMake(orginX, originY + (nameHeight - statusSize.height)/2, statusSize.width, statusSize.height)];
    
    if(_syn) {
        orginX -= padding + synSize.width;
    }
    [_synLbl setFrame:CGRectMake(orginX, originY + (nameHeight - synSize.height)/2, synSize.width, synSize.height)];
    
    orginX -= padding + typeSize.width;
    [_typeLbl setFrame:CGRectMake(orginX, originY + (nameHeight - typeSize.height)/2, typeSize.width, typeSize.height)];
    originY += nameHeight + padding;
    
    orginX = 0;
    [_spotLbl setFrame:CGRectMake(orginX, originY, (width-[FMSize getInstance].defaultPadding*2)/2, msgHeight)];
    
    [_deviceLbl setFrame:CGRectMake(orginX+(width-[FMSize getInstance].defaultPadding*2)/2+[FMSize getInstance].defaultPadding, originY, (width-[FMSize getInstance].defaultPadding*2)/2, msgHeight)];
    originY += msgHeight + padding;
    
    [_startTimeLbl setFrame:CGRectMake(orginX, originY, width-padding*2, msgHeight)];
    originY += msgHeight + padding;
    
    [_endTimeLbl setFrame:CGRectMake(orginX, originY, width-padding*2, msgHeight)];
    
//    [_submitBtn setFrame:CGRectMake(width-_btnWidth-orginX, originY + (msgHeight - _btnHeight)/2, _btnWidth, _btnHeight)];
    originY += msgHeight + padding;;
}

- (void) setInfoWithName: (NSString*) name
               startTime: (NSString*) startTime
                 endTime: (NSString*) endTime
                    spot: (NSInteger) spotCount
                  device: (NSInteger) deviceCount
                taskType:(PatrolTaskType) type
                isFinish: (BOOL) isFinish
                     syn:(NSNumber *) syn
                  submit: (BOOL) showSubmit {
    
    _name = name;
    _startTime = startTime;
    _endTime = endTime;
    _spotCount = spotCount;
    _deviceCount = deviceCount;
    _isFinish = isFinish;
    _syn = syn;
    _showSubmit = showSubmit;
    _taskType = type;
    
    [self updateInfo];
}

- (void) updateInfo {
    
    [_nameLbl setText:_name];
    
    if(![FMUtils isStringEmpty:_startTime]) {
        [_startTimeLbl setContent:_startTime];
    } else {
        [_startTimeLbl setContent:@""];
    }
    
    if(![FMUtils isStringEmpty:_endTime]) {
        [_endTimeLbl setContent:_endTime];
    } else {
        [_endTimeLbl setContent:@""];
    }
    
    [_spotLbl setContent:[NSString stringWithFormat:@"%ld", _spotCount]];
    
    [_deviceLbl setContent:[NSString stringWithFormat:@"%ld", _deviceCount]];
    
    if(_syn) {
        [_synLbl setHidden:NO];
        if(_syn.boolValue) {
            [_synLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_syned" inTable:nil]];
        } else {
            [_synLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_un_syned" inTable:nil]];
        }
    } else {
        [_synLbl setHidden:YES];
    }
    
    if(_isFinish) {
        [_finishLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_normal" inTable:nil]];
        [_finishLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
    } else {
        [_finishLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_not_finish" inTable:nil]];
        [_finishLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
    }
    
    /* 巡检与巡视颜色区分 */
    UIColor *backgroundColor;
    if (_taskType == PATROL_TASK_TYPE_INSPECTION) {
        
        backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    }
    else if (_taskType == PATROL_TASK_TYPE_PATROL) {
        
        backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    }
    [_typeLbl setTextColor:[UIColor whiteColor] andBorderColor:backgroundColor andBackgroundColor:backgroundColor];
    NSString * strType = [PatrolServerConfig getTaskTypeDescription:_taskType];
    [_typeLbl setContent:strType];
    
    [self updateViews];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener{
    self.listener = listener;
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 16;
    CGFloat padding = 14;
    height = codeHeight + itemHeight * 3 + padding * 5;
    return height;
}


@end
