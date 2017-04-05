//
//  AssetBaseParemeterView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/7/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AssetBaseParemeterView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetBaseParemeterView()

@property (nonatomic, strong) BaseLabelView *nameLbl;
@property (nonatomic, strong) BaseLabelView *defaultValueLbl;
@property (nonatomic, strong) BaseLabelView *unitLbl;
@property (nonatomic, strong) BaseLabelView *descLbl;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) BOOL isInited;
@property (nonatomic, assign) BOOL isFlexible;

@end

@implementation AssetBaseParemeterView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        _isFlexible = NO;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _nameLbl = [[BaseLabelView alloc] init];
        [_nameLbl setLabelFont:mFont andColor:lightColor];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:darkColor];
        
        _defaultValueLbl = [[BaseLabelView alloc] init];
        [_defaultValueLbl setLabelFont:mFont andColor:lightColor];
        [_defaultValueLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_default_value" inTable:nil] andLabelWidth:0];
        [_defaultValueLbl setContentFont:mFont];
        [_defaultValueLbl setContentColor:darkColor];
        
        _unitLbl = [[BaseLabelView alloc] init];
        [_unitLbl setLabelFont:mFont andColor:lightColor];
        [_unitLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_unit" inTable:nil] andLabelWidth:0];
        [_unitLbl setContentFont:mFont];
        [_unitLbl setContentColor:darkColor];
        
        _descLbl = [[BaseLabelView alloc] init];
        [_descLbl setLabelFont:mFont andColor:lightColor];
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_desc" inTable:nil] andLabelWidth:0];
        [_descLbl setContentFont:mFont];
        [_descLbl setContentColor:darkColor];
        
        [self addSubview:_nameLbl];
        [self addSubview:_defaultValueLbl];
        [self addSubview:_unitLbl];
        [self addSubview:_descLbl];
    }
}

- (void) updateViews {
    if (!_isFlexible) {
        _nameLbl.hidden = YES;
        _defaultValueLbl.hidden = YES;
        _unitLbl.hidden = YES;
        _descLbl.hidden = YES;
        return;
    } else {
        _nameLbl.hidden = NO;
        _defaultValueLbl.hidden = NO;
        _unitLbl.hidden = NO;
        _descLbl.hidden = NO;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 16;
    CGFloat paddingTop = 13;
    CGFloat sepHeight = 9;
    
    CGFloat originY = paddingTop;
    CGFloat originX = 0;
    
    UIFont *mFont = [FMFont getInstance].font38;

    CGFloat nameHeight = [BaseLabelView calculateHeightByInfo:_name font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_name" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    CGFloat defaultvalueHeight = [BaseLabelView calculateHeightByInfo:_defaultValue font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_default_value" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:(width-padding)/2];
    
    CGFloat unitHeight = [BaseLabelView calculateHeightByInfo:_unit font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_unit" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:(width-padding)/2];
    
    CGFloat descHeight = [BaseLabelView calculateHeightByInfo:_desc font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_desc" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    
    nameHeight = (nameHeight>=itemHeight)?nameHeight:itemHeight;
    [_nameLbl setFrame:CGRectMake(originX, originY, width-padding, nameHeight)];
    originY += nameHeight + sepHeight;
    
    
    defaultvalueHeight = (defaultvalueHeight>itemHeight)?defaultvalueHeight:itemHeight;
    [_defaultValueLbl setFrame:CGRectMake(originX, originY, (width-padding)/2, defaultvalueHeight)];
    
    
    unitHeight = (unitHeight>itemHeight)?unitHeight:itemHeight;
    [_unitLbl setFrame:CGRectMake(originX+(width-padding)/2, originY, (width-padding)/2, unitHeight)];
    originY += (unitHeight>defaultvalueHeight)?unitHeight:defaultvalueHeight + sepHeight;
    
    
    descHeight = (descHeight>itemHeight)?descHeight:itemHeight;
    [_descLbl setFrame:CGRectMake(originX, originY, width - padding, descHeight)];
}

- (void) updateInfo {
    [_nameLbl setContent:_name];
    [_defaultValueLbl setContent:_defaultValue];
    [_unitLbl setContent:_unit];
    [_descLbl setContent:_desc];
    
    [self updateViews];
}


- (void) setParemeterInfoWith:(nonnull AssetEquipmentParams *) entity {
    _name = @"";
    _defaultValue = @"";
    _unit = @"";
    _desc = @"";
    
    if (![FMUtils isStringEmpty:entity.name]) {
        _name = [entity.name copy];
    }
    if (![FMUtils isStringEmpty:entity.value]) {
        _defaultValue = [entity.value copy];
    }
    if (![FMUtils isStringEmpty:entity.unit]) {
        _unit = [entity.unit copy];
    }
    if (![FMUtils isStringEmpty:entity.pDescription]) {
        _desc = [entity.pDescription copy];
    }
}


- (void)setFlexible:(BOOL)flexible {
    _isFlexible = flexible;
    [self updateInfo];
}


+ (CGFloat) calculaterHeightBy:(nonnull AssetEquipmentParams *) entity andFlexible:(BOOL) isFlexible {
    CGFloat height = 0;
    if (!isFlexible) {
        height = 0;
    } else {
        CGFloat paddingTop = 13;
        CGFloat sepHeight = 9;
        CGFloat itemHeight = 16;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        CGFloat width = [FMSize getInstance].screenWidth;
        
        UIFont *mFont = [FMFont getInstance].font38;
        
        CGFloat nameHeight = [BaseLabelView calculateHeightByInfo:entity.name font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_name" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
        
        CGFloat defaultvalueHeight = [BaseLabelView calculateHeightByInfo:entity.value font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_default_value" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:(width-padding)/2];
        
        CGFloat unitHeight = [BaseLabelView calculateHeightByInfo:entity.unit font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_unit" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:(width-padding)/2];
        
        CGFloat descHeight = [BaseLabelView calculateHeightByInfo:entity.pDescription font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_paremeter_desc" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
        
        nameHeight = (nameHeight>itemHeight)?nameHeight:itemHeight;
        defaultvalueHeight = (defaultvalueHeight>itemHeight)?defaultvalueHeight:itemHeight;
        unitHeight = (unitHeight>itemHeight)?unitHeight:itemHeight;
        descHeight = (descHeight>itemHeight)?descHeight:itemHeight;
        
        height = (defaultvalueHeight>unitHeight)?defaultvalueHeight:unitHeight;
        height += nameHeight + descHeight + sepHeight*2 + paddingTop*2;
    }
    
    return height;
}


@end



