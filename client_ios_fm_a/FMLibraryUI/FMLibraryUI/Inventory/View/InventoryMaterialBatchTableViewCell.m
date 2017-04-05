//
//  InventoryStorageInEditMaterialBatchTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialBatchTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface InventoryMaterialBatchTableViewCell ()

@property (nonatomic, strong) DescriptionLabelView *providerLbl;
@property (nonatomic, strong) DescriptionLabelView *dueTimeLbl;
@property (nonatomic, strong) DescriptionLabelView *priceLbl;
@property (nonatomic, strong) DescriptionLabelView *amountLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryMaterialBatchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _providerLbl = [[DescriptionLabelView alloc] init];
        _providerLbl.descLbl.font = mFont;
        _providerLbl.descLbl.textColor = titleColor;
        _providerLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_provider" inTable:nil];;
        _providerLbl.contentLbl.font = mFont;
        _providerLbl.contentLbl.textColor = contentColor;
        
        
        _dueTimeLbl = [[DescriptionLabelView alloc] init];
        _dueTimeLbl.descLbl.font = mFont;
        _dueTimeLbl.descLbl.textColor = titleColor;
        _dueTimeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_duetime" inTable:nil];;
        _dueTimeLbl.contentLbl.font = mFont;
        _dueTimeLbl.contentLbl.textColor = contentColor;
        
        
        _priceLbl = [[DescriptionLabelView alloc] init];
        _priceLbl.descLbl.font = mFont;
        _priceLbl.descLbl.textColor = titleColor;
        _priceLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_price" inTable:nil];;
        _priceLbl.contentLbl.font = mFont;
        _priceLbl.contentLbl.textColor = contentColor;
        
        
        _amountLbl = [[DescriptionLabelView alloc] init];
        _amountLbl.descLbl.font = mFont;
        _amountLbl.descLbl.textColor = titleColor;
        _amountLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_amount" inTable:nil];;
        _amountLbl.contentLbl.font = mFont;
        _amountLbl.contentLbl.textColor = contentColor;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_providerLbl];
        [self.contentView addSubview:_dueTimeLbl];
        [self.contentView addSubview:_priceLbl];
        [self.contentView addSubview:_amountLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    CGFloat labelWidth = (width-padding*2)/2;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_providerLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth;
    
    [_dueTimeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX = padding;
    originY += padding + labelHeight;
    
    [_priceLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth;
    
    [_amountLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX = padding;
    originY += sepHeight + labelHeight;
    
    if (_seperatorGapped) {
        [_seperator setFrame:CGRectMake(padding, height - [FMSize getInstance].seperatorHeight, width-padding*2, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:YES];
    } else {
        [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void)updateInfo {
    [_providerLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_provider]) {
        [_providerLbl.contentLbl setText:_provider];
    }
    
    [_dueTimeLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_dueTime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:_dueTime format:@"yyyy-MM-dd"];
        [_dueTimeLbl.contentLbl setText:time];
    }
    
    [_priceLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_price]) {
        [_priceLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_price.doubleValue]];
    }
    
    [_amountLbl.contentLbl setText:@""];
    if (_amount >= 0) {
        [_amountLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_amount.doubleValue]];
    }
    
}

- (void)setSeperatorGapped:(BOOL)seperatorGapped {
    _seperatorGapped = seperatorGapped;
}

- (void)setProvider:(NSString *)provider {
    _provider = provider;
}

- (void)setDueTime:(NSNumber *)dueTime {
    _dueTime = dueTime;
}

- (void)setPrice:(NSString *)price {
    _price = price;
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    
    height = sepHeight*2 + padding + labelHeight*2;
    
    return height;
}


@end

