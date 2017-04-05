//
//  InventoryDeliveryMaterialTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryMaterialTableViewCell.h"
#import "BaseLabelView.h"
#import "MaterialEntity.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "SeperatorView.h"

@interface InventoryMaterialTableViewCell ()

@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;           //编码
@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;           //名称
@property (readwrite, nonatomic, strong) BaseLabelView * brandLbl;          //品牌
@property (readwrite, nonatomic, strong) BaseLabelView * modelLbl;          //型号
@property (readwrite, nonatomic, strong) BaseLabelView * inventoryNumberLbl;//账面or有效数量
@property (readwrite, nonatomic, strong) BaseLabelView * numberLbl;         //实际数量

@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;   //底部分割线

@property (readwrite, nonatomic, strong) MaterialEntity * material; //物料
@property (readwrite, nonatomic, strong) NSNumber * amount;  //数量
@property (readwrite, nonatomic, assign) InventoryMaterialType type;    //cell Type
@property (readwrite, nonatomic, assign) BOOL showFullSeperator;   //标记分割线是否显示全的

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation InventoryMaterialTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        UIColor * lblColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        UIColor * amountColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        
        _codeLbl = [[BaseLabelView alloc] init];
        _nameLbl = [[BaseLabelView alloc] init];
        _brandLbl = [[BaseLabelView alloc] init];
        _modelLbl = [[BaseLabelView alloc] init];
        _inventoryNumberLbl = [[BaseLabelView alloc] init];
        _numberLbl = [[BaseLabelView alloc] init];
        
        [_codeLbl setLabelFont:font andColor:lblColor];
        [_codeLbl setContentColor:contentColor];
        [_codeLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_code" inTable:nil] andLabelWidth:0];
        
        [_nameLbl setLabelFont:font andColor:lblColor];
        [_nameLbl setContentColor:contentColor];
        [_nameLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_name" inTable:nil] andLabelWidth:0];
        
        [_brandLbl setLabelFont:font andColor:lblColor];
        [_brandLbl setContentColor:contentColor];
        [_brandLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_brand" inTable:nil] andLabelWidth:0];
        
        [_modelLbl setLabelFont:font andColor:lblColor];
        [_modelLbl setContentColor:contentColor];
        [_modelLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_model" inTable:nil] andLabelWidth:0];
        
        [_inventoryNumberLbl setLabelFont:font andColor:lblColor];
        [_inventoryNumberLbl setContentColor:contentColor];
        [_inventoryNumberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_realnumber" inTable:nil] andLabelWidth:0];
        
        [_numberLbl setLabelFont:font andColor:lblColor];
        [_numberLbl setContentColor:amountColor];
        [_numberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count" inTable:nil] andLabelWidth:0];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_inventoryNumberLbl];
        [self.contentView addSubview:_numberLbl];
        
        [self.contentView addSubview:_bottomSeperator];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    //    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat padding = 14;
    CGFloat sepHeight = 10;
    
    CGFloat originY = padding;
    CGFloat itemHeight = 16;
    
    [_codeLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_nameLbl setFrame:CGRectMake(width/2, originY, width/2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_brandLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_modelLbl setFrame:CGRectMake(width/2, originY, width/2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_inventoryNumberLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_numberLbl setFrame:CGRectMake(width/2, originY, width/2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateSeperator];
    
    [self updateInfo];
}

- (void) updateSeperator {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    if(_showFullSeperator) {
        [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
        [_bottomSeperator setDotted:NO];
    } else {
        [_bottomSeperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
        [_bottomSeperator setDotted:YES];
        
    }
}

- (void) updateInfo {
    if(_material) {
        [_codeLbl setContent:_material.materialCode];
        [_nameLbl setContent:_material.materialName];
        [_brandLbl setContent:_material.materialBrand];
        [_modelLbl setContent:_material.materialModel];
        [_inventoryNumberLbl setContent:[[NSString alloc] initWithFormat:@"%0.2f", _material.realNumber.doubleValue]];
        [_numberLbl setContent:[[NSString alloc] initWithFormat:@"%0.2f", _amount.doubleValue]];
        
        switch(_type) {
            case INVENTORY_MATERIAL_IN_CELL:
                [_numberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_in" inTable:nil] andLabelWidth:0];
                break;
                
            case INVENTORY_MATERIAL_OUT_CELL:
                [_inventoryNumberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_realnumber" inTable:nil] andLabelWidth:0];
                [_numberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_out" inTable:nil] andLabelWidth:0];
                break;
                
            case INVENTORY_MATERIAL_MOVE_CELL:
                [_inventoryNumberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_dbcount" inTable:nil] andLabelWidth:0];
                [_inventoryNumberLbl setContent:[[NSString alloc] initWithFormat:@"%0.2f", _material.totalNumber.doubleValue]];
                
                [_numberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_move" inTable:nil] andLabelWidth:0];
                break;
                
            case INVENTORY_MATERIAL_RESERVE_CELL:
                [_numberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_count_reserve" inTable:nil] andLabelWidth:0];
                break;
        }
    }
}

//设置 Cell Type
- (void) setType:(InventoryMaterialType) type {
    _type = type;
    [self updateInfo];
}

- (void) setInfoWithMaterial:(MaterialEntity *) material {
    _material = material;
    [self updateInfo];
}

- (void) setInfoWithAmount:(NSNumber *) amount {
    _amount = amount;
    [self updateInfo];
}

- (void) setInfoWithMaterial:(MaterialEntity *) material amount:(NSNumber *) amount {
    _material = material;
    _amount = amount;
    [self updateInfo];
}

- (void) setShowFullSeperator:(BOOL)showFullSeperator {
    _showFullSeperator = showFullSeperator;
    [self updateSeperator];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat) calculateHeight {
    CGFloat padding = 14;
    CGFloat sepHeight = 10;
    CGFloat itemHeight = 16;
    
    CGFloat height = padding * 2 + itemHeight * 3 + sepHeight * 2;
    return height;
}

@end
