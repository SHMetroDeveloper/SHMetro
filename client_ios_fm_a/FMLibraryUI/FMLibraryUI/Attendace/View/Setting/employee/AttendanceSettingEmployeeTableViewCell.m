//
//  AttendanceSettingEmployeeTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingEmployeeTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"

@interface AttendanceSettingEmployeeTableViewCell()

@property (nonatomic, strong) UILabel *employeeLbl;
@property (nonatomic, strong) UILabel *workTeamLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSettingEmployeeTableViewCell

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
        
        _employeeLbl = [UILabel new];
        _employeeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _employeeLbl.font = [FMFont getInstance].font42;
        
        _workTeamLbl = [UILabel new];
        _workTeamLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        _workTeamLbl.font = [FMFont getInstance].font42;
        
        
        _descLbl = [UILabel new];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        _descLbl.font = [FMFont getInstance].font42;
        
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_employeeLbl];
        [self.contentView addSubview:_workTeamLbl];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGSize employeeSize = [FMUtils getLabelSizeBy:_employeeLbl andContent:_employeeLbl.text andMaxLabelWidth:width];
    [_employeeLbl setFrame:CGRectMake(padding, (height- employeeSize.height)/2, employeeSize.width, employeeSize.height)];
    
    
    CGSize descSize = [FMUtils getLabelSizeBy:_descLbl andContent:_descLbl.text andMaxLabelWidth:width];
    [_descLbl setFrame:CGRectMake(width - padding - descSize.width, (height - descSize.height)/2, descSize.width, descSize.height)];
    
    
    CGSize workTeamSize = [FMUtils getLabelSizeBy:_workTeamLbl andContent:_workTeamLbl.text andMaxLabelWidth:width];
    [_workTeamLbl setFrame:CGRectMake((width - workTeamSize.width)/2, (height - workTeamSize.height)/2, workTeamSize.width, workTeamSize.height)];
    
    
    if (_isGapped) {
        [_seperator setFrame:CGRectMake(padding, height - [FMSize getInstance].seperatorHeight, width-padding*2, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:YES];
    } else {
        [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void) updateInfo {
    [_employeeLbl setText:_employeeName];
    
    [_workTeamLbl setText:_workTeamName];
    
    [_descLbl setText:_employeeDesc];
    
    [self setNeedsLayout];
}

- (void)setIsGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setEmployeeName:(NSString *)employeeName {
    _employeeName = @"";
    if (![FMUtils isStringEmpty:employeeName]) {
        _employeeName = employeeName;
    }
}

- (void)setWorkTeamName:(NSString *)workTeamName {
    _workTeamName = @"";
    if (![FMUtils isStringEmpty:workTeamName]) {
        _workTeamName = workTeamName;
    }
}

- (void)setEmployeeDesc:(NSString *)employeeDesc {
    _employeeDesc = @"";
    if (![FMUtils isStringEmpty:employeeDesc]) {
        _employeeDesc = employeeDesc;
    }
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 48;
    return height;
}

@end
