//
//  BaseItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseItemView.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"

@interface BaseItemView ()

@property (readwrite, nonatomic, strong) UIImageView * logoImgView;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) UIImageView * rightImgView;


@property (readwrite, nonatomic, assign) CGFloat logoWidth;     //左侧图标大小
@property (readwrite, nonatomic, assign) CGFloat rightImgWidth; //右侧图标大小
@property (readwrite, nonatomic, assign) CGFloat defaultLeftWidth;  //name 到边框的间距


@property (readwrite, nonatomic, strong) UIImage * logoImg;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * status;
@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, strong) UIFont *mFont ;
@property (readwrite, nonatomic, strong) UIFont *mDescFont ;
@property (readwrite, nonatomic, strong) UIFont *mStatusFont ;

@property (readwrite, nonatomic, assign) BOOL showRightImage;
@property (readwrite, nonatomic, assign) BOOL showLogoImage;    //设置是否显示 logoImageView，用于左对齐

@property (readwrite, nonatomic, assign) BOOL inited;
@end

@implementation BaseItemView

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
        
        _logoImgView = [[UIImageView alloc] init];
        _nameLbl = [[UILabel alloc] init];
        _statusLbl = [[UILabel alloc] init];
        _descLbl = [[UILabel alloc] init];
        _rightImgView = [[UIImageView alloc] init];
        
        _nameLbl.font = _mFont;
        _statusLbl.font = _mStatusFont;
        _descLbl.font = _mDescFont;
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
        
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.clipsToBounds = YES;
        
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl.textColor = [UIColor whiteColor];
        _statusLbl.layer.backgroundColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK] CGColor];
        _statusLbl.clipsToBounds = YES;
        
        [self setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8] width:1 height:1] forState:UIControlStateHighlighted];
        
        [self addSubview:_logoImgView];
        [self addSubview:_nameLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_descLbl];
        [self addSubview:_rightImgView];
        
    }
}


- (void) initSettings {
    _mFont = [FMFont fontWithSize:14];
    _mDescFont = [FMFont getInstance].defaultFontLevel3;
    _mStatusFont = [FMFont getInstance].defaultFontLevel3;
    _logoWidth = [FMSize getInstance].imgWidthLevel2;
    _rightImgWidth = [FMSize getInstance].imgWidthLevel3;
    
    _paddingLeft = 0;
    _paddingRight = 0;
    _paddingTop = 0;
    _paddingBottom = 0;
    
    _showLogoImage = NO;
    
}

- (void) updateViews {
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat logoWidth = 0;
    CGFloat nameWidth = 0;
    CGFloat descWidth = 0;
    CGFloat rightImgWidth = 0;
    CGFloat descHeight = 16;
    
    CGFloat logoSepWidth = 0;
    CGFloat statusWidth = 0;
    CGFloat statusHeight = 0;
    CGFloat descSepWidth = 5;
    CGFloat leftWidth = 0;
    
    if(_showLogoImage) {
        if(_defaultLeftWidth == 0) {
            leftWidth = _paddingLeft * 2 + _logoWidth;
        } else {
            leftWidth = _defaultLeftWidth;
        }
        [_logoImgView setFrame:CGRectMake(_paddingLeft, (height - _logoWidth)/2, _logoWidth, _logoWidth)];
        [_logoImgView setHidden:NO];
        logoWidth = _logoWidth;
        logoSepWidth = leftWidth - _paddingLeft - _logoWidth;
    } else {
        if(_defaultLeftWidth == 0) {
            leftWidth = _paddingLeft;
        } else {
            leftWidth = _defaultLeftWidth;
        }
        [_logoImgView setHidden:YES];
    }
    if(_showRightImage) {
        rightImgWidth = _rightImgWidth;
    }
    
    if(_status) {
        [_statusLbl setFrame:CGRectMake(_paddingLeft + logoWidth +descSepWidth + nameWidth, 0, width - _paddingLeft - _paddingRight, height)];
        statusHeight = [FMUtils heightForStringWith:_statusLbl value:_status andWidth:width - _paddingLeft - _paddingRight] + 2;
        statusWidth = [FMUtils widthForString:_statusLbl value:_status] + 10;
        
        [_statusLbl setFrame:CGRectMake(width-_paddingLeft-rightImgWidth-statusWidth, (height-statusHeight)/2, statusWidth, statusHeight)];
        _statusLbl.layer.cornerRadius = statusHeight/2;
        [_statusLbl setHidden:NO];
    } else {
        [_statusLbl setHidden:YES];
    }
    
    if(_desc) {
        [_descLbl setFrame:CGRectMake(_paddingLeft + logoWidth + descSepWidth + nameWidth + statusWidth, (height-descHeight)/2, width - _paddingLeft - _paddingRight, descHeight)];
        descWidth = [FMUtils widthForString:_descLbl value:_desc] + 8;
        [_descLbl setFrame:CGRectMake(width-_paddingRight - descWidth-rightImgWidth-statusWidth, (height-descHeight)/2, descWidth, descHeight)];
        _descLbl.layer.cornerRadius = descHeight / 2;
        [_descLbl setHidden:NO];
    } else {
        [_descLbl setHidden:YES];
    }
    
    
    
    [_nameLbl setFrame:CGRectMake(leftWidth, _paddingTop, width - leftWidth - _paddingRight, height)];
    nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    if(nameWidth > width - leftWidth - rightImgWidth - statusWidth-descWidth) {
        nameWidth = width - leftWidth - rightImgWidth-logoSepWidth - statusWidth-descWidth;
    }
    [_nameLbl setFrame:CGRectMake(leftWidth, 0, nameWidth, height)];
    
    
    if(_showRightImage) {
        [_rightImgView setFrame:CGRectMake(width-rightImgWidth-_paddingRight, (height-rightImgWidth)/2, rightImgWidth, rightImgWidth)];
        [_rightImgView setHidden:NO];
    } else {
        [_rightImgView setHidden:YES];
    }
    
    [self updateInfo];
}

