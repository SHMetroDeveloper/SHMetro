//
//  AssetContractView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetEquipmentDetailEntity.h"

typedef NS_ENUM(NSInteger, AssetContractType) {
    ASSET_CONTRACT_FIXED,   //维修合同
    ASSET_CONTRACT_MAINTAIN,   //维保合同
    ASSET_CONTRACT_OTHER,   //其他合同
};

@interface AssetContractView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setAssetContractInfoWith:(AssetEquipmentDetailEntity *) entity andContractType:(AssetContractType) type andPosition:(NSInteger) position;

+ (CGFloat)calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *)entity andWidth:(CGFloat)width andContractType:(AssetContractType)type andPosition:(NSInteger)position;

@end
