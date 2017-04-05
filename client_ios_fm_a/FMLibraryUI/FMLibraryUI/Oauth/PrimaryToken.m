//
//  PrimaryToken.m
//  FMLibraryUI
//
//  Created by 林江锋 on 2017/3/27.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "PrimaryToken.h"

PrimaryToken *primaryTokenInstance;

@interface PrimaryToken ()
@property (nonatomic, strong) NSString *primaryToken;
@property (nonatomic, strong) NSString *mAccessToken;
@property (nonatomic, strong) NSString *mRefreshToken;
@end

@implementation PrimaryToken

+ (instancetype) getInstance {
    if(!primaryTokenInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            primaryTokenInstance = [[PrimaryToken alloc] init];
        });
    }
    return primaryTokenInstance;
}

- (void)setPrimaryToken:(NSString *)pyToken {
    _primaryToken = [pyToken copy];
    [self tokenConvert];
}

#pragma mark - Private Method
- (void)tokenConvert {
    
}


@end
