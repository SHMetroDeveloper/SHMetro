//
//  DownloadItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadItemView : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithName:(NSString *) name
                   isNew:(BOOL) isNew
                  status:(NSString *) status
                    time:(NSString *) time;

//设置状态信息颜色
- (void) setStatusColor:(UIColor *) color;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setSeperatorPadding:(CGFloat) padding;

- (void) updateStatus:(NSString *) status andTime:(NSString *) time progress:(CGFloat) progress;

- (void) updateNeweast:(BOOL) isNeweast;

@end
