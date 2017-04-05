//
//  AttendanceSignHeaderView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignHeaderView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SystemConfig.h"
#import "UserEntity.h"
#import "BaseDataDBHelper.h"
#import "UIImageView+AFNetWorking.h"
#import "SeperatorView.h"


@interface AttendanceDatePickerButton : UIButton
@end

@implementation AttendanceDatePickerButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[FMFont getInstance].font38 forKey:NSFontAttributeName];
    CGSize size = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat originX = 13;  //button的高度为36，圆弧角度为高的一般，所以这里的X点为半圆的半径
    CGRect newRect = CGRectMake(originX, (height-size.height)/2, size.width, size.height);
    
    return newRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat doub = 0.4;
    CGFloat imageWidth = 30*doub;
    CGFloat imageHeight = 16*doub;
    
    CGRect newRect = CGRectMake(width-13-imageWidth, (height - imageHeight)/2, imageWidth, imageHeight);
    return newRect;
}
@end




@interface AttendanceSignHeaderView()

@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) AttendanceDatePickerButton *datePickerBtn;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) CGFloat nameLblHeight;
@property (nonatomic, assign) CGFloat descLblHeight;
@property (nonatomic, assign) CGFloat thumbnailHeight;
@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSignHeaderView

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
        _nameLblHeight = 19;
        _descLblHeight = 16.5;
        _thumbnailHeight = 48;
        _btnHeight = 36;
        _btnWidth = 116;
        
        
        _thumbnailView = [[UIImageView alloc] init];
        _thumbnailView.layer.masksToBounds = YES;
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font44;  //高度为19
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        
        
//        _descLbl = [[UILabel alloc] init];
//        _descLbl.font = [FMFont getInstance].font38;   //高度为16.5
//        _descLbl.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
        
        
        _datePickerBtn = [[AttendanceDatePickerButton alloc] init];
        [_datePickerBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] forState:UIControlStateNormal];
        _datePickerBtn.layer.borderWidth = 0.5;
        _datePickerBtn.layer.borderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME].CGColor;
        _datePickerBtn.layer.cornerRadius = _btnHeight/2;
        _datePickerBtn.layer.masksToBounds = YES;
        _datePickerBtn.backgroundColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] colorWithAlphaComponent:0.05];
        _datePickerBtn.titleLabel.font = [FMFont getInstance].font38;
        [_datePickerBtn addTarget:self action:@selector(datePicker) forControlEvents:UIControlEventTouchUpInside];
        NSString *time = [FMUtils getTimeDescriptionByDate:[NSDate date] format:@"yyyy.MM.dd"];
        [_datePickerBtn setTitle:time forState:UIControlStateNormal];
        [_datePickerBtn setImage:[[FMTheme getInstance]  getImageByName:@"Sign_Date_Picker_Button_Arrow_down"] forState:UIControlStateNormal];
        
        _seperator = [[SeperatorView alloc] init];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_thumbnailView];
        [self addSubview:_nameLbl];
//        [self addSubview:_descLbl];
        [self addSubview:_datePickerBtn];
        [self addSubview:_seperator];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 10;
    
    CGFloat originX = padding;
    CGFloat originY = (height - _thumbnailHeight)/2;
    
    _thumbnailView.layer.cornerRadius = _thumbnailHeight/2;
    [_thumbnailView setFrame:CGRectMake(originX, originY, _thumbnailHeight, _thumbnailHeight)];
    originX += _thumbnailHeight + padding;
    
    [_nameLbl setFrame:CGRectMake(originX, (height - _nameLblHeight)/2, width-_thumbnailHeight-_btnWidth-padding*4, _nameLblHeight)];
    
//    CGFloat sepHeight = (_thumbnailHeight - _nameLblHeight - _descLblHeight)/3;
//    originY += sepHeight;
//    [_nameLbl setFrame:CGRectMake(originX, originY, width-_thumbnailHeight-_btnWidth-padding*4, _nameLblHeight)];
//    originY += _nameLblHeight + sepHeight;
    
//    [_descLbl setFrame:CGRectMake(originX, originY, width-_thumbnailHeight-_btnWidth-padding*4, _descLblHeight)];
    
    [_datePickerBtn setFrame:CGRectMake(width-padding-_btnWidth, (height - _btnHeight)/2, _btnWidth, _btnHeight)];
    
    [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight*2, width, [FMSize getInstance].seperatorHeight*2)];
    
    [self updateInfo];
}

- (void) updateInfo {
    NSNumber * userId = [SystemConfig getUserId];
    UserInfo * user = [[BaseDataDbHelper getInstance] queryUserById:userId];
    [_thumbnailView setImageWithURL:[FMUtils getUrlOfImageById:user.pictureId] placeholderImage:[[FMTheme getInstance]  getImageByName:@"user_default_head"]];
    
    if (![FMUtils isStringEmpty:user.name]) {
        [_nameLbl setText:user.name];
    } else {
        [_nameLbl setText:@""];
    }
    
    if (![FMUtils isStringEmpty:user.organizationName]) {
        [_descLbl setText:user.organizationName];
    } else {
        [_descLbl setText:@""];
    }
}

- (void) setDateTime:(NSNumber *) datetime {
    if (![FMUtils isNumberNullOrZero:datetime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:datetime format:@"yyyy.MM.dd"];
        [_datePickerBtn setTitle:time forState:UIControlStateNormal];
    }
}

- (void) datePicker {
    _actionBlock();
}

+ (CGFloat) calculateHeight {
    CGFloat height = 66;
    
    return height;
}

@end

