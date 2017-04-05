//
//  PPMTaskView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/23.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMTaskView : UIView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString *) name
            hasWorkOrder:(BOOL) hasorder
                  status:(NSInteger) status
                    time:(NSNumber *) time ;

@end
