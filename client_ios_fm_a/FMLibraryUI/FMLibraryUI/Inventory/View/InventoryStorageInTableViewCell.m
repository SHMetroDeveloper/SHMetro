//
//  InventoryStorageInTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageInTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "DescriptionLabelView.h"
#import "BaseBundle.h"

@interface InventoryStorageInTableViewCell ()
//@property (nonatomic, strong) SeperatorView *topSeperator;
@property (nonatomic, strong) SeperatorView *bottomSeperator;

@property (nonatomic, strong) DescriptionLabelView *codeLbl;
@property (nonatomic, strong) DescriptionLabelView *nameLbl;
@property (nonatomic, strong) DescriptionLabelView *brandLbl;
@property (nonatomic, strong) DescriptionLabelView *modelLbl;
@property (nonatomic, strong) DescriptionLabelView *dbCountLbl;
@property (nonatomic, strong) DescriptionLabelView *countLbl;

@property (nonatomic, strong) UIImageView *arrowNextImageView;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryStorageInTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *descColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _codeLbl = [[DescriptionLabelView alloc] init];
        _codeLbl.descLbl.font = mFont;
        _codeLbl.descLbl.textColor = descColor;
        _codeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_code" inTable:nil];;
        _codeLbl.contentLbl.font = mFont;
        _codeLbl.contentLbl.textColor = contentColor;
        
        _nameLbl = [[DescriptionLabelView alloc] init];
        _nameLbl.descLbl.font = mFont;
        _nameLbl.descLbl.textColor = descColor;
        _nameLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_name" inTable:nil];;
        _nameLbl.contentLbl.font = mFont;
        _nameLbl.contentLbl.textColor = contentColor;
        
        _brandLbl = [[DescriptionLabelView alloc] init];
        _brandLbl.descLbl.font = mFont;
        _brandLbl.descLbl.textColor = descColor;
        _brandLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_brand" inTable:nil];;
        _brandLbl.contentLbl.font = mFont;
        _brandLbl.contentLbl.textColor = contentColor;
        
        _modelLbl = [[DescriptionLabelView alloc] init];
        _modelLbl.descLbl.font = mFont;
        _modelLbl.descLbl.textColor = descColor;
        _modelLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_model" inTable:nil];;
        _modelLbl.contentLbl.font = mFont;
        _modelLbl.contentLbl.textColor = contentColor;
        
        _dbCountLbl = [[DescriptionLabelView alloc] init];
        _dbCountLbl.descLbl.font = mFont;
        _dbCountLbl.descLbl.textColor = descColor;
        _dbCountLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_dbcount" inTable:nil];;
        _dbCountLbl.contentLbl.font = mFont;
        _dbCountLbl.contentLbl.textColor = contentColor;
        
        _countLbl = [[DescriptionLabelView alloc] init];
        _countLbl.descLbl.font = mFont;
        _countLbl.descLbl.textColor = descColor;
        if (_tableViewType == TABLEVIEW_TYPE_STORAGE) {
            _countLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_in" inTable:nil];;
        } else if (_tableViewType == TABLEVIEW_TYPE_CHECK) {
            _countLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_check_number" inTable:nil];;
        }
        _countLbl.contentLbl.font = mFont;
        _countLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        
//        _topSeperator = [[SeperatorView alloc] init];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        _arrowNextImageView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"arrows_next_inventory"]];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_dbCountLbl];
        [self.contentView addSubview:_countLbl];
        
//        [self.contentView addSubview:_topSeperator];
        [self.contentView addSubview:_bottomSeperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat sepHeight = 10;
    CGFloat padding = 15;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    CGFloat labelWidth = (width - padding*2.5)/2;
    CGFloat labelheight = 17;
    
//    [_topSeperator setFrame:CGRectMake(0, 0, self.frame.size.width, seperatorHeight)];
    
    [_codeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX += padding/2 + labelWidth;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX = padding;
    originY += sepHeight + labelheight;
    
    [_brandLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX += padding/2 + labelWidth;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX = padding;
    originY += sepHeight + labelheight;
    
    [_dbCountLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX += padding/2 + labelWidth;
    
    [_countLbl setFrame:CGRectMake(originX, originY, labelWidth, labelheight)];
    originX = padding;
    originY += sepHeight + labelheight;
    
    if (_isGapped) {
        [_bottomSeperator setFrame:CGRectMake(padding, height-seperatorHeight, width - padding*2, seperatorHeight)];
        [_bottomSeperator setDotted:YES];
        
    } else {
        [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
        [_bottomSeperator setDotted:NO];
    }
}

- (void)setTableViewType:(TableViewType)tableViewType {
    _tableViewType = tableViewType;
    if (_tableViewType == TABLEVIEW_TYPE_STORAGE) {
        _countLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_in" inTable:nil];;
    } else if (_tableViewType == TABLEVIEW_TYPE_CHECK) {
        _countLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_check_number" inTable:nil];;
    }
}

- (void) setInfoWithCode:(NSString *) code
                    name:(NSString *) name
                   brand:(NSString *) brand
                   model:(NSString *) model
              realNumber:(NSNumber *) realNumber  //账面数量
                  number:(NSNumber *) number {     //入库数量
    _codeLbl.content = @"";
    if (![FMUtils isStringEmpty:code]) {
        _codeLbl.content = code;
    }
    
    _nameLbl.content = @"";
    if (![FMUtils isStringEmpty:name]) {
        _nameLbl.content = name;
    }
    
    _brandLbl.content = @"";
    if (![FMUtils isStringEmpty:brand]) {
        _brandLbl.content = brand;
    }
    
    _modelLbl.content = @"";
    if (![FMUtils isStringEmpty:model]) {
        _modelLbl.content = model;
    }
    
    _dbCountLbl.content = [NSString stringWithFormat:@"%0.2f",realNumber.doubleValue];
    
    _countLbl.content = [NSString stringWithFormat:@"%0.2f",number.doubleValue];
}

- (void) setSeperatorGapped:(BOOL) isGapped {
    _isGapped = isGapped;
    [self setNeedsLayout];
}

+ (CGFloat) getItemHeight {
    CGFloat height = 0;
    CGFloat sepHeight = 10;
    CGFloat labelHeight = 17;
    
    height = sepHeight * 4 + labelHeight * 3;
    
    return height;
}

@end


