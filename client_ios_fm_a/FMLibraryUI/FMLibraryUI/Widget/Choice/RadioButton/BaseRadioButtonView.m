//
//  BaseRadioButtonView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseRadioButtonView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"

@interface BaseRadioButtonView ()

@property (readwrite, nonatomic, strong) UIImageView * imgView;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat sepWidth;

@property (readwrite, nonatomic, assign) BOOL isSelected;
@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@end

@implementation BaseRadioButtonView

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
        _isSelected = NO;
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _padding = [FMSize getInstance].defaultPadding;
        _sepWidth = _padding / 2;
        
        _imgView = [[UIImageView alloc] init];
        _descLbl = [[UILabel alloc] init];
        
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _descLbl.font = [FMFont getInstance].font42;
        
        [self addSubview:_imgView];
        [self addSubview:_descLbl];
        
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat sepWidth = 5;
    if(width == 0|| height == 0) {
        return;
    }
    [_imgView setFrame:CGRectMake(0, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    [_descLbl setFrame:CGRectMake(_imgWidth+sepWidth, 0, width-_imgWidth-sepWidth, height)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_descLbl setText:_desc];
    if(_isSelected) {
        [_imgView setImage:[[FMTheme getInstance] getImageByName:@"btn_radio_on"]];
    } else {
        [_imgView setImage:[[FMTheme getInstance] getImageByName:@"btn_radio_off"]];
    }
}

- (void) setSelected:(BOOL) selected {
    _isSelected = selected;
    [self updateInfo];
}

- (void) setDesc:(NSString *) desc {
    _desc = desc;
    [self updateInfo];
}

- (void) actiondo:(UIView *) v {
    [self notifyViewClicked];
    
}

- (void) notifyViewClicked {
    if(_listener) {
        [_listener onClick:self];
    }
}
//设置点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
}

@end
