//
//  FastEntryAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastEntryItem.h"
#import "OnItemClickListener.h"

@interface FastEntryAlertContentView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
//
- (void) addItemWith:(FastEntryItem *) item;
- (void) setItemsWith:(NSMutableArray *) itemArray;
- (void) clearAllItems;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
