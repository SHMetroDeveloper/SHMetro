//
//  WorkOrderValidateView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/14.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderValidateContentView.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMTheme.h"


@interface WorkOrderValidateContentView () <OnViewResizeListener>
@property (readwrite, nonatomic, strong) UIView * titleContainerView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;    //
@property (readwrite, nonatomic, strong) UIScrollView * descContainerView;
@property (readwrite, nonatomic, strong) BaseTextView * descTV;


@property (readwrite, nonatomic, strong) UIView * signContainerView;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIImageView * signImgView;

@property (readwrite, nonatomic, strong) UIView * controlContainerView;

@property (readwrite, nonatomic, strong) UIButton * leftDoBtn;
@property (readwrite, nonatomic, strong) UIButton * rightDoBtn;


@property (readwrite, nonatomic, strong) UIImage * signImg;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat minDescHeight;
@property (readwrite, nonatomic, assign) CGFloat signHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) NSInteger btnCount;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation WorkOrderValidateContentView

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
        _signHeight = 100;
        _btnHeight = 40;
        _padding = [FMSize getInstance].defaultPadding;
        
        
        _titleContainerView = [[UIView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        
        _descContainerView = [[UIScrollView alloc] init];
        _descTV = [[BaseTextView alloc] init];
        _controlContainerView = [[UIView alloc] init];
        _leftDoBtn = [[UIButton alloc] init];
        _rightDoBtn = [[UIButton alloc] init];
        
        _signContainerView = [[UIScrollView alloc] init];
        _descLbl = [[UILabel alloc] init];
        _signImgView = [[UIImageView alloc] init];
        
        _titleContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_alert_title_validate" inTable:nil];
        
        _descTV.backgroundColor = [UIColor whiteColor];
        [_descTV setShowBounds:YES];
        [_descTV setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_validate_desc" inTable:nil]];
        
        
        [_descTV setOnViewResizeListener:self];
        
        //签字
        _signContainerView.tag = WO_VALIDATE_CONTENT_ACTION_SIGN;
        _signContainerView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _signContainerView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        _signContainerView.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        
        _signContainerView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tryToSign:)];
        [_signContainerView addGestureRecognizer:tapGesture];
        
        [_signImgView setHidden:YES];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        [_descLbl setFont:[FMFont fontWithSize:13]];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        [_descLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_sign_supervisor" inTable:nil]];
        
        _leftDoBtn.tag = WO_VALIDATE_CONTENT_ACTION_REFUSE;
        _rightDoBtn.tag = WO_VALIDATE_CONTENT_ACTION_PASS;
        
        //        _controlContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_leftDoBtn addTarget:self action:@selector(onLeftDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightDoBtn addTarget:self action:@selector(onRightDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_rightDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_leftDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_validate_refuse" inTable:nil] forState:UIControlStateNormal];
        [_rightDoBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_validate_pass" inTable:nil] forState:UIControlStateNormal];
        
        _btnCount = 2;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_titleContainerView addSubview:_titleLbl];
        
        
//        [_signContainerView addSubview:_descLbl];
//        [_signContainerView addSubview:_signImgView];
        
        [_descContainerView addSubview:_descTV];
//        [_descContainerView addSubview:_signContainerView];
        
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
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemHeight = 0;
    CGFloat leftBtnWidth = 0;
    CGFloat rightBtnWidth = 0;
    CGFloat originY = 0;
    
    //输入框
    CGFloat marginLeft = 13;
    CGFloat marginTop = 17;
    CGFloat marginBottom = 17;
    
    [_titleContainerView setFrame:CGRectMake(0, originY, width, _titleHeight)];
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2, _titleHeight)];
    originY += _titleHeight;
    
    [_descContainerView setFrame:CGRectMake(0, originY, width, height-_controlHeight-_titleHeight)];
    
    itemHeight = CGRectGetHeight(_descTV.frame);
    if(itemHeight < _minDescHeight) {
        itemHeight = _minDescHeight;
    }
    [_descTV setFrame:CGRectMake(marginLeft, marginTop, width-marginLeft * 2, itemHeight)];
    originY += marginTop + itemHeight + marginBottom;
    

//    [_signContainerView setFrame:CGRectMake(marginLeft, marginTop + itemHeight+sepHeight, width-marginLeft * 2, _signHeight)];
//    [_descLbl setFrame:CGRectMake(0, 0, width-marginLeft * 2, _signHeight)];
//    [_signImgView setFrame:CGRectMake(0, 0, width-marginLeft * 2, _signHeight)];
//    originY += sepHeight + _signHeight + marginBottom ;
    
    _descContainerView.contentSize = CGSizeMake(width, originY);
    
    
    
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    if(_btnCount > 1) {
        leftBtnWidth = (width-marginLeft * 2 - marginLeft)/2;
        rightBtnWidth = width-marginLeft * 2 - marginLeft - leftBtnWidth;
    } else if(_btnCount > 0) {
        leftBtnWidth = width-marginLeft * 2;
        rightBtnWidth = 0;
    }
    [_leftDoBtn setFrame:CGRectMake(marginLeft, 0, leftBtnWidth, _btnHeight)];
    [_rightDoBtn setFrame:CGRectMake(marginLeft * 2 + leftBtnWidth, 0, rightBtnWidth, _btnHeight)];
    
    [_leftDoBtn grayStyle];
    [_rightDoBtn successStyle];
}

- (void) setTitleWithText:(NSString *) title {
    [_titleLbl setText:title];
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

#pragma mark - 点击签字
- (void) tryToSign:(UITapGestureRecognizer *) gesture {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_signContainerView];
    }
}
@end
