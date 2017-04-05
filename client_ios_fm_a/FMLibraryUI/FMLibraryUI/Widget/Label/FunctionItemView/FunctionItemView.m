//
//  ProjectItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "FunctionItemView.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"

@interface FunctionItemView ()

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) UIImage * logo;


@property (readwrite, nonatomic, strong) UIImageView * projectLogoImgView;
@property (readwrite, nonatomic, strong) UILabel * projectNameLbl;
@property (readwrite, nonatomic, strong) UILabel * projectStateLbl;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation FunctionItemView

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
        
        _itemHeight = [FMSize getInstance].functionItemHeight;
        UIFont * nameFont = [FMFont getInstance].functionItemFontMsg;
        
        _projectLogoImgView = [[UIImageView alloc] init];
        _projectNameLbl = [[UILabel alloc] init];
        _projectStateLbl = [[UILabel alloc] init];
        
        _projectNameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _projectStateLbl.font = [FMFont getInstance].defaultFontLevel2;
        _projectStateLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _projectStateLbl.clipsToBounds = YES;
        _projectStateLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _projectStateLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.projectNameLbl setFont:nameFont];
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setAdjustsImageWhenHighlighted:NO];
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7] CGColor];
        
        [self setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8] width:1 height:1] forState:UIControlStateHighlighted];
        
        _projectLogoImgView.userInteractionEnabled = NO;
        _projectNameLbl.userInteractionEnabled = NO;
        _projectStateLbl.userInteractionEnabled = NO;
        
        
        [self addSubview:self.projectLogoImgView];
        [self addSubview:self.projectNameLbl];
        [self addSubview:self.projectStateLbl];
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat stateWidth = 0;
    CGFloat stateHeight = 18;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    CGFloat logoOrginX = [FMSize getInstance].functionItemPaddingLeft*2;
    CGFloat logoWidth = height/2;
    CGFloat paddingRight = [FMSize getInstance].defaultPadding;
    if(width == 0 || height == 0) {
        return;
    }
    
    
    [_projectLogoImgView setFrame:CGRectMake(logoOrginX, (height - logoWidth)/2, logoWidth, logoWidth)];
    [_projectNameLbl setFrame:CGRectMake((logoOrginX + logoWidth + logoOrginX/2), 0, frame.size.width - (logoOrginX*2+logoWidth) - stateWidth, height)];
    if(_status > 0) {
        NSString * strStatus = [[NSString alloc] initWithFormat:@"%ld", _status];
        stateWidth = [FMUtils widthForString:_projectStateLbl value:strStatus];
        stateWidth += stateHeight/2;
        if(stateWidth < stateHeight) {
            stateWidth = stateHeight;
        }
    }
    [_projectStateLbl setFrame:CGRectMake(frame.size.width - stateWidth-paddingRight, (height-stateHeight)/2, stateWidth, stateHeight)];
    _projectStateLbl.layer.cornerRadius = stateHeight / 2;
    
    [self updateInfo];
}

- (void) setInfoWithLogo:(UIImage*)logo name:(NSString*) name status:(NSInteger) status {
    _logo = logo;
    _name = name;
    _status = status;
    
    [self updateViews];
}

- (void) updateStatus:(NSInteger) status {
    _status = status;
    [self updateViews];
}

- (void) updateInfo {
    [_projectLogoImgView setImage:self.logo];
    [_projectNameLbl setText:self.name];
    if(_status > 0) {
        [_projectStateLbl setText:[[NSString alloc] initWithFormat:@"%ld", _status]];
        [_projectStateLbl setHidden:NO];
    } else {
        [_projectStateLbl setHidden:YES];
    }
    
}


@end