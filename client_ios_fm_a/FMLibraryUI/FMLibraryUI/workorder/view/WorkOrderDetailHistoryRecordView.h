//
//  WorkOrderDetailHistoryRecordView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/12.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderDetailHistoryRecordView : UIView <OnMessageHandleListener>

- (instancetype)init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置头像图片
- (void) setPortraitImage:(UIImage *) img;

//设置头像图片Url
- (void) setPortraitWithURL:(NSURL *) url;

//设置头像图片ID
- (void) setPortraitImageID:(NSNumber *) imgId;

- (void) setInfoWithIndex:(NSInteger) index
                     time:(NSNumber*) time
                 operater:(NSString*) operater
                     step:(NSInteger) step
                  content:(NSString *) content
                andPhotos:(NSMutableArray *) photos;


- (void) setOnMessageHandleListener:(id) handler;

+ (CGFloat) calculateHeightByInfo:(NSString *)content photoCount:(NSInteger) count andWidth:(CGFloat)width;

@end
