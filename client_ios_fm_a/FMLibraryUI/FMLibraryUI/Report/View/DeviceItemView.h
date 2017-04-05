//
//  DeviceItemView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/7/27.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportEntity.h"


@interface DeviceItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithCode:(NSString *) code
                    name:(NSString *) name
                location:(NSString *) location;

+ (CGFloat) calculateHeight;


@end
