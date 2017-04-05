//
//  AssetFactoryView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetEquipmentDetailEntity.h"

typedef NS_ENUM(NSInteger, AssetFactoryType) {
    ASSET_FACTORY_MANUFACTURER,    //生厂商
    ASSET_FACTORY_SUPPLIER,    //供应商
    ASSET_FACTORY_INSTALLER,    //安装单位
};

@interface AssetFactoryView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setAssetFactoryInfoWith:(AssetEquipmentDetailEntity *) entity andContractType:(AssetFactoryType) type;

+ (CGFloat)calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *)entity andWidth:(CGFloat)width andContractType:(AssetFactoryType)type;

@end
