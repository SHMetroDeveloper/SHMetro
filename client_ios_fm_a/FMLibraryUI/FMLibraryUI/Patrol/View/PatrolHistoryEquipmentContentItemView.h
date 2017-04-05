//
//  PatrolHistoryEquipmentContentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, PatrolHistoryContentItemEventType) {
    PATROL_HISTORY_CONTENT_ITEM_EVENT_UNKNOW,
    PATROL_HISTORY_CONTENT_ITEM_EVENT_PROCESS,  //处理
    PATROL_HISTORY_CONTENT_ITEM_EVENT_SHOW_PHOTO,  //展示图片
};



@interface PatrolHistoryEquipmentContentItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithTitle:(NSString *) title
                andResult:(NSString *) result
                     desc:(NSString *) desc
                 hasPhoto:(BOOL) hasPhoto
                hasIgnore:(BOOL) hasIgnore
             hasException:(BOOL) hasException
             hasProcessed:(BOOL) hasProcessed
               showReport:(BOOL) showReport;

;

//设置图片，数据类型支持 NSURL , NSNumber, UIImage
- (void) setImages:(NSMutableArray *) imgArray;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

//设置报障按钮的点击事件代理
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//设置是否隐藏报障按钮
- (void) setHideReport:(BOOL) hide;

//计算所需的高度
+ (CGFloat) calculateHeightByTitle:(NSString *) title
                         andResult:(NSString *) result
                           andDesc:(NSString *) desc
                          andWidth:(CGFloat) width
                        showIgnore:(BOOL) showIgnore
                     showException:(BOOL) showException
                  showReportButton:(BOOL) showReport;

@end
