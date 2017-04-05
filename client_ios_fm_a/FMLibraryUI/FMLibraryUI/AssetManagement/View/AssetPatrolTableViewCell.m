//
//  AssetPatrolTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetPatrolTableViewCell.h"
#import "FMUtilsPackages.h"
#import "ColorLabel.h"
#import "SeperatorView.h"

@interface AssetPatrolTableViewCell ()
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) ColorLabel *statusLbl;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetPatrolTableViewCell

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
        _nameLbl.font = [FMFont getInstance].font38;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];
        
        _tagImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_tagImgView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 15;
    CGFloat itemHeight = 17;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    
    CGFloat originX = padding;
    
    CGSize stateSize = [ColorLabel calculateSizeByInfo:_statusStr];
    
    [_nameLbl setFrame:CGRectMake(originX, (height - itemHeight)/2, width-padding*4-imgWidth-stateSize.width, itemHeight)];
    
    [_tagImgView setFrame:CGRectMake(width-padding-imgWidth, (height-imgWidth)/2, imgWidth, imgWidth)];
    
    [_statusLbl setFrame:CGRectMake(width-padding-imgWidth-padding-stateSize.width, (height-stateSize.height)/2, stateSize.width, stateSize.height)];
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    if (_finished) {
        _statusStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
        [_statusLbl setContent:_statusStr];
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
    } else {
        _statusStr = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_incomplete" inTable:nil];
        [_statusLbl setContent:_statusStr];
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
    }
    [_nameLbl setText:_name];
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setPatrolInfoWith:(NSString *)name
                 finished:(BOOL)finished {
    _name = name;
    _finished = finished;
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 48;
    
    return height;
}

@end
