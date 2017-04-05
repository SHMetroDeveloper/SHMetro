//
//  RequirementBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "RequirementBaseInfoView.h"
#import "SeperatorView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseTextView.h"

@interface RequirementBaseInfoView ()

@property (readwrite, nonatomic, strong) BaseTextView * demanderTextView;  //需求人
@property (readwrite, nonatomic, strong) BaseTextView * phoneTextView;  //电话
@property (readwrite, nonatomic, strong) BaseTextView * demandTypeTextView;  //需求类型
@property (readwrite, nonatomic, strong) BaseTextView * descTextView;  //描述

@property (readwrite, nonatomic, strong) UILabel * demanderLbl;  //左标签
@property (readwrite, nonatomic, strong) UILabel * phoneLbl;  //左标签
@property (readwrite, nonatomic, strong) UILabel * demandTypeLbl;  //左标签
@property (readwrite, nonatomic, strong) UILabel * descLbl;  //左标签

@property (readwrite, nonatomic, strong) UILabel * markLbl1;   //星号标记
@property (readwrite, nonatomic, strong) UILabel * markLbl2;   //星号标记
@property (readwrite, nonatomic, strong) UILabel * markLbl3;   //星号标记
@property (readwrite, nonatomic, strong) UILabel * markLbl4;   //星号标记

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * phone;
@property (readwrite, nonatomic, strong) NSString * demandType;
@property (readwrite, nonatomic, strong) NSString * descDetail; //需求描述

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultSeperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat minContentHeight; //basetextview最低标准


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL showBound;
@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@end

