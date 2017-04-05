//
//  FastEntryItem.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FastEntryItem : NSObject
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) UIImage * icon;
@property (readwrite, nonatomic, strong) UIImage * iconHighlight;
@property (readwrite, nonatomic, assign) NSInteger key;
@end
