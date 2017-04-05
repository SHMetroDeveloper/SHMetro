//
//  MaintenanceDetailStepItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailStepItemView.h"

#import "BaseLabelView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"


@interface MaintenanceDetailStepItemView ()
@property (readwrite, nonatomic, strong) BaseLabelView * groupLbl;       //工作组
@property (readwrite, nonatomic, strong) BaseLabelView * contentLbl;  //维护内容
@property (readwrite, nonatomic, strong) UILabel * stepLbl;     //步骤

@property (readwrite, nonatomic, strong) MaintenanceDetailStepModel * model;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat stepWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation MaintenanceDetailStepItemView

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
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingTop = 11;
        _stepWidth = 25;
        
        _groupLbl = [[BaseLabelView alloc] init];
        _contentLbl = [[BaseLabelView alloc] init];
        _stepLbl = [[UILabel alloc] init];
        _stepLbl.textAlignment = NSTextAlignmentCenter;
        
        
        CGFloat labelWidth = 0;
        [_groupLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_work_group" inTable:nil] andLabelWidth:labelWidth];
        [_contentLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"maintenance_content_colon" inTable:nil] andLabelWidth:labelWidth];
        
        _stepLbl.backgroundColor = [UIColor colorWithRed:0x5e/255.0 green:0xba/255.0 blue:0x15/255.0 alpha:1.0f];
        _stepLbl.layer.cornerRadius = _stepWidth/2;
        _stepLbl.clipsToBounds = YES;
        _stepLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _stepLbl.font = [UIFont systemFontOfSize:11.0f];
        
        [self addSubview:_groupLbl];
        [self addSubview:_contentLbl];
        [self addSubview:_stepLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat defaultItemHeight = 30;
    CGFloat itemWidth = width - _paddingLeft - _stepWidth;
    CGFloat contentHeight = [BaseLabelView calculateHeightByInfo:_model.content font:nil desc:[[BaseBundle getInstance] getStringByKey:@"maintenance_content_colon" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:itemWidth];
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    CGFloat sepHeight = (height - contentHeight - defaultItemHeight - _paddingTop * 2);
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat originY = _paddingTop;
    CGFloat originX = _paddingLeft;
    [_stepLbl setFrame:CGRectMake(originX, padding, _stepWidth, _stepWidth)];
    originX += _stepWidth;
    
    CGFloat itemHeight = defaultItemHeight;
    [_groupLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = contentHeight;
    [_contentLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    
    [self updateInfo];
}

- (void) updateInfo {
    [_stepLbl setText:_model.step];
    [_groupLbl setContent:_model.group];
    [_contentLbl setContent:_model.content];
}

- (void) setInfoWith:(MaintenanceDetailStepModel *) model {
    _model = model;
    [self updateViews];
}

+ (CGFloat) calculateHeightByModel:(MaintenanceDetailStepModel *) model width:(CGFloat) width{
    CGFloat height = 0;
    CGFloat paddingTop = 11;
    CGFloat paddingRight = [FMSize getInstance].defaultPadding;//右边距
    CGFloat defaultItemHeight = 30;
    CGFloat sepHeight = 4;
    CGFloat stepWidth = 25;
    
    CGFloat itemWidth = width - paddingRight - stepWidth;
    CGFloat contentHeight = [BaseLabelView calculateHeightByInfo:model.content font:nil desc:[[BaseBundle getInstance] getStringByKey:@"maintenance_content_colon" inTable:nil] labelFont:nil andLabelWidth:0 andWidth:itemWidth];
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    height = contentHeight + defaultItemHeight + paddingTop * 2 + sepHeight;
    
    return height;
}

@end

