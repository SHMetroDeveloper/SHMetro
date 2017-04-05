//
//  MaintenanceDetailTargetItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailEquipmentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "BaseBundle.h"

@interface MaintenanceDetailEquipmentItemView ()

@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * systemlLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;

@property (readwrite, nonatomic, strong) MaintenanceDetailEquipmentModel * model;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;


@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MaintenanceDetailEquipmentItemView

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
        
        
        _codeLbl = [[BaseLabelView alloc] init];
        _nameLbl = [[BaseLabelView alloc] init];
        _systemlLbl = [[BaseLabelView alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        
        
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil] andLabelWidth:_labelWidth];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil] andLabelWidth:_labelWidth];
        [_systemlLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_system" inTable:nil] andLabelWidth:_labelWidth];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] andLabelWidth:_labelWidth];
        
        [_codeLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        [_nameLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        [_systemlLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        [_locationLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        
        [self addSubview:_codeLbl];
        [self addSubview:_nameLbl];
        [self addSubview:_systemlLbl];
        [self addSubview:_locationLbl];
    }
    
}


- (void) updateViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;;
    
    CGFloat locationHeight;
    
    locationHeight = [BaseLabelView calculateHeightByInfo:_model.location font:nil desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] labelFont:[FMFont getInstance].defaultLabelFont andLabelWidth:0 andWidth:width - _paddingLeft - _paddingRight];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    
    sepHeight = (height - defaultItemHeight * 3 - locationHeight) / 5;
    CGFloat itemHeight = 0;
    CGFloat originY = sepHeight;
    
    
    
    itemHeight = defaultItemHeight;
    [_codeLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_systemlLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = locationHeight;
    [_locationLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}



- (void) setInfoWith:(MaintenanceDetailEquipmentModel *) model{
    _model = model;
    
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateViews];
}

- (void) updateInfo {
    [_codeLbl setContent: _model.code];
    [_nameLbl setContent: _model.name];
    [_systemlLbl setContent: _model.system];
    [_locationLbl setContent:_model.location];
}

- (void) setShowBounds:(BOOL)showBounds {
    if(showBounds) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
}

+ (CGFloat) calculateHeightByModel:(MaintenanceDetailEquipmentModel *) model andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = 5;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    UILabel * locationLbl = [[UILabel alloc] init];
    locationLbl.font = [FMFont getInstance].defaultFontLevel2;
    locationLbl.numberOfLines = 0;
    
    CGFloat  locationHeight = [FMUtils heightForStringWith:locationLbl value:model.location andWidth:width-padding * 2];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    height = locationHeight + defaultItemHeight * 3 + sepHeight * 5;
    return height;
}

@end

