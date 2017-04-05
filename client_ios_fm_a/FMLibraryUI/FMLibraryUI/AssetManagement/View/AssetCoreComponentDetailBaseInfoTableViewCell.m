//
//  AssetCoreComponentDetailBaseInfoTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetCoreComponentDetailBaseInfoTableViewCell.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"

@interface AssetCoreComponentDetailBaseInfoTableViewCell ()
@property (nonatomic, strong) BaseLabelView *codeLbl;
@property (nonatomic, strong) BaseLabelView *nameLbl;
@property (nonatomic, strong) BaseLabelView *brandLbl;
@property (nonatomic, strong) BaseLabelView *modelLbl;
@property (nonatomic, strong) BaseLabelView *periodLbl;
@property (nonatomic, strong) BaseLabelView *installDateLbl;
@property (nonatomic, strong) BaseLabelView *expireDateLbl;
//@property (nonatomic, strong) BaseLabelView *replacedDateLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSNumber *installDate;
@property (nonatomic, strong) NSNumber *expireDate;
//@property (nonatomic, strong) NSNumber *replaceDate;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetCoreComponentDetailBaseInfoTableViewCell

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
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _codeLbl = [[BaseLabelView alloc] init];  //设备编号
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setLabelFont:mFont andColor:labelColor];
        [_codeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:contentColor];
        [_codeLbl setContentAlignment:NSTextAlignmentLeft];
        
        _nameLbl = [[BaseLabelView alloc] init];  //设备名称
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setLabelFont:mFont andColor:labelColor];
        [_nameLbl setLabelAlignment:NSTextAlignmentLeft];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:contentColor];
        [_nameLbl setContentAlignment:NSTextAlignmentLeft];
        
        _brandLbl = [[BaseLabelView alloc] init];  //设备品牌
        [_brandLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_brand" inTable:nil] andLabelWidth:0];
        [_brandLbl setLabelFont:mFont andColor:labelColor];
        [_brandLbl setLabelAlignment:NSTextAlignmentLeft];
        [_brandLbl setContentFont:mFont];
        [_brandLbl setContentColor:contentColor];
        [_brandLbl setContentAlignment:NSTextAlignmentLeft];
        
        _modelLbl = [[BaseLabelView alloc] init];  //设备型号
        [_modelLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_model" inTable:nil] andLabelWidth:0];
        [_modelLbl setLabelFont:mFont andColor:labelColor];
        [_modelLbl setLabelAlignment:NSTextAlignmentLeft];
        [_modelLbl setContentFont:mFont];
        [_modelLbl setContentColor:contentColor];
        [_modelLbl setContentAlignment:NSTextAlignmentLeft];
        
        _periodLbl = [[BaseLabelView alloc] init];  //设备周期
        [_periodLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_period" inTable:nil] andLabelWidth:0];
        [_periodLbl setLabelFont:mFont andColor:labelColor];
        [_periodLbl setLabelAlignment:NSTextAlignmentLeft];
        [_periodLbl setContentFont:mFont];
        [_periodLbl setContentColor:contentColor];
        [_periodLbl setContentAlignment:NSTextAlignmentLeft];
        
        _installDateLbl = [[BaseLabelView alloc] init];  //设备安装日期
        [_installDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_installDate" inTable:nil] andLabelWidth:0];
        [_installDateLbl setLabelFont:mFont andColor:labelColor];
        [_installDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_installDateLbl setContentFont:mFont];
        [_installDateLbl setContentColor:contentColor];
        [_installDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        _expireDateLbl = [[BaseLabelView alloc] init];  //设备质保日期
        [_expireDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_expireDate" inTable:nil] andLabelWidth:0];
        [_expireDateLbl setLabelFont:mFont andColor:labelColor];
        [_expireDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_expireDateLbl setContentFont:mFont];
        [_expireDateLbl setContentColor:contentColor];
        [_expireDateLbl setContentAlignment:NSTextAlignmentLeft];
        
//        _replacedDateLbl = [[BaseLabelView alloc] init];  //设备更换日期
//        [_replacedDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_base_info_replaceDate" inTable:nil] andLabelWidth:0];
//        [_replacedDateLbl setLabelFont:mFont andColor:labelColor];
//        [_replacedDateLbl setLabelAlignment:NSTextAlignmentLeft];
//        [_replacedDateLbl setContentFont:mFont];
//        [_replacedDateLbl setContentColor:contentColor];
//        [_replacedDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_periodLbl];
        [self.contentView addSubview:_installDateLbl];
        [self.contentView addSubview:_expireDateLbl];
//        [self.contentView addSubview:_replacedDateLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    
    CGFloat originX = 0;
    CGFloat originY = padding;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_brandLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_periodLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_installDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_expireDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
//    [_replacedDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
//    originY += itemHeight + padding;
    
    [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
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
    
    [_brandLbl setContent:@""];
    if (![FMUtils isStringEmpty:_brand]) {
        [_brandLbl setContent:_brand];
    }
    
    [_modelLbl setContent:@""];
    if (![FMUtils isStringEmpty:_model]) {
        [_modelLbl setContent:_model];
    }
    
    [_periodLbl setContent:@""];
    if (![FMUtils isNumberNullOrZero:_period]) {
        NSString *periodStr = [NSString stringWithFormat:@"%ld%@",_period.integerValue,[[BaseBundle getInstance] getStringByKey:@"month" inTable:nil]];
        [_periodLbl setContent:periodStr];
    }
    
    [_installDateLbl setContent:@""];
    if (![FMUtils isNumberNullOrZero:_installDate]) {
        NSString *installDateStr = [FMUtils getDateTimeDescriptionBy:_installDate format:@"yyyy-MM-dd"];
        [_installDateLbl setContent:installDateStr];
    }
    
    [_expireDateLbl setContent:@""];
    if (![FMUtils isNumberNullOrZero:_expireDate]) {
        NSString *expireDateStr = [FMUtils getDateTimeDescriptionBy:_expireDate format:@"yyyy-MM-dd"];
        [_expireDateLbl setContent:expireDateStr];
    }
    
//    [_replacedDateLbl setContent:@""];
//    if (![FMUtils isNumberNullOrZero:_replaceDate]) {
//        NSString *replaceDateStr = [FMUtils getDateTimeDescriptionBy:_replaceDate format:@"yyyy-MM-dd"];
//        [_replacedDateLbl setContent:replaceDateStr];
//    }
    
    [self setNeedsLayout];
}

- (void)setCoreComponentDetail:(AssetCoreComponentDetailEntity *) coreComponentDetail {
    _code = coreComponentDetail.code;
    _name = coreComponentDetail.name;
    _brand = coreComponentDetail.brand;
    _model = coreComponentDetail.model;
    _period = coreComponentDetail.period;
    _installDate = coreComponentDetail.installDate;
    _expireDate = coreComponentDetail.expireDate;
//    _replaceDate = coreComponentDetail.replacedDate;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    
    height = itemHeight*7 + padding*8;
    
    return height;
}

@end
