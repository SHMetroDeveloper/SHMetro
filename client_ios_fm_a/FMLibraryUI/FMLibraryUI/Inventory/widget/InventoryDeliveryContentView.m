//
//  InventoryDeliveryContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/19/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDeliveryContentView.h"
#import "BaseTextView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "UIButton+Bootstrap.h"
#import "BaseLabelView.h"

@interface InventoryDeliveryContentView () <OnViewResizeListener>
@property (readwrite, nonatomic, strong) UIView * titleContainerView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;    //

@property (readwrite, nonatomic, strong) UIScrollView * descContainerView;
@property (readwrite, nonatomic, strong) BaseLabelView * countLbl;      //出库总量
@property (readwrite, nonatomic, strong) BaseLabelView * warehouseLbl;  //仓库名称
@property (readwrite, nonatomic, strong) BaseLabelView * applicantLbl;  //领料人
@property (readwrite, nonatomic, strong) BaseLabelView * dateLbl;       //日期
@property (readwrite, nonatomic, strong) BaseTextView * descTV;         //备注

@property (readwrite, nonatomic, strong) UIView * controlContainerView;

@property (readwrite, nonatomic, strong) UIButton * leftDoBtn;
@property (readwrite, nonatomic, strong) UIButton * rightDoBtn;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat minDescHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, strong) NSString * count;
@property (readwrite, nonatomic, strong) NSString * warehouse;
@property (readwrite, nonatomic, strong) NSString * applicant;
@property (readwrite, nonatomic, strong) NSString * date;


@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation InventoryDeliveryContentView

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
        
        _minDescHeight = 120;
        _titleHeight = 40;
        _controlHeight = 50;
        _btnHeight = 40;
        _defaultItemHeight = 20;
        _padding = [FMSize getInstance].defaultPadding;
        
        
        _titleContainerView = [[UIView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        
        _descContainerView = [[UIScrollView alloc] init];
        _descTV = [[BaseTextView alloc] init];
        
        _countLbl = [[BaseLabelView alloc] init];
        _warehouseLbl = [[BaseLabelView alloc] init];
        _applicantLbl = [[BaseLabelView alloc] init];
        _dateLbl = [[BaseLabelView alloc] init];
        
        _controlContainerView = [[UIView alloc] init];
        _leftDoBtn = [[UIButton alloc] init];
        _rightDoBtn = [[UIButton alloc] init];
        
        _descContainerView.delaysContentTouches = NO;
        
        _titleContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _descTV.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        _descTV.backgroundColor = [UIColor whiteColor];
        [_descTV setShowBounds:YES];
        [_descTV setOnViewResizeListener:self];
        
        [_countLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_count_colon" inTable:nil] andLabelWidth:0];
        [_warehouseLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_warehouse_colon" inTable:nil] andLabelWidth:0];
        [_applicantLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_applicant_colon" inTable:nil] andLabelWidth:0];
        [_dateLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_date_colon" inTable:nil] andLabelWidth:0];
        
        _leftDoBtn.tag = INVENTORY_DELIVERY_ALERT_OPERATE_TYPE_CANCEL;
        _rightDoBtn.tag = INVENTORY_DELIVERY_ALERT_OPERATE_TYPE_OK;
        
        //        _controlContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_leftDoBtn addTarget:self action:@selector(onLeftDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightDoBtn addTarget:self action:@selector(onRightDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_rightDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_leftDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        [_rightDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_titleContainerView addSubview:_titleLbl];
        
        [_descContainerView addSubview:_countLbl];
        [_descContainerView addSubview:_warehouseLbl];
        [_descContainerView addSubview:_applicantLbl];
        [_descContainerView addSubview:_dateLbl];
        
        [_descContainerView addSubview:_descTV];
        [_controlContainerView addSubview:_leftDoBtn];
        [_controlContainerView addSubview:_rightDoBtn];
        
        [self addSubview:_titleContainerView];
        [self addSubview:_descContainerView];
        [self addSubview:_controlContainerView];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight;
    CGFloat leftBtnWidth;
    CGFloat rightBtnWidth;
    CGFloat originY = 0;
    
    if(width == 0 || height == 0) {
        return;
    }
    
    //输入框
    CGFloat marginLeft = 13;
    CGFloat marginTop = 15;
    CGFloat marginBottom = 20;
    CGFloat sepHeight = 7;
    
    
    [_titleContainerView setFrame:CGRectMake(0, originY, width, _titleHeight)];
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2, _titleHeight)];
    originY += _titleHeight;
    
    
    [_descContainerView setFrame:CGRectMake(0, originY, width, height-_controlHeight)];
    
    [_countLbl setFrame:CGRectMake(0, marginTop, width-_padding, _defaultItemHeight)];
    marginTop += _defaultItemHeight + sepHeight;
    
    [_warehouseLbl setFrame:CGRectMake(0, marginTop, width-_padding, _defaultItemHeight)];
    marginTop += _defaultItemHeight + sepHeight;
    
    [_applicantLbl setFrame:CGRectMake(0, marginTop, width-_padding, _defaultItemHeight)];
    marginTop += _defaultItemHeight + sepHeight;
    
    [_dateLbl setFrame:CGRectMake(0, marginTop, width-_padding, _defaultItemHeight)];
    marginTop += _defaultItemHeight + sepHeight*2;
    
    itemHeight = CGRectGetHeight(_descTV.frame);
    if(itemHeight < _minDescHeight) {
        itemHeight = _minDescHeight;
    }
    [_descTV setFrame:CGRectMake(marginLeft, marginTop, width-marginLeft * 2, itemHeight)];
    originY += marginTop + itemHeight + marginBottom;
    
    _descContainerView.contentSize = CGSizeMake(width, originY);
    
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];

    leftBtnWidth = (width-marginLeft * 2 - marginLeft)/2;
    rightBtnWidth = width-marginLeft * 2 - marginLeft - leftBtnWidth;

    [_leftDoBtn setFrame:CGRectMake(marginLeft, 0, leftBtnWidth, _btnHeight)];
    [_rightDoBtn setFrame:CGRectMake(marginLeft * 2 + leftBtnWidth, 0, rightBtnWidth, _btnHeight)];
    
    [_leftDoBtn grayStyle];
    [_rightDoBtn successStyle];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_countLbl setContent:_count];
    [_warehouseLbl setContent:_warehouse];
    [_applicantLbl setContent:_applicant];
    [_dateLbl setContent:_date];
}

- (void) setTitleWithText:(NSString *) title {
    [_titleLbl setText:title];
}

- (void) setEditLabelWithText:(NSString *) text {
    [_descTV setTopDesc:text];
    
}

- (void) setInfoWithAmount:(NSString *) amount warehouse:(NSString *) warehouse applicant:(NSString *) applicant date:(NSString *) date {
    _count = amount;
    _warehouse = warehouse;
    _applicant = applicant;
    _date = date;
    
    [self updateInfo];
}


- (NSString *) getDesc {
    return [_descTV getContent];
}
- (void) clearInput{
    [_descTV setContentWith:@""];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

- (void) onLeftDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_leftDoBtn];
    }
}

- (void) onRightDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_rightDoBtn];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descTV) {
        CGRect frame = _descTV.frame;
        frame.size = newSize;
        _descTV.frame = frame;
        [self updateViews];
    }
}
@end
