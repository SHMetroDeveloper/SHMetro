//
//  ApprovalTaskAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ApprovalTaskAlertContentView.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface ApprovalTaskAlertContentView ()

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) BaseTextView * noteBaseTv;
@property (readwrite, nonatomic, assign) ApprovalTaskOperateType approvalType;

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * refuseBtn;
@property (readwrite, nonatomic, strong) UIButton * accessBtn;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat minDescHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;
@end


@implementation ApprovalTaskAlertContentView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = _paddingLeft;
        _paddingBottom = 0;
        
        _controlHeight = [FMSize getInstance].bottomControlHeight;
        _minDescHeight = 200;
        
        _mainContainerView = [[UIScrollView alloc] init];
        _controlView = [[UIView alloc] init];
        
        _noteBaseTv = [[BaseTextView alloc] init];
        _refuseBtn = [[UIButton alloc] init];
        _accessBtn = [[UIButton alloc] init];
        
        [_noteBaseTv setTopDesc:[[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil]];
        [_noteBaseTv setOnViewResizeListener:self];
        [_noteBaseTv setMinHeight:_minDescHeight];
        
        _refuseBtn.tag = APPROVAL_TASK_APPROVAL_TYPE_REFUSE;
        _accessBtn.tag = APPROVAL_TASK_APPROVAL_TYPE_ACCESS;
        
        [_refuseBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_refuse" inTable:nil] forState:UIControlStateNormal];
        [_accessBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_pass" inTable:nil] forState:UIControlStateNormal];
        
        [_refuseBtn addTarget:self action:@selector(onRefuseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_accessBtn addTarget:self action:@selector(onAccessButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [_controlView addSubview:_refuseBtn];
        [_controlView addSubview:_accessBtn];
        
        [_mainContainerView addSubview:_noteBaseTv];
        
        
        [self addSubview:_mainContainerView];
        [self addSubview:_controlView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat originY = _paddingTop;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat sepWidth = 10;
    [_mainContainerView setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    
    CGFloat btnWidth = (width - _paddingLeft - _paddingRight - sepWidth) / 2;
    [_refuseBtn setFrame:CGRectMake(_paddingLeft, padding/2, btnWidth, _controlHeight - padding)];
    [_accessBtn setFrame:CGRectMake(width-_paddingRight-btnWidth, padding/2, btnWidth, _controlHeight - padding)];
    
    [_refuseBtn primaryStyle];
    [_accessBtn primaryStyle];
    
    CGFloat itemHeight = CGRectGetHeight(_noteBaseTv.frame);
    if(itemHeight < _minDescHeight) {
        itemHeight = _minDescHeight;
    }
    [_noteBaseTv setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + _paddingBottom;
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
    
}


- (NSString *) getApprovalDesc {
    NSString * res;
    res = [_noteBaseTv getContent];
    return res;
}
- (ApprovalTaskOperateType) getApprovalResultType {
    ApprovalTaskOperateType res = APPROVAL_TASK_APPROVAL_TYPE_UNKNOW;
    res = _approvalType;
    return res;
}

- (void) clearInput {
    [_noteBaseTv setContentWith:@""];
}

- (void) onRefuseButtonClicked {
    _approvalType = APPROVAL_TASK_APPROVAL_TYPE_REFUSE;
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_refuseBtn];
    }
}

- (void) onAccessButtonClicked {
    _approvalType = APPROVAL_TASK_APPROVAL_TYPE_ACCESS;
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_accessBtn];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _noteBaseTv) {
        CGRect frame = view.frame;
        frame.size = newSize;
        view.frame = frame;
        [self updateViews];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener{
    _clickListener = listener;
}

@end
