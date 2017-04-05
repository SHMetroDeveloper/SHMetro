//
//  SingleCountView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleCountView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithName:(NSString *) name count:(NSInteger) count;

@end
