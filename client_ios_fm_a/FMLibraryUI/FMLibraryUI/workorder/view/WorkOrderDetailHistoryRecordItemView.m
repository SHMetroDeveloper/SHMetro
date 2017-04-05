//
//  WorkOrderDetailHistoryRecordItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/28.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailHistoryRecordItemView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderServerConfig.h"


@interface WorkOrderDetailHistoryRecordItemView ()

@property (readwrite, nonatomic, assign) NSInteger index; //记录序号
@property (readwrite, nonatomic, strong) NSNumber * time; //记录时间
@property (readwrite, nonatomic, strong) NSString * operater; //处理人
@property (readwrite, nonatomic, assign) NSInteger  step;   //步骤
@property (readwrite, nonatomic, strong) NSString *  content;   //内容



@property (readwrite, nonatomic, strong) BaseLabelView * indexLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * timeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * operaterLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * stepLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * contentLbl;

@property (readwrite, nonatomic, strong) UIFont * font;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@end

@implementation WorkOrderDetailHistoryRecordItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        _labelWidth = 80;
        _font = [FMFont fontWithSize:13];
        
        _indexLbl = [[BaseLabelView alloc] init];
        _timeLbl = [[BaseLabelView alloc] init];
        _operaterLbl = [[BaseLabelView alloc] init];
        _stepLbl = [[BaseLabelView alloc] init];
        _contentLbl = [[BaseLabelView alloc] init];
        
        
        [_indexLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_record_code" inTable:nil] andLabelWidth:_labelWidth];
        [_timeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_record_time" inTable:nil] andLabelWidth:_labelWidth];
        [_operaterLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_record_person" inTable:nil] andLabelWidth:_labelWidth];
        [_stepLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_record_step" inTable:nil] andLabelWidth:_labelWidth];
        [_contentLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_record_content" inTable:nil] andLabelWidth:_labelWidth];
        
        [_indexLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_timeLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_operaterLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_stepLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_contentLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        [self addSubview:_indexLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_operaterLbl];
        [self addSubview:_stepLbl];
        [self addSubview:_contentLbl];
        
        [self updateSubViews];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat originY = sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemHeight = 0;
    
    
    itemHeight = defaultItemHeight;
    [_indexLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_timeLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_operaterLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = defaultItemHeight;
    [_stepLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_content font:_font desc:[[BaseBundle getInstance] getStringByKey:@"order_record_content" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width-_paddingLeft-_paddingRight];
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_contentLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    
    if(originY != height) {
        CGSize newSize = CGSizeMake(width, originY);
        [self notifyViewNeedResized:newSize];
    }
    
    [self updateInfo];
}


- (void) setInfoWithIndex:(NSInteger) index
                     time:(NSNumber*) time
                 operater:(NSString*) operater
                     step:(NSInteger) step
                  content:(NSString *) content{
    
    _index = index;
    _time = time;
    if(![FMUtils isStringEmpty:operater]) {
        _operater = operater;
    } else {
        _operater = @"";
    }
    _step = step;
    if(![FMUtils isStringEmpty:content]) {
        _content = content;
    } else {
        _content = @"";
    }
    [self updateSubViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}


- (void) updateInfo {
    [_indexLbl setContent:[[NSString alloc] initWithFormat:@"%d", _index]];
    [_timeLbl setContent:[FMUtils timeLongToDateString:_time]];
    [_operaterLbl setContent:_operater];
    [_stepLbl setContent:[WorkOrderServerConfig getOrderStepDesc:_step]];
    [_contentLbl setContent:_content];
}



+ (CGFloat) calculateHeightByInfo:(NSString *) content  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight{
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat labelWidth = 80;
    CGFloat contentHeight = 0;
    UIFont * font = [FMFont fontWithSize:13];
    if(![FMUtils isStringEmpty:content]) {
        contentHeight = [BaseLabelView calculateHeightByInfo:content font:font desc:[[BaseBundle getInstance] getStringByKey:@"order_record_content" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:(width-paddingLeft-paddingRight)];
    }
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    
    
    height = defaultItemHeight * 4 + contentHeight + sepHeight * 6;
    
    
    return height;
}

@end



