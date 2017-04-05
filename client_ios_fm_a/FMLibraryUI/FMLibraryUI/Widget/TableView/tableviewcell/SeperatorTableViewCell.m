//
//  SeperatorTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/11/27.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "SeperatorTableViewCell.h"

@interface SeperatorTableViewCell ()

@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;

@end

@implementation SeperatorTableViewCell

- (void) setFrame:(CGRect)frame {
    frame.size.height -= _seperatorHeight;
    [super setFrame:frame];
}

- (void) setSeperatorHeight:(CGFloat)seperatorHeight {
    _seperatorHeight = seperatorHeight;
}

@end