@implementation RequirementBaseInfoView
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
    if (!_isInited) {
        _isInited = YES;
        
        _defaultItemHeight = 40;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _labelWidth = 80;
        _minContentHeight = 150;
        
        
        //申请人
        _demanderTextView = [[BaseTextView alloc] init];
        _demanderLbl = [[UILabel alloc] init];
        _markLbl1 = [[UILabel alloc] init];
        _markLbl1.text = @"*";
        _markLbl1.textAlignment = NSTextAlignmentCenter;
        _markLbl1.textColor = [UIColor redColor];
        _demanderLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_req_person" inTable:nil];;
        _demanderLbl.textAlignment = NSTextAlignmentLeft;
        _demanderLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _demanderLbl.font = [FMFont getInstance].defaultFontLevel2;
        [_demanderTextView setEditAble:NO];
        [_demanderTextView setShowBounds:YES];
        [_demanderTextView setShowCorner:YES];
        [_demanderTextView setMinHeight:_defaultItemHeight];
        [_demanderTextView setOnClickedListener:self];
        
        
        //联系电话
        _phoneTextView = [[BaseTextView alloc] init];
        _phoneLbl = [[UILabel alloc] init];
        _markLbl2 = [[UILabel alloc] init];
        _markLbl2.text = @"*";
        _markLbl2.textAlignment = NSTextAlignmentCenter;
        _markLbl2.textColor = [UIColor redColor];
        _phoneLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_req_phone" inTable:nil];;
        _phoneLbl.textAlignment = NSTextAlignmentLeft;
        _phoneLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _phoneLbl.font = [FMFont getInstance].defaultFontLevel2;
        [_phoneTextView setEditAble:YES];
        [_phoneTextView setShowBounds:YES];
        [_phoneTextView setShowCorner:YES];
        [_phoneTextView setMinHeight:_defaultItemHeight];
        [_phoneTextView setOnClickedListener:self];
        
        
        
        //需求类型
        _demandTypeTextView = [[BaseTextView alloc] init];
        _demandTypeLbl = [[UILabel alloc] init];
        _markLbl3 = [[UILabel alloc] init];
        _markLbl3.text = @"*";
        _markLbl3.textAlignment = NSTextAlignmentCenter;
        _markLbl3.textColor = [UIColor redColor];
        _demandTypeLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_req_type" inTable:nil];;
        _demandTypeLbl.textAlignment = NSTextAlignmentLeft;
        _demandTypeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _demandTypeLbl.font = [FMFont getInstance].defaultFontLevel2;
        _demandTypeTextView.tag = REQUIREMENT_BASE_INFO_ITEM_DEMAND_TYPE;
        [_demandTypeTextView setEditAble:NO];
        [_demandTypeTextView setShowBounds:YES];
        [_demandTypeTextView setShowCorner:YES];
        [_demandTypeTextView setMinHeight:_defaultItemHeight];
        [_demandTypeTextView setOnClickedListener:self];
        
        //需求描述
        _descTextView = [[BaseTextView alloc] init];
        _descLbl = [[UILabel alloc] init];
        _markLbl4 = [[UILabel alloc] init];
        _markLbl4.text = @"*";
        _markLbl4.textAlignment = NSTextAlignmentCenter;
        _markLbl4.textColor = [UIColor redColor];
        _descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"requirement_req_desc" inTable:nil];;
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.font = [FMFont getInstance].defaultFontLevel2;
        [_descTextView setBackgroundColor:[UIColor whiteColor]];
        [_descTextView becomeFirstResponder];
        [_descTextView setOnViewResizeListener:self];
        [_descTextView setShowBounds:YES];
        [_descTextView setShowCorner:YES];
        [_descTextView setMinHeight:_minContentHeight];
        
        [self addSubview:_demanderTextView];
        [self addSubview:_demanderLbl];
        [self addSubview:_markLbl1];
        
        [self addSubview:_phoneTextView];
        [self addSubview:_phoneLbl];
        [self addSubview:_markLbl2];
        
        [self addSubview:_demandTypeTextView];
        [self addSubview:_demandTypeLbl];
        [self addSubview:_markLbl3];
        
        [self addSubview:_descTextView];
        [self addSubview:_descLbl];
        [self addSubview:_markLbl4];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight = 0;
    CGFloat sepHeight = 8;
    CGFloat markWidth = 14;
    CGFloat originY = 20;
    
    if (width == 0 || height == 0) {
        return;
    }
    
    //申请人
    itemHeight = _defaultItemHeight;
    [_demanderLbl setFrame:CGRectMake(_paddingLeft, originY, _labelWidth, itemHeight)];
    [_markLbl1 setFrame:CGRectMake(_paddingLeft + _labelWidth + sepHeight, originY, markWidth, itemHeight)];
    [_demanderTextView setFrame:CGRectMake(_paddingLeft + sepHeight*2 + _labelWidth + markWidth, originY, width-_paddingLeft*2-_labelWidth-sepHeight*2-markWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //联系电话
    itemHeight = _defaultItemHeight;
    [_phoneLbl setFrame:CGRectMake(_paddingLeft, originY, _labelWidth, itemHeight)];
    [_markLbl2 setFrame:CGRectMake(_paddingLeft + _labelWidth + sepHeight, originY, markWidth, itemHeight)];
    [_phoneTextView setFrame:CGRectMake(_paddingLeft + sepHeight*2 + _labelWidth + markWidth, originY, width-_paddingLeft*2-_labelWidth-sepHeight*2-markWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //需求类型
    itemHeight = _defaultItemHeight;
    [_demandTypeLbl setFrame:CGRectMake(_paddingLeft, originY, _labelWidth, itemHeight)];
    [_markLbl3 setFrame:CGRectMake(_paddingLeft + _labelWidth + sepHeight, originY, markWidth, itemHeight)];
    [_demandTypeTextView setFrame:CGRectMake(_paddingLeft + sepHeight*2 + _labelWidth + markWidth, originY, width-_paddingLeft*2-_labelWidth-sepHeight*2-markWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    //需求描述
    CGFloat descHeight = CGRectGetHeight(_descTextView.frame);
    if (descHeight == 0) {
        descHeight = _minContentHeight;
    }
    [_descLbl setFrame:CGRectMake(_paddingLeft, originY, _labelWidth, itemHeight)];
    [_markLbl4 setFrame:CGRectMake(_paddingLeft + _labelWidth + sepHeight, originY, markWidth, itemHeight)];
    [_descTextView setFrame:CGRectMake(_paddingLeft + sepHeight*2 + _labelWidth + markWidth, originY, width-_paddingLeft*2-_labelWidth-sepHeight*2-markWidth, descHeight)];
    originY += descHeight + sepHeight * 2;
    

    [self updateInfo];
    
    if(originY != height) {
        [self notifyViewNeedResized:CGSizeMake(width, originY)];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descTextView) {
        CGRect frame = view.frame;
        frame.size = newSize;
        _descTextView.frame = frame;
        [self updateViews];
    }
}

- (void) updateInfo {
    [_demanderTextView setContentWith:_name];
    if ([FMUtils isStringEmpty:[_phoneTextView getContent]]) {
        [_phoneTextView setContentWith:_phone];
    }
//    [_demanderTextView setText:_name];
//    if ([FMUtils isStringEmpty:[_phoneTextView text]]) {
//        [_phoneTextView setText:_phone];
//    }
    [_demandTypeTextView setContentWith:_demandType];
}

- (void) setInfoWithDemandType:(NSString *)demandType {
    _demandType = [demandType copy];
    [_demandTypeTextView setContentWith:_demandType];
    
    [self updateInfo];
}

#pragma mark - 存方法
- (void)setUserName:(NSString *)name {
    _name = [name copy];
    [self updateInfo];
}

- (void) setPhone:(NSString *)phone {
    _phone = [phone copy];
    [self updateInfo];
}

#pragma mark - 取方法
- (NSString *)getDemander {
    return [_demanderTextView getContent];
}

- (NSString *)getPhoneNumber {
    return [_phoneTextView getContent];
}

- (NSString *) getDemandType {
    return _demandType;
}

- (NSString *)getDescDetail {
    return [_descTextView getContent];
}

- (void)clearAll {
    [_demanderTextView setContentWith:@""];
    [_phoneTextView setContentWith:@""];
    [_demandTypeTextView setContentWith:@""];
    [_descTextView setContentWith:@""];
}

#pragma mark 点击事件监听
- (void)onClick:(UIView *)view {
    if (view == _demandTypeTextView) {
        [self onDemandTypeItemClicked];
    }
}

- (void) onDemandTypeItemClicked  {
    if (_clickListener) {
        [_clickListener onItemClick:self subView:_demandTypeTextView];
    }
}

- (void)setOnItemLickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

@end


