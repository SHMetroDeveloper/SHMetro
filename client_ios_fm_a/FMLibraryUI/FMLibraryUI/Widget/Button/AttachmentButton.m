//
//  AttachmentButton.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/17/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "AttachmentButton.h"

@implementation AttachmentButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGRect newRect = CGRectMake(0, 0, width, height-10);
    
    return newRect;
}

@end
