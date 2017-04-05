//
//  WorkJobItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkJobItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ResizeableLabelView.h"
#import "WorkOrderServerConfig.h"
#import "UIButton+Bootstrap.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"


@interface WorkJobItemView ()
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * pfmCode;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, strong) NSString * desc;
@property (readwrite, nonatomic, assign) NSInteger laborerStatus;
@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, assign) NSInteger status;

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * pfmCodeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation WorkJobItemView

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
        
        _labelWidth = 0;
        
        //工单号
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = [FMFont getInstance].listCodeFont;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _pfmCodeLbl = [[UILabel alloc] init];
        _pfmCodeLbl.font = [FMFont getInstance].listDescFont;
        _pfmCodeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //时间lbl
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [FMFont getInstance].ListTimeFont;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        //描述信息lbl
        _descLbl = [[UILabel alloc] init];
        _descLbl.numberOfLines = 2;
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.font = [FMFont getInstance].listDescFont;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //优先级
        _priorityLbl = [[UILabel alloc] init];
        _priorityLbl.textAlignment = NSTextAlignmentCenter;
        _priorityLbl.font = [FMFont getInstance].listPriorityFont;
        _priorityLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //工单状态
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        [self addSubview:_codeLbl];
        [self addSubview:_pfmCodeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_descLbl];
        [self addSubview:_priorityLbl];
        [self addSubview:_statusLbl];
    }
}



- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width ==0 || height ==0) {
        return;
    }
    //根据变化设置一些控件的参数
    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[self getStatusColor:_status] andBackgroundColor:[self getStatusColor:_status]];
    
    CGFloat sepHeight = 14;
    CGFloat padding = [FMSize getInstance].listePadding;
    CGFloat defaultItemHeight = 16;
    
    //提前获取Lbl大小方便布局
    CGSize codeSize = [FMUtils getLabelSizeBy:_codeLbl andContent:_code andMaxLabelWidth:width-padding*2];
    CGSize descSize = [FMUtils getLabelSizeBy:_descLbl andContent:_desc andMaxLabelWidth:width-padding*2];
    CGSize prioritySize = [FMUtils getLabelSizeBy:_priorityLbl andContent:[WorkOrderServerConfig getOrderPriorityLevelDesc:_priority] andMaxLabelWidth:width-padding*2];
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[WorkOrderServerConfig getOrderStatusDesc:_status]];
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, codeSize.width, codeSize.height)];
    originX += codeSize.width + (width - padding*2 - codeSize.width - statusSize.width - prioritySize.width)/2;
    [_priorityLbl setFrame:CGRectMake(originX, originY+(codeSize.height-prioritySize.height)/2, prioritySize.width, prioritySize.height)];
    [_statusLbl setFrame:CGRectMake(width - padding - statusSize.width, originY+(codeSize.height - statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += codeSize.height + sepHeight;
    originX = padding;
    
    if(![FMUtils isStringEmpty:_pfmCode]) {
        [_pfmCodeLbl setHidden:NO];
        [_pfmCodeLbl setFrame:CGRectMake(originX, originY, width-padding*2, defaultItemHeight)];
        originY += defaultItemHeight + sepHeight;
    } else {
        [_pfmCodeLbl setHidden:YES];
    }
    
    
    [_timeLbl setFrame:CGRectMake(originX, originY, width-padding*2, defaultItemHeight)];
    originY += defaultItemHeight + sepHeight;
    
    [_descLbl setFrame:CGRectMake(originX, originY, width-padding*2, descSize.height)];
    originY += descSize.height + sepHeight;
    

    [self updateInfo];
}

- (void) updateInfo {
    [_codeLbl setText:_code];
    [_pfmCodeLbl setText:_pfmCode];
    [_timeLbl setText: _time];
    [_descLbl setText:_desc];
    [_priorityLbl setText:[WorkOrderServerConfig getOrderPriorityLevelDesc:_priority]];
    [_statusLbl setContent:[WorkOrderServerConfig getOrderStatusDesc:_status]];
}

- (void) setInfoWithCode:(NSString*) code
                 pfmCode:(NSString *) pfmCode
                    time:(NSString*) time
                location:(NSString*) location
                    desc:(NSString *) desc
                  status:(NSInteger) status
           laborerStatus:(NSInteger) laborerStatus
                priority:(NSInteger) priority {
    _code = [code copy];
    _pfmCode = [pfmCode copy];
    _time = [time copy];
    if(![FMUtils isStringEmpty:location]) {
        _location = [location copy];
    } else {
        _location = @"";
    }
    
    _desc = [desc copy];
    _priority = priority;
    _status = status;
    _laborerStatus = laborerStatus;
    
    [self updateViews];
}

- (UIColor *) getStatusColor:(NSInteger) status {
    WorkOrderStatus orderStatus = (WorkOrderStatus)status;
    UIColor * color = [WorkOrderServerConfig getOrderStatusColor:orderStatus];
    return color;
}

+ (CGFloat) calculateHeightByDesc:(NSString *) desc location:(NSString *) location pfmCode:(NSString *) pfmCode andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat defaultItemHeight = 16;
    CGFloat sepHeight = 14;
    UILabel * testLbl = [UILabel new];
    testLbl.numberOfLines = 2;
    testLbl.font = [FMFont setFontByPX:44];
    CGSize descSize = [FMUtils getLabelSizeBy:testLbl andContent:desc andMaxLabelWidth:width-20];
    testLbl = nil;
    
    height = [FMUtils isStringEmpty:desc]? (sepHeight*3 + codeHeight + defaultItemHeight):(sepHeight*4 + codeHeight + defaultItemHeight + descSize.height);
    if(![FMUtils isStringEmpty:pfmCode]) {
        height += defaultItemHeight + sepHeight;
    }
    return height;
}

@end
