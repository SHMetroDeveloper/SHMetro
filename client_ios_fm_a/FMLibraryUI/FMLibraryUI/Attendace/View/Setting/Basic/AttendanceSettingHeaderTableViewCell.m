//
//  AttendanceSettingHeaderTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingHeaderTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface AttendanceSettingHeaderTableViewCell ()
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, assign) BOOL isInited;
@end


@implementation AttendanceSettingHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews{
    if (!_isInited) {
        _isInited = YES;
        _btnHeight = 48;
        _btnWidth = 80;
        
        
        self.textLabel.font = [FMFont getInstance].font42;
        self.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        
        _settingBtn = [UIButton new];
        [_settingBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_setting" inTable:nil] forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        _settingBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _settingBtn.titleLabel.font = [FMFont getInstance].font42;
        _settingBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _settingBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, [FMSize getInstance].defaultPadding);  //扩大可触控面积，增加用户体验
        [_settingBtn addTarget:self action:@selector(onSettingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_settingBtn];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[FMFont getInstance].font42 forKey:NSFontAttributeName];
    CGSize size = [[[BaseBundle getInstance] getStringByKey:@"attendance_tabbar_btn_setting" inTable:nil] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat originX = width - padding - size.width;
    
    [_settingBtn setFrame:CGRectMake(originX, (height-_btnHeight)/2, size.width + padding, _btnHeight)];
    
    [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
}

- (void) onSettingBtnClick {
    _actionBlock();
}

+ (CGFloat) calculateHeight {
    CGFloat height = 48;
    
    return height;
}

@end
