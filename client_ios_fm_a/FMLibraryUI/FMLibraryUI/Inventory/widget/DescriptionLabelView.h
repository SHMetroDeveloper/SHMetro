//
//  DescriptionLabelView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 2016/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionLabelView : UIView

/**
 说明标签
 */
@property (nonatomic, strong) UILabel *descLbl;

/**
 内容
 */
@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) NSString *desc;  //标签标题

@property (nonatomic, strong) NSString *content;  //内容

@end
