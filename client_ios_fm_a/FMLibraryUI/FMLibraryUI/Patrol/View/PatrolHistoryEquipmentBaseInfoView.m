//
//  PatrolHistoryEquipmentBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryEquipmentBaseInfoView.h"
#import "BaseLabelView.h"
#import "FMUtilsPackages.h"
#import "ColorLabel.h"
#import "FMTheme.h"
#import "BaseBundle.h"


@interface PatrolHistoryEquipmentBaseInfoView ()

@property (readwrite, nonatomic, strong) BaseLabelView * nameBaseLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * systemBaseLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * system;
@property (readwrite, nonatomic, assign) PatrolEquipmentExceptionStatus status;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PatrolHistoryEquipmentBaseInfoView

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
        
        _paddingLeft = [FMSize getInstance].padding50;
        _paddingRight = [FMSize getInstance].padding50;
        _labelWidth = 80;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _nameBaseLbl = [[BaseLabelView alloc] init];
        [_nameBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_name" inTable:nil] andLabelWidth:0];
        [_nameBaseLbl setLabelFont:mFont andColor:labelColor];
        [_nameBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_nameBaseLbl setContentFont:mFont];
        [_nameBaseLbl setContentColor:contentColor];
        [_nameBaseLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _systemBaseLbl = [[BaseLabelView alloc] init];
        [_systemBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_system" inTable:nil] andLabelWidth:0];
        [_systemBaseLbl setLabelFont:mFont andColor:labelColor];
        [_systemBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_systemBaseLbl setContentFont:mFont];
        [_systemBaseLbl setContentColor:contentColor];
        [_systemBaseLbl setContentAlignment:NSTextAlignmentLeft];
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        [self addSubview:_nameBaseLbl];
        [self addSubview:_systemBaseLbl];
        [self addSubview:_statusLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = [FMSize getInstance].defaultPadding;
    
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    
    CGSize size = CGSizeMake(0, 0);
    size = [ColorLabel calculateSizeByInfo:[PatrolServerConfig getEquipmentStatusDescription:_status]];
    
    
    [_nameBaseLbl setFrame:CGRectMake(originX, originY, width-_paddingLeft-size.width, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width-_paddingLeft-size.width, originY+(itemHeight-size.height)/2, size.width, size.height)];
    originY += itemHeight + sepHeight;
    
    [_systemBaseLbl setFrame:CGRectMake(originX, originY, width-_paddingLeft, itemHeight)];
    
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameBaseLbl setContent:_name];
    [_systemBaseLbl setContent:_system];
    
    if(_status == PATROL_EQUIPMENT_EXCEPTION_STATUS_STOP) {
        [_statusLbl setHidden:NO];
        [_statusLbl setContent:[PatrolServerConfig getEquipmentStatusDescription:_status]];
    } else {
        [_statusLbl setHidden:YES];
    }
}

- (void) setInfoWithDeviceName:(NSString *) name andSystemName:(NSString *) system {
    if(name) {
        _name = [name copy];
    } else {
        _name = @"";
    }
    if(system) {
        _system = system;
    } else {
        _system = @"";
    }
    
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) setExceptionStatus:(PatrolEquipmentExceptionStatus) status {
    _status = status;
    [self updateViews];
}

+ (CGFloat) getBaseInfoHeight {
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    
    height = itemHeight * 2 + sepHeight * 3;
    
    return height;
}

@end
