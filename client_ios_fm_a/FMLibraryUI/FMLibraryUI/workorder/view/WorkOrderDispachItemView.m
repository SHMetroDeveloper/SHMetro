//
//  WorkOrderDispachItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  派工列表项 View

#import "WorkOrderDispachItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "WorkOrderDispachEntity.h"
#import "UIButton+Bootstrap.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "WorkOrderServerConfig.h"

@interface WorkOrderDispachItemView ()

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * pfmCodeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;    //状态

//@property (readwrite, nonatomic, strong) ColorLabel * priorityLbl;  //优先级
//@property (readwrite, nonatomic, strong) BaseLabelView * serviceTypeLbl;
//@property (readwrite, nonatomic, strong) BaseLabelView * contentLbl;
//@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;
//@property (readwrite, nonatomic, strong) UILabel * timeLbl;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;   //标签宽度
//@property (readwrite, nonatomic, strong) UIImageView * grabImgView;
//@property (readwrite, nonatomic, assign) CGFloat imgWidth;   //图片 宽度

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) WorkOrderDispach * order;     //工单实体

@property (readwrite, nonatomic, strong) id<OnItemClickListener> listener;

@end

@implementation WorkOrderDispachItemView

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

        //工单号
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = [FMFont getInstance].listCodeFont;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //pfm编码
        _pfmCodeLbl = [[UILabel alloc] init];
        _pfmCodeLbl.font = [FMFont getInstance].listDescFont;
        _pfmCodeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //优先级
        _priorityLbl = [[UILabel alloc] init];
        _priorityLbl.font = [FMFont getInstance].listPriorityFont;
        _priorityLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //时间lbl
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [FMFont getInstance].ListTimeFont;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        //描述信息
        _descLbl = [[UILabel alloc] init];
        _descLbl.numberOfLines = 2;
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.font = [FMFont getInstance].listDescFont;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //状态
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        //角标 “抢”
//        _imgWidth = [FMSize getInstance].imgWidthLevel1;
//        _grabImgView = [[UIImageView alloc] init];
//        [_grabImgView setImage:[[FMTheme getInstance] getImageByName:@"grab"]];

        [self addSubview:_codeLbl];
        [self addSubview:_pfmCodeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_descLbl];
        [self addSubview:_priorityLbl];
        [self addSubview:_statusLbl];
//        [self addSubview:_grabImgView];
        
        [self updateViews];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width == 0 || height == 0) {
        return;
    }
    
    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[self getStatusColor:_order.status] andBackgroundColor:[self getStatusColor:_order.status]];
    
    CGFloat sepHeight = 14;
    CGFloat padding = [FMSize getInstance].listePadding;
    CGFloat defaultItemHeight = 16;
    
    CGSize codeSize = [FMUtils getLabelSizeBy:_codeLbl andContent:_order.code andMaxLabelWidth:width-padding*2];
    CGSize descSize = [FMUtils getLabelSizeBy:_descLbl andContent:_order.woDescription andMaxLabelWidth:width-padding*2];
    CGSize prioritySize = [FMUtils getLabelSizeBy:_priorityLbl andContent:[_order getPriorityName] andMaxLabelWidth:width-padding*2];
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[WorkOrderServerConfig getOrderStatusDesc:_order.status]];
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, codeSize.width, codeSize.height)];
    originX += codeSize.width + (width - padding*2 - codeSize.width - statusSize.width - prioritySize.width)/2;
    [_priorityLbl setFrame:CGRectMake(originX, originY+(codeSize.height-prioritySize.height)/2, prioritySize.width, prioritySize.height)];
    [_statusLbl setFrame:CGRectMake(width - padding - statusSize.width, originY+(codeSize.height - statusSize.height)/2, statusSize.width, statusSize.height)];
    originY += codeSize.height + sepHeight;
    originX = padding;
    
    if(![FMUtils isStringEmpty:_order.pfmCode]) {
        [_pfmCodeLbl setHidden:NO];
        [_pfmCodeLbl setFrame:CGRectMake(originX, originY, width-padding*2, defaultItemHeight)];
        originY += defaultItemHeight + sepHeight;
    } else {
        [_pfmCodeLbl setHidden:YES];
    }
    
        
    [_timeLbl setFrame:CGRectMake(originX, originY, width-padding*2, defaultItemHeight)];
    originY += defaultItemHeight + sepHeight;
    
    [_descLbl setFrame:CGRectMake(originX, originY, width-padding*2, descSize.height)];
    originY += descSize.height + sepHeight;
    
    [self updateInfo];
}

- (void) setInfoWithWorkJobDetail:(WorkOrderDispach *) jobDetail {
    _order = [jobDetail copy];
    [self updateViews];
}

- (void) updateInfo {
    [_codeLbl setText:_order.code];
    [_pfmCodeLbl setText:_order.pfmCode];
    [_timeLbl setText:[_order getCreateDateStr]];
    [_descLbl setText:_order.woDescription];
    [_priorityLbl setText:[_order getPriorityName]];
    [_statusLbl setContent:[_order getStatusStr]];
//    if(_order.grabType == WORK_ORDER_GRAB_TYPE_GRAB) {
//        [_grabImgView setHidden:NO];
//    } else {
//        [_grabImgView setHidden:YES];
//    }
}

- (UIColor *) getStatusColor:(NSInteger) status {
    WorkOrderStatus orderStatus = (WorkOrderStatus)status;
    UIColor * color = [WorkOrderServerConfig getOrderStatusColor:orderStatus];
    return color;
}

+ (CGFloat) calculateHeightByContent:(NSString *) content andLocation:(NSString *) location pfmCode:(NSString *) pfmCode  andWidth:(CGFloat) width{
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat defaultItemHeight = 16;
    CGFloat sepHeight = 14;
    
    UILabel * testLbl = [UILabel new];
    testLbl.numberOfLines = 2;
    testLbl.font = [FMFont setFontByPX:44];
    CGSize descSize = [FMUtils getLabelSizeBy:testLbl andContent:content andMaxLabelWidth:width-20];
    testLbl = nil;
    
    height = [FMUtils isStringEmpty:content]? (sepHeight*3 + codeHeight + defaultItemHeight):(sepHeight*4 + codeHeight + defaultItemHeight + descSize.height);
    if(![FMUtils isStringEmpty:pfmCode]) {
        height += defaultItemHeight + sepHeight;
    }
    return height;
}

@end

