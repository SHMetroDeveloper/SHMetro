//
//  AttendanceSignOutView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignButtonTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTimeLabel.h"
#import "AttendanceConfig.h"
#import "FMTheme.h"
#import "UIControl+FMControl.h"
#import "UIButton+OnceResponse.h"
#import "BaseBundle.h"

@interface SpecialSignButton : UIButton
@property (nonatomic, strong) FMTimeLabel *timeLabel;
@end

@implementation SpecialSignButton
- (instancetype)init {
    self = [super init];
    if (self) {
        _timeLabel = [[FMTimeLabel alloc] init];
        _timeLabel.font = [FMFont getInstance].font44;
        _timeLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_timeLabel];
        
        self.custom_acceptEventInterval = 0.0f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGSize titleSize = [FMUtils getLabelSizeByFont:[UIFont fontWithName:@"Arial-BoldMT" size:(56 * 72.f)/192.f] andContent:self.currentTitle andMaxWidth:width];
    CGSize timeSize = [FMTimeLabel calculateSizeByFont:[FMFont getInstance].font44];
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat timeWidth = 70.0f;  //实际为65左右，此处放大5pt为的是不冲突
    CGFloat originX = (width - timeWidth)/2;;
    CGFloat originY = (height - titleSize.height - padding - timeSize.height)/2 + titleSize.height + padding;
    
    [_timeLabel setFrame:CGRectMake(originX, originY, timeWidth, timeSize.height)];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGSize titleSize = [FMUtils getLabelSizeByFont:[UIFont fontWithName:@"Arial-BoldMT" size:(56 * 72.f)/192.f] andContent:self.currentTitle andMaxWidth:width];
    CGSize timeSize = [FMTimeLabel calculateSizeByFont:[FMFont getInstance].font42];
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originX = (width - titleSize.width)/2;
    CGFloat originY = (height - titleSize.height - padding - timeSize.height)/2;
    
    CGRect newRect = CGRectMake(originX, originY + 8, titleSize.width, titleSize.height);
    
    return newRect;
}
@end



@interface AttendanceSignButtonTableViewCell ()
@property (nonatomic, strong) UILabel *timeLineTop;
@property (nonatomic, strong) UIButton *tagLbl;                // 圆形的 “上”/“下” 字眼
@property (nonatomic, strong) UILabel *tagDescLbl;            // 跟在上下图标后面的描述

@property (nonatomic, strong) SpecialSignButton *signButton;           //签到按钮

@property (nonatomic, strong) UIImageView *signStatusImgView; //签到状态图标
@property (nonatomic, strong) UILabel *signStatusDescLbl;     //签到状态描述

@property (nonatomic, assign) CGFloat buttonWidth;    //签到按钮的宽度
@property (nonatomic, assign) CGFloat tagWidth;    //“入” 图标宽度
@property (nonatomic, assign) CGFloat tagDescHeight;  //签入描述高度

@property (nonatomic, assign) BOOL timeCondition;
@property (nonatomic, assign) BOOL employeeCondition;
@property (nonatomic, assign) BOOL editCondition;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation AttendanceSignButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        _tagWidth = 20;
        _tagDescHeight = 19;
        _buttonWidth = [FMSize getInstance].screenWidth*0.375;
        
        
        _timeLineTop = [UILabel new];
        _timeLineTop.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        
        
        _tagLbl = [UIButton new];
        if ([[FMUtils getPreferredLanguage] isEqualToString:@"zh_CN"]) {
            _tagLbl.titleLabel.font = [FMFont setFontByPX:30];
        } else if ([[FMUtils getPreferredLanguage] isEqualToString:@"en_US"]) {
            _tagLbl.titleLabel.font = [FMFont setFontByPX:24];
        }
        _tagLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_tagLbl setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [_tagLbl setTitle:@"入" forState:UIControlStateNormal];
        _tagLbl.layer.cornerRadius = _tagWidth/2;
        _tagLbl.layer.masksToBounds = YES;
        _tagLbl.clipsToBounds = YES;
        _tagLbl.layer.borderColor = [UIColor clearColor].CGColor;
        _tagLbl.layer.borderWidth = 0.0f;
        [_tagLbl setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_tag_status_on"] forState:UIControlStateNormal];
        
        
        
        _tagDescLbl = [UILabel new];
        _tagDescLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        _tagDescLbl.font = [FMFont getInstance].font44;
        _tagDescLbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_IN" inTable:nil];
        
        
        _signButton = [SpecialSignButton new];
        _signButton.exclusiveTouch = YES;
        _signButton.layer.masksToBounds = YES;
        _signButton.layer.cornerRadius = _buttonWidth/2;
//        _signButton.titleLabel.font = [FMFont setFontByPX:56];
        _signButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(56 * 72.f)/192.f];
        
        [_signButton setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_IN" inTable:nil] forState:UIControlStateNormal];
        [_signButton setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_in_backgroundImage_on"] forState:UIControlStateNormal];
        [_signButton addTarget:self action:@selector(onSignInButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_signButton setNeedLimited:[NSNumber numberWithInteger:1000]];
        
        _signStatusImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"Sign_Status_Check_in"]];
        
        
        _signStatusDescLbl = [UILabel new];
        _signStatusDescLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _signStatusDescLbl.font = [FMFont setFontByPX:32];
        
        
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:255/255.0 blue:253/255.0 alpha:1];
        
        [self.contentView addSubview:_timeLineTop];
        [self.contentView addSubview:_tagLbl];
        [self.contentView addSubview:_tagDescLbl];
        [self.contentView addSubview:_signButton];
        
        [self.contentView addSubview:_signStatusImgView];
        [self.contentView addSubview:_signStatusDescLbl];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
