//
//  ContractOperateContentView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "ContractOperateContentView.h"
#import "FMUtilsPackages.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"

@interface ContractOperateContentView ()
@property (nonatomic, strong) UIView *titleContainerView;
@property (nonatomic, strong) UILabel *titleLbl;    //
@property (nonatomic, strong) UIScrollView *descContainerView;
@property (nonatomic, strong) BaseTextView *descTV;

@property (nonatomic, strong) UIView *controlContainerView;

@property (nonatomic, strong) UIButton *leftDoBtn;
@property (nonatomic, strong) UIButton *rightDoBtn;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat minDescHeight;
@property (nonatomic, assign) CGFloat controlHeight;
@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<OnItemClickListener> clickListener;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractOperateContentView

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
        _padding = [FMSize getInstance].defaultPadding;
        
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _titleContainerView = [[UIView alloc] init];
        _titleContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_titleContainerView addSubview:_titleLbl];
        
        
        _descTV = [[BaseTextView alloc] init];
        _descTV.backgroundColor = [UIColor whiteColor];
        [_descTV setShowBounds:YES];
        [_descTV setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_validate_desc" inTable:nil]];
        
        _descContainerView = [[UIScrollView alloc] init];
        [_descContainerView addSubview:_descTV];
        
        
        _leftDoBtn = [[UIButton alloc] init];
        _leftDoBtn.tag = CONTRACT_OPERATE_CONTENT_ACTION_REFUSE;
        [_leftDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_leftDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"notice_delete_cancel" inTable:nil] forState:UIControlStateNormal];
        [_leftDoBtn addTarget:self action:@selector(onLeftDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        _rightDoBtn = [[UIButton alloc] init];
        _rightDoBtn.tag = CONTRACT_OPERATE_CONTENT_ACTION_PASS;
        [_rightDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"notice_delete_done" inTable:nil] forState:UIControlStateNormal];
        [_rightDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_rightDoBtn addTarget:self action:@selector(onRightDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _controlContainerView = [[UIView alloc] init];
        [_controlContainerView addSubview:_leftDoBtn];
        [_controlContainerView addSubview:_rightDoBtn];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [self addSubview:_titleContainerView];
        [self addSubview:_descContainerView];
        [self addSubview:_controlContainerView];
    }
}

- (void)updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat itemHeight = 0;
    CGFloat leftBtnWidth = 0;
    CGFloat rightBtnWidth = 0;
    
    //输入框
    CGFloat marginLeft = 13;
    CGFloat marginTop = 17;
    CGFloat marginBottom = 17;
    
    CGFloat originY = 0;
    
    [_titleContainerView setFrame:CGRectMake(0, originY, width, _titleHeight)];
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding*2, _titleHeight)];
    originY += _titleHeight;
    
    [_descContainerView setFrame:CGRectMake(0, originY, width, height-_controlHeight-_titleHeight)];
    
    itemHeight = CGRectGetHeight(_descTV.frame);
    if(itemHeight < _minDescHeight) {
        itemHeight = _minDescHeight;
    }
    [_descTV setFrame:CGRectMake(marginLeft, marginTop, width-marginLeft*2, itemHeight)];
    originY += marginTop + itemHeight + marginBottom;
    
    _descContainerView.contentSize = CGSizeMake(width, originY);
    
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    leftBtnWidth = (width-marginLeft*3)/2;
    rightBtnWidth = leftBtnWidth;
    
    [_leftDoBtn setFrame:CGRectMake(marginLeft, 0, leftBtnWidth, _btnHeight)];
    [_rightDoBtn setFrame:CGRectMake(marginLeft*2 + leftBtnWidth, 0, rightBtnWidth, _btnHeight)];
    
    [_leftDoBtn grayStyle];
    [_rightDoBtn successStyle];
    
}


//设置content的标题
- (void)setTitleOfContentView:(NSString *)title {
    _title = title;
    
    [_titleLbl setText:_title];
}

//获取描述信息
- (NSString *)getDesc {
    NSString *res = [_descTV getContent]; ;
    return res;
}

- (void)clearInput {
    [_descTV setContentWith:@""];
}

- (void)setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}

- (void)onLeftDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_leftDoBtn];
    }
}

- (void)onRightDoButtonClicked {
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
