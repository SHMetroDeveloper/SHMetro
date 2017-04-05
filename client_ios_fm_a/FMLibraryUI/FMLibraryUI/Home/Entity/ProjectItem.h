//
//  ProjectItem.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProjectItem : NSObject

@property (readwrite, nonatomic, strong) NSString * projectName;
@property (readwrite, nonatomic, strong) UIImage * projectLogo;
@property (readwrite, nonatomic, assign) NSInteger projectState;
@property (readwrite, nonatomic, strong) NSString* projectMessage;
@property (readwrite, nonatomic, strong) NSString* projectMessageTime;

- (instancetype) init;
@end
