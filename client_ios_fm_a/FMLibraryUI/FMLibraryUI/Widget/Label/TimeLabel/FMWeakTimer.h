//
//  FMWeakTimer.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/14.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FMTimerHandler)(id userInfo);

@interface FMWeakTimer : NSObject

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(FMTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end


