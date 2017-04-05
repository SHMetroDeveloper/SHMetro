//
//  ReservationItemView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReservationItemView.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "ColorLabel.h"


@interface ReservationItemView ()
@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;   //预定单号
@property (readwrite, nonatomic, strong) BaseLabelView * personLbl;   //预定人
@property (readwrite, nonatomic, strong) BaseLabelView * timeLbl;   //预定时间
@property (readwrite, nonatomic, strong) BaseLabelView * warehouseLbl;   //仓库名称
@property (readwrite, nonatomic, strong) BaseLabelView * orderLbl;   //关联工单
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;   //审核状态

@property (readwrite, nonatomic, strong) SeperatorView * bottomLine;

@property (readwrite, nonatomic, strong) ReservationEntity * entity;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) BOOL isLast;   //是否为最后一条记录，影响 bottomLine 显示效果
@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation ReservationItemView

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
        
        _paddingTop = 15;
        _labelWidth = 0;    //自动计算
        _seperatorHeight = [FMSize getInstance].seperatorHeight;
        _defaultItemHeight = 18;
        
        UIFont * codeFont = [FMFont getInstance].font44;
        
        _codeLbl = [[BaseLabelView alloc] init];
        _personLbl = [[BaseLabelView alloc] init];
        _timeLbl = [[BaseLabelView alloc] init];
        _warehouseLbl = [[BaseLabelView alloc] init];
        _orderLbl = [[BaseLabelView alloc] init];
        _statusLbl = [[ColorLabel alloc] init];
        
        _bottomLine = [[SeperatorView alloc] init];
        [_bottomLine setDotted:YES];
        
        [_codeLbl setLabelFont:codeFont andColor:nil];
        [_codeLbl setContentFont:codeFont];
        
        [_personLbl setLabelFont:codeFont andColor:nil];
        [_personLbl setContentFont:codeFont];
        
        [_timeLbl setLabelFont:codeFont andColor:nil];
        [_timeLbl setContentFont:codeFont];
        
        [_warehouseLbl setLabelFont:codeFont andColor:nil];
        [_warehouseLbl setContentFont:codeFont];
        
        [_orderLbl setLabelFont:codeFont andColor:nil];
        [_orderLbl setContentFont:codeFont];
        
        [_codeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_code_colon" inTable:nil] andLabelWidth:_labelWidth];
        [_personLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_person_colon" inTable:nil] andLabelWidth:_labelWidth];
        [_timeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_time_colon" inTable:nil] andLabelWidth:_labelWidth];
        [_warehouseLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_warehouse_colon" inTable:nil] andLabelWidth:_labelWidth];
        [_orderLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_order_colon" inTable:nil] andLabelWidth:_labelWidth];
        
        [self addSubview:_codeLbl];
        [self addSubview:_personLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_warehouseLbl];
        [self addSubview:_orderLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_bottomLine];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = 0;
    CGFloat itemHeight = 0;
    CGFloat sepHeight = (height - _paddingTop * 2 - _defaultItemHeight * 5) / 4;
    CGFloat paddingRight = [FMSize getInstance].defaultPadding;
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[InventoryServerConfig getReservationStatusDescription:_entity.status]];
    
    originY = _paddingTop;
    
    itemHeight = _defaultItemHeight;
    [_codeLbl setFrame:CGRectMake(0, originY, width-paddingRight-statusSize.width , itemHeight)];
    
    
    [_statusLbl setFrame:CGRectMake(width-paddingRight-statusSize.width, originY+(itemHeight-statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_personLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_timeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;

    itemHeight = _defaultItemHeight;
    [_warehouseLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_orderLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    if(_isLast) {
        [_bottomLine setFrame:CGRectMake(0, height-_seperatorHeight, width, _seperatorHeight)];
        [_bottomLine setDotted:NO];
    } else {
        [_bottomLine setFrame:CGRectMake(paddingRight, height-_seperatorHeight, width-paddingRight*2, _seperatorHeight)];
        [_bottomLine setDotted:YES];
    }
    
//    [self updateInfo];
}

- (void) updateInfo {
    [_codeLbl setContent:_entity.reservationCode];
    [_personLbl setContent:_entity.reservationPersonName];
    NSDate * date = [FMUtils timeLongToDate:_entity.reservationDate];
    NSString * strTime = [FMUtils getDayStr:date];
    [_timeLbl setContent:strTime];
    [_warehouseLbl setContent:_entity.warehouseName];
    [_orderLbl setContent:_entity.woCode];

    NSString * strStatus = [InventoryServerConfig getReservationStatusDescription:_entity.status];
    UIColor * color = [InventoryServerConfig getReservationStatusColor:_entity.status];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:color andBackgroundColor:color];
    [_statusLbl setContent:strStatus];
    
    [self updateViews];
}

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    //    [self updateViews];
}

- (void) setInfoWith:(ReservationEntity *) entity {
    _entity = entity;
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat paddingTop = 15;
    CGFloat itemHeight = 18;
    CGFloat sepHeight = 10;
    
    height = paddingTop * 2 + itemHeight * 5 + sepHeight * 4;
    return height;
}

@end