//    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat padding = 14;
    CGFloat sepHeight = 10;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    if (_isTopTimeLineShow) {
        _timeLineTop.hidden = NO;
        [_timeLineTop setFrame:CGRectMake(padding + _tagWidth/2, 0, [FMSize getInstance].defaultBorderWidth, sepHeight)];
    } else {
        _timeLineTop.hidden = YES;
    }
    
    [_tagLbl setFrame:CGRectMake(originX, originY, _tagWidth, _tagWidth)];
    originX += _tagWidth + sepHeight;
    
    [_tagDescLbl setFrame:CGRectMake(originX, originY+(_tagWidth-_tagDescHeight)/2, width - padding*3 - _tagWidth, _tagDescHeight)];
    originY += _tagDescHeight + 30; //距离button需要多一点空隙此处暂定为30
    originX = (width - _buttonWidth)/2;
    
    [_signButton setFrame:CGRectMake(originX, originY, _buttonWidth, _buttonWidth)];
    originY += _buttonWidth + padding + 8; //扩大状态与button之间的距离
    
    CGFloat imgWidth = 14;
    CGSize signStatusDescSize = [FMUtils getLabelSizeBy:_signStatusDescLbl andContent:_signStatusDescLbl.text andMaxLabelWidth:width-padding*2-imgWidth-sepHeight];
    CGFloat signStatusDescWidth = signStatusDescSize.width;
    if (imgWidth + 6 + signStatusDescWidth >= width - padding*2) {  // 6 为状态按钮与状态描述之间的距离
        signStatusDescWidth = width - imgWidth - 6 - padding*2;
    }
    originX = (width - 6 - imgWidth - signStatusDescWidth)/2;
    [_signStatusImgView setFrame:CGRectMake(originX, originY, imgWidth, imgWidth)];
    originX += imgWidth + 6;
    [_signStatusDescLbl setFrame:CGRectMake(originX, originY, signStatusDescWidth, signStatusDescSize.height)];
}

- (void) updateInfo {
    //签入签出显示判断
    if (_isSignIn) {
        [_tagLbl setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_in" inTable:nil] forState:UIControlStateNormal];
        [_tagDescLbl setText:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_IN" inTable:nil]];
        [_signButton setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_IN" inTable:nil] forState:UIControlStateNormal];
        [_signStatusDescLbl setText:_signStatusDesc];
    } else {
        [_tagLbl setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_out" inTable:nil] forState:UIControlStateNormal];
        [_tagDescLbl setText:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_OUT" inTable:nil]];
        [_signButton setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_type_sign_OUT" inTable:nil] forState:UIControlStateNormal];
        [_signStatusDescLbl setText:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_leave" inTable:nil]];
    }
    
    
    if (_isSignIn && _editCondition && _timeCondition && _employeeCondition) {
        //允许签入
        [_tagLbl setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_tag_status_on"] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_in_backgroundImage_on"] forState:UIControlStateNormal];
        [_signStatusImgView setImage:[[FMTheme getInstance]  getImageByName:@"Sign_Status_Check_in"]];
    } else if (!_isSignIn && _timeCondition && _employeeCondition) {
        //允许签出
        [_tagLbl setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_tag_status_on"] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_in_backgroundImage_on"] forState:UIControlStateNormal];
        [_signStatusImgView setImage:[[FMTheme getInstance]  getImageByName:@"Sign_Status_Check_in"]];
    } else {
        //不允许操作状态
        [_tagLbl setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_tag_status_off"] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_in_backgroundImage_off"] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_in_backgroundImage_off"] forState:UIControlStateHighlighted];
        [_signStatusImgView setImage:[[FMTheme getInstance]  getImageByName:@"Sign_Status_Check_off"]];
        [_signStatusDescLbl setText:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_forbidden" inTable:nil]];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter
- (void)setIsTopTimeLineShow:(BOOL)isTopTimeLineShow {
    _isTopTimeLineShow = isTopTimeLineShow;
}

- (void)setQueryTime:(NSNumber *)queryTime {
    _queryTime = queryTime;
    NSInteger status = [FMUtils compareTimeA:[FMUtils getTimeLongNow] withTimeB:_queryTime];
    _timeCondition = NO;
    if (status == 0) {
        _timeCondition = YES;
    }
}

- (void)setEmployeeType:(NSInteger)employeeType {
    _employeeType = employeeType;
    _employeeCondition = YES;
    if (_employeeType == 0) {
        _employeeCondition = NO;
    }
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    _editCondition = _editable;
}

- (void) setIsSignIn:(BOOL)isSignIn {
    _isSignIn = isSignIn;
}

- (void)setSignStatusDesc:(NSString *)signStatusDesc {
    _signStatusDesc = @"";
    if (![FMUtils isStringEmpty:signStatusDesc]) {
        _signStatusDesc = signStatusDesc;
    }
    [self updateInfo];
}

#pragma mark - ActionEvent
- (void) onSignInButtonClick {
    
    if (_isSignIn && _editCondition && _timeCondition && _employeeCondition) {
        //允许签入
        _actionBlock(SIGN_BUTTON_EVENT_TYPE_IN);
    } else if (!_isSignIn && _timeCondition && _employeeCondition) {
        //允许签出
        _actionBlock(SIGN_BUTTON_EVENT_TYPE_OUT);
    }
}

#pragma mark - CalculateHeight
+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat btnWidth = [FMSize getInstance].screenWidth*0.375;
    height = 120.5 + btnWidth;
    
    return height;
}

@end
