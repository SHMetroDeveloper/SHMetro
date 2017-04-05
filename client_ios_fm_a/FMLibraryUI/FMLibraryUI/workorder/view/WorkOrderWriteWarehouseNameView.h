//
//  WorkOrderWriteWarehouseNameView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/12.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface WorkOrderWriteWarehouseNameView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(NSString *) name;
- (void) setShowBound:(BOOL) show;
- (void) setEditable:(BOOL) editable;
- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
