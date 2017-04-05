//
//  BulletinTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BulletinTableViewCell : UITableViewCell

//小红点
@property (nonatomic, assign) BOOL isShowAnnotion;

//是否置顶
@property (nonatomic, assign) BOOL isTop;

//公告级别
@property (nonatomic, assign) NSInteger type;

//主题图片
@property (nonatomic, strong) NSNumber *themeImageId;

//标题
@property (nonatomic, strong) NSString *title;

//时间
@property (nonatomic, strong) NSNumber *time;

//作者
@property (nonatomic, strong) NSString *creator;

//获取高度
+ (CGFloat) getHeightOfCell;

@end
