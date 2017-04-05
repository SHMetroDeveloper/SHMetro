//
//  AssetOrderRecordView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetOrderRecordView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "WorkOrderServerConfig.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetOrderRecordView ()
@property (nonatomic, strong) UILabel * codeLbl;
@property (nonatomic, strong) UILabel * timeLbl;
@property (nonatomic, strong) BaseLabelView * applicantLbl;
@property (nonatomic, strong) BaseLabelView * locationLbl;
@property (nonatomic, strong) ColorLabel * statusLbl;

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSString * applicant;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetOrderRecordView

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
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _labelWidth = 50;
        
        _codeLbl = [[UILabel alloc] init];
        _codeLbl.font = [FMFont getInstance].font44;
        _codeLbl.textColor = contentColor;
        
        _applicantLbl = [[BaseLabelView alloc] init];
        [_applicantLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_order_record_applicant" inTable:nil] andLabelWidth:0];
        [_applicantLbl setLabelFont:mFont andColor:labelColor];
        [_applicantLbl setLabelAlignment:NSTextAlignmentLeft];
        [_applicantLbl setContentFont:mFont];
        [_applicantLbl setContentColor:contentColor];
        [_applicantLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_order_record_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:labelColor];
        [_locationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:contentColor];
        [_locationLbl setContentAlignment:NSTextAlignmentLeft];

        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = mFont;
        _timeLbl.textColor = labelColor;
        
        [self addSubview:_codeLbl];
        [self addSubview:_applicantLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_timeLbl];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    WorkOrderStatus orderStatus = _status;
    CGSize statusSize = [ColorLabel calculateSizeByInfo:[WorkOrderServerConfig getOrderStatusDesc:orderStatus]];
    CGSize codeSize = [FMUtils getLabelSizeBy:_codeLbl andContent:_codeLbl.text andMaxLabelWidth:width];
    CGSize timeSize = [FMUtils getLabelSizeBy:_timeLbl andContent:_timeLbl.text andMaxLabelWidth:width];
    
    [_codeLbl setFrame:CGRectMake(originX, originY, codeSize.width, itemHeight)];
    
    [_statusLbl setFrame:CGRectMake(originX+codeSize.width+(width-padding*2-codeSize.width-timeSize.width-statusSize.width)/2, originY+(itemHeight-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    [_timeLbl setFrame:CGRectMake(width-padding-timeSize.width, originY, timeSize.width, itemHeight)];
    
    originY += padding + itemHeight;
    originX = 0;
    
    [_applicantLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
//    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:_location font:mFont  desc:[[BaseBundle getInstance] getStringByKey:@"asset_order_record_location" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
//    if (locationHeight < defaultItemHeight) {
//        locationHeight = itemHeight;
//    }
    [_locationLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    
}


- (void) updateInfo {
    [_codeLbl setText:_code];
    WorkOrderStatus orderStatus = _status;
    [_statusLbl setContent:[WorkOrderServerConfig getOrderStatusDesc:orderStatus]];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[WorkOrderServerConfig getOrderStatusColor:orderStatus] andBackgroundColor:[WorkOrderServerConfig getOrderStatusColor:orderStatus]];
    
    [_timeLbl setText:[FMUtils timeLongToDateStringWithOutYear:_time]];
    [_applicantLbl setContent:_applicant];
    [_locationLbl setContent:_location];
    
    [self updateViews];
}

- (void) setFixedRecordData:(AssetWorkOrderFixedEntity *) fixedData {
    _code = @"";
    _status = 0;
    _time = nil;
    _applicant = @"";
    _location = @"";
    
    if (![FMUtils isStringEmpty:fixedData.code]) {
        _code = fixedData.code;
    }
    if (fixedData.status) {
        _status = fixedData.status.integerValue;
    }
    if (fixedData.createDateTime) {
        _time = fixedData.createDateTime;
    }
    if (![FMUtils isStringEmpty:fixedData.applicantName]) {
        _applicant = fixedData.applicantName;
    }
    if (![FMUtils isStringEmpty:fixedData.location]) {
        _location = fixedData.location;
    }
    
    [self updateInfo];
}

- (void) setMaintainRecordData:(AssetWorkOrderMaintainEntity *) maintainData {
    _code = @"";
    _status = 0;
    _time = nil;
    _applicant = @"";
    _location = @"";
    
    if (![FMUtils isStringEmpty:maintainData.code]) {
        _code = maintainData.code;
    }
    if (maintainData.status) {
        _status = maintainData.status.integerValue;
    }
    if (maintainData.createDateTime) {
        _time = maintainData.createDateTime;
    }
    if (![FMUtils isStringEmpty:maintainData.applicantName]) {
        _applicant = maintainData.applicantName;
    }
    if (![FMUtils isStringEmpty:maintainData.location]) {
        _location = maintainData.location;
    }
    
    [self updateInfo];
}


+ (CGFloat) calculateFixedHeightBy:(AssetWorkOrderFixedEntity *) fixedData andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat itemHeight = 16;
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:fixedData.location font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_order_record_location" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:50 andWidth:width-padding];
    height = itemHeight*2 + padding*4;
    if (itemHeight < locationHeight) {
        itemHeight = locationHeight;
    }
    height += itemHeight;
    
    return height;
}

+ (CGFloat) calculateMaintainHeightBy:(AssetWorkOrderMaintainEntity *) maintainData andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
//    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:maintainData.location font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_order_record_location" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:50 andWidth:width-padding];
    height = itemHeight*2 + padding*4;
//    if (itemHeight < locationHeight) {
//        itemHeight = locationHeight;
//    }
    height += itemHeight;
    return height;
}

@end










