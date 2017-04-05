//
//  PhoneItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PhoneItemView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"


@interface PhoneItemView ()

@property (readwrite, nonatomic, strong) UIImageView * iconImgView;

@property (readwrite, nonatomic, strong) UILabel * phoneLblView;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, strong) NSString * phone;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) PhoneActionType type;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end


@implementation PhoneItemView

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
        
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _type = PHONE_ACTION_CALL;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _iconImgView = [[UIImageView alloc] init];
        _phoneLblView = [[UILabel alloc] init];
        [_phoneLblView setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        _phoneLblView.textAlignment = NSTextAlignmentRight;
//        [_phoneLblView setFont:[FMFont getInstance].defaultFontLevel2];
//         [_phoneLblView setFont:[FMFont getInstance].defaultFontLevel2];
        
        [_iconImgView setImage:[[FMTheme getInstance] getImageByName:@"home_phone_call"]];
        
        UITapGestureRecognizer * tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tabGesture];
        
        [self addSubview:_iconImgView];
        [self addSubview:_phoneLblView];
    }
    
}

- (void) updateViews {
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepWidth = 8;
    [_iconImgView setFrame:CGRectMake(_paddingLeft, (height - _imgWidth)/2, _imgWidth, _imgWidth)];
    [_phoneLblView setFrame:CGRectMake(_paddingLeft+_imgWidth+sepWidth, 0, width-_paddingLeft-_paddingRight-_imgWidth-sepWidth, height)];
    
}

- (void) updateInfo {
    [_phoneLblView setText:_phone];
    switch(_type) {
        case PHONE_ACTION_CALL:
            
            [_iconImgView setHidden:NO];
            break;
        case PHONE_ACTION_MESSAGE:
            [_iconImgView setHidden:YES];
            break;
    }
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) setInfoWithPhoneNumber:(NSString *) phoneNumber {
    _phone = phoneNumber;
    [self updateInfo];
}

- (void) onClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:nil];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}


@end
