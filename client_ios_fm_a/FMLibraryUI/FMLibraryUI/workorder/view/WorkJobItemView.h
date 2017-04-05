//
//  WorkJobItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface WorkJobItemView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setInfoWithCode:(NSString*) code
                 pfmCode:(NSString *) pfmCode
                    time:(NSString*) time
                location:(NSString*) location
                    desc:(NSString *) desc
                  status:(NSInteger) status
           laborerStatus:(NSInteger) laborerStatus
                priority:(NSInteger) priority;

//- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需高度
+ (CGFloat) calculateHeightByDesc:(NSString *) desc location:(NSString *) location pfmCode:(NSString *) pfmCode andWidth:(CGFloat) width ;

@end
