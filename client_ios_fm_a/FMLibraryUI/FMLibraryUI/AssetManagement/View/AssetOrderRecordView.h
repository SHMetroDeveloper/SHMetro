//
//  AssetOrderRecordView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetWorkOrderRecordEntity.h"


@interface AssetOrderRecordView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setFixedRecordData:(AssetWorkOrderFixedEntity *) fixedData;

- (void) setMaintainRecordData:(AssetWorkOrderMaintainEntity *) maintainData;


+ (CGFloat) calculateFixedHeightBy:(AssetWorkOrderFixedEntity *) fixedData andWidth:(CGFloat) width;

+ (CGFloat) calculateMaintainHeightBy:(AssetWorkOrderMaintainEntity *) maintainData andWidth:(CGFloat) width;

@end