- (void) updateInfo {
    if(_logoImg) {
        [_logoImgView setImage:_logoImg];
    }
    _nameLbl.text = _name;
    if(_status) {
        _statusLbl.text = _status;
    }
    if(_desc) {
        _descLbl.text = _desc;
    }
    
}

//只显示名称
- (void) setInfoWithName:(NSString *) name {
    _name = name;
    [self updateViews];
}

//显示名称和图标
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image {
    _name = name;
    _logoImg = image;
    if(image) {
        _showLogoImage = YES;
    }
    [self updateViews];
}

//显示名称和图标
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image andDesc:(NSString *) desc{
    _name = name;
    _logoImg = image;
    if(image) {
        _showLogoImage = YES;
    }
    _desc = desc;
    [self updateViews];
}

//显示名称和图标
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image andDesc:(NSString *) desc andStatus:(NSString *) statusStr{
    _name = name;
    _logoImg = image;
    if(image) {
        _showLogoImage = YES;
    }
    _desc = desc;
    _status = statusStr;
    [self updateViews];
}

//设置名字的颜色
- (void) setNameColor:(UIColor *) nameColor {
    [_nameLbl setTextColor:nameColor];
}

//设置说明信息颜色
- (void) setDescColor:(UIColor *) descColor {
    [_descLbl setTextColor:descColor];
}

- (void) setDescFont:(UIFont *) descFont {
    _descLbl.font = descFont;
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

//设置是否显示向右箭头
- (void) setShowMore:(BOOL) show {
    _showRightImage = show;
    if(show) {
        [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        _rightImgWidth = [FMSize getInstance].imgWidthLevel3;
    }
    [self updateViews];
}

//设置红点
- (void) setShowRedPoint:(BOOL) show {
    _showRightImage = show;
    if(show) {
//        [_rightImgView setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] width:1 height:1]];
        [_rightImgView setImage:nil];
        _rightImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        _rightImgWidth = 7;
        _rightImgView.layer.cornerRadius = _rightImgWidth/2.0;
        _rightImgView.clipsToBounds = YES;
    } else {
        _rightImgView.layer.cornerRadius = 0;
        _rightImgView.clipsToBounds = NO;
    }
    
    [self updateViews];
}

//设置右侧图标
- (void) setRightImage:(UIImage *) image {
    _showRightImage = YES;
    [_rightImgView setImage:image];
    [self updateViews];
}

//设置是否显示右侧图标
- (void) setShowRightImage:(BOOL) showRightImage {
    _showRightImage = showRightImage;
    [self updateViews];
}

//设置右侧图标宽度
- (void) setRightImageWidth:(CGFloat) imgWidth {
    _rightImgWidth = imgWidth;
    [self updateViews];
}

//设置是否显示logoImageView 用于左对齐
- (void) setShowLogoImage:(BOOL)showLogoImage {
    _showLogoImage = showLogoImage;
    [self updateViews];
}

//设置边框的显示
- (void) setShowBound:(BOOL) show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderWidth = 0;
    }
}

//设置logo图标宽度
- (void) setLogoImageWidth:(CGFloat) imgWidth {
    _logoWidth = imgWidth;
    [self updateViews];
}

//设置左侧区域（name 到边框）的宽度
- (void) setLeftWidth:(CGFloat) width {
    _defaultLeftWidth = width;
    [self updateViews];
}

//设置描述信息的展示方式
- (void) setDescType:(BaseItemViewDescType) type {
    switch(type) {
        case BASE_ITEM_DESC_TYPE_DEFAULT:
            _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
            _descLbl.backgroundColor = [UIColor clearColor];
            _descLbl.layer.borderWidth = 0;
            break;
        case BASE_ITEM_DESC_TYPE_BOUND_RECT:
            _descLbl.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
            _descLbl.layer.cornerRadius = 0;
            _descLbl.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
            _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            _descLbl.backgroundColor = [UIColor clearColor];
            break;
        case BASE_ITEM_DESC_TYPE_BOUND_ROUND:
            _descLbl.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
            _descLbl.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
            _descLbl.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] CGColor];
            _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            _descLbl.backgroundColor = [UIColor clearColor];
            break;
        case BASE_ITEM_DESC_TYPE_RED_BG:
            _descLbl.layer.borderWidth = 0;
            _descLbl.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
            _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
            _descLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
            break;
    }
}



//更新描述
- (void) updateDesc:(NSString *) desc {
    _desc = [desc copy];
    [self updateViews];
}

//
- (void) updateStatus:(NSString *) status {
    _status = status;
    [self updateViews];
}

- (CGFloat) getPaddingLeft {
    return _paddingLeft;
}

- (CGFloat) getPaddingRight {
    return _paddingRight;
}

@end
