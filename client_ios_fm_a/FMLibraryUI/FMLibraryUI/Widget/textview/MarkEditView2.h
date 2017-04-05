//
//  ReportBaseItemView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface MarkEditView2 : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setEditable:(BOOL)editable showMore:(BOOL) showmore isMarked:(BOOL) ismarked;

- (void) setTitle:(NSString *)title andDescription:(NSString *)desc;

- (NSString *) getContent;

//设置点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
