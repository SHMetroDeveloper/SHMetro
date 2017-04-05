//
//  AttendanceSettingLocationTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingLocationTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface AttendanceSettingLocationTableViewCell ()
@property (nonatomic, strong) UILabel *locationNameLbl;
@property (nonatomic, strong) UILabel *locationDescLbl;
@property (nonatomic, strong) UILabel *enableStatusLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSettingLocationTableViewCell

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
        
        _locationNameLbl = [UILabel new];
        _locationNameLbl.font = [FMFont getInstance].font42;
        _locationNameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _locationDescLbl = [UILabel new];
        _locationDescLbl.font = [FMFont getInstance].font38;
        _locationDescLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _enableStatusLbl = [UILabel new];
        _enableStatusLbl.font = [FMFont getInstance].font42;
        _enableStatusLbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_enable" inTable:nil];
        _enableStatusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_locationNameLbl];
        [self.contentView addSubview:_locationDescLbl];
        [self.contentView addSubview:_enableStatusLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 20;
    CGFloat sepHeight = 9;
    CGFloat nameHeight = 20;
    CGFloat descHeight = 16.5;
    
    CGFloat originX = padding;
    CGFloat originY = (height - nameHeight - descHeight - sepHeight)/2;
    CGSize statusSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font42 andContent:_enableStatusLbl.text andMaxWidth:MAXFLOAT];
    
    [_locationNameLbl setFrame:CGRectMake(originX, originY, width-padding*3-statusSize.width, nameHeight)];
    [_enableStatusLbl setFrame:CGRectMake(width-padding-statusSize.width, originY, statusSize.width, statusSize.height)];
    originY += sepHeight + nameHeight;
    
    [_locationDescLbl setFrame:CGRectMake(originX, originY, width-padding*2, descHeight)];
    
    if (_isGapped) {
        [_seperator setFrame:CGRectMake(padding, height - [FMSize getInstance].seperatorHeight, width-padding*2, [FMSize getInstance].seperatorHeight)];
    } else {
        [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
    }
    [_seperator setDotted:_isSeperatorDotted];
}

- (void) updateInfo {
    [_locationNameLbl setText:_locationName];
    
    [_locationDescLbl setText:_locationDesc] ;
    
    if (_enable) {
        _enableStatusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _enableStatusLbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_enable" inTable:nil];
    } else {
        _enableStatusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        _enableStatusLbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_disable" inTable:nil];
    }
    
    if (_isShowState) {
        _enableStatusLbl.hidden = NO;
    } else {
        _enableStatusLbl.hidden = YES;
    }
    [self setNeedsLayout];
}

- (void)setIsSeperatorDotted:(BOOL)isSeperatorDotted {
    _isSeperatorDotted = isSeperatorDotted;
}

- (void)setIsGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setIsShowState:(BOOL)isShowState {
    _isShowState = isShowState;
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
}

- (void)setLocationName:(NSString *)locationName {
    _locationName = @"";
    if (![FMUtils isStringEmpty:locationName]) {
        _locationName = locationName;
    }
}

- (void)setLocationDesc:(NSString *)locationDesc {
    _locationDesc = @"";
    if (![FMUtils isStringEmpty:locationDesc]) {
        _locationDesc = locationDesc;
    }
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 76;
    
    return height;
}

@end

