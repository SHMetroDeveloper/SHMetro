//
//  NodeItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeList.h"

@interface NodeItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(NodeItem  *) node;
- (void) setShowMore:(BOOL) show;
- (void) setMaterialsAmount:(NSNumber *) amount;
- (void) setChecked:(NSNumber *) isChecked;

@end
