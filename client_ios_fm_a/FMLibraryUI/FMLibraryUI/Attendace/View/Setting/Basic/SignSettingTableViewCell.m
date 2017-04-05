//
//  SignSettingTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "SignSettingTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "SeperatorView.h"

@interface SignSettingTableViewCell ()

@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UILabel * statusLbl;
@property (nonatomic, strong) UILabel * descLbl;

@property (nonatomic, strong) SeperatorView *seperator;


@property (nonatomic, assign) BOOL isInited;

@end

@implementation SignSettingTableViewCell

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
        
        _nameLbl = [UILabel new];
        _nameLbl.font = [FMFont getInstance].font42;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _descLbl = [UILabel new];
        _descLbl.font = [FMFont getInstance].font38;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        
        _descLbl.textAlignment = NSTextAlignmentRight;
        
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.font = [FMFont getInstance].font38;
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 20;
    CGFloat sepWidth = 8;
    
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    NSString * strStatus = [self getStatusDescription];
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    CGFloat descWidth = [FMUtils widthForString:_descLbl value:_desc];
    CGFloat statusWidth = [FMUtils widthForString:_statusLbl value:strStatus];
    
    if(nameWidth + descWidth + statusWidth + sepWidth * 2 + padding * 2 > width) {
        descWidth = width - padding * 2 - nameWidth - sepWidth * 2 - statusWidth;
    }
    [_nameLbl setFrame:CGRectMake(padding, 0, nameWidth, height)];
    [_statusLbl setFrame:CGRectMake(padding+nameWidth+sepWidth, 0, statusWidth, height)];
    [_descLbl setFrame:CGRectMake(width-padding-descWidth, 0, descWidth, height)];
    
    if(_isLast) {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];
    } else {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(paddingLeft, height - seperatorHeight, width-paddingLeft*2, seperatorHeight)];
    }
}

- (NSString *) getStatusDescription {
    NSString * res = @"";
    if(_enable) {
        res = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_status_enable" inTable:nil];
    } else {
        res = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_status_unable" inTable:nil];
    }
    return res;
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_descLbl setText:_desc] ;
    
    NSString * strStatus = [self getStatusDescription];
    [_statusLbl setText:strStatus];
    if(_enable) {
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
    } else {
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
    }
    
    [self setNeedsLayout];
}

- (void)setName:(NSString *)name {
    _name = @"";
    if (![FMUtils isStringEmpty:name]) {
        _name = name;
    }
    [self updateInfo];
}

- (void)setDesc:(NSString *)desc {
    _desc = @"";
    if (![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    }
    [self updateInfo];
}

- (void) setEnable:(BOOL)enable {
    _enable = enable;
    [self updateInfo];
}

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    [self updateInfo];
}


@end

