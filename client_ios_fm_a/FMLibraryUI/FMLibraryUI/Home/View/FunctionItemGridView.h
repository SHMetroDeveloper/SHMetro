//
//  ProjectItemGridView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface FunctionItemGridView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithLogo:(UIImage*)logo name:(NSString*) name message: (NSString*)message time:(NSString*) time state:(NSInteger) state;

- (void) setState:(NSInteger) state;

- (void) setNameFont:(UIFont *) msgFont;

- (void) setStatusFont:(UIFont *) statusFont;

- (void) setShowRightLine:(BOOL) show;

- (void) setShowBottomLine:(BOOL) show;

- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
