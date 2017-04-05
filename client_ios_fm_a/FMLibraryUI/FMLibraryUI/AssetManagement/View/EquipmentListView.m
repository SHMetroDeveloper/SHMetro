//
//  EquipmentListView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentListView.h"
#import "FMUtilsPackages.h"
#import "ColorLabel.h"
#import "BaseLabelView.h"
#import "AssetManagementConfig.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface EquipmentListView()

@property (readwrite, nonatomic, strong) ColorLabel * statusLbl;
@property (readwrite, nonatomic, strong) ColorLabel * repairLbl;
@property (readwrite, nonatomic, strong) ColorLabel * maintainLbl;

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * categoryLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;

@property (readwrite, nonatomic, strong) UIImageView * moreTagView;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * category;
@property (readwrite, nonatomic, strong) NSString * location;

@property (readwrite, nonatomic, strong) NSString *status;
@property (readwrite, nonatomic, strong) NSString *repair;
@property (readwrite, nonatomic, strong) NSString *maintenance;

@property (readwrite, nonatomic, strong) UIColor *statusColor;

@end

@implementation EquipmentListView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        
//        UIFont * mFont = [FMFont getInstance].font38;
        _statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        
        UIFont * mFont = [FMFont fontWithSize:15];
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = mFont;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.numberOfLines = 1;
        
        _categoryLbl = [[BaseLabelView alloc] init];
        [_categoryLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"System_classification" inTable:nil] andLabelWidth:0];
        [_categoryLbl setLabelFont:mFont andColor:labelColor];
        [_categoryLbl setLabelAlignment:NSTextAlignmentLeft];
        [_categoryLbl setContentFont:mFont];
        [_categoryLbl setContentColor:contentColor];
        [_categoryLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"Installation_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:labelColor];
        [_locationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:contentColor];
        [_locationLbl setContentAlignment:NSTextAlignmentLeft];
        
        _repairLbl = [[ColorLabel alloc] init];
        [_repairLbl setShowCorner:YES];
        
        _maintainLbl = [[ColorLabel alloc] init];
        [_maintainLbl setShowCorner:YES];
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];
        
        _moreTagView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        
        [self addSubview:_titleLbl];
        [self addSubview:_categoryLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_repairLbl];
        [self addSubview:_maintainLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_moreTagView];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 17;
    CGFloat imageWidth = [FMSize getInstance].imgWidthLevel3;
    
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:_status];
    CGSize repairSize = [ColorLabel calculateSizeByInfo:_repair];
    CGSize maintainSize = [ColorLabel calculateSizeByInfo:_maintenance];
    
    
//    [_titleLbl setFrame:CGRectMake(originX, originY, (width-padding*3-statusSize.width-repairSize.width), itemHeight)];
    
    originX = width-padding-statusSize.width;
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:_statusColor andBackgroundColor:_statusColor];
    [_statusLbl setFrame:CGRectMake(originX, originY + (titleSize.height-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    
    [_repairLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
    [_repairLbl setFrame:CGRectMake(originX-(padding+repairSize.width), originY+(titleSize.height-repairSize.height)/2, repairSize.width, repairSize.height)];
    if (![FMUtils isStringEmpty:_repair]) {
        originX -= padding+repairSize.width;
    }
    
    [_maintainLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
    [_maintainLbl setFrame:CGRectMake(originX-(padding+maintainSize.width), originY+(titleSize.height-maintainSize.height)/2, maintainSize.width, maintainSize.height)];
    if (![FMUtils isStringEmpty:_maintenance]) {
        originX -= padding+maintainSize.width;
    }
    
    //在此处设置titleLbl的目的是 让title的长度自适应
    [_titleLbl setFrame:CGRectMake(padding, originY, (originX-padding), itemHeight)];
    
    originY += padding + itemHeight;
    originX = 0;
    
    [_categoryLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_locationLbl setFrame:CGRectMake(originX, originY, width-padding*2-imageWidth, itemHeight)];
    
    [_moreTagView setFrame:CGRectMake(width-imageWidth-padding, originY + (itemHeight - imageWidth)/2, imageWidth, imageWidth)];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    
    [_categoryLbl setContent:_category];
    [_locationLbl setContent:_location];
    
    [_statusLbl setContent:_status];
    if (![FMUtils isStringEmpty:_repair]) {
        _repairLbl.hidden = NO;
        [_repairLbl setContent:_repair];
    } else {
        _repairLbl.hidden = YES;
    }
    
    if (![FMUtils isStringEmpty:_maintenance]) {
        _maintainLbl.hidden = NO;
        [_maintainLbl setContent:_maintenance];
    } else {
        _maintainLbl.hidden = YES;
    }
    
    [self updateViews];
}

- (void) setInfoWithTitle:(NSString *) title
                 category:(NSString *) category
                 location:(NSString *) location
                   status:(NSInteger) status
                   repair:(NSInteger) repair
              maintecance:(NSInteger) maintenance {
    _title = @"";
    _category = @"";
    _location = @"";
    
    if (![FMUtils isStringEmpty:title]) {
        _title = [title copy];
    }
    if (![FMUtils isStringEmpty:category]) {
        _category = [category copy];
    }
    if (![FMUtils isStringEmpty:location]) {
        _location = [location copy];
    }
    
    EquipmentStatus equipmentStatus = status;
    _status = [AssetManagementConfig getEquipmentStatusStrByStatus:equipmentStatus];
    
    _statusColor = [AssetManagementConfig getEquipmentStatusColorByStatus:equipmentStatus];
    
    
    if (repair > 0) {
        _repair = [[BaseBundle getInstance] getStringByKey:@"asset_repair" inTable:nil];
    } else {
        _repair = nil;
    }
    
    if (maintenance > 0) {
        _maintenance = [[BaseBundle getInstance] getStringByKey:@"asset_maintenance" inTable:nil];
    } else {
        _maintenance = nil;
    }
    
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    height = padding * 4 + itemHeight * 3;
    
    return height;
}


@end
