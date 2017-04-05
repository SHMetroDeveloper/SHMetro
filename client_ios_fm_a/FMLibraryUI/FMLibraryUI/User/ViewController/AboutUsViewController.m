//
//  AboutUsViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIButton+Bootstrap.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "SystemConfig.h"
#import "BaseBundle.h"


@interface AboutUsViewController ()

@property (readwrite, nonatomic, strong) UIImageView * logoImgView; //logo

@property (readwrite, nonatomic, strong) UILabel* nameLbl;          //名字
//@property (readwrite, nonatomic, strong) UILabel* versionLbl;       //版本号

@property (readwrite, nonatomic, strong) UILabel* companyLbl;     //公司申明
@property (readwrite, nonatomic, strong) UILabel* copyrightLbl;     //版权申明
@property (readwrite, nonatomic, strong) UILabel* noteLbl;     //申明


@property (readwrite, nonatomic, strong) UIView* mainContainerView;

@property (readwrite, nonatomic, assign) CGFloat logoWidth;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * version;

@property (readwrite, nonatomic, strong) NSString * company;
@property (readwrite, nonatomic, strong) NSString * copyright;
@property (readwrite, nonatomic, strong) NSString * note;

@property (readwrite, nonatomic, strong) UIFont * mFont;
@end

@implementation AboutUsViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void) initSettings {
    _logoWidth = 65;
    
    _name = [SystemConfig getProductName];
//    _version = [SystemConfig getCurrentVersion];
    _version = [[BaseBundle getInstance] getStringByKey:@"about_us_version_beta" inTable:nil];
    
//    _company = NSLocalizedString(@"about_company_name", nil);
    _company = [[BaseBundle getInstance] getStringByKey:@"about_company_name" inTable:nil];
    _copyright = @"Copyright © 2016 FacilityONE.";
    _note = @"All Rights Reserved.";
    _mFont = [FMFont getInstance].defaultFontLevel3;
}

- (void) initViews {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat labelHeight = 40;
    
    CGFloat logoOrigin = height/4;
    CGFloat sepHeight = 6;
    CGFloat paddingBottom = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 20;
    CGFloat originY = 0;
    
    UIFont * nameFont = [FMFont fontWithSize:16];
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((width - _logoWidth)/2, logoOrigin, _logoWidth, _logoWidth)];
    [_logoImgView setImage:[[FMTheme getInstance] getImageByName:@"logo_about"]];
    
    _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, logoOrigin + _logoWidth + sepHeight, width, labelHeight)];
    _nameLbl.text = [[NSString alloc] initWithFormat:@"%@ %@", _name, _version];
    _nameLbl.font = nameFont;
    _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _nameLbl.textAlignment = NSTextAlignmentCenter;
    
    
    originY = height - paddingBottom - itemHeight * 3 ;
    _companyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
    _companyLbl.textAlignment = NSTextAlignmentCenter;
    _companyLbl.text = _company;
    _companyLbl.font = _mFont;
    _companyLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
    originY += itemHeight ;
    _copyrightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
    _copyrightLbl.textAlignment = NSTextAlignmentCenter;
    _copyrightLbl.text = _copyright;
    _copyrightLbl.font = _mFont;
    _copyrightLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
    originY += itemHeight;
    _noteLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
    _noteLbl.textAlignment = NSTextAlignmentCenter;
    _noteLbl.text = _note;
    _noteLbl.font = _mFont;
    _noteLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
    
    [_mainContainerView addSubview:_logoImgView];
    [_mainContainerView addSubview:_nameLbl];
    
    [_mainContainerView addSubview:_companyLbl];
    [_mainContainerView addSubview:_copyrightLbl];
    [_mainContainerView addSubview:_noteLbl];
    
    [self.view addSubview:_mainContainerView];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initSettings];
    [self initViews];
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting_about" inTable:nil]];
    [self setBackAble:YES];
}



@end
