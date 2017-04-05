//
//  SignAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "SignAlertContentView.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "UIImageView+AFNetworking.h"


@interface SignAlertContentView ()
@property (readwrite, nonatomic, strong) UIView * titleContainerView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;    //

@property (readwrite, nonatomic, strong) UIView * signContainerView;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIImageView * signImgView;

@property (readwrite, nonatomic, strong) UIView * controlContainerView;
@property (readwrite, nonatomic, strong) UIButton * doBtn;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, strong) UIImage * signImg;
@property (readwrite, nonatomic, strong) NSURL * signImgUrl;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation SignAlertContentView

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
        
        _titleHeight = 40;
        _controlHeight = 50;
        _btnHeight = 40;
        _padding = [FMSize getInstance].defaultPadding;
        
        
        _titleContainerView = [[UIView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        
        _signContainerView = [[UIScrollView alloc] init];
        _descLbl = [[UILabel alloc] init];
        _signImgView = [[UIImageView alloc] init];
        
        
        
        _controlContainerView = [[UIView alloc] init];
        _doBtn = [[UIButton alloc] init];
        
        _titleContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _signContainerView.tag = SIGN_ALERT_OPERATE_TYPE_SIGN;
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
        [_descLbl setText:[[BaseBundle getInstance] getStringByKey:@"signature_notice_desc" inTable:nil]];
        
        
        
        _doBtn.tag = SIGN_ALERT_OPERATE_TYPE_OK;
        
        
        [_doBtn addTarget:self action:@selector(onDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_doBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_doBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil] forState:UIControlStateNormal];
        [_doBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_titleContainerView addSubview:_titleLbl];
        
        [_signContainerView addSubview:_descLbl];
        [_signContainerView addSubview:_signImgView];
        
        [_controlContainerView addSubview:_doBtn];
        
        [self addSubview:_titleContainerView];
        [self addSubview:_signContainerView];
        [self addSubview:_controlContainerView];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight;
    CGFloat originY = 0;
    
    //输入框
    CGFloat marginLeft = 13;
    CGFloat marginTop = 17;
    CGFloat marginBottom = 20;
    
    [_titleContainerView setFrame:CGRectMake(0, originY, width, _titleHeight)];
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2, _titleHeight)];
    originY += _titleHeight + marginTop;
    
    itemHeight = height - _titleHeight - _controlHeight - marginTop - marginBottom;
    [_signContainerView setFrame:CGRectMake(marginLeft, originY, width-marginLeft * 2, itemHeight)];
    [_descLbl setFrame:CGRectMake(0, 0, width-marginLeft * 2, itemHeight)];
    [_signImgView setFrame:CGRectMake(0, 0, width-marginLeft * 2, itemHeight)];
    
    
    
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    [_doBtn setFrame:CGRectMake(marginLeft, 0, width-marginLeft*2, _btnHeight)];
    [_doBtn successStyle];
    [self updateInfo];
    
}

- (void) updateInfo {
    if(_signImg || _signImgUrl) {
        [_descLbl setHidden:YES];
        [_signImgView setHidden:NO];
        if(_signImgUrl) {
            [_signImgView setImageWithURL:_signImgUrl];
        } else {
            [_signImgView setImage:_signImg];
        }
    } else {
        [_descLbl setHidden:NO];
        [_signImgView setHidden:YES];
    }
    
}

- (void) setTitleWithText:(NSString *) title {
    [_titleLbl setText:title];
}

- (void) setDescWithText:(NSString *) text {
    [_descLbl setText:text];
    
}

- (void) setSignImg:(UIImage *)signImg {
    _signImg = signImg;
    [self updateInfo];
}

//设置签字图片
- (void) setSignImgWithUrl:(NSURL *) url {
    _signImgUrl = url;
    [self updateInfo];
}

//设置按钮上的操作提示
- (void) setOperationButtonText:(NSString *) text {
    [_doBtn setTitle:text forState:UIControlStateNormal];
}



- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

- (void) onDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_doBtn];
    }
}

#pragma mark - 点击签字
- (void) tryToSign:(UITapGestureRecognizer *) gesture {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_signContainerView];
    }
}

@end

