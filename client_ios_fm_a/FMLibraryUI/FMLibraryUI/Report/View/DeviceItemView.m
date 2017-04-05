//
//  DeviceItemView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/7/27.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "DeviceItemView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface DeviceItemView()

@property (nonatomic, strong) BaseLabelView *codeLbl;
@property (nonatomic, strong) BaseLabelView *nameLbl;
@property (nonatomic, strong) BaseLabelView *locationLbl;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) BOOL isInited;

@end


@implementation DeviceItemView

- (instancetype)init {
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
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _codeLbl = [[BaseLabelView alloc] init];
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setLabelFont:mFont andColor:lightColor];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:darkColor];
        
        
        _nameLbl = [[BaseLabelView alloc] init];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setLabelFont:mFont andColor:lightColor];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:darkColor];
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:lightColor];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:darkColor];
        
        
        [self addSubview:_codeLbl];
        [self addSubview:_nameLbl];
        [self addSubview:_locationLbl];
    }
}

- (void) updateViews {
    CGFloat width = [FMSize getInstance].screenWidth;
    CGFloat itemHeight = 16;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepHeight = 14;
    
    CGFloat originX = 0;
    CGFloat originY = sepHeight;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width+padding, itemHeight)];
    originY += sepHeight + itemHeight;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, width+padding, itemHeight)];
    originY += sepHeight + itemHeight;
    
    [_locationLbl setFrame:CGRectMake(originX, originY, width+padding, itemHeight)];
    originY += sepHeight + itemHeight;
}

- (void) updateInfo {
    [_codeLbl setContent:_code];
    [_nameLbl setContent:_name];
    [_locationLbl setContent:_location];
    
    [self updateViews];
}

- (void)setInfoWithCode:(NSString *)code
                   name:(NSString *)name
               location:(NSString *)location {
    _code = @"";
    _name = @"";
    _location = @"";
    
    if (![FMUtils isStringEmpty:code]) {
        _code = [code copy];
    }
    if (![FMUtils isStringEmpty:name]) {
        _name = [name copy];
    }
    if (![FMUtils isStringEmpty:location]) {
        _location = [location copy];
    }
    
    [self updateInfo];
}

+ (CGFloat)calculateHeight {
    CGFloat heigth = 0;
    CGFloat itemHeight = 16;
    CGFloat sepHeight = 14;
    
    heigth = itemHeight*3+ sepHeight*4;
    
    return heigth;
}

@end

