//
//  MaintenanceDetailToolItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailToolItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"

@interface MaintenanceDetailToolItemView ()

@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * brandLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * modelLbl;
//@property (readwrite, nonatomic, strong) BaseLabelView * unitLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * countLbl;

@property (readwrite, nonatomic, strong) MaintenanceDetailToolModel * model;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat unitWidth;
@property (readwrite, nonatomic, assign) CGFloat countWidth;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@end

@implementation MaintenanceDetailToolItemView

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
    _countWidth = 140;
    _labelWidth = 50;
    _btnWidth = 70;
    _btnHeight = [FMSize getInstance].listItemBtnHeight;
    
    
    _nameLbl = [[BaseLabelView alloc] init];
    _brandLbl = [[BaseLabelView alloc] init];
    _modelLbl = [[BaseLabelView alloc] init];
//    _unitLbl = [[BaseLabelView alloc] init];
    _countLbl = [[BaseLabelView alloc] init];
    
    
    [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_tool_name" inTable:nil] andLabelWidth:_labelWidth];
    [_brandLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_tool_brand" inTable:nil] andLabelWidth:_labelWidth];
    [_modelLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_tool_model" inTable:nil] andLabelWidth:_labelWidth];
//    [_unitLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_tool_unit" inTable:nil] andLabelWidth:_labelWidth];
    [_countLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_tool_amount" inTable:nil] andLabelWidth:_labelWidth];
    
    [_nameLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
    [_brandLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
    [_modelLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
//    [_unitLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[FMColor getInstance].defaultLabel];
    [_countLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
    
    
    [self addSubview:_nameLbl];
    [self addSubview:_brandLbl];
    [self addSubview:_modelLbl];
//    [self addSubview:_unitLbl];
    [self addSubview:_countLbl];
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
    
    CGFloat msgHeight = defaultItemHeight;
    sepHeight = (height - msgHeight * 4) / 5;
    CGFloat itemHeight = 0;
    CGFloat originY = sepHeight;
    CGFloat btnWidth = 0;
    
    
    itemHeight = defaultItemHeight;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_brandLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_modelLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_countLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
//    
//    [_unitLbl setFrame:CGRectMake(width-_paddingRight-_countWidth, originY, _countWidth, itemHeight)];
//    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}



- (void) setInfoWith:(MaintenanceDetailToolModel *) model{
    _model = model;
    
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateViews];
}

- (void) updateInfo {
    [_nameLbl setContent: _model.name];
//    [_brandLbl setContent: _model.brand];
    [_modelLbl setContent: _model.model];
    //    [_unitLbl setContent: _unit];
    [_countLbl setContent:_model.amountDesc];
    
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

@end




