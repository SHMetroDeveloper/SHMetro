//
//  ServerAddressEditView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/8/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ServerAddressEditView.h"
#import "LineTextField.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "UIButton+Bootstrap.h"

@interface ServerAddressEditView ()

@property (readwrite, nonatomic, strong) UIView * topContainerView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;

@property (readwrite, nonatomic, strong) UIView * contentContainerView;
@property (readwrite, nonatomic, strong) LineTextField * addressBaseTf;

@property (readwrite, nonatomic, strong) UIView * controlContainerView;
@property (readwrite, nonatomic, strong) UIButton * cancelBtn;
@property (readwrite, nonatomic, strong) UIButton * okBtn;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat inputHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * defaultAddress;

@property (readwrite, nonatomic, assign) BOOL showCorner;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation ServerAddressEditView

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
    
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _titleHeight = 40;
        _controlHeight = 50;
        _btnHeight = 40;
        _padding = 13;
        _inputHeight = 40;
        
        _title = [[BaseBundle getInstance] getStringByKey:@"login_input_server_address" inTable:nil];
        _defaultAddress = @"http://116.236.176.99:9999";
        
        _topContainerView = [[UIView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        
        _contentContainerView = [[UIView alloc] init];
        _addressBaseTf = [[LineTextField alloc] init];
        
        _controlContainerView = [[UIView alloc] init];
        _cancelBtn = [[UIButton alloc] init];
        _okBtn = [[UIButton alloc] init];
        
        _topContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        [_addressBaseTf setLineColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_addressBaseTf setFont:[FMFont getInstance].defaultFontLevel2];
        
        _cancelBtn.tag = SERVER_ADDRESS_EDIT_CANCEL;
        _okBtn.tag = SERVER_ADDRESS_EDIT_OK;
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        
        [_cancelBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_okBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        
        [_cancelBtn addTarget:self action:@selector(onCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn addTarget:self action:@selector(onOKBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        

        
        [_topContainerView addSubview:_titleLbl];
        
        [_contentContainerView addSubview:_addressBaseTf];
        
        [_controlContainerView addSubview:_cancelBtn];
        [_controlContainerView addSubview:_okBtn];
        
        [self addSubview:_topContainerView];
        [self addSubview:_contentContainerView];
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
    CGFloat paddingBottom = 27;
    [_topContainerView setFrame:CGRectMake(0, 0, width, _titleHeight)];
    [_contentContainerView setFrame:CGRectMake(0, _titleHeight, width, height-_controlHeight-_titleHeight)];
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    
    
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2, _titleHeight)];
    
    [_addressBaseTf setFrame:CGRectMake(_padding, height-_controlHeight-_titleHeight-paddingBottom-_inputHeight, width-_padding * 2, _inputHeight)];
    
    CGFloat btnWidth = (width - _padding * 3) / 2;
    [_cancelBtn setFrame:CGRectMake(_padding, 0, btnWidth, _btnHeight)];
    [_okBtn setFrame:CGRectMake(width-_padding-btnWidth, 0, btnWidth, _btnHeight)];
    
    [_cancelBtn grayStyle];
    [_okBtn primaryStyle];
    
    _okBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    _okBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]CGColor];
    [_okBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] width:1 height:1] forState:UIControlStateHighlighted];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    [_addressBaseTf setPlaceholder:_defaultAddress];
}

- (void) setDefaultAddress:(NSString *) address {
    _defaultAddress = [address copy];
    [_addressBaseTf setPlaceholder:_defaultAddress];
}

- (void) setAddress:(NSString *) address {
    _addressBaseTf.text = address;
}

- (void) clearInput {
    [_addressBaseTf setText:@""];
}

//设置是否展示圆角
- (void) setShowCorner:(BOOL) showCorner {
    if(showCorner) {
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    } else {
        self.layer.cornerRadius = 0;
    }
}

- (NSString *) getAddressInput {
    return _addressBaseTf.text;
}

- (void) setDelegate:(id<UITextFieldDelegate>) delegate {
    _addressBaseTf.delegate = delegate;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _listener = listener;
}

#pragma mark - 点击事件
- (void) onCancelBtnClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_cancelBtn];
    }
}

- (void) onOKBtnClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_okBtn];
    }
}

@end
