//
//  SpotContentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotContentItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                   state:(NSString*) state
               exception:(BOOL) isException
                   count:(NSInteger) count
               showImage:(BOOL) show
         exceptionStatus:(NSNumber *) exceptionStatus;

@end
