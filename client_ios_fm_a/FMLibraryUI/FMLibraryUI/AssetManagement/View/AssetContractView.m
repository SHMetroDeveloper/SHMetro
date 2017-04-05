//
//  AssetContractView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetContractView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetContractView ()

@property (nonatomic, strong) BaseLabelView * codeLbl;   //合同编号
@property (nonatomic, strong) BaseLabelView * guarantorLbl;  //保修单位
@property (nonatomic, strong) BaseLabelView * startDateLbl;  //开始时间
@property (nonatomic, strong) BaseLabelView * deadlineLbl;  //到期时间
@property (nonatomic, strong) BaseLabelView * amountLbl;  //合同金额
@property (nonatomic, strong) BaseLabelView * descriptionLbl;  //合同简介

@property (nonatomic, strong) NSString * code;   //合同编号
@property (nonatomic, strong) NSString * guarantor;  //保修单位
@property (nonatomic, strong) NSNumber * startDate;  //开始时间
@property (nonatomic, strong) NSNumber * deadline;  //到期时间
@property (nonatomic, strong) NSString * amount;  //合同金额
@property (nonatomic, strong) NSString * desc;  //合同简介

@property (nonatomic, strong) AssetEquipmentCWContract * fixedContract;  //维修合同
@property (nonatomic, strong) AssetEquipmentCMContract * maintainContract;  //维修合同
@property (nonatomic, strong) AssetEquipmentOtherContract * otherContract;  //维修合同

