//
//  WorkOrderDetailLaborerView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailLaborerItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ColorLabel.h"
#import "WorkOrderServerConfig.h"


NSString const * STATUS_PERSONAL_UN_ACCEPT_STR = @"未接单";
NSString const * STATUS_PERSONAL_ACCEPT_STR = @"已接单";
NSString const * STATUS_PERSONAL_BACK_STR = @"已退单";
NSString const * STATUS_PERSONAL_SUBMIT_STR = @"已提交";

@interface WorkOrderDetailLaborerItemView ()

@property (readwrite, nonatomic, strong) NSString * name;    //执行人名字
@property (readwrite, nonatomic, strong) NSString * position;    //岗位
@property (readwrite, nonatomic, strong) NSString * telno;    //联系方式
@property (readwrite, nonatomic, strong) NSString * arriveTime;    //到场时间
@property (readwrite, nonatomic, strong) NSString * finishTime;    //完成时间
@property (readwrite, nonatomic, assign) NSInteger status;    //执行人状态



@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIImageView * telnoImgView;
@property (readwrite, nonatomic, strong) UILabel * responsibleLbl;   //负责人
@property (readwrite, nonatomic, strong) UILabel * statusLbl;        //状态，是否已接单
@property (readwrite, nonatomic, strong) UIImageView * clockImgView;    //
@property (readwrite, nonatomic, strong) BaseLabelView * timeLbl; //工作时间
@property (readwrite, nonatomic, strong) UIImageView * moreImgView; //


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat nameWidth;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat phoneWidth;

@property (readwrite, nonatomic, assign) BOOL showBounds;   //是否显示边框
@property (readwrite, nonatomic, assign) BOOL isResponsible;//是否为负责人
@property (readwrite, nonatomic, assign) BOOL editable;     //是否可编辑

@property (readwrite, nonatomic, assign) BOOL isInited;



@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;
@end

@implementation WorkOrderDetailLaborerItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        CGFloat labelWidth = 0;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _imgWidth = 16;
        _phoneWidth = 24;   //电话号码图标宽度
        _nameWidth = 120;
        
        _nameLbl = [[UILabel alloc] init];
        _telnoImgView = [[UIImageView alloc] init];
        _timeLbl = [[BaseLabelView alloc] init];
        _statusLbl = [[UILabel alloc] init];
        _responsibleLbl = [[UILabel alloc] init];
        
        _clockImgView = [[UIImageView alloc] init];
        _moreImgView = [[UIImageView alloc] init];
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _nameLbl.font = [FMFont fontWithSize:13];
        [_timeLbl setLabelFont:[FMFont fontWithSize:13] andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]];
        
        _statusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _statusLbl.font = [FMFont getInstance].defaultFontLevel3;
        
        _responsibleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _responsibleLbl.font = [FMFont getInstance].defaultFontLevel3;
        [_responsibleLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_laborer_responsible" inTable:nil]];
        [_responsibleLbl setHidden:YES];
        
        [_moreImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        [_clockImgView setImage:[[FMTheme getInstance] getImageByName:@"clock"]];
        [_telnoImgView setImage:[[FMTheme getInstance] getImageByName:@"home_my_phone"]];
        
        [_timeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_laborer_time" inTable:nil] andLabelWidth:labelWidth];
        
        [self addSubview:_nameLbl];
        [self addSubview:_telnoImgView];
        [self addSubview:_responsibleLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_clockImgView];
        [self addSubview:_timeLbl];
        [self addSubview:_moreImgView];
        
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
    CGFloat imgWidth = _imgWidth;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = (height - itemHeight * 2) /3;
    CGFloat originY = sepHeight;
    
    CGFloat originX = 0;
    
    NSString * strStatus = [WorkOrderServerConfig getOrderLaborerStatusDesc:_status];
    CGFloat responsibleWidth = [FMUtils widthForString:_responsibleLbl value:[[BaseBundle getInstance] getStringByKey:@"order_laborer_responsible" inTable:nil]];
    CGFloat statusWidth = [FMUtils widthForString:_statusLbl value:strStatus];
    CGSize nameSize = [FMUtils getLabelSizeBy:_nameLbl andContent:_name andMaxLabelWidth:width];
    
    
    originX = _paddingLeft;
    [_nameLbl setFrame:CGRectMake(originX, originY, nameSize.width, itemHeight)];
    originX += nameSize.width + [FMSize getSizeByPixel:150];
    
    if(![FMUtils isStringEmpty:_telno]) {
        [_telnoImgView setHidden:NO];
        [_telnoImgView setFrame:CGRectMake(originX, originY + (itemHeight - _phoneWidth) / 2, _phoneWidth, _phoneWidth)];
    } else {
        [_telnoImgView setHidden:YES];
    }
    originX += imgWidth + [FMSize getSizeByPixel:150];
    
    if(_isResponsible) {
        [_responsibleLbl setHidden:NO];
        [_responsibleLbl setFrame:CGRectMake(originX, originY, responsibleWidth, itemHeight)];
    } else {
        [_responsibleLbl setHidden:YES];
    }
    
    if(![FMUtils isStringEmpty:strStatus]) {
        [_statusLbl setHidden:NO];
        [_statusLbl setFrame:CGRectMake(width-_paddingRight-statusWidth, originY, statusWidth, itemHeight)];
    } else {
        [_statusLbl setHidden:YES];
    }
    
    originY += itemHeight + sepHeight;
    [_clockImgView setFrame:CGRectMake(_paddingLeft, originY+(itemHeight - imgWidth)/2, imgWidth, imgWidth)];
    
    [_timeLbl setFrame:CGRectMake(_paddingLeft/3+imgWidth, originY, width-_paddingLeft/3-_paddingRight-imgWidth * 2, itemHeight)];
    
    if(_editable) {
        [_moreImgView setHidden:NO];
        [_moreImgView setFrame:CGRectMake(width-_paddingRight-imgWidth, originY+(itemHeight - imgWidth)/2, imgWidth, imgWidth)];
    } else {
        [_moreImgView setHidden:YES];
    }
    
    [self updateInfo];
}

- (void) setInfoWithName:(NSString *) name
                position:(NSString *) position
                   telno:(NSString *) telno
              arriveTime:(NSString *) arriveTime
              finishTime:(NSString *) finishTime
                  status:(NSInteger) status
             responsible:(BOOL) isResponsible{
    
    _name = name;
    _position = position;
    _telno = telno;
    _arriveTime = arriveTime;
    _finishTime = finishTime;
    _status = status;
    _isResponsible = isResponsible;
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateViews];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    
    NSString * strStatus = [WorkOrderServerConfig getOrderLaborerStatusDesc:_status];
    switch(_status) {
        case ORDER_STATUS_PERSONAL_UN_ACCEPT:
            [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_UNACCEPT]];
            break;
        case ORDER_STATUS_PERSONAL_ACCEPT:
            [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_ACCEPT]];
            break;
        case ORDER_STATUS_PERSONAL_BACK:
            [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_BACK]];
            break;
        case ORDER_STATUS_PERSONAL_SUBMIT:
            [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_SUBMIT]];
            break;
    }
    [_statusLbl setText:strStatus];
    [_timeLbl setContent:[self getTimeDescription]];
}

- (NSString *) getTimeDescription {
    NSString * res = @"";
    BOOL isArrivalNull = [FMUtils isStringEmpty:_arriveTime];
    BOOL isFinishNull = [FMUtils isStringEmpty:_finishTime];
    if(!isArrivalNull && !isFinishNull) {
        res = [[NSString alloc] initWithFormat:@"%@ ~ %@", _arriveTime, _finishTime];
    } else if(!isArrivalNull) {
        res = [[NSString alloc] initWithFormat:@"%@ ~", _arriveTime];
    } else if(!isFinishNull) {
        res = [[NSString alloc] initWithFormat:@"~ %@", _finishTime];
    }
    return res;
}

- (void) setShowBounds:(BOOL) show {
    _showBounds = show;
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
}

- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateViews];
}

#pragma - onclick 事件
- (void) actiondo:(UIView *) v {
    [self notifyViewClicked];
    
}

- (void) notifyViewClicked {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}


- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}
@end



