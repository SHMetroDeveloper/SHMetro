//
//  ProjectItem.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  功能入口

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FunctionEntryItem : NSObject

@property (readwrite, nonatomic, strong) NSString * projectName;
@property (readwrite, nonatomic, strong) UIImage * projectLogo;
@property (readwrite, nonatomic, assign) NSInteger projectState;
@property (readwrite, nonatomic, strong) NSString* projectMessage;
@property (readwrite, nonatomic, strong) NSString* projectMessageTime;
@property (readwrite, nonatomic, strong) Class entryClass;     

- (instancetype) init;
@end
