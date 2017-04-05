//
//  CheckableItemView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/18.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"


@interface CheckableItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
               isChecked:(BOOL) isChecked;
//是否选中
- (BOOL) isChecked;


- (void) setFont:(UIFont*) font;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;


- (void) setOnClickListener:(id<OnClickListener>) listener;
@end