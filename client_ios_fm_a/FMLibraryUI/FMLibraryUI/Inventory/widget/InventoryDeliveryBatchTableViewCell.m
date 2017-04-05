//
//  InventoryDeliveryBatchTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDeliveryBatchTableViewCell.h"
#import "BaseLabelView.h"
#import "MaterialEntity.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "SeperatorView.h"

@interface InventoryDeliveryBatchTableViewCell ()

@property (readwrite, nonatomic, strong) BaseLabelView * providerLbl;           //供应商
@property (readwrite, nonatomic, strong) BaseLabelView * dateLbl;           //入库日期
@property (readwrite, nonatomic, strong) BaseLabelView * dueDateLbl;          //过期日期
@property (readwrite, nonatomic, strong) BaseLabelView * priceLbl;          //单价
@property (readwrite, nonatomic, strong) BaseLabelView * inventoryNumberLbl;//账面数量
@property (readwrite, nonatomic, strong) BaseLabelView * numberLbl;         //出库数量

@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;   //底部分割线

@property (readwrite, nonatomic, strong) InventoryMaterialDetailBatchEntity * batch; //批次
@property (readwrite, nonatomic, strong) NSNumber * outNumber;  //出库数量
@property (readwrite, nonatomic, assign) InventoryDeliveryBatchTableViewCellType amountType;

@property (readwrite, nonatomic, assign) BOOL showFullSeperator;   //标记分割线是否显示全的

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation InventoryDeliveryBatchTableViewCell

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
        UIColor * amountColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        
        _providerLbl = [[BaseLabelView alloc] init];
        _dateLbl = [[BaseLabelView alloc] init];
        _dueDateLbl = [[BaseLabelView alloc] init];
        _priceLbl = [[BaseLabelView alloc] init];
        _inventoryNumberLbl = [[BaseLabelView alloc] init];
        _numberLbl = [[BaseLabelView alloc] init];
        
        [_providerLbl setLabelFont:font andColor:lblColor];
        [_providerLbl setContentColor:contentColor];
        [_providerLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_provider" inTable:nil] andLabelWidth:0];
        
        [_dateLbl setLabelFont:font andColor:lblColor];
        [_dateLbl setContentColor:contentColor];
        [_dateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_date" inTable:nil] andLabelWidth:0];
        
        [_dueDateLbl setLabelFont:font andColor:lblColor];
        [_dueDateLbl setContentColor:contentColor];
        [_dueDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_due_date" inTable:nil] andLabelWidth:0];
        
        [_priceLbl setLabelFont:font andColor:lblColor];
        [_priceLbl setContentColor:contentColor];
        [_priceLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_price" inTable:nil] andLabelWidth:0];
        
        [_inventoryNumberLbl setLabelFont:font andColor:lblColor];
        [_inventoryNumberLbl setContentColor:contentColor];
        [_inventoryNumberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_inventory_amount" inTable:nil] andLabelWidth:0];
        
        [_numberLbl setLabelFont:font andColor:lblColor];
        [_numberLbl setContentColor:amountColor];
        [_numberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount" inTable:nil] andLabelWidth:0];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_providerLbl];
        [self.contentView addSubview:_dateLbl];
        [self.contentView addSubview:_dueDateLbl];
        [self.contentView addSubview:_priceLbl];
        [self.contentView addSubview:_inventoryNumberLbl];
        [self.contentView addSubview:_numberLbl];
        
        [self.contentView addSubview:_bottomSeperator];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat height = CGRectGetHeight(self.frame);
//    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat padding = 14;
    CGFloat sepHeight = 10;
    
    CGFloat originY = padding;
    CGFloat itemHeight = 16;
    
    [_providerLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_dateLbl setFrame:CGRectMake(width/2, originY, width/2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_priceLbl setFrame:CGRectMake(0, originY, width/2, itemHeight)];
    [_dueDateLbl setFrame:CGRectMake(width/2, originY, width/2, itemHeight)];
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
        [_bottomSeperator setDotted:NO];
        [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    } else {
        [_bottomSeperator setDotted:YES];
        [_bottomSeperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    }
}

- (void) updateInfo {
    if(_batch) {
        [_providerLbl setContent:_batch.providerName];
        
        [_dateLbl setContent:@""];
        if (![FMUtils isNumberNullOrZero:_batch.date]) {
            [_dateLbl setContent:[FMUtils getDayStr:[FMUtils timeLongToDate:_batch.date]]];
        }
        
        [_dueDateLbl setContent:@""];
        if (![FMUtils isNumberNullOrZero:_batch.dueDate]) {
            [_dueDateLbl setContent:[FMUtils getDayStr:[FMUtils timeLongToDate:_batch.dueDate]]];
        }
        
        [_priceLbl setContent:[NSString stringWithFormat:@"%0.2f",_batch.cost.doubleValue]];
        
        [_inventoryNumberLbl setContent:[[NSString alloc] initWithFormat:@"%0.2f", _batch.amount.doubleValue]];
        
        if (_amountType == INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_DELIVERY) {
            [_numberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount" inTable:nil] andLabelWidth:0];
        } else if (_amountType == INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_SHIFT) {
            [_numberLbl setLabelText: [[BaseBundle getInstance] getStringByKey:@"inventory_shift_detail_header_batch_amount" inTable:nil] andLabelWidth:0];
        }
        [_numberLbl setContent:[[NSString alloc] initWithFormat:@"%0.2f", _outNumber.doubleValue]];
    }
}


- (void) setInfoWithBatch:(InventoryMaterialDetailBatchEntity *) batch {
    _batch = batch;
    [self updateInfo];
}

- (void) setInfoWithOutNumber:(NSNumber *) outNumber {
    _outNumber = outNumber;
    [self updateInfo];
}

- (void) setInfoWithBatch:(InventoryMaterialDetailBatchEntity *)batch outNumber:(NSNumber *)outNumber {
    _batch = batch;
    _outNumber = outNumber;
    [self updateInfo];
}

- (void) setShowFullSeperator:(BOOL)showFullSeperator {
    _showFullSeperator = showFullSeperator;
    [self updateSeperator];
}

//设置批次操作数量种类
- (void) setAmountType:(InventoryDeliveryBatchTableViewCellType) amountType {
    _amountType = amountType;
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

