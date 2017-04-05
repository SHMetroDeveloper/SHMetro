//
//  ShowMoreDetailTableViewCell.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/28.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMoreDetailTableViewCell : UITableViewCell

- (void) setFrame:(CGRect)frame;

//设置间隔高度
- (void)setSeperatorHeight:(CGFloat)seperatorHeight andShowMoreHeight:(CGFloat) showMoreHeight;

@end
