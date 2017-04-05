//
//  OnValueChangedListener.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/20.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnValueChangedListener <NSObject>

- (void) onValueChanged:(UIView *) view type:(NSInteger) valueType value:(id) value;

@end
