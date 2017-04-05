//
//  AssetFactoryView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetFactoryView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AssetFactoryView()

@property (nonatomic, strong) BaseLabelView * contactLbl;
@property (nonatomic, strong) BaseLabelView * phoneLbl;
@property (nonatomic, strong) BaseLabelView * locationLbl;

@property (nonatomic, strong) NSString * contact;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * location;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetFactoryView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _contactLbl = [[BaseLabelView alloc] init];
        [_contactLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_factory_contact" inTable:nil] andLabelWidth:0];
        [_contactLbl setLabelFont:mFont andColor:labelColor];
        [_contactLbl setLabelAlignment:NSTextAlignmentLeft];
        [_contactLbl setContentFont:mFont];
        [_contactLbl setContentColor:contentColor];
        [_contactLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _phoneLbl = [[BaseLabelView alloc] init];
        [_phoneLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_factory_phone" inTable:nil] andLabelWidth:0];
        [_phoneLbl setLabelFont:mFont andColor:labelColor];
        [_phoneLbl setLabelAlignment:NSTextAlignmentLeft];
        [_phoneLbl setContentFont:mFont];
        [_phoneLbl setContentColor:contentColor];
        [_phoneLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _locationLbl = [[BaseLabelView alloc] init];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_factory_address" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:labelColor];
        [_locationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:contentColor];
        [_locationLbl setContentAlignment:NSTextAlignmentLeft];
        [_locationLbl setShowOneLine:NO];
        
        
        [self addSubview:_contactLbl];
        [self addSubview:_phoneLbl];
        [self addSubview:_locationLbl];
        
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat defaultItemHeight = 26.7f;
    CGFloat originX = 0;
    CGFloat originY = padding;
 
    [_contactLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    [_phoneLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += itemHeight + padding;
    
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:_location font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_factory_address" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:width-padding];
    if (locationHeight < defaultItemHeight) {
        locationHeight = itemHeight;
    }
    [_locationLbl setFrame:CGRectMake(originX, originY, width-padding, locationHeight)];
    
}

- (void) updateInfo {
    [_contactLbl setContent:_contact];
    [_phoneLbl setContent:_phone];
    [_locationLbl setContent:_location];
    
    [self updateViews];
}

- (void) setAssetFactoryInfoWith:(AssetEquipmentDetailEntity *) entity andContractType:(AssetFactoryType) type {
    _contact = @"";
    _phone = @"";
    _location = @"";
    
    switch (type) {
        case ASSET_FACTORY_MANUFACTURER:{
            AssetEquipmentManufacturer * manufacturer = entity.manufacturer;
            _contact = manufacturer.contact;
            _phone = manufacturer.phone;
            _location = manufacturer.address;
        }
            break;
        case ASSET_FACTORY_SUPPLIER:{
            AssetEquipmentProvider * provider = entity.provider;
            _contact = provider.contact;
            _phone = provider.phone;
            _location = provider.address;
        }
            break;
        case ASSET_FACTORY_INSTALLER:{
            AssetEquipmentInstaller * installer = entity.installer;
            _contact = installer.contact;
            _phone = installer.phone;
            _location = installer.address;
        }
            break;
    }
    
    [self updateInfo];
}

+ (CGFloat)calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *)entity andWidth:(CGFloat)width andContractType:(AssetFactoryType)type {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat defaultItemHeight = 26.7f;
    CGFloat locationHeight = 0;
    
    height = itemHeight*2 + padding*4;
    switch (type) {
        case ASSET_FACTORY_MANUFACTURER:{
            AssetEquipmentManufacturer * manufacturer = entity.manufacturer;
            locationHeight = [BaseLabelView calculateHeightByInfo:manufacturer.address font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_factory_address" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:width-padding];
        }
            break;
        case ASSET_FACTORY_SUPPLIER:{
            AssetEquipmentProvider * supplier = entity.provider;
            locationHeight = [BaseLabelView calculateHeightByInfo:supplier.address font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_factory_address" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:width-padding];
        }
            break;
        case ASSET_FACTORY_INSTALLER:{
            AssetEquipmentInstaller * installer = entity.installer;
            locationHeight = [BaseLabelView calculateHeightByInfo:installer.address font:[FMFont getInstance].font38 desc:[[BaseBundle getInstance] getStringByKey:@"asset_factory_address" inTable:nil] labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:width-padding];
        }
            break;
    }
    
    if (locationHeight < defaultItemHeight) {
        locationHeight = itemHeight;
    }
    height += locationHeight;
    
    return height;
}


@end






