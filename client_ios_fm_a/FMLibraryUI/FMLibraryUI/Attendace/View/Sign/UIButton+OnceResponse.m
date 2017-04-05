//
//  UIButton+OnceResponse.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/17.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "UIButton+OnceResponse.h"
#import "FMUtilsPackages.h"
#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

//@interface UIButton (_OnceResponse)
//@end

//static const void *tapCountKey = &tapCountKey;
//static const void *currentTimerKey = &currentTimerKey;
//static const void *needLimitedKey = &needLimitedKey;
@implementation UIButton (_OnceResponse)

//- (NSNumber *)tapCount {
//    return objc_getAssociatedObject(self, tapCountKey);
//}
//
//- (void)setTapCount:(NSNumber *)tapCount {
//    objc_setAssociatedObject(self, tapCountKey, tapCount, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (NSTimer *)currentTimer {
//    return objc_getAssociatedObject(self, currentTimerKey);
//}
//
//- (void)setCurrentTimer:(NSTimer *)currentTimer {
//    objc_setAssociatedObject(self, currentTimerKey, currentTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (BOOL)needLimited {
//    return objc_getAssociatedObject(self, needLimitedKey);
//}
//
//- (void)setNeedLimited:(NSNumber *)needLimited {
//    objc_setAssociatedObject(self, needLimitedKey, needLimited, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//+ (void)load {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        Class selfClass = [self class];
//        
//        //获取UIButton原生的事件响应方法
//        SEL oriSEL = @selector(sendAction:to:forEvent:);
//        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
//        
//        //获取UIButton+OnceResponse自己写的事件响应方法
//        SEL cusSEL = @selector(mySendAction:to:forEvent:);
//        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
//        
//        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
//        if (addSucc) {
//            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//        }else {
//            method_exchangeImplementations(oriMethod, cusMethod);
//        }
//        
//    });
//}
//
//- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    if (![FMUtils isNumberNullOrZero:self.needLimited]) {
//        self.tapCount = [NSNumber numberWithInteger:self.tapCount.integerValue + 1];
//        if (self.currentTimer) {
//            //do nothing
//            NSLog(@"你在5秒内连续点击了这个按钮%ld次",self.tapCount.integerValue);
//            return;
//        } else {
//            self.tapCount = [NSNumber numberWithInteger:0];
//            [self mySendAction:action to:target forEvent:event];
//            [self setupTimer];
//            NSLog(@"UIButton做出了反应");
//            NSLog(@"你在5秒内连续点击了这个按钮%ld次",self.tapCount.integerValue);
//        }
//    } else {
//        [self mySendAction:action to:target forEvent:event];
//    }
//}
//
//- (void) setupTimer {
//    [self invalidateTimer];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(invalidateTimer)
//                                                    userInfo:nil repeats:YES];
//    
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    self.currentTimer = timer;
//}
//
//- (void) invalidateTimer {
//    [self.currentTimer invalidate];
//    self.currentTimer = nil;
//}

@end

#endif
