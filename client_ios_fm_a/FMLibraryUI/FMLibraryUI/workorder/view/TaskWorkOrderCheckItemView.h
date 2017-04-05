//
//  TaskWorkOrderCheckItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWorkOrderCheckItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setInfoWithCode:(NSString*) code
                    desc:(NSString*) desc
                    time:(NSString*) time
                checkType:(NSString*) checkType
                priority:(NSString*) priority;

@end