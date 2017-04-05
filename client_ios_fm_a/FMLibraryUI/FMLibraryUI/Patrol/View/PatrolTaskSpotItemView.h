//
//  PatrolTaskSpotItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolTaskSpotItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                position:(NSString*) position
               composite:(NSInteger) compositeCount
                  device:(NSInteger) deviceCount
                   state:(NSString*) state
                  notice:(NSString*) notice;

- (void) setInfoWithName:(NSString*) name
                taskName:(NSString *) taskName
                position:(NSString*) position
               composite:(NSInteger) compositeCount
                  device:(NSInteger) deviceCount
                   state:(NSString*) state
                  notice:(NSString*) notice;

@end
