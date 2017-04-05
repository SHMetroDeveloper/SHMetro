//
//  WorkOrderWriteLaborerItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderWriteLaborerItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithName:(NSString *) name
                position:(NSString *) position
                   telno:(NSString *) telno
                  status:(NSString*) status
              arriveTime:(NSString*) arriveTime
              finishTime:(NSString*) finishTime;

@end

