//
//  AttendanceSignInView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignInTableViewCell.h"
#import "FMUtilsPackages.h"
#import "AttendanceConfig.h"
#import "FMTheme.h"

#import "BaseBundle.h"
@interface AttendanceSignInTableViewCell ()

@property (nonatomic, strong) UILabel *timeLineTop;
@property (nonatomic, strong) UIButton *tagLbl;                // 圆形的 “上” 字样
@property (nonatomic, strong) UILabel *signInTimeLbl;         // 跟在后面的签入时间
@property (nonatomic, strong) UILabel *timeLineBottom;

@property (nonatomic, strong) UIImageView *signTypeImgView;   //签到类别图标
@property (nonatomic, strong) UILabel *signDescLbl;           //定位信息，或者是wifi信息
@property (nonatomic, strong) UILabel *statusLbl;             //正常or不正常

@property (nonatomic, assign) CGFloat tagWidth;  //“入” 图标宽度
@property (nonatomic, assign) CGFloat signInTimeHeight;  //签入时间label高度
@property (nonatomic, assign) CGFloat signDescHeight;   //签到说明高度
@property (nonatomic, assign) CGFloat statusHeight;     //状态label的高度

@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, assign) NSInteger signInType;
@property (nonatomic, assign) BOOL isSignIn;
@property (nonatomic, strong) NSString *signDesc;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSignInTableViewCell

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
        _signInTimeHeight = 19;
        _signDescHeight = 16.5;
        _statusHeight = 16;
        
        
        //时间线
        _timeLineTop = [[UILabel alloc] init];
        _timeLineTop.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        
        _timeLineBottom = [[UILabel alloc] init];
        _timeLineBottom.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        
        
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
        [_tagLbl setBackgroundImage:[[FMTheme getInstance] getImageByName:@"sign_tag_status_off"] forState:UIControlStateNormal];
        
        
        _signInTimeLbl = [UILabel new];
        _signInTimeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        _signInTimeLbl.font = [FMFont getInstance].font44;
        _signInTimeLbl.text = @"签入时间 08:45";
        
        
        _signTypeImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"Sign_Type_Icon_WiFi"]];
        
        _signDescLbl = [UILabel new];
        _signDescLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _signDescLbl.font = [FMFont getInstance].font38;
        _signDescLbl.text = @"FM-IT-3_5G 08:6d:41:e7:83:2a";
        
        
        _statusLbl = [UILabel new];
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl.font = [FMFont setFontByPX:32];
        _statusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _statusLbl.backgroundColor = [UIColor colorWithRed:58/255.0 green:179/255.0 blue:147/255.0 alpha:1];
        _statusLbl.layer.cornerRadius = _statusHeight/2;
        _statusLbl.layer.masksToBounds = YES;
        _statusLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_status_normal" inTable:nil];
        
        
        [self.contentView addSubview:_timeLineTop];
        [self.contentView addSubview:_tagLbl];
        [self.contentView addSubview:_signInTimeLbl];
        [self.contentView addSubview:_timeLineBottom];
        
        [self.contentView addSubview:_signTypeImgView];
        [self.contentView addSubview:_signDescLbl];
        [self.contentView addSubview:_statusLbl];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
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
    originX += _tagWidth/2;
    originY += _tagWidth;
    
    [_timeLineBottom setFrame:CGRectMake(originX, originY, [FMSize getInstance].defaultBorderWidth, height - sepHeight - _tagWidth)];
    originY = sepHeight;
    originX = padding + _tagWidth + sepHeight;
    
    [_signInTimeLbl setFrame:CGRectMake(originX, originY + (_tagWidth - _signInTimeHeight)/2, width - padding*2 - sepHeight - _tagWidth, _signInTimeHeight)];
    originY += _signInTimeHeight + sepHeight;
    
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel4;
//    if (_isSignIn) {
        _signTypeImgView.hidden = NO;
        _signDescLbl.hidden = NO;
        
        [_signTypeImgView setFrame:CGRectMake(originX, originY + (_signDescHeight - imgWidth)/2, imgWidth, imgWidth)];
        originX += imgWidth + 6;
        
        [_signDescLbl setFrame:CGRectMake(originX, originY, width - padding*2 - sepHeight - _tagWidth - imgWidth- 6, _signDescHeight)];
        originY += _signDescHeight + sepHeight;
//    } else {
//        _signTypeImgView.hidden = YES;
//        _signDescLbl.hidden = YES;
//        originX += imgWidth + 5;
//    }
    originX = padding + _tagWidth + sepHeight;
    
    
    CGSize lblSize = [FMUtils getLabelSizeBy:_statusLbl andContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_normal" inTable:nil] andMaxLabelWidth:200];
    [_statusLbl setFrame:CGRectMake(originX, originY, lblSize.width + 15, _statusHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    if (_isSignIn) {
        [_tagLbl setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_in" inTable:nil] forState:UIControlStateNormal];
        NSString *time  = [FMUtils getDateTimeDescriptionBy:_time format:@"MM-dd HH:mm"];
        [_signInTimeLbl setText:[NSString stringWithFormat:@"%@ %@",[[BaseBundle getInstance] getStringByKey:@"attendance_time_type_sign_IN" inTable:nil],time]];
    } else {
        [_tagLbl setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_sign_out" inTable:nil] forState:UIControlStateNormal];
        NSString *time  = [FMUtils getDateTimeDescriptionBy:_time format:@"MM-dd HH:mm"];
        [_signInTimeLbl setText:[NSString stringWithFormat:@"%@ %@",[[BaseBundle getInstance] getStringByKey:@"attendance_time_type_sign_OUT" inTable:nil],time]];
    }
    
    UIImage *image = [AttendanceConfig getSignInTypeImageDescByType:_signInType];
    [_signTypeImgView setImage:image];
    
    [_signDescLbl setText:_signDesc];
}


- (void)setIsTopTimeLineShow:(BOOL)isTopTimeLineShow {
    _isTopTimeLineShow = isTopTimeLineShow;
    
}

- (void) setSignInfoWithTime:(NSNumber *) time
                    signType:(NSInteger ) type
                    isSignIn:(BOOL ) isSignIn
                    signDesc:(NSString *) desc {
    
    _time = time;
    _signInType = type;
    _isSignIn = isSignIn;
    _signDesc = desc;
    
    [self setNeedsLayout];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    height = 116;
    
    return height;
}


@end
