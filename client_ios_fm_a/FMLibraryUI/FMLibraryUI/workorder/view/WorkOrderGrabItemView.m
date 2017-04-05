//
//  WorkOrderGrabItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/3.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "WorkOrderGrabItemView.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ResizeableLabelView.h"
#import "WorkOrderServerConfig.h"
#import "UIButton+Bootstrap.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "FMTheme.h"


@interface WorkOrderGrabItemView ()

@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;
@property (readwrite, nonatomic, strong) ColorLabel * priorityLbl;
@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) UIImageView * grabImgView;

@property (readwrite, nonatomic, strong) UIButton * doBtn;

@property (readwrite, nonatomic, strong) WorkOrderGrab * order;

@property (readwrite, nonatomic, assign) BOOL showBtn;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;

@property (readwrite, nonatomic, assign) CGFloat minLocationHeight;

@property (readwrite, nonatomic, strong) UIFont * font;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> itemListener;
@end

@implementation WorkOrderGrabItemView

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

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        _minLocationHeight = 24;
        _btnWidth = [FMSize getInstance].btnWidth;
        _btnHeight = [FMSize getInstance].listItemBtnHeight;
        _labelWidth = 0;
        _imgWidth = [FMSize getInstance].imgWidthLevel1;
        _font = [FMFont fontWithSize:13];
        
        _showBtn = YES;
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        
        _codeLbl = [[UILabel alloc] init];
        _timeLbl = [[UILabel alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _priorityLbl = [[ColorLabel alloc] init];
        _statusLbl = [[ColorLabel alloc] init];
        _doBtn = [[UIButton alloc] init];
        _grabImgView = [[UIImageView alloc] init];
        
        
        [_grabImgView setImage:[[FMTheme getInstance] getImageByName:@"grab"]];
        
        [_codeLbl setFont:msgFont];
        [_timeLbl setFont:msgFont];
        
        
        [_priorityLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
//        [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        _doBtn.tag = WORK_ORDER_ITEM_OPERATE_TYPE_GRAB;
        [_doBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_grab" inTable:nil] forState:UIControlStateNormal];
        [_doBtn.titleLabel setFont:msgFont];
        [_doBtn addTarget:self action:@selector(onDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_location" inTable:nil] andLabelWidth:_labelWidth];
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"label_desc" inTable:nil] andLabelWidth:_labelWidth];
        
        
        [self addSubview:_codeLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_descLbl];
        [self addSubview:_priorityLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_grabImgView];
        [self addSubview:_doBtn];
        
        [self updateViews];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    if(width ==0 || height ==0) {
        return;
    }
    CGFloat btnWidth = 0;
    CGFloat timeWidth = 80;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat sepWidth = 10;
    CGFloat originX = [FMSize getInstance].listItemPaddingLeft;
    CGFloat originY = sepHeight;
    
    CGFloat itemHeight;
    
    
    if(_showBtn) {
        btnWidth = _btnWidth;
    }
    
    [_grabImgView setFrame:CGRectMake(width-_imgWidth, 0, _imgWidth, _imgWidth)];
    
    itemHeight = defaultItemHeight;
    [_codeLbl setFrame:CGRectMake(originX, originY, width - originX*2 -timeWidth, itemHeight)];
    CGFloat codeWidth = [FMUtils widthForString:_codeLbl value:_order.woCode];
    [_codeLbl setFrame:CGRectMake(originX, originY, codeWidth, itemHeight)];
    originX += codeWidth + sepWidth;
    
    CGSize prioritySize = CGSizeMake(0, 0);
    NSString * priority = [_order getPriorityName];
    if(![FMUtils isStringEmpty:priority]) {
        [_priorityLbl setHidden:NO];
        prioritySize = [ColorLabel calculateSizeByInfo:priority];
        [_priorityLbl setFrame:CGRectMake(originX, originY + (defaultItemHeight - prioritySize.height)/2,
                                          prioritySize.width, prioritySize.height)];
        originX += prioritySize.width + sepWidth;
    } else {
        [_priorityLbl setHidden:YES];
    }
    
    NSString * status = [self getStatus];
    CGSize statusSize = [ColorLabel calculateSizeByInfo:status];
    [_statusLbl setFrame:CGRectMake(originX, originY + (defaultItemHeight - statusSize.height) / 2,
                                    statusSize.width, statusSize.height)];
    originX += statusSize.width + sepWidth;
    
    [_timeLbl setFrame:CGRectMake(width-timeWidth-sepWidth, originY, timeWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    originX = sepWidth;
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_order.woDescription font:_font desc:[[BaseBundle getInstance] getStringByKey:@"label_desc" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width - originX];
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_descLbl setFrame:CGRectMake(0, originY, width - originX, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_order.location font:_font desc:[[BaseBundle getInstance] getStringByKey:@"order_location" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width - originX-btnWidth];
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_locationLbl setFrame:CGRectMake(0, originY, width - originX -btnWidth, itemHeight)];
    if(_showBtn) {
        [_doBtn setFrame:CGRectMake(width-originX-btnWidth, originY + (itemHeight - _btnHeight)/2, btnWidth, _btnHeight)];
    }
    originY += itemHeight + sepHeight;
    
    [_doBtn defaultStyle];
    _doBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
    [_doBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
    [_doBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateHighlighted];
    
    [self updateStatus];
    [self updateInfo];
}

- (void) updateInfo {
    if(_order.woCode) {
        [_codeLbl setText:_order.woCode];
    }
    [_timeLbl setText: [_order getCreateDateStr]];
    if(_order.location) {
        [_locationLbl setContent: _order.location];
    }
    if(_order.woDescription) {
        [_descLbl setContent:_order.woDescription];
    }
    [_priorityLbl setContent:[_order getPriorityName]];
}

- (NSString *) getStatus {
    NSString * strStatus = @"";
    if(_order.grabType == WORK_ORDER_GRAB_TYPE_GRAB) {   //如果处于抢单期
        switch(_order.grabStatus) {
            case WORK_ORDER_GRAB_LABORER_STATUS_UNKNOW:
            case WORK_ORDER_GRAB_LABORER_STATUS_UNTOOK:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_untook" inTable:nil];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_WAITING:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_approve" inTable:nil];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_SUCCESS:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_success" inTable:nil];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_FAIL:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_fail" inTable:nil];
                break;
        }
    } else {
        strStatus = [WorkOrderServerConfig getOrderStatusDesc:_order.status];
    }
    return strStatus;
}

- (void) updateStatus {
    NSString * strStatus = @"";
    if([_order isGrabAble]) {
        [_doBtn setHidden:NO];
    } else {
        [_doBtn setHidden:YES];
    }
    if(_order.grabType == WORK_ORDER_GRAB_TYPE_GRAB) {   //如果处于抢单期
        switch(_order.grabStatus) {
            case WORK_ORDER_GRAB_LABORER_STATUS_UNKNOW:
            case WORK_ORDER_GRAB_LABORER_STATUS_UNTOOK:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_untook" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_WAITING:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_approve" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_SUCCESS:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_success" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
                break;
            case WORK_ORDER_GRAB_LABORER_STATUS_FAIL:
                strStatus = [[BaseBundle getInstance] getStringByKey:@"order_grab_status_fail" inTable:nil];
                [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
                break;
        }
    } else {
        strStatus = [WorkOrderServerConfig getOrderStatusDesc:_order.status];
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[UIColor clearColor] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
    }
    [_statusLbl setContent:strStatus];
}


- (void) setInfoWithOrder:(WorkOrderGrab*) order {
    _order = order;
    [self updateViews];
}

- (void) setShowGrabButton:(BOOL) show {
    if(show) {
        [_doBtn setHidden:NO];
    } else {
        [_doBtn setHidden:YES];
    }
}


- (void) onDoButtonClicked {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:_doBtn];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _itemListener = listener;
    
}

+ (CGFloat) calculateHeightByDesc:(NSString *) desc location:(NSString *) location andWidth:(CGFloat) width {
    CGFloat height = 0;
    
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat paddingRight = [FMSize getInstance].listItemPaddingRight;;
    
    CGFloat btnWidth = 70;
    CGFloat labelWidth = 40;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    UIFont * font = [FMFont fontWithSize:13];
    CGFloat descHeight = [BaseLabelView calculateHeightByInfo:desc font:font desc:[[BaseBundle getInstance] getStringByKey:@"label_desc" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:width-paddingRight];
    if(descHeight < defaultItemHeight) {
        descHeight = defaultItemHeight;
    }
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:location font:font desc:[[BaseBundle getInstance] getStringByKey:@"order_location" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:width-paddingRight-btnWidth];
    if(locationHeight < defaultItemHeight) {
        locationHeight = defaultItemHeight;
    }
    height = descHeight + locationHeight + defaultItemHeight + sepHeight * 4;
    return height;
}

@end

