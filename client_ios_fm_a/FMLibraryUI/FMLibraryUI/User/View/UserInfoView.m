//
//  UserInfoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "UserInfoView.h"
#import "FMUtils.h"
#import "UIImageView+AFNetWorking.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"

@interface UserInfoView ()

@property (readwrite, nonatomic, strong) UIImageView * bgImgView;
@property (readwrite, nonatomic, strong) UIImageView * logoBgImgView;

@property (readwrite, nonatomic, strong) UIImageView * logoImgView;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;



@property (readwrite, nonatomic, assign) CGFloat logoWidth;

@property (readwrite, nonatomic, strong) UIImage * defaultLogo;
@property (readwrite, nonatomic, strong) UIImage * logoImg;
@property (readwrite, nonatomic, strong) NSURL * logoImgUrl;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, strong) UIFont *mFont ;

@property (readwrite, nonatomic, assign) CGFloat logoPadding;   //头像的边距

@property (readwrite, nonatomic, assign) BOOL inited;
@end

@implementation UserInfoView

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
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_inited) {
        _inited = YES;
        
        [self initSettings];
        
        _bgImgView = [[UIImageView alloc] init];
        _logoBgImgView = [[UIImageView alloc] init];
        
        _logoImgView = [[UIImageView alloc] init];
        _nameLbl = [[UILabel alloc] init];
        _descLbl = [[UILabel alloc] init];

        _nameLbl.font = _mFont;
        _descLbl.font = _mFont;
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        
        
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        
        _defaultLogo = [[FMTheme getInstance] getImageByName:@"user_default_head"];
        
        [_bgImgView setImage:[[FMTheme getInstance] getImageByName:@"user_default_bg"]];
        [_logoBgImgView setImage:[[FMTheme getInstance] getImageByName:@"user_default_head_bg"]];
        
        
        [self addSubview:_bgImgView];
        [self addSubview:_logoBgImgView];
        
        [self addSubview:_logoImgView];
        [self addSubview:_nameLbl];
        [self addSubview:_descLbl];
    }
    
}


- (void) initSettings {
    _mFont = [FMFont fontWithSize:13];
    _logoWidth = 80;    //
    
    _paddingLeft = [FMSize getInstance].defaultPadding ;
    _paddingRight = [FMSize getInstance].defaultPadding;
    _paddingTop = 20;
    _paddingBottom = 0;
    _logoPadding = 3;
    
}

- (void) updateViews {
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat bgWidth = height * 0.4;
    CGFloat logoWidth = 0;
    CGFloat originY = 0;
    CGFloat sepHeight = 8;
    CGFloat nameHeight = 16;
    
    logoWidth = bgWidth - _logoPadding * 2;
    if(logoWidth > _logoWidth) {
        logoWidth = _logoWidth;
    }
    
    
    
    CGFloat padding = height * 2/ 3 - bgWidth;
    originY = padding;
    
    [_bgImgView setFrame:CGRectMake(0, 0, width, height)];
    [_logoImgView setFrame:CGRectMake(0, 0, logoWidth, logoWidth)];
    
    [_logoBgImgView setFrame:CGRectMake((width-bgWidth)/2, originY, bgWidth, bgWidth)];
    [_logoImgView setCenter:_logoBgImgView.center];
    
    
    originY += bgWidth + sepHeight;
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, nameHeight)];
    originY += nameHeight + sepHeight / 2;
    
    [_descLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, nameHeight)];
    
    
    _logoBgImgView.layer.cornerRadius = bgWidth / 2;
    _logoBgImgView.layer.masksToBounds = YES;
    
    _logoImgView.layer.cornerRadius = logoWidth / 2;
    _logoImgView.layer.masksToBounds = YES;
    
    [self updateInfo];
}

//获取描述信息
- (NSString *) getNameDesc {
    NSString * res = @"";
    if(_name) {
        res = _name;
    }
    return res;
}

- (void) updateInfo {
    if(_logoImg) {
        [_logoImgView setImage:_logoImg];
    } else if(_logoImgUrl) {
        [_logoImgView setImageWithURL:_logoImgUrl placeholderImage:_defaultLogo];
    } else {
        [_logoImgView setImage:_defaultLogo];
    }
    [_nameLbl setHidden:NO];
    [_descLbl setHidden:NO];
    if(![FMUtils isStringEmpty:_name]) {
        _nameLbl.text = _name;
        if(![FMUtils isStringEmpty:_desc]) {
            _descLbl.text = _desc;
        } else {
            [_descLbl setHidden:YES];
        }
    } else {
        [_descLbl setHidden:YES];
        if(![FMUtils isStringEmpty:_desc]) {
            _nameLbl.text = _desc;
        } else {
            [_nameLbl setHidden:YES];
        }
    }
}

//只显示名称
- (void) setInfoWithName:(NSString *) name {
    _name = name;
    _logoImg = nil;
    _logoImgUrl = nil;
    [self updateViews];
}

- (void) setInfoWithPhoto:(UIImage *) photo {
    _logoImg = photo;
    _logoImgUrl = nil;
    [self updateViews];
}

//显示名称和图标
- (void) setInfoWithName:(NSString *) name andPhoto:(UIImage *) image {
    _name = name;
    _logoImg = image;
    _logoImgUrl = nil;
    [self updateViews];
}

- (void) setInfoWithName:(NSString *) name andPhoto:(UIImage *) image andDesc:(NSString *) desc{
    if(name) {
        _name = name;
    } else {
        _name = @"";
    }
    if(image) {
        _logoImg = image;
    } else {
        _logoImg = nil;
    }
    _logoImgUrl = nil;
    if(desc) {
        _desc = desc;
    } else {
        _desc = nil;
    }
    [self updateViews];
}

- (void) setInfoWithName:(NSString *) name andPhotoUrl:(NSURL *) imageUrl andDesc:(NSString *) desc{
    if(name) {
        _name = name;
    } else {
        _name = @"";
    }
    if(imageUrl) {
        _logoImgUrl = imageUrl;
    } else {
        _logoImgUrl = nil;
    }
    _logoImg = nil;
    
    if(desc) {
        _desc = desc;
    } else {
        _desc = nil;
    }
    [self updateViews];
}

- (void) setShowBounds:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}


- (CGFloat) getPaddingLeft {
    return _paddingLeft;
}

- (CGFloat) getPaddingRight {
    return _paddingRight;
}

@end
