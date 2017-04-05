//
//  AssetProfileView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetProfileView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithAssetTotalAmount:(NSInteger) amount
                       Assetcategory:(NSInteger) category
                        PlanMaintain:(NSInteger) ppm;

+ (CGFloat) calculateHeightByWidth:(CGFloat) width andTotalAmount:(NSInteger) amount category:(NSInteger) category planmaintain:(NSInteger) ppm;

@end
