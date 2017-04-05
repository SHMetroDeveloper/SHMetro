//
//  InventoryProviderTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryProviderTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface InventoryProviderTableViewCell ()
@property (nonatomic, strong) UILabel *nameLbl;
//@property (nonatomic, strong) UILabel *contactLbl;
//@property (nonatomic, strong) DescriptionLabelView *locationLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryProviderTableViewCell

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
        
//        UIFont *mFont = [FMFont getInstance].font38;
//        UIColor *titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font44;;
        _nameLbl.textColor = contentColor;
        
//        _contactLbl = [[UILabel alloc] init];
//        _contactLbl.font = mFont;
//        _contactLbl.textColor = contentColor;
//        
//        _locationLbl = [[DescriptionLabelView alloc] init];
//        _locationLbl.descLbl.font = mFont;
//        _locationLbl.descLbl.textColor = titleColor;
//        _locationLbl.descLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_order_record_location" inTable:nil];
//        _locationLbl.contentLbl.font = mFont;
//        _locationLbl.contentLbl.textColor = contentColor;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
//        [self.contentView addSubview:_contactLbl];
//        [self.contentView addSubview:_locationLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat nameHeight = 19;
//    CGFloat labelHeight = 17;
    CGFloat labelWidth = width-padding*2;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, labelWidth, nameHeight)];
    originY += nameHeight + sepHeight;
    
//    [_contactLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
//    originY += labelHeight + sepHeight;
//    
//    [_locationLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
//    originY += labelHeight + sepHeight;

    if (_seperatorGapped) {
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
        [_seperator setDotted:YES];
    } else {
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
        [_seperator setDotted:NO];
    }
}

- (void)updateInfo {
    [_nameLbl setText:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl setText:_name];
    }
    
//    NSMutableString *contact = [[NSMutableString alloc] initWithString:@""];
//    if (![FMUtils isStringEmpty:_contact]) {
//        [contact appendString:_contact];
//    }
//    if (![FMUtils isStringEmpty:_phone]) {
//        [contact appendFormat:@"(%@)",_phone];
//    }
//    [_contactLbl setText:contact];
//    
//    [_locationLbl.contentLbl setText:@""];
//    if (![FMUtils isStringEmpty:_location]) {
//        [_locationLbl.contentLbl setText:_location];
//    }
}

- (void)setSeperatorGapped:(BOOL)seperatorGapped {
    _seperatorGapped = seperatorGapped;
    [self setNeedsDisplay];
}

- (void)setInfoWithName:(NSString *) name
                contact:(NSString *) contact
                  phone:(NSString* ) phone
               location:(NSString *) location {
    _name = name;
//    _contact = contact;
//    _phone = phone;
//    _location = location;
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
 
    CGFloat sepHeight = 18;
    CGFloat nameHeight = 19;
    
    height = sepHeight*2 + nameHeight;
    
    return height;
}

@end
