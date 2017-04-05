//
//  WorkOrderDetailMaterialItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailMaterialItemView.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"

@interface WorkOrderDetailMaterialItemView ()

@property (readwrite, nonatomic, strong) NSString * name; //名字
@property (readwrite, nonatomic, strong) NSString * unit; //单位
@property (readwrite, nonatomic, strong) NSString * model; //型号
@property (readwrite, nonatomic, assign) NSInteger count; //个数
@property (readwrite, nonatomic, assign) CGFloat cost;//费用
@property (readwrite, nonatomic, strong) NSString * brand;

@property (readwrite, nonatomic, strong) NSString * desc;//备注，高度允许自动计算

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * costLbl;

@property (readwrite, nonatomic, strong) UILabel * brandLbl;
@property (readwrite, nonatomic, strong) UILabel * modelLbl;
@property (readwrite, nonatomic, strong) UILabel * countLbl;


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat costWidth;
//@property (readwrite, nonatomic, assign) CGFloat countWidth;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

//@property (readwrite, nonatomic, assign) CGFloat btnWidth;
//@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@end

@implementation WorkOrderDetailMaterialItemView

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
        [self updateSubViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) initViews {
    if(!_isInited) {
        _labelWidth = 0;
        _editable = YES;
        
        _paddingLeft = 17;
        _paddingRight = 17;
        _costWidth = 100;
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        UIFont * labelFont = [FMFont fontWithSize:13];
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * costColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        
        _nameLbl = [[UILabel alloc] init];
        _costLbl = [[UILabel alloc] init];
        _brandLbl = [[UILabel alloc] init];
        _modelLbl = [[UILabel alloc] init];
        _countLbl = [[UILabel alloc] init];
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _costLbl.textColor = costColor;
        _brandLbl.textColor = labelColor;
        _modelLbl.textColor = labelColor;
        _countLbl.textColor = labelColor;
        
        _nameLbl.font = msgFont;
        _costLbl.font = msgFont;
        _brandLbl.font = labelFont;
        _modelLbl.font = labelFont;
        _countLbl.font = labelFont;
        
        
        [self addSubview:_nameLbl];
        //        [self addSubview:_brandLbl];
        [self addSubview:_modelLbl];
//        [self addSubview:_costLbl];
        [self addSubview:_countLbl];
    }
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = 17;
    
    sepHeight = (height - defaultItemHeight * 2) / 3;
    
    CGFloat itemHeight = 0;
    CGFloat originY = sepHeight;
    
    itemHeight = defaultItemHeight;
    
    CGFloat costWidth = [FMUtils widthForString:_costLbl value:[self getCostDesc]];
    [_costLbl setFrame:CGRectMake(width-costWidth-_paddingRight, originY, costWidth, itemHeight)];
    
    CGFloat countWidth = [FMUtils widthForString:_countLbl value:[self getCountDesc]];
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight - costWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //    itemHeight = defaultItemHeight;
    //    [_brandLbl setFrame:CGRectMake(_paddingLeft, originY, width/2 - _paddingLeft , itemHeight)];
    
    
    itemHeight = defaultItemHeight;
    [_modelLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight-countWidth, itemHeight)];
    [_countLbl setFrame:CGRectMake(width-_paddingRight-countWidth, originY, countWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (NSString *) getNameDesc {
    NSString * name = [[NSString alloc] initWithFormat:@"%@(%@)", _name, _unit];
    return name;
}

- (NSString *) getCountDesc {
    NSString * desc = [[NSString alloc] initWithFormat:@"x%ld", _count];
    return desc;
}


- (NSString *) getModelDesc {
    NSString * model = [[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_tool_model" inTable:nil], _model];
    return model;
}

- (NSString *) getCostDesc {
    NSString * cost = [[NSString alloc] initWithFormat:@"%@%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil] ,_cost];
    return cost;
}

- (NSString *) getBrandDesc {
    NSString * brand = [[NSString alloc] initWithFormat:@"%@: %@",[[BaseBundle getInstance] getStringByKey:@"order_tool_brand" inTable:nil],_brand];
    return brand;
}

- (void) setInfoWithCreateName:(NSString*) name
                         model:(NSString *) model
                         brand:(NSString *) brand
                          unit:(NSString*) unit
                         count:(NSInteger) count {
    if(name) {
        _name = name;
    } else {
        _name = @"";
    }
    if (brand) {
        _brand = brand;
    } else {
        _brand = @"";
    }
    if(model) {
        _model = model;
    } else {
        _model = @"";
    }
    if(unit) {
        _unit = unit;
    } else {
        _unit = @"";
    }
    if(count > 0) {
        _count = count;
    } else {
        _count = 0;
    }
    [self updateSubViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}

- (void) updateInfo {
    [_nameLbl setText: [self getNameDesc]];
    [_modelLbl setText:[self getModelDesc]];
    [_costLbl setText: [self getCostDesc]];
    [_brandLbl setText:[self getBrandDesc]];
    [_countLbl setText:[self getCountDesc]];
}

- (void) setShowBounds:(BOOL)showBounds {
    if(showBounds) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
    [self updateSubViews];
}
@end




