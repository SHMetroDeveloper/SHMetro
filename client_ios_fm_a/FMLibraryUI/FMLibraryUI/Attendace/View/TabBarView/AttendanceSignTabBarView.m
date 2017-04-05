//
//  AttendanceSignTabBarView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignTabBarView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseBundle.h"


//自定义SignButton
@interface AttendanceTabBarButton : UIButton
@property (nonatomic, strong) NSString *textInfo;
@end

@implementation AttendanceTabBarButton
- (void)setTextInfo:(NSString *)textInfo {
    _textInfo = textInfo;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[FMFont setFontByPX:28] forKey:NSFontAttributeName];
    CGSize size = [_textInfo boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGFloat imageWidth = 26;
    CGFloat sepHeight = 5;
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat padding = (height - imageWidth - sepHeight - size.height)/2 + 2;
    
    CGRect newRect = CGRectMake((width-imageWidth)/2, padding, imageWidth, imageWidth);
    
    return newRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[FMFont setFontByPX:28] forKey:NSFontAttributeName];
    CGSize size = [_textInfo boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGFloat imageWidth = 26;
    CGFloat sepHeight = 5;
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat padding = (height - imageWidth - sepHeight - size.height)/2 + 2;
    
    CGRect newRect =  CGRectMake((width - size.width)/2, padding+imageWidth+sepHeight, size.width, size.height);
    
    return newRect;
}
@end




@interface AttendanceSignTabBarView ()
@property (nonatomic, strong) AttendanceTabBarButton *signBtn;
@property (nonatomic, strong) AttendanceTabBarButton *settingBtn;
@property (nonatomic, strong) SeperatorView *seperator;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation AttendanceSignTabBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _signBtn = [[AttendanceTabBarButton alloc] init];
        [_signBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_sign" inTable:nil] forState:UIControlStateNormal];
        _signBtn.textInfo = [[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_sign" inTable:nil];
        [_signBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
        [_signBtn addTarget:self action:@selector(onSignBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _signBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];;
        _signBtn.titleLabel.font = [FMFont setFontByPX:28];
        [_signBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Sign_Tag_on"] forState:UIControlStateNormal];
        
        
        _settingBtn = [[AttendanceTabBarButton alloc] init];
        [_settingBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_setting" inTable:nil] forState:UIControlStateNormal];
        _settingBtn.textInfo = [[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_setting" inTable:nil];
        [_settingBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(onSettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _settingBtn.titleLabel.font = [FMFont setFontByPX:28];
        [_settingBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Setting_Tag_off"]forState:UIControlStateNormal];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self addSubview:_signBtn];
        [self addSubview:_settingBtn];
        [self addSubview:_seperator];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight = height;
    CGFloat btnWidth = width/2;
    CGFloat originX = 0;
    
    [_seperator setFrame:CGRectMake(0, 0, width, [FMSize getInstance].seperatorHeight)];
    
    [_signBtn setFrame:CGRectMake(originX, 0, btnWidth, itemHeight)];
    originX += btnWidth;
    
    [_settingBtn setFrame:CGRectMake(originX, 0, btnWidth, itemHeight)];
}

- (void) onSignBtnClick {
    [_signBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
    [_signBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Setting_Tag_off"] forState:UIControlStateNormal];
    
    [_settingBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
    [_settingBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Setting_Tag_off"]forState:UIControlStateNormal];
    _actionBlock(SIGN_ACTION_BUTTON_SIGN);
}

- (void) onSettingBtnClick {
    [_signBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
    [_signBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Sign_Tag_off"] forState:UIControlStateNormal];
    
    [_settingBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
    [_settingBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_TabBar_Setting_Tag_on"] forState:UIControlStateNormal];
    _actionBlock(SIGN_ACTION_BUTTON_SETTING);
}


+ (CGFloat) getItemHeight {
    CGFloat height = 49;
    
    return height;
}

@end



