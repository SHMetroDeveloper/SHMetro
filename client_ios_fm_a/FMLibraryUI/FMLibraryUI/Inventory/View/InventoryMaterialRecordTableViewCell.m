//
//  InventoryMaterialRecordTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialRecordTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface InventoryMaterialRecordTableViewCell ()
@property (nonatomic, strong) DescriptionLabelView *codeLbl;
@property (nonatomic, strong) DescriptionLabelView *providerLbl;
@property (nonatomic, strong) DescriptionLabelView *priceLbl;
@property (nonatomic, strong) DescriptionLabelView *amountbl;
@property (nonatomic, strong) DescriptionLabelView *realNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *storageInLbl;
@property (nonatomic, strong) DescriptionLabelView *dueTimeLbl;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSNumber * realNumber;
@property (nonatomic, strong) NSNumber *storageInTime;
@property (nonatomic, strong) NSNumber *dueTime;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryMaterialRecordTableViewCell

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
        
        _codeLbl = [[DescriptionLabelView alloc] init];
        _codeLbl.descLbl.font = [FMFont getInstance].font44;
        _codeLbl.descLbl.textColor = contentColor;
        _codeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_ordercode" inTable:nil];;
        _codeLbl.contentLbl.font = [FMFont getInstance].font44;
        _codeLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        
        
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
        
        
        _amountbl = [[DescriptionLabelView alloc] init];
        _amountbl.descLbl.font = mFont;
        _amountbl.descLbl.textColor = titleColor;
        _amountbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_storage_amount" inTable:nil];;
        _amountbl.contentLbl.font = mFont;
        _amountbl.contentLbl.textColor = contentColor;
        
        
        _realNumberLbl = [[DescriptionLabelView alloc] init];
        _realNumberLbl.descLbl.font = mFont;
        _realNumberLbl.descLbl.textColor = titleColor;
        _realNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_real_amount" inTable:nil];;
        _realNumberLbl.contentLbl.font = mFont;
        _realNumberLbl.contentLbl.textColor = contentColor;
        
        
        _storageInLbl = [[DescriptionLabelView alloc] init];
        _storageInLbl.descLbl.font = mFont;
        _storageInLbl.descLbl.textColor = titleColor;
        _storageInLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_storage_time" inTable:nil];;
        _storageInLbl.contentLbl.font = mFont;
        _storageInLbl.contentLbl.textColor = contentColor;
        
        _dueTimeLbl = [[DescriptionLabelView alloc] init];
        _dueTimeLbl.descLbl.font = mFont;
        _dueTimeLbl.descLbl.textColor = titleColor;
        _dueTimeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_duetime" inTable:nil];;
        _dueTimeLbl.contentLbl.font = mFont;
        _dueTimeLbl.contentLbl.textColor = contentColor;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_providerLbl];
        [self.contentView addSubview:_priceLbl];
        [self.contentView addSubview:_amountbl];
        [self.contentView addSubview:_realNumberLbl];
        [self.contentView addSubview:_storageInLbl];
        [self.contentView addSubview:_dueTimeLbl];
        
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
    
    CGFloat codeHeight = 19;
    CGFloat codeWidth = width - padding*2;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, codeWidth, codeHeight)];
    originY += padding + codeHeight;
    
    [_providerLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth;
    
    [_priceLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += padding + labelHeight;
    originX = padding;
    
    [_amountbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth;
    
    [_storageInLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += padding + labelHeight;
    originX = padding;
    
    [_realNumberLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += labelWidth;
    
    [_dueTimeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += sepHeight + labelHeight;
    originX = padding;
    
    if (_seperatorGapped) {
        [_seperator setFrame:CGRectMake(padding, height-[FMSize getInstance].seperatorHeight, width-padding*2, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:YES];
        
    } else {
        [_seperator setFrame:CGRectMake(0, height-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void)updateInfo {
    [_codeLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_code]) {
        [_codeLbl.contentLbl setText:_code];
    }
    
    [_providerLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_provider]) {
        [_providerLbl.contentLbl setText:_provider];
    }
    
    [_priceLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_price]) {
        NSNumber * tmpNumber = [FMUtils stringToNumber:_price];
        [_priceLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",tmpNumber.doubleValue]];
    }
    
    [_amountbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_amount.doubleValue]];
    
    [_realNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_realNumber.doubleValue]];
    
    [_storageInLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_storageInTime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:_storageInTime format:@"yyyy-MM-dd"];
        [_storageInLbl.contentLbl setText:time];
    }
    
    [_dueTimeLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_dueTime]) {
        NSString *time = [FMUtils getDateTimeDescriptionBy:_dueTime format:@"yyyy-MM-dd"];
        [_dueTimeLbl.contentLbl setText:time];
    }
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)seperatorGapped {
    _seperatorGapped = seperatorGapped;
}

- (void) setInfoWithCode:(NSString *) code    //入库单号
                provider:(NSString *) provider  //供应商
                   price:(NSString *) price   //单价(元)
                  amount:(NSNumber *) amount  //入库数量
              realNumber:(NSNumber *) realNumber  //有效数量
           storageInTime:(NSNumber *) storageInTime  //入库时间
                 dueTime:(NSNumber *) dueTime {  //过期时间
    _code = code;
    _provider = provider;
    _price = price;
    _amount = amount;
    _realNumber = realNumber;
    _storageInTime = storageInTime;
    _dueTime = dueTime;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    
    CGFloat codeHeight = 19;

    height = sepHeight*2 + padding*3 + codeHeight + labelHeight*3;
    
    return height;
}

@end
