//
//  InventoryMaterialCountBatchTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/2.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialCheckBatchTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface InventoryMaterialCheckBatchTableViewCell ()
@property (nonatomic, strong) DescriptionLabelView *providerLbl;
@property (nonatomic, strong) DescriptionLabelView *priceLbl;
@property (nonatomic, strong) DescriptionLabelView *realNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *storageInTimeLbl;
@property (nonatomic, strong) DescriptionLabelView *dueTimeLbl;
@property (nonatomic, strong) DescriptionLabelView *countNumberLbl;
@property (nonatomic, strong) UILabel *differenceNumberLbl;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSNumber * realNumber;
@property (nonatomic, strong) NSNumber * checkNumber;
@property (nonatomic, strong) NSNumber *storageInTime;
@property (nonatomic, strong) NSNumber *dueTime;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryMaterialCheckBatchTableViewCell

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
        UIColor *titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _providerLbl = [[DescriptionLabelView alloc] init];
        _providerLbl.descLbl.font = mFont;
        _providerLbl.descLbl.textColor = titleColor;
        _providerLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_provider" inTable:nil];;
        _providerLbl.contentLbl.font = mFont;
        _providerLbl.contentLbl.textColor = contentColor;
        
        
        _priceLbl = [[DescriptionLabelView alloc] init];
        _priceLbl.descLbl.font = mFont;
        _priceLbl.descLbl.textColor = titleColor;
        _priceLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_price" inTable:nil];;
        _priceLbl.contentLbl.font = mFont;
        _priceLbl.contentLbl.textColor = contentColor;
        
        
        _realNumberLbl = [[DescriptionLabelView alloc] init];
        _realNumberLbl.descLbl.font = mFont;
        _realNumberLbl.descLbl.textColor = titleColor;
        _realNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_real_amount" inTable:nil];;
        _realNumberLbl.contentLbl.font = mFont;
        _realNumberLbl.contentLbl.textColor = contentColor;
        
        
        _storageInTimeLbl = [[DescriptionLabelView alloc] init];
        _storageInTimeLbl.descLbl.font = mFont;
        _storageInTimeLbl.descLbl.textColor = titleColor;
        _storageInTimeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_storage_time" inTable:nil];;
        _storageInTimeLbl.contentLbl.font = mFont;
        _storageInTimeLbl.contentLbl.textColor = contentColor;
        
        
        _dueTimeLbl = [[DescriptionLabelView alloc] init];
        _dueTimeLbl.descLbl.font = mFont;
        _dueTimeLbl.descLbl.textColor = titleColor;
        _dueTimeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_duetime" inTable:nil];;
        _dueTimeLbl.contentLbl.font = mFont;
        _dueTimeLbl.contentLbl.textColor = contentColor;
        
        
        _countNumberLbl = [[DescriptionLabelView alloc] init];
        _countNumberLbl.descLbl.font = mFont;
        _countNumberLbl.descLbl.textColor = titleColor;
        _countNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_amount" inTable:nil];;
        _countNumberLbl.contentLbl.font = mFont;
        _countNumberLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        
        _differenceNumberLbl = [[UILabel alloc] init];
        _differenceNumberLbl.font = mFont;
        _differenceNumberLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _differenceNumberLbl.textAlignment = NSTextAlignmentRight;
        
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_providerLbl];
        [self.contentView addSubview:_storageInTimeLbl];
        [self.contentView addSubview:_priceLbl];
        [self.contentView addSubview:_dueTimeLbl];
        [self.contentView addSubview:_realNumberLbl];
        [self.contentView addSubview:_countNumberLbl];
        [self.contentView addSubview:_differenceNumberLbl];
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
    CGFloat sepWidth = 0;
    CGFloat labelWidth = (width-padding*2-sepWidth)/2;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_providerLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth + sepWidth;
    
    [_storageInTimeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX = padding;
    originY += labelHeight + padding;
    
    [_priceLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth + sepWidth;
    
    [_dueTimeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX = padding;
    originY += labelHeight + padding;
    
    [_realNumberLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth + sepWidth;
    
    [_countNumberLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    if (_isChecked) {
        CGSize differenceSize = [FMUtils getLabelSizeByFont:_differenceNumberLbl.font andContent:_differenceNumberLbl.text andMaxWidth:labelWidth];
        _differenceNumberLbl.hidden = NO;
        [_differenceNumberLbl setFrame:CGRectMake(width-padding-differenceSize.width, originY, differenceSize.width, labelHeight)];
    } else {
        _differenceNumberLbl.hidden = YES;
    }
    originX = padding;
    originY += labelHeight + sepHeight;
    
    if (_seperatorGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-[FMSize getInstance].seperatorHeight, width-padding*2, [FMSize getInstance].seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
    }
}

- (void)updateInfo {
    [_providerLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_provider]) {
        [_providerLbl.contentLbl setText:_provider];
    }
    
    [_priceLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_price]) {
        [_priceLbl.contentLbl setText:_price];
    }
    
    [_realNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_realNumber.doubleValue]];
    
//    if (_checkNumber > 0) {
//        _countNumberLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
//    } else {
//        _countNumberLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//    }
    [_countNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_checkNumber.doubleValue]];
    
    if (_isChecked) {
        if (_checkNumber >= _realNumber) {
            [_differenceNumberLbl setText:[NSString stringWithFormat:@"%+0.2f",_checkNumber.doubleValue-_realNumber.doubleValue]];
        } else {
            [_differenceNumberLbl setText:[NSString stringWithFormat:@"%0.2f",_checkNumber.doubleValue-_realNumber.doubleValue]];
        }
    }
    
    [_storageInTimeLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_storageInTime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:_storageInTime format:@"yyyy-MM-dd"];
        [_storageInTimeLbl.contentLbl setText:time];
    }
    
    [_dueTimeLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_dueTime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:_dueTime format:@"yyyy-MM-dd"];
        [_dueTimeLbl.contentLbl setText:time];
    }
}

- (void)setSeperatorGapped:(BOOL)seperatorGapped {
    _seperatorGapped = seperatorGapped;
}

- (void)setInfoWithProvider:(NSString *) provider
                      price:(NSString *) price
            inventoryNumber:(NSNumber *) inventoryNumber
                checkNumber:(NSNumber *) checknumber
              storageInTime:(NSNumber *) storageInTime
                    dueTime:(NSNumber *) dueTime {
    
    _provider = provider;
    _price = price;
    _realNumber = inventoryNumber;
    _checkNumber = checknumber;
    _storageInTime = storageInTime;
    _dueTime = dueTime;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    
    height = sepHeight*2 + padding*2 + labelHeight*3;
    
    return height;
}

@end