@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetContractView

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
        
        _codeLbl = [[BaseLabelView alloc] init];
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setLabelFont:mFont andColor:labelColor];
        [_codeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:contentColor];
        [_codeLbl setContentAlignment:NSTextAlignmentLeft];
        
        _guarantorLbl = [[BaseLabelView alloc] init];
        [_guarantorLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_guarantor" inTable:nil] andLabelWidth:0];
        [_guarantorLbl setLabelFont:mFont andColor:labelColor];
        [_guarantorLbl setLabelAlignment:NSTextAlignmentLeft];
        [_guarantorLbl setContentFont:mFont];
        [_guarantorLbl setContentColor:contentColor];
        [_guarantorLbl setContentAlignment:NSTextAlignmentLeft];
        
        _startDateLbl = [[BaseLabelView alloc] init];
        [_startDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_startdate" inTable:nil] andLabelWidth:0];
        [_startDateLbl setLabelFont:mFont andColor:labelColor];
        [_startDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_startDateLbl setContentFont:mFont];
        [_startDateLbl setContentColor:contentColor];
        [_startDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        _deadlineLbl = [[BaseLabelView alloc] init];
        [_deadlineLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_stopdate" inTable:nil] andLabelWidth:0];
        [_deadlineLbl setLabelFont:mFont andColor:labelColor];
        [_deadlineLbl setLabelAlignment:NSTextAlignmentLeft];
        [_deadlineLbl setContentFont:mFont];
        [_deadlineLbl setContentColor:contentColor];
        [_deadlineLbl setContentAlignment:NSTextAlignmentLeft];
        
        _amountLbl = [[BaseLabelView alloc] init];
        [_amountLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_amount" inTable:nil] andLabelWidth:0];
        [_amountLbl setLabelFont:mFont andColor:labelColor];
        [_amountLbl setLabelAlignment:NSTextAlignmentLeft];
        [_amountLbl setContentFont:mFont];
        [_amountLbl setContentColor:contentColor];
        [_amountLbl setContentAlignment:NSTextAlignmentLeft];
        
        _descriptionLbl = [[BaseLabelView alloc] init];
        [_descriptionLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_contract_description" inTable:nil] andLabelWidth:0];
        [_descriptionLbl setLabelFont:mFont andColor:labelColor];
        [_descriptionLbl setLabelAlignment:NSTextAlignmentLeft];
        [_descriptionLbl setContentFont:mFont];
        [_descriptionLbl setContentColor:contentColor];
        [_descriptionLbl setContentAlignment:NSTextAlignmentLeft];
        [_descriptionLbl setShowOneLine:NO];
        
        [self addSubview:_codeLbl];
        [self addSubview:_guarantorLbl];
        [self addSubview:_startDateLbl];
        [self addSubview:_deadlineLbl];
        [self addSubview:_amountLbl];
        [self addSubview:_descriptionLbl];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat defaultItemHeight = 26.7f;
    CGFloat originX = 0;
    CGFloat originY = padding;
    UIFont * mFont = [FMFont getInstance].font38;
    
    CGFloat descriptionHeight = [BaseLabelView calculateHeightByInfo:_desc font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_contract_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_guarantorLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_startDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_deadlineLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_amountLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    if (descriptionHeight < defaultItemHeight) {
        descriptionHeight = itemHeight;
    }
    [_descriptionLbl setFrame:CGRectMake(originX, originY, width-padding, descriptionHeight)];
}

- (void) updateInfo {
    [_codeLbl setContent:_code];
    
    [_guarantorLbl setContent:_guarantor];
    
    if (_startDate) {
        NSString * startTime = [FMUtils getDateTimeDescriptionBy:_startDate format:@"yyy-MM-dd"];
        [_startDateLbl setContent:startTime];
    } else {
        [_startDateLbl setContent:@""];
    }
    
    if (_deadline) {
        NSString * deadline = [FMUtils getDateTimeDescriptionBy:_deadline format:@"yyy-MM-dd"];
        [_deadlineLbl setContent:deadline];
    } else {
        [_deadlineLbl setContent:@""];
    }
    
    [_amountLbl setContent:_amount];
    
    [_descriptionLbl setContent:_desc];
    
    [self updateViews];
}

- (void) setAssetContractInfoWith:(AssetEquipmentDetailEntity *) entity andContractType:(AssetContractType) type andPosition:(NSInteger) position{
    
    _code = @"";
    _guarantor = @"";
    _startDate = nil;
    _deadline = nil;
    _amount = @"";
    _desc = @"";
    
    switch (type) {
        case ASSET_CONTRACT_FIXED:
            if (entity.cwCntract) {
                _fixedContract = entity.cwCntract ;
                _code = [_fixedContract.code copy];
                _guarantor = [_fixedContract.mVendorName copy];
                _startDate = [_fixedContract.startDate copy];
                _deadline = [_fixedContract.dueDate copy];
                _amount = [_fixedContract.amounts copy];
                _desc = [_fixedContract.cDescription copy];
            }
            break;
            
        case ASSET_CONTRACT_MAINTAIN:
            if (entity.cmContract.count > 0) {
                _maintainContract = [entity.cmContract objectAtIndex:position];
                _code = [_maintainContract.code copy];
                _guarantor = [_maintainContract.mVendorName copy];
                _startDate = [_maintainContract.startDate copy];
                _deadline = [_maintainContract.dueDate copy];
                _amount = [_maintainContract.amounts copy];
                _desc = [_maintainContract.cDescription copy];
            }
            break;
            
        case ASSET_CONTRACT_OTHER:
            if (entity.otherContract.count > 0) {
                _otherContract = [entity.otherContract objectAtIndex:position];
                _code = [_otherContract.code copy];
                _guarantor = [_otherContract.mVendorName copy];
                _startDate = [_otherContract.startDate copy];
                _deadline = [_otherContract.dueDate copy];
                _amount = [_otherContract.amounts copy];
                _desc = [_otherContract.cDescription copy];
            }
            break;
    }
    
    [self updateInfo];
}

+ (CGFloat)calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *)entity andWidth:(CGFloat)width andContractType:(AssetContractType)type andPosition:(NSInteger)position {
    
    CGFloat height = 0;
    CGFloat descHeight = 17;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UIFont * mFont = [FMFont getInstance].font38;
    CGFloat defaultItemHeight = 26.7f;
    
    height = itemHeight * 5 + padding * 7;
    switch (type) {
        case ASSET_CONTRACT_FIXED:
            if (entity.cwCntract) {
                AssetEquipmentCWContract * fixedContract = entity.cwCntract ;
                descHeight = [BaseLabelView calculateHeightByInfo:fixedContract.cDescription font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_contract_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
            }
            break;
        case ASSET_CONTRACT_MAINTAIN:
            if (entity.cmContract.count > 0) {
                AssetEquipmentCMContract * maintainContract = [entity.cmContract objectAtIndex:position];
                descHeight = [BaseLabelView calculateHeightByInfo:maintainContract.cDescription font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_contract_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
            }
            break;
        case ASSET_CONTRACT_OTHER:
            if (entity.otherContract.count > 0) {
                AssetEquipmentOtherContract * otherContract = [entity.otherContract objectAtIndex:position];
                descHeight = [BaseLabelView calculateHeightByInfo:otherContract.cDescription font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"asset_contract_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
            }
            break;
    }
    
    if (descHeight < defaultItemHeight) {
        descHeight = itemHeight;
    }
    height += descHeight;
    
    return height;
}

@end








