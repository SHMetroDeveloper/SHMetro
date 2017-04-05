//
//  SeperatorTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/11/27.
//  Copyright © 2015年 flynn. All rights reserved.
//
//  有间隔的 tableViewCell

#import <UIKit/UIKit.h>

@interface SeperatorTableViewCell : UITableViewCell



- (void) setFrame:(CGRect)frame;

//设置间隔高度
- (void) setSeperatorHeight:(CGFloat)seperatorHeight;

@end
