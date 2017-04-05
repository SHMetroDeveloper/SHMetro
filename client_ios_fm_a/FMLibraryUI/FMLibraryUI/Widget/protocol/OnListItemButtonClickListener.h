//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol OnListItemButtonClickListener <NSObject>

- (void) onButtonClick:(UIView*) parent view:(UIView*) view;

@end