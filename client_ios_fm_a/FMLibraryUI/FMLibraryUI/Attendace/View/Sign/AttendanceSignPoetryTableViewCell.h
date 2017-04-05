//
//  AttendancePoetryTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/20.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceSignPoetryTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *poetry;

+ (CGFloat) calculateHeightBy:(NSString *) poetry;

@end
