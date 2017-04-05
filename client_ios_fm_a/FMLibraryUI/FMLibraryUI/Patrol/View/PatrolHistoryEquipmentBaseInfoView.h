//
//  PatrolHistoryEquipmentBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolServerConfig.h"

@interface PatrolHistoryEquipmentBaseInfoView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithDeviceName:(NSString *) name andSystemName:(NSString *) system;
- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;
- (void) setExceptionStatus:(PatrolEquipmentExceptionStatus) status;

+ (CGFloat) getBaseInfoHeight;

@end
