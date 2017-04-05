//
//  ReservationDetailBaseView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationDetailBaseView.h"
#import "BaseLabelView.h"
#import "BaseBundle.h"
#import "ColorLabel.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "FMSize.h"

@interface ReservationDetailBaseView ()

@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;  //预定单号
//@property (readwrite, nonatomic, strong) BaseLabelView * applicantLbl;  //申请人
@property (readwrite, nonatomic, strong) BaseLabelView * dateLbl;       //时间
@property (readwrite, nonatomic, strong) BaseLabelView * warehouseLbl;  //仓库
@property (readwrite, nonatomic, strong) BaseLabelView * orderLbl;      //关联工单
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;       //备注
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;       //状态

@property (readwrite, nonatomic, strong) SeperatorView * bottomLine;       //底部分割线

@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * warehouseName;
@property (readwrite, nonatomic, strong) NSString * date;
@property (readwrite, nonatomic, strong) NSString * order;
@property (readwrite, nonatomic, strong) NSString * desc;
@property (readwrite, nonatomic, assign) ReservationStatusType status;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ReservationDetailBaseView

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
        
        _defaultItemHeight = 20;
        _paddingTop = 13;
        _paddingLeft = 15;
        
        _codeLbl = [[BaseLabelView alloc] init];
        _warehouseLbl = [[BaseLabelView alloc] init];
        _dateLbl = [[BaseLabelView alloc] init];
        _orderLbl = [[BaseLabelView alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _statusLbl = [[ColorLabel alloc] init];
        _bottomLine = [[SeperatorView alloc] init];
        
        CGFloat labelWidth = 0;
        [_codeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_code_colon" inTable:nil] andLabelWidth:labelWidth];
        [_warehouseLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_warehouse_colon" inTable:nil] andLabelWidth:labelWidth];
        [_dateLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_date_colon" inTable:nil] andLabelWidth:labelWidth];
        [_orderLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_order_colon" inTable:nil] andLabelWidth:labelWidth];
        [_descLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_desc_colon" inTable:nil] andLabelWidth:labelWidth];
        
        [self addSubview:_codeLbl];
        [self addSubview:_warehouseLbl];
        [self addSubview:_dateLbl];
        [self addSubview:_orderLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_bottomLine];
//        [self addSubview:_descLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat itemWidth = width - _paddingLeft;
    CGFloat descHeight = 0;
//    descHeight = [BaseLabelView calculateHeightByInfo:_desc font:nil desc: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_desc_colon" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:itemWidth];
//    if(descHeight < _defaultItemHeight) {
//        descHeight = _defaultItemHeight;
//    }
    
    CGFloat sepHeight = (height - _paddingTop * 2 - descHeight - _defaultItemHeight * 4) / 3;
    CGFloat originY = _paddingTop;
    CGSize size = [ColorLabel calculateSizeByInfo:[InventoryServerConfig getReservationStatusDescription:_status]];
    
    CGFloat itemHeight = _defaultItemHeight;
    [_codeLbl setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width-_paddingLeft-size.width, originY+(itemHeight - size.height)/2, size.width, size.height)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_dateLbl setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_warehouseLbl setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = _defaultItemHeight;
    [_orderLbl setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
//    
//    itemHeight = descHeight;
//    [_descLbl setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
//    originY += itemHeight + sepHeight;
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    [_bottomLine setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_codeLbl setContent:_code];
    [_warehouseLbl setContent:_warehouseName];
    [_dateLbl setContent:_date];
    [_orderLbl setContent:_order];
    [_descLbl setContent:_desc];
    
    [_statusLbl setContent:[InventoryServerConfig getReservationStatusDescription:_status]];
    
    UIColor * color = [InventoryServerConfig getReservationStatusColor:_status];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:color andBackgroundColor:color];
}

- (void) setInfoWithCode:(NSString *) code warehouse:(NSString *) warehouseName date:(NSString *) date orderCode:(NSString *) order desc:(NSString *) desc status:(ReservationStatusType) status {
    _code = code;
    _warehouseName = warehouseName;
    _date = date;
    _order = order;
    _desc = desc;
    _status = status;
    [self updateViews];
}

+ (CGFloat) calculateHeightByDesc:(NSString *) desc width:(CGFloat) width {
    CGFloat height = 0;
    CGFloat defaultItemHeight = 20;
    CGFloat paddingTop = 15;
    CGFloat sepHeight = 7;
    CGFloat paddingLeft = 17;
    
    CGFloat descHeight = 0;
//    NSString * labelStr = [ [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base_desc_colon" inTable:nil] copy];
//    descHeight = [BaseLabelView calculateHeightByInfo:desc font:nil desc:labelStr labelFont:nil andLabelWidth:0 andWidth:width - paddingLeft];
//    if(descHeight < defaultItemHeight) {
//        descHeight = defaultItemHeight;
//    }
    
    height = defaultItemHeight * 4 + descHeight + paddingTop * 2 + sepHeight * 3;
    
    return height;
}

@end
