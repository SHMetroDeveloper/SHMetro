//
//  WorkJobHistoryItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkJobHistoryItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "WorkOrderServerConfig.h"


@interface WorkJobHistoryItemView ()

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * pfmCodeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) WorkOrderHistory * order;

//@property (readwrite, nonatomic, strong) UIImageView * grabImgView;
//@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@end

@implementation WorkJobHistoryItemView

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
    
        //工单号
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = [FMFont getInstance].listCodeFont;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _pfmCodeLbl = [[UILabel alloc] init];
        _pfmCodeLbl.font = [FMFont getInstance].listDescFont;
        _pfmCodeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //时间lbl
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = [FMFont getInstance].ListTimeFont;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        //优先级
        _priorityLbl = [[UILabel alloc] init];
        _priorityLbl.font = [FMFont getInstance].listPriorityFont;
        _priorityLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //描述信息
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = [FMFont getInstance].listDescFont;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //工单状态
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        //角标 “抢”
//        _grabImgView = [[UIImageView alloc] init];
//        _imgWidth = [FMSize getInstance].imgWidthLevel1;
//        [_grabImgView setImage:[[FMTheme getInstance] getImageByName:@"grab"]];
        
        [self addSubview:_codeLbl];
        [self addSubview:_pfmCodeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_descLbl];
        [self addSubview:_priorityLbl];
        [self addSubview:_statusLbl];
//        [self addSubview:_grabImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
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
    originX += codeSize.width + (width-codeSize.width-statusSize.width-prioritySize.width-padding*2)/2;
    [_priorityLbl setFrame:CGRectMake(originX, originY+(codeSize.height - prioritySize.height)/2, prioritySize.width, prioritySize.height)];
    [_statusLbl setFrame:CGRectMake(width-statusSize.width-padding, originY+(codeSize.height-statusSize.height)/2, statusSize.width, statusSize.height)];
    originX = padding;
    originY += sepHeight + codeSize.height;
    
    if(![FMUtils isStringEmpty:_order.pfmCode]) {
        [_pfmCodeLbl setHidden:NO];
        [_pfmCodeLbl setFrame:CGRectMake(originX, originY, width-originX*2, defaultItemHeight)];
        originY += sepHeight + defaultItemHeight;
    } else {
        [_pfmCodeLbl setHidden:YES];
    }
    
    
    [_timeLbl setFrame:CGRectMake(originX, originY, width-originX*2, defaultItemHeight)];
    originY += sepHeight + defaultItemHeight;
    
    [_descLbl setFrame:CGRectMake(originX, originY, width-originX*2, descSize.height)];
    originY += sepHeight + descSize.height;
    
    [self updateInfo];
}

- (void) setInfoWithOrder:(WorkOrderHistory*) order {
    _order = order;
    
    [self updateViews];
}

- (void) updateInfo {
    [_codeLbl setText:_order.code];
    [_pfmCodeLbl setText:_order.pfmCode];
    [_timeLbl setText: [_order getCreateTimeStr]];
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

+ (CGFloat) calculateHeightByDescription:(NSString *) desc pfmCode:(NSString *) pfmCode andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat codeHeight = 19;
    CGFloat defaultItemHeight = 16;
    CGFloat sepHeight = 14;
    CGFloat descHeight = 17;
    
    height = sepHeight*3 + codeHeight + defaultItemHeight ;
    if(![FMUtils isStringEmpty:desc]) {
        height += descHeight + sepHeight;
    }
    if(![FMUtils isStringEmpty:pfmCode]) {
        height += defaultItemHeight + sepHeight;
    }
    return height;
}

@end

