//
//  ContractEquipmentTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractEquipmentTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView2.h"
#import "SeperatorView.h"

@interface ContractEquipmentTableViewCell ()
@property (nonatomic, strong) UILabel *codeLbl;
@property (nonatomic, strong) DescriptionLabelView2 *locationLbl;
@property (nonatomic, strong) SeperatorView *seperator;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractEquipmentTableViewCell

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
        
        
        _codeLbl = [UILabel new];
        _codeLbl.font = [FMFont getInstance].font44;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _locationLbl = [[DescriptionLabelView2 alloc] init];
        _locationLbl.titleLbl.font = [FMFont getInstance].font38;
        _locationLbl.titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _locationLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_equipment_title_location" inTable:nil];
        _locationLbl.contentLbl.font = [FMFont getInstance].font38;
        _locationLbl.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_locationLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 15;
    CGFloat paddingTop = 18;
    CGFloat sepHeight = 10;
    CGFloat codeHeight = 19;
    CGFloat labelHeight = 17;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = padding;
    CGFloat originY = paddingTop;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding*2, codeHeight)];
    originY += codeHeight + sepHeight;
    
    [_locationLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)upadteInfo {
    NSString *codeStr = [NSString stringWithFormat:@""];
    if (![FMUtils isStringEmpty:_code]) {
        codeStr = [codeStr stringByAppendingString:_code];
    }
    if (![FMUtils isStringEmpty:_name]) {
        codeStr = [codeStr stringByAppendingFormat:@"(%@)",_name];
    }
    [_codeLbl setText:codeStr];
    
    [_locationLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_location]) {
        [_locationLbl.contentLbl setText:_location];
    }
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setEquipmentCode:(NSString *)code {
    _code = code;
}

- (void)setEquipmentName:(NSString *)name {
    _name = name;
}

- (void)setEquipmentLocation:(NSString *)location {
    _location = location;
    [self upadteInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat paddingTop = 18;
    CGFloat sepHeight = 10;
    CGFloat codeHeight = 19;
    CGFloat labelHeight = 17;
    
    height = codeHeight + labelHeight +paddingTop*2 + sepHeight;
    
    return height;
}

@end




