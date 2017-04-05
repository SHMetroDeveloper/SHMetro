//
//  ProjectItem.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "FunctionEntryItem.h"



@implementation FunctionEntryItem

- (instancetype) init {
    self = [super init];
    if(self) {
        self.projectName = nil;
        self.projectState = 0;
        self.projectLogo = nil;
    }
    return self;
}

@end