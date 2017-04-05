//
//  OrderEquipmentComponentTableViewCell.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/5.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "OrderEquipmentComponentTableViewCell.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"
#import "FMUtilsPackages.h"

@interface OrderEquipmentComponentTableViewCell ()
@property (nonatomic, strong) BaseLabelView * codeLbl;
@property (nonatomic, strong) BaseLabelView * nameLbl;
@property (nonatomic, strong) UIButton * replaceBtn;
@property (nonatomic, strong) SeperatorView * bottomLine;
@property (readwrite, nonatomic, assign) id<OnItemClickListener> clickListener;
@end

@implementation OrderEquipmentComponentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _codeLbl = [[BaseLabelView alloc] init];
    [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil] andLabelWidth:0];
    
    _nameLbl = [[BaseLabelView alloc] init];
    [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil] andLabelWidth:0];
    
    _replaceBtn = [UIButton new];
    _replaceBtn.titleLabel.font = [FMFont fontWithSize:13];
    [_replaceBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_component_operation_replace" inTable:nil] forState:UIControlStateNormal];
    [_replaceBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
    [_replaceBtn addTarget:self action:@selector(onReplaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomLine = [[SeperatorView alloc] init];
    
    [self.contentView addSubview:_codeLbl];
    [self.contentView addSubview:_nameLbl];
    [self.contentView addSubview:_replaceBtn];
    [self.contentView addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat padding = 15;
    CGFloat sepHeight = 10;
    CGFloat itemHeight = 18;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
   
    CGFloat originY = padding;
    
    [_codeLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_nameLbl setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_replaceBtn setFrame:CGRectMake(width-padding-height, 0, height, height)];
    
    if(_isLast) {
        [_bottomLine setDotted:NO];
        [_bottomLine setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    } else {
        [_bottomLine setDotted:YES];
        [_bottomLine setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    }
    
}

- (void)updateInfo {
    [_codeLbl setContent:_code];
    [_nameLbl setContent:_name];
    
    [self setNeedsLayout];
}

- (void) setName:(NSString *)name {
    _name = name;
    [self updateInfo];
}

- (void) setCode:(NSString *)code {
    _code = code;
    [self updateInfo];
}

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    [self setNeedsLayout];
}

- (void)onReplaceBtnClick:(UIButton *)sender {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_replaceBtn];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener{
    _clickListener = listener;
}

+ (CGFloat) getCellHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat itemHeight = 18;
    CGFloat sepHeight = 10;
    height = itemHeight * 2 + padding * 2 + sepHeight;
    return height;
}

@end
