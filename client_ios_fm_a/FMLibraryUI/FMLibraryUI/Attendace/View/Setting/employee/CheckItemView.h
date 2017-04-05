//
//  CheckedItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, CheckableItemEventType) {
    CHECKABLE_ITEM_EVENT_TYPE_UNKNOW,
    CHECKABLE_ITEM_EVENT_TYPE_CHECK_UPDATE, //选框状态变化
    CHECKABLE_ITEM_EVENT_TYPE_RIGHT_CLICK,  //右侧图标点击
};

@interface CheckItemView : UIView

//初始化
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置是否显示右侧图片
- (void) setShowRightImage:(BOOL) show;
- (void) setRightImage:(UIImage *) image;
- (void) setChecked:(BOOL) checked;
- (void) setInfoWithName:(NSString *) name desc:(NSString *) desc; //设置基本信息

- (void) setRightImgWidth:(CGFloat) imgWidth;
//设置事件代理
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
