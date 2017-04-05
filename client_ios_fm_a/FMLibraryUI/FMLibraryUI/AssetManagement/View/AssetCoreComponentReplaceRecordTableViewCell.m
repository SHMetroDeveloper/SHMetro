//
//  AssetCoreComponentReplaceRecordTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetCoreComponentReplaceRecordTableViewCell.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"
#import "FMUtilsPackages.h"

@interface AssetCoreComponentReplaceRecordTableViewCell ()
@property (nonatomic, strong) UILabel *nameLbl;
//@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) BaseLabelView *codeLbl;
@property (nonatomic, strong) BaseLabelView *handlerLbl;
@property (nonatomic, strong) BaseLabelView *operateTimeLbl;
@property (nonatomic, strong) BaseLabelView *brandLbl;
@property (nonatomic, strong) BaseLabelView *modelLbl;
@property (nonatomic, strong) BaseLabelView *periodLbl;
@property (nonatomic, strong) BaseLabelView *installDateLbl;
@property (nonatomic, strong) BaseLabelView *expiredDateLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic, strong) NSNumber *operateTime;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSNumber *installDate;
@property (nonatomic, strong) NSNumber *expiredDate;

@property (nonatomic, assign) BOOL replaced;  //更换前后
@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetCoreComponentReplaceRecordTableViewCell

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
        
        _nameLbl = [UILabel new];
        _nameLbl.textColor = contentColor;
        _nameLbl.font = [FMFont getInstance].font44;
        
