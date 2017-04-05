//
//  AssetBaseServiceAreaView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/7/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AssetBaseServiceAreaView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetBaseServiceAreaView()

@property (nonatomic, strong) BaseLabelView *areaLbl;
@property (nonatomic, strong) BaseLabelView *targetLbl;

@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *target;

@property (nonatomic, assign) BOOL isInited;
@property (nonatomic, assign) BOOL isFlexible;
@end

@implementation AssetBaseServiceAreaView


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
        _isFlexible = NO;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        
        _areaLbl = [[BaseLabelView alloc] init];
        [_areaLbl setLabelFont:mFont andColor:lightColor];
        [_areaLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_service_area" inTable:nil] andLabelWidth:0];
        [_areaLbl setContentFont:mFont];
        [_areaLbl setContentColor:darkColor];
        
        
        _targetLbl = [[BaseLabelView alloc] init];
        [_targetLbl setLabelFont:mFont andColor:lightColor];
        [_targetLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_service_target" inTable:nil] andLabelWidth:0];
        [_targetLbl setContentFont:mFont];
        [_targetLbl setContentColor:darkColor];
        
        [self addSubview:_areaLbl];
        [self addSubview:_targetLbl];
    }
}

- (void) updateViews {
    if (_isFlexible) {
        _areaLbl.hidden = NO;
        _targetLbl.hidden = NO;
    } else {
        _areaLbl.hidden = YES;
        _targetLbl.hidden = YES;
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat paddingTop = 13;
    CGFloat sepHeight = 9;
    CGFloat itemHeight = 16;
    CGFloat originX = 0;
    CGFloat originY = paddingTop;
    
    UIFont *mFont = [FMFont getInstance].font38;
    
    CGFloat areaHeight = [BaseLabelView calculateHeightByInfo:_area font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_service_area" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    CGFloat targetHeight = [BaseLabelView calculateHeightByInfo:_target font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_service_target" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    areaHeight = (areaHeight>itemHeight)?areaHeight:itemHeight;
    [_areaLbl setFrame:CGRectMake(originX, originY, width-padding, areaHeight)];
    originY += areaHeight + sepHeight;
    
    targetHeight = (targetHeight>itemHeight)?targetHeight:itemHeight;
    [_targetLbl setFrame:CGRectMake(originX, originY, width-padding, targetHeight)];
    originY += targetHeight + sepHeight;
}

- (void) updateInfo {
    [_areaLbl setContent:_area];
    [_targetLbl setContent:_target];
    
    [self updateViews];
}

- (void)setServiceAreaInfoWith:(AssetEquipmentServiceZone *)entity {
    _area = @"";
    _target = @"";
    
    if (![FMUtils isStringEmpty:entity.zone]) {
        _area = [entity.zone copy];
    }
    
    if (![FMUtils isStringEmpty:entity.target]) {
        _target = [entity.target copy];
    }
}

- (void)setFlexible:(BOOL)flexible {
    _isFlexible = flexible;
    [self updateInfo];
}

+ (CGFloat)calculaterHeightBy:(AssetEquipmentServiceZone *)entity andFlexible:(BOOL)isFlexible {
    CGFloat height = 0;
    if (!isFlexible) {
        height = 0;
    } else {
        CGFloat width = [FMSize getInstance].screenWidth;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        CGFloat paddingTop = 13;
        CGFloat sepHeight = 9;
        CGFloat itemHeight = 16;
        
        UIFont *mFont = [FMFont getInstance].font38;
        
        CGFloat areaHeight = [BaseLabelView calculateHeightByInfo:entity.zone font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_service_area" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
        CGFloat targetHeight = [BaseLabelView calculateHeightByInfo:entity.target font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_service_target" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
        
        areaHeight = (areaHeight>itemHeight)?areaHeight:itemHeight;
        targetHeight = (targetHeight>itemHeight)?targetHeight:itemHeight;
        
        height = areaHeight + targetHeight + paddingTop*2 + sepHeight;
    }
    
    return height;
}

@end
