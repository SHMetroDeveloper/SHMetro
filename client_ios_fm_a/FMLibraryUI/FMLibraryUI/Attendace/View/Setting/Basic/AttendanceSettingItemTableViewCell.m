//
//  AttendanceSettingItemTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingItemTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"

@interface AttendanceSettingItemTableViewCell ()
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) SeperatorView *seperator;


@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSettingItemTableViewCell

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
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        
        _descriptionLbl = [UILabel new];
        _descriptionLbl.font = [FMFont getInstance].font42;
        _descriptionLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_descriptionLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 20;
    
    CGSize nameSize = [FMUtils getLabelSizeBy:_nameLbl andContent:_nameLbl.text andMaxLabelWidth:width];
    [_nameLbl setFrame:CGRectMake(padding, (height - nameSize.height)/2, nameSize.width, nameSize.height)];
    
    CGSize descSize = [FMUtils getLabelSizeBy:_descriptionLbl andContent:_descriptionLbl.text andMaxLabelWidth:width];
    [_descriptionLbl setFrame:CGRectMake(width - padding - descSize.width, (height - descSize.height)/2, descSize.width, descSize.height)];
    
    if (_isAlternated) {
        [_seperator setFrame:CGRectMake([FMSize getInstance].defaultPadding, height-[FMSize getInstance].seperatorHeight, width-[FMSize getInstance].defaultPadding*2, [FMSize getInstance].seperatorHeight)];
    } else {
        [_seperator setFrame:CGRectMake(0, height-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
    }
    
}

- (void) updateInfo {
    [_descriptionLbl setText:_desc];
    
    [_nameLbl setText:_name];
    
    _descriptionLbl.textColor = _descriptionColor;
    
    if (_isSeperatorDotted) {
        [_seperator setDotted:YES];
    } else {
        [_seperator setDotted:NO];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter
- (void)setIsSeperatorDotted:(BOOL)isSeperatorDotted {
    _isSeperatorDotted = isSeperatorDotted;
}

- (void)setIsAlternated:(BOOL)isAlternated {
    _isAlternated = isAlternated;
}

- (void)setDescriptionColor:(UIColor *)descriptionColor {
    if (!descriptionColor) {
        _descriptionColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    }
    _descriptionColor = descriptionColor;
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

+ (CGFloat) calculateHeight {
    CGFloat height = 48;
    
    return height;
}

@end
