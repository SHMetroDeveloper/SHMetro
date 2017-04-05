//
//  RequirementDetailRequestorView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/25.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequirementDetailEntity.h"

@interface RequirementDetailRequestorView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(RequirementRequestor *) requestor;

@end
