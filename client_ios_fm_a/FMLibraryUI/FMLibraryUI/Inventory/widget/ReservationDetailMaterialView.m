//
//  ReservationDetailMaterialView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationDetailMaterialView.h"
#import "BaseLabelView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMSize.h"

@interface ReservationDetailMaterialView ()
@property (readwrite, nonatomic, strong) UILabel * codeLbl;   //物料编码
//@property (readwrite, nonatomic, strong) UILabel * nameLbl;   //物料名称
@property (readwrite, nonatomic, strong) BaseLabelView * brandLbl;  //品牌
@property (readwrite, nonatomic, strong) BaseLabelView * modelLbl;       //型号
@property (readwrite, nonatomic, strong) UILabel * reservedCountLbl;  //预定数量
@property (readwrite, nonatomic, strong) UILabel * receivedCountLbl;  //领用数量
@property (readwrite, nonatomic, strong) UILabel * costLbl;       //费用

@property (readwrite, nonatomic, strong) ReservationMaterial * material;

@property (readwrite, nonatomic, strong) NSString *codeString;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;

@property (readwrite, nonatomic, assign) BOOL showPrice;

@property (readwrite, nonatomic, assign) BOOL showReceive;  //显示领用数量

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation ReservationDetailMaterialView

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
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _showReceive = YES;
        _showPrice = YES;
        
        _codeLbl = [[UILabel alloc] init];
//        _nameLbl = [[UILabel alloc] init];
        _brandLbl = [[BaseLabelView alloc] init];
        _modelLbl = [[BaseLabelView alloc] init];
        _reservedCountLbl = [[UILabel alloc] init];
        _receivedCountLbl = [[UILabel alloc] init];
        _costLbl = [[UILabel alloc] init];
        
        CGFloat labelWidth = 0;
        [_brandLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_material_brand_colon" inTable:nil] andLabelWidth:labelWidth];
        [_modelLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_material_model_colon" inTable:nil] andLabelWidth:labelWidth];
        
        
        
        _codeLbl.font = [FMFont getInstance].font44;
//        _nameLbl.font = [FMFont getInstance].defaultFontLevel2;
        _reservedCountLbl.font = [FMFont getInstance].font38;
        _receivedCountLbl.font = [FMFont getInstance].font38;
        _costLbl.font = [FMFont getInstance].font44;
        
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _reservedCountLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _receivedCountLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _costLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        
        [self addSubview:_codeLbl];
//        [self addSubview:_nameLbl];
        [self addSubview:_brandLbl];
        [self addSubview:_modelLbl];
        [self addSubview:_reservedCountLbl];
        [self addSubview:_receivedCountLbl];
        [self addSubview:_costLbl];
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
    
    CGFloat sepHeight = (height - _paddingTop * 2  - _defaultItemHeight * 3) / 2;
    CGFloat originY = _paddingTop;
    CGFloat originX = 0;
    CGFloat sepWidth = 8;
    
//    CGFloat codeWidth = [FMUtils widthForString:_codeLbl value:_material.materialCode];
//    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_material.materialName];
    
    CGFloat costWidth = [FMUtils widthForString:_costLbl value:[self getCostDesc]];
    CGFloat reservedWidth = [FMUtils widthForString:_reservedCountLbl value:[self getReservedCountDesc]];
    CGFloat receivedWidth = [FMUtils widthForString:_receivedCountLbl value:[self getReceivedCountDesc]];
    
    CGFloat itemHeight = 0;
    
    originX = _paddingLeft;
    itemHeight = _defaultItemHeight;
//    [_codeLbl setFrame:CGRectMake(originX, originY, codeWidth, itemHeight)];
//    originX += codeWidth;
//    if(codeWidth > 0) {
//        originX += sepWidth;
//    }
    [_codeLbl setFrame:CGRectMake(originX, originY, width-_paddingLeft*2-costWidth-sepWidth, itemHeight)];
    
//    [_nameLbl setFrame:CGRectMake(originX, originY, width-originX-costWidth-_paddingLeft-sepWidth, itemHeight)];
//    originX += nameWidth + sepWidth;
    
    [_costLbl setFrame:CGRectMake(width-_paddingLeft-costWidth, originY, costWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    originX = 0;
    itemHeight = _defaultItemHeight;
    [_modelLbl setFrame:CGRectMake(originX, originY, itemWidth-reservedWidth, itemHeight)];
    [_reservedCountLbl setFrame:CGRectMake(width-_paddingLeft-reservedWidth, originY, reservedWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    originX = 0;
    itemHeight = _defaultItemHeight;
    [_brandLbl setFrame:CGRectMake(originX, originY, itemWidth-receivedWidth, itemHeight)];
    [_receivedCountLbl setFrame:CGRectMake(width-_paddingLeft-receivedWidth, originY, receivedWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (NSString *) getCostDesc {
    NSString * res = @"";
    res = [[NSString alloc] initWithFormat:@"￥%0.2f", [_material.cost doubleValue]];
    return res;
}

- (NSString *) getReservedCountDesc {
    NSString * res = @"";
    res = [[NSString alloc] initWithFormat:@"%@%0.2f",  [[BaseBundle getInstance] getStringByKey:@"inventory_detail_material_count_reserved" inTable:nil], _material.bookAmount.doubleValue];
    return res;
}

- (NSString *) getReceivedCountDesc {
    NSString * res = @"";
    res = [[NSString alloc] initWithFormat:@"%@%0.2f",  [[BaseBundle getInstance] getStringByKey:@"inventory_detail_material_count_received" inTable:nil], _material.receiveAmount.doubleValue];
    return res;
}

- (void) updateInfo {
    NSMutableString *codeStr = [[NSMutableString alloc] init];
    if (![FMUtils isStringEmpty:_material.materialCode]) {
        [codeStr appendString:_material.materialCode];
    }
    if (![FMUtils isStringEmpty:_material.materialName]) {
        [codeStr appendFormat:@"  %@",_material.materialName];
    }
    _codeString = codeStr;
    [_codeLbl setText:_codeString];
//    [_codeLbl setText:_material.materialCode];
//    [_nameLbl setText:_material.materialName];
    [_brandLbl setContent:_material.materialBrand];
    [_modelLbl setContent:_material.materialModel];
    [_reservedCountLbl setText:[self getReservedCountDesc]];
    [_receivedCountLbl setText:[self getReceivedCountDesc]];
    
    if(_showReceive) {
        [_receivedCountLbl setHidden:NO];
    } else {
        [_receivedCountLbl setHidden:YES];
    }
    
    if (_showPrice) {
        [_costLbl setHidden:NO];
    } else {
        [_costLbl setHidden:YES];
    }
    
    [_costLbl setText:[self getCostDesc]];
}


- (void) setInfoWithMaterial:(ReservationMaterial *) material {
    _material = material;
    [self updateViews];
}

//设置是否显示核定价格
- (void) setShowPirce:(BOOL)showPrice {
    _showPrice = showPrice;
//    [self updateInfo];
}

//设置是否显示领用数量
- (void) setShowReceiveAmount:(BOOL) show {
    _showReceive = show;
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat paddingTop = 13;
    CGFloat itemHeight = 20;
    CGFloat sepHeight = 8;
    
    height = itemHeight * 3 + paddingTop * 2 + sepHeight * 2;
    return height;
}
@end
