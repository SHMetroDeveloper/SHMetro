//
//  QuickReportEquipmentTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportEquipmentTableViewCell.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"

@interface QuickReportEquipmentTableViewCell ()
@property (nonatomic, strong) BaseLabelView *codeLbl;
@property (nonatomic, strong) BaseLabelView *nameLbl;
@property (nonatomic, strong) BaseLabelView *locationLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL showLocation;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation QuickReportEquipmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _codeLbl = [[BaseLabelView alloc] init];
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"quick_report_equipment_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setLabelFont:mFont andColor:lightColor];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:darkColor];
        
        
        _nameLbl = [[BaseLabelView alloc] init];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"quick_report_equipment_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setLabelFont:mFont andColor:lightColor];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:darkColor];
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"quick_report_equipment_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:lightColor];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:darkColor];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_locationLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = 0;
    CGFloat originY = padding;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    if (_showLocation) {
        _locationLbl.hidden = NO;
        [_locationLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += itemHeight + padding;
    } else {
        _locationLbl.hidden = YES;
    }
    
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    [_codeLbl setContent:@""];
    if (![FMUtils isStringEmpty:_code]) {
        [_codeLbl setContent:_code];
    }
    
    [_nameLbl setContent:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl setContent:_name];
    }
    
    [_locationLbl setContent:@""];
    if (![FMUtils isStringEmpty:_location]) {
        [_locationLbl setContent:_location];
    }
    
    [self setNeedsLayout];
}

- (void) setSeperatorGapped:(BOOL) isGapped {
    _isGapped = isGapped;
}

- (void) setShowLocation:(BOOL) showLocation {
    _showLocation = showLocation;
}

- (void) setInfoWithCode:(NSString *) code
                    name:(NSString *) name
                location:(NSString *) location {
    _code = code;
    _name = name;
    _location = location;
    [self updateInfo];
}

+ (CGFloat) getItemHeightByShowLocation:(BOOL) show {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    if (show) {
        height = itemHeight*3 + padding*4;
    } else {
        height = itemHeight*2 + padding*3;
    }
    return height;
}

@end
