//
//  Token.m
//  hello
//
//  Created by 杨帆 on 15/3/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "Token.h"
#import "FMUtils.h"

@implementation Token


- (BOOL) isSessionValid {
    if (![FMUtils isStringEmpty:self.mAccessToken]) {
        if(self.mExpiresTime == 0 || [FMUtils currentTimeMills] < self.mExpiresTime) {
            return YES;
        }
    }
    return NO;
    
}
- (NSString *) toString {
    NSString * res = nil;
    NSString * date = [FMUtils getDateTimeStringBy:self.mExpiresTime format:@"yyyy/MM/dd hh:mm:ss"];
    res = [[NSString alloc] initWithFormat:@"mAccessToken:%@;mExpiresTime:%@;mRefreshToken:%@;mUid:%@", self.mAccessToken, date, self.mRefreshToken, self.mUid];
    return res;
}

@end