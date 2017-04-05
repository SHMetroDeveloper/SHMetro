//
//  WifiDetailTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/9.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "WifiDetailTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "SeperatorView.h"

@interface WifiDetailTableViewCell()
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIButton *enableBtn;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *enableDesc;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation WifiDetailTableViewCell
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
        _descLbl.font = [FMFont getInstance].font42;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _descLbl.textAlignment = NSTextAlignmentRight;
        
        _enableBtn = [UIButton new];
        _enableDesc = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_enable" inTable:nil];
        [_enableBtn setTitle:_enableDesc forState:UIControlStateNormal];
        [_enableBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
//        [_enableBtn addTarget:self action:@selector(onEnableBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _enableBtn.titleLabel.font = [FMFont getInstance].font42;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_enableBtn];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat originX = padding;
    
    
    CGSize nameSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font42 andContent:_name andMaxWidth:width];
    CGSize enableSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font42 andContent:_enableDesc andMaxWidth:width];
    CGSize descSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font42 andContent:_desc andMaxWidth:width];

    [_nameLbl setFrame:CGRectMake(originX, (height-nameSize.height)/2, width/2-padding*2, nameSize.height)];
    
    [_descLbl setFrame:CGRectMake(width-padding-descSize.width, (height-descSize.height)/2, descSize.width, descSize.height)];
    
    [_enableBtn setFrame:CGRectMake((width-enableSize.width-10)/2, 0, enableSize.width+10, height)];
    
    if(_isLast) {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];
    } else {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height - seperatorHeight, width-padding*2, seperatorHeight)];
    }
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_descLbl setText:_desc];
    if (_isEnable) {
        _enableDesc = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_enable" inTable:nil];
        [_enableBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
    } else {
        _enableDesc = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_configuration_disable" inTable:nil];
        [_enableBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] forState:UIControlStateNormal];
    }
    [_enableBtn setTitle:_enableDesc forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

#pragma mark - Setter
- (void)setIsEnable:(BOOL)isEnable {
    _isEnable = isEnable;
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
}

- (void)setName:(NSString *)name {
    _name = @"";
    if (![FMUtils isStringEmpty:name]) {
        _name = name;
    }
}

- (void)setDesc:(NSString *)desc {
    _desc = @"";
    if (![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    }
    [self updateInfo];
}

- (void) onEnableBtnClick {
    _actionBlock(!_isEnable);
}

+ (CGFloat) calculateHeight {
    CGFloat height = 48;
    return height;
}

@end

