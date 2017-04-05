//
//  ReportUnUploadItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ResizeableView.h"
#import "ReportEntity.h"
#import "OnListItemButtonClickListener.h"

typedef NS_ENUM(NSInteger, ReportUnUploadButtonTagType) {
    TAG_BUTTON_TYPE_UPLOAD_REPORT,
    TAG_BUTTON_TYPE_DELETE_REPORT
};

@interface ReportUnUploadItemView : ResizeableView <OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithServiceType:(NSString *)stype andContent:(NSString *) workContent andLocation:(NSString *) location andStatus:(NSInteger)status;

//设置内部对齐方式
- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>)listener;

//根据必要信息计算所需高度
+ (CGFloat) calculateHeightByContent:(NSString *) workContent andLocation:(NSString *) location withWidth:(CGFloat) width;
@end