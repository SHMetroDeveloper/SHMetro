//
//  FMTimeLabel.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "FMTimeLabel.h"
#import "FMUtilsPackages.h"
#import "FMWeakTimer.h"

@interface FMTimeLabel ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation FMTimeLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _timer = [FMWeakTimer scheduledTimerWithTimeInterval:1.0f block:^(id userInfo) {
            [weakSelf updateTime];
        } userInfo:nil repeats:YES];
        
        [self setText:[FMUtils getTimeDescriptionByDate:[NSDate date] format:@"HH:mm:ss"]];
    }
    return self;
}

- (void) updateTime {
    NSString *time = [FMUtils getTimeDescriptionByDate:[NSDate date] format:@"HH:mm:ss"];
    [self setText:time];
}

#pragma mark - Setter
- (void)setMFont:(UIFont *)mFont {
    self.font = mFont;
}

- (void)setMColor:(UIColor *)mColor {
    self.textColor = mColor;
}

- (void)dealloc {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

+ (CGSize) calculateSizeByFont:(UIFont *)font {
    NSString *time = [FMUtils getTimeDescriptionByDate:[NSDate date] format:@"HH:mm:ss"];
    CGSize size = [FMUtils getLabelSizeByFont:font andContent:time andMaxWidth:MAXFLOAT];
    
    return size;
}

@end