//        _statusLbl = [UILabel new];
//        _statusLbl.font = [FMFont getInstance].font38;
        
        _codeLbl = [[BaseLabelView alloc] init];  //设备编码
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setLabelFont:mFont andColor:labelColor];
        [_codeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:contentColor];
        [_codeLbl setContentAlignment:NSTextAlignmentLeft];
        
        _handlerLbl = [[BaseLabelView alloc] init];  //
        [_handlerLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_handler" inTable:nil] andLabelWidth:0];
        [_handlerLbl setLabelFont:mFont andColor:labelColor];
        [_handlerLbl setLabelAlignment:NSTextAlignmentLeft];
        [_handlerLbl setContentFont:mFont];
        [_handlerLbl setContentColor:contentColor];
        [_handlerLbl setContentAlignment:NSTextAlignmentLeft];
        
        _operateTimeLbl = [[BaseLabelView alloc] init];  //
        [_operateTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_operatetime" inTable:nil] andLabelWidth:0];
        [_operateTimeLbl setLabelFont:mFont andColor:labelColor];
        [_operateTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_operateTimeLbl setContentFont:mFont];
        [_operateTimeLbl setContentColor:contentColor];
        [_operateTimeLbl setContentAlignment:NSTextAlignmentLeft];
        
        _brandLbl = [[BaseLabelView alloc] init];  //
        [_brandLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_brand" inTable:nil] andLabelWidth:0];
        [_brandLbl setLabelFont:mFont andColor:labelColor];
        [_brandLbl setLabelAlignment:NSTextAlignmentLeft];
        [_brandLbl setContentFont:mFont];
        [_brandLbl setContentColor:contentColor];
        [_brandLbl setContentAlignment:NSTextAlignmentLeft];
        
        _modelLbl = [[BaseLabelView alloc] init];  //
        [_modelLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_model" inTable:nil] andLabelWidth:0];
        [_modelLbl setLabelFont:mFont andColor:labelColor];
        [_modelLbl setLabelAlignment:NSTextAlignmentLeft];
        [_modelLbl setContentFont:mFont];
        [_modelLbl setContentColor:contentColor];
        [_modelLbl setContentAlignment:NSTextAlignmentLeft];
        
        _periodLbl = [[BaseLabelView alloc] init];  //
        [_periodLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_period" inTable:nil] andLabelWidth:0];
        [_periodLbl setLabelFont:mFont andColor:labelColor];
        [_periodLbl setLabelAlignment:NSTextAlignmentLeft];
        [_periodLbl setContentFont:mFont];
        [_periodLbl setContentColor:contentColor];
        [_periodLbl setContentAlignment:NSTextAlignmentLeft];
        
        _installDateLbl = [[BaseLabelView alloc] init];  //
        [_installDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_installdate" inTable:nil] andLabelWidth:0];
        [_installDateLbl setLabelFont:mFont andColor:labelColor];
        [_installDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_installDateLbl setContentFont:mFont];
        [_installDateLbl setContentColor:contentColor];
        [_installDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        _expiredDateLbl = [[BaseLabelView alloc] init];  //
        [_expiredDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"core_component_record_expireddate" inTable:nil] andLabelWidth:0];
        [_expiredDateLbl setLabelFont:mFont andColor:labelColor];
        [_expiredDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_expiredDateLbl setContentFont:mFont];
        [_expiredDateLbl setContentColor:contentColor];
        [_expiredDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
//        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_handlerLbl];
        [self.contentView addSubview:_operateTimeLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_periodLbl];
        [self.contentView addSubview:_installDateLbl];
        [self.contentView addSubview:_expiredDateLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat nameHeight = 19;
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemWidth = (width-padding)/2;
    
    CGFloat originX = 0;
    CGFloat originY = padding;
    
//    CGSize stateSize = [FMUtils getLabelSizeBy:_statusLbl andContent:_statusLbl.text andMaxLabelWidth:width];
    
    [_nameLbl setFrame:CGRectMake(padding, originY, width-padding*2, nameHeight)];
//    [_statusLbl setFrame:CGRectMake(width-padding-stateSize.width, originY+(nameHeight-stateSize.height)/2, stateSize.width, stateSize.height)];
    originY += nameHeight + padding;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originX += itemWidth;
    [_handlerLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + padding;
    originX = 0;
    
    [_operateTimeLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originX += itemWidth;
    [_brandLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + padding;
    originX = 0;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originX += itemWidth;
    [_periodLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + padding;
    originX = 0;
    
    [_installDateLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originX += itemWidth;
    [_expiredDateLbl setFrame:CGRectMake(originX, originY, itemWidth, itemHeight)];
    originY += itemHeight + padding;
    originX = 0;
    
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    [_nameLbl setText:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl setText:_name];
    }
    
//    if (_replaced) {
//        _statusLbl.textColor = [UIColor colorWithRed:0x1a/255.0 green:0xb3/255.0 blue:0x94/255.0 alpha:1];
//        [_statusLbl setText:[[BaseBundle getInstance] getStringByKey:@"core_component_replace_yes" inTable:nil]];
//    } else {
//        _statusLbl.textColor = [UIColor colorWithRed:0x15/255.0 green:0x9f/255.0 blue:0xe6/255.0 alpha:1];
//        [_statusLbl setText:[[BaseBundle getInstance] getStringByKey:@"core_component_replace_no" inTable:nil]];
//    }
    
    [_codeLbl setContent:@""];
    if (![FMUtils isStringEmpty:_code]) {
        [_codeLbl setContent:_code];
    }
    
    [_handlerLbl setContent:@""];
    if (![FMUtils isStringEmpty:_handler]) {
        [_handlerLbl setContent:_handler];
    }
    
    [_operateTimeLbl setContent:@""];
    if (![FMUtils isNumberNullOrZero:_operateTime]) {
        NSString *operateTimeStr = [FMUtils getDateTimeDescriptionBy:_operateTime format:@"yyyy-MM-dd"];
        [_operateTimeLbl setContent:operateTimeStr];
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
    
    [_expiredDateLbl setContent:@""];
    if (![FMUtils isNumberNullOrZero:_expiredDate]) {
        NSString *expireDateStr = [FMUtils getDateTimeDescriptionBy:_expiredDate format:@"yyyy-MM-dd"];
        [_expiredDateLbl setContent:expireDateStr];
    }
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL) isGapped {
    _isGapped = isGapped;
}

- (void)setCoreReplaced:(BOOL)replaced {
    _replaced = replaced;
}

- (void)setCoreComponentReplaceHistory:(AssetCoreComponentReplaceRecord *) replaceRecord {
    _name = replaceRecord.name;
    _code = replaceRecord.code;
    _handler = replaceRecord.handler;
    _operateTime = replaceRecord.operateTime;
    _brand = replaceRecord.brand;
    _model = replaceRecord.model;
    _period = replaceRecord.period;
    _installDate = replaceRecord.installDate;
    _expiredDate = replaceRecord.expireDate;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat nameHeight = 19;
    CGFloat itemHeight = 17;
    
    height = padding*6 + nameHeight + itemHeight*4;
    
    return height;
}

@end
