//
//  HorizontalFlowLayout.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "HorizontalFlowLayout.h"

@implementation HorizontalFlowLayout

- (instancetype) init {
    self = [super init];
    if(self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
