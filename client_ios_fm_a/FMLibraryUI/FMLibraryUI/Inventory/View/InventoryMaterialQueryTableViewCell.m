//
//  InventoryMaterialTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialQueryTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"
#import "ColorLabel.h"
#import "UIImageView+AFNetworking.h"

@interface InventoryMaterialQueryTableViewCell ()
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) ColorLabel *statusLbl;
@property (nonatomic, strong) UILabel *brandLbl;
@property (nonatomic, strong) UILabel *modelLbl;
@property (nonatomic, strong) DescriptionLabelView *totalNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *minNumberLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSNumber *previewImageId;
@property (nonatomic, assign) CGFloat totalNumber;
@property (nonatomic, assign) CGFloat minNumber;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryMaterialQueryTableViewCell
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
        
        
        _previewImageView = [[UIImageView alloc] init];
        
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [FMFont getInstance].font44;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];
        
        
        _brandLbl = [UILabel new];
        _brandLbl.font = mFont;
        _brandLbl.textColor = contentColor;
        
        
        _modelLbl = [UILabel new];
        _modelLbl.font = mFont;
        _modelLbl.textColor = contentColor;
        
        
        _totalNumberLbl = [[DescriptionLabelView alloc] init];
        _totalNumberLbl.descLbl.font = mFont;
        _totalNumberLbl.descLbl.textColor = titleColor;
        _totalNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_dbcount" inTable:nil];;
        _totalNumberLbl.contentLbl.font = mFont;
        _totalNumberLbl.contentLbl.textColor = contentColor;
        
        
        _minNumberLbl = [[DescriptionLabelView alloc] init];
        _minNumberLbl.descLbl.font = mFont;
        _minNumberLbl.descLbl.textColor = titleColor;
        _minNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_minnumber" inTable:nil];;
        _minNumberLbl.contentLbl.font = mFont;
        _minNumberLbl.contentLbl.textColor = contentColor;
        
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_previewImageView];
        [self.contentView addSubview:_titleLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_totalNumberLbl];
        [self.contentView addSubview:_minNumberLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat padding = 15;
    CGFloat imageWidth = 100;
    CGFloat titleHeight = 19;
    CGFloat labelHeight = 17;
    CGFloat labelWidth = width - imageWidth - padding*3;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat sepHeight = (imageWidth - titleHeight - labelHeight*3)/3;
    
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    [_previewImageView setFrame:CGRectMake(originX, (height-imageWidth)/2, imageWidth, imageWidth)];
    originX += imageWidth + padding;
    
    CGSize stateSize = [ColorLabel calculateSizeByInfo:_state];
    [_statusLbl setFrame:CGRectMake(width-padding-stateSize.width, originY+(titleHeight-stateSize.height)/2, stateSize.width, stateSize.height)];
    
    [_titleLbl setFrame:CGRectMake(originX, originY, width-padding*4-stateSize.width-imageWidth, titleHeight)];
    originY += titleHeight + sepHeight;
    
    CGFloat doubleLabelWidth = (width-imageWidth-padding*4)/2;
    [_brandLbl setFrame:CGRectMake(originX, originY, doubleLabelWidth, labelHeight)];
    originX += doubleLabelWidth + padding;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, doubleLabelWidth, labelHeight)];
    originX = padding*2 + imageWidth;
    originY += labelHeight + sepHeight;
    
    [_totalNumberLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_minNumberLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    if (_seperatorGapped) {
        [_seperator setFrame:CGRectMake(padding, height - seperatorHeight, width - padding*2, seperatorHeight)];
        [_seperator setDotted:YES];
    } else {
        [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void)updateInfo {
    NSMutableString *title = [[NSMutableString alloc] initWithString:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [title appendString:_name];
    }
    if (![FMUtils isStringEmpty:_code]) {
        [title appendFormat:@"(%@)",_code];
    }
    [_titleLbl setText:title];
    
    
    UIColor *backColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    if (_totalNumber <= _minNumber) {
        backColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _state =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_lack" inTable:nil];;
    } else {
        backColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _state =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_filter_enough" inTable:nil];;
    }
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:backColor andBackgroundColor:backColor];
    [_statusLbl setContent:_state];
    
    [_brandLbl setText:@""];
    if (![FMUtils isStringEmpty:_brand]) {
        [_brandLbl setText:_brand];
    }
    
    [_modelLbl setText:@""];
    if (![FMUtils isStringEmpty:_model]) {
        [_modelLbl setText:_model];
    }
    
    [_totalNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_totalNumber]];
    
    [_minNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_minNumber]];
    
    NSURL *imgUrl = [FMUtils getUrlOfImageById:_previewImageId];
    [_previewImageView setImageWithURL:imgUrl placeholderImage:[[FMTheme getInstance] getImageByName:@"material_placeholder"]];
    
    [self setNeedsLayout];
}

- (void)setInfoWithName:(NSString *)name
                   code:(NSString *)code
          warehouseName:(NSString *)warehouseName
                  brand:(NSString *)brand
                  model:(NSString *)model
         previewImageId:(NSNumber *)previewImageId
             totalNumber:(CGFloat)totalNumber
              minNumber:(CGFloat)minNumber {
    _name = name;
    _code = code;
    _brand = brand;
    _model = model;
    _previewImageId = previewImageId;
    _totalNumber = totalNumber;
    _minNumber = minNumber;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    
    CGFloat imageWidth = 100;
    CGFloat padding = 15;
    height = padding*2 + imageWidth;
//    CGFloat sepHeight = 18;
//    CGFloat titleHeight = 19;
//    CGFloat labelHeight = 17;
    
//    height = sepHeight*2 + padding*3 + titleHeight + labelHeight*3;
    
    return height;
}

@end

