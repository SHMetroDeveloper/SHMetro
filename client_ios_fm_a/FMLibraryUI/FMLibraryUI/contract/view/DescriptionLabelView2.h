//
//  DescriptionLabelView2.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionLabelView2 : UIView

/**
 说明标签
 */
@property (nonatomic, strong) UILabel *titleLbl;

/**
 内容
 */
@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) NSString *title;  //标签标题

@property (nonatomic, strong) NSString *content;  //内容

- (CGFloat)getHeight;

@end
