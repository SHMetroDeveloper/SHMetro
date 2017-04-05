//
//  TaskWorkOrderDispachItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWorkOrderDispachItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setInfoWithCode:(NSString*) code
                    location:(NSString*) location
                    time:(NSString*) time
               serviceType:(NSString*) serviceType
                priority:(NSString*) priority ;

@end
