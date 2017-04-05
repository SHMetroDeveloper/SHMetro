//
//  AttendancePoetryTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/20.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignPoetryTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"

@interface AttendanceSignPoetryTableViewCell()

@property (nonatomic, strong) UILabel *poetryLbl;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation AttendanceSignPoetryTableViewCell

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
        
        _poetryLbl = [UILabel new];
        _poetryLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        _poetryLbl.font = [FMFont getInstance].font38;
        _poetryLbl.numberOfLines = 0;
        
        [self.contentView addSubview:_poetryLbl];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originX = padding;
    CGFloat originY = 20;
    
    CGSize poetryLblSize = [FMUtils getLabelSizeBy:_poetryLbl andContent:_poetry andMaxLabelWidth:width-padding*2];
    [_poetryLbl setFrame:CGRectMake(originX, originY, poetryLblSize.width, poetryLblSize.height)];
    
}

- (void) updateInfo {
    [_poetryLbl setText:_poetry];
    [self setNeedsLayout];
}

- (void)setPoetry:(NSString *)poetry {
    _poetry = @"今天太宝贵，但他已经一去不复返";
    if (![FMUtils isStringEmpty:poetry]) {
        _poetry = poetry;
    }
    [self updateInfo];
}


+ (CGFloat) calculateHeightBy:(NSString *) poetry {
    CGFloat height = 0;
    CGFloat width = [FMSize getInstance].screenWidth;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat paddingTop = 20;
    UILabel *targetLbl = [UILabel new];
    targetLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
    targetLbl.font = [FMFont getInstance].font38;
    targetLbl.numberOfLines = 0;
    CGSize targetLblSize = [FMUtils getLabelSizeBy:targetLbl andContent:poetry andMaxLabelWidth:width-padding*2];
    
    height = paddingTop*2 + targetLblSize.height;
    
    return height;
}
@end
