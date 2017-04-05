//
//  AttendanceSettingWifiTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"

@interface BaseTableViewCell ()

@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UILabel * descLbl;

@property (nonatomic, strong) SeperatorView *seperator;




@property (nonatomic, assign) BOOL isInited;

@end

@implementation BaseTableViewCell

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
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_descLbl];
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
    
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    CGFloat descWidth = [FMUtils widthForString:_descLbl value:_desc];
    if(nameWidth + descWidth + sepWidth + padding * 2 > width) {
        descWidth = width - padding * 2 - nameWidth - sepWidth;
    }
    [_nameLbl setFrame:CGRectMake(padding, 0, nameWidth, height)];
    [_descLbl setFrame:CGRectMake(width-padding-descWidth, 0, descWidth, height)];
    
    if(_isLast) {
        [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];
        [_seperator setDotted:NO];
    } else {
        [_seperator setFrame:CGRectMake(paddingLeft, height - seperatorHeight, width-paddingLeft*2, seperatorHeight)];
        [_seperator setDotted:YES];
    }
    
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    [_descLbl setText:_desc] ;
    
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

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    [self updateInfo];
}


@end

