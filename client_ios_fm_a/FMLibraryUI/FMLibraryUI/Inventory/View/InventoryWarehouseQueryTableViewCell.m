//
//  InventoryWarehouseTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryWarehouseQueryTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface InventoryWarehouseQueryTableViewCell ()
@property (nonatomic, strong) DescriptionLabelView *nameLbl;
@property (nonatomic, strong) DescriptionLabelView *contactLbl;
@property (nonatomic, strong) DescriptionLabelView *locationLbl;
@property (nonatomic, strong) DescriptionLabelView *typeLbl;
@property (nonatomic, strong) DescriptionLabelView *amountLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *amount;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation InventoryWarehouseQueryTableViewCell

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
        
        _nameLbl = [[DescriptionLabelView alloc] init];
        _nameLbl.descLbl.font = mFont;
        _nameLbl.descLbl.textColor = titleColor;
        _nameLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_warehouse_name" inTable:nil];;
        _nameLbl.contentLbl.font = mFont;
        _nameLbl.contentLbl.textColor = contentColor;
        
        
        _contactLbl = [[DescriptionLabelView alloc] init];
        _contactLbl.descLbl.font = mFont;
        _contactLbl.descLbl.textColor = titleColor;
        _contactLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_admin" inTable:nil];;
        _contactLbl.contentLbl.font = mFont;
        _contactLbl.contentLbl.textColor = contentColor;
        
        
        _locationLbl = [[DescriptionLabelView alloc] init];
        _locationLbl.descLbl.font = mFont;
        _locationLbl.descLbl.textColor = titleColor;
        _locationLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_location" inTable:nil];;
        _locationLbl.contentLbl.font = mFont;
        _locationLbl.contentLbl.textColor = contentColor;
        
        
        _typeLbl = [[DescriptionLabelView alloc] init];
        _typeLbl.descLbl.font = mFont;
        _typeLbl.descLbl.textColor = titleColor;
        _typeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_category" inTable:nil];;
        _typeLbl.contentLbl.font = mFont;
        _typeLbl.contentLbl.textColor = contentColor;
        
        
        _amountLbl = [[DescriptionLabelView alloc] init];
        _amountLbl.descLbl.font = mFont;
        _amountLbl.descLbl.textColor = titleColor;
        _amountLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_query_amount" inTable:nil];;
        _amountLbl.contentLbl.font = mFont;
        _amountLbl.contentLbl.textColor = contentColor;
        
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_contactLbl];
        [self.contentView addSubview:_locationLbl];
        [self.contentView addSubview:_typeLbl];
        [self.contentView addSubview:_amountLbl];
        
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    CGFloat labelWidth = width-padding*2;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    
    [_nameLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + padding;
    
    [_contactLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + padding;
    
    [_locationLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + padding;
    
    [_typeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + padding;
    
    [_amountLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    if (_seperatorGapped) {
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
        [_seperator setDotted:YES];
    } else {
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void)updateInfo {
    [_nameLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl.contentLbl setText:_name];
    }
    
    [_contactLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contact]) {
        [_contactLbl.contentLbl setText:_contact];
    }
    
    [_locationLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_location]) {
        [_locationLbl.contentLbl setText:_location];
    }
    
    //解析type的类型 转化成 string
    [_typeLbl.contentLbl setText:_type];
    
    [_amountLbl.contentLbl setText:_amount];
    
//    [self setNeedsLayout];
}

- (void)setInfoWithName:(NSString *) name
                contact:(NSString *) contact
               location:(NSString *) location
                   type:(NSString *) type
                 amount:(NSString *) amount {
    _name = name;
    _contact = contact;
    _location = location;
    _type = type;
    _amount = amount;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    
    height = sepHeight*2 + padding*4 + labelHeight*5;
    
    return height;
}

@end
