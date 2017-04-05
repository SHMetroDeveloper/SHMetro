//
//  FMMessageTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/12.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "NotificationServerConfig.h"

@interface FMMessageTableViewCell : SWTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuse:(NSString *)reuseIdentifier;

//设置是否为宽分割线
- (void) setSeperatorBroad:(BOOL) isBroad;

//设置是否为展示模式
- (void) setShowType:(BOOL) showType paddingLeft:(CGFloat) paddingLeft;

//设置信息
- (void) setInfoWithTitle:(NSString *)title
                  content:(NSString *)content
                     time:(NSNumber *)time
                     type:(NotificationItemType)type
                   status:(NSInteger)status
                     read:(BOOL) isRead;

//根据消息内容计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width paddingLeft:(CGFloat) paddingLeft;

@end






