//
//  ContractQueryItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractEntity.h"

@interface ContractQueryItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithContract:(ContractEntity *) contract;

+ (CGFloat) getItemHeight;
@end
