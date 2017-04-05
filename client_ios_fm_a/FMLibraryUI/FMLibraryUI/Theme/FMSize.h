//
//  FMSize.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMSize : NSObject

- (instancetype) init;
+ (instancetype) getInstance;
+ (CGFloat) getSizeByPixel:(CGFloat) pixel;

@property (readwrite, nonatomic, assign) CGFloat defaultAnimationDuration;  //默认的动画持续时间。

//title
@property (readwrite, nonatomic, assign) CGFloat navigationTitleImgWidth;
@property (readwrite, nonatomic, assign) CGFloat navigationTitleImgHeight;

//menu
@property (readwrite, nonatomic, assign) CGFloat menuItemWidth;
@property (readwrite, nonatomic, assign) CGFloat menuBackImageWidth;
@property (readwrite, nonatomic, assign) CGFloat menuItemImageWidth;

@property (readwrite, nonatomic, assign) CGFloat defaultPadding;    //默认边距
@property (readwrite, nonatomic, assign) CGFloat listePadding;    //默认边距
@property (readwrite, nonatomic, assign) CGFloat defaultNoticeHeight;    //无数据时的提示框的高度

//screen
@property (readwrite ,nonatomic, assign) CGFloat screenHeight;
@property (readwrite ,nonatomic, assign) CGFloat screenWidth;
@property (readwrite ,nonatomic, assign) CGFloat screenContentHeight;
@property (readwrite ,nonatomic, assign) CGFloat screenContentWidth;

//padding
@property (readwrite, nonatomic, assign) CGFloat padding20;
@property (readwrite, nonatomic, assign) CGFloat padding30;
@property (readwrite, nonatomic, assign) CGFloat padding40;
@property (readwrite, nonatomic, assign) CGFloat padding50;
@property (readwrite, nonatomic, assign) CGFloat padding60;
@property (readwrite, nonatomic, assign) CGFloat padding70;
@property (readwrite, nonatomic, assign) CGFloat padding80;
@property (readwrite, nonatomic, assign) CGFloat padding90;
@property (readwrite, nonatomic, assign) CGFloat padding100;

// selectList
@property (readwrite, nonatomic, assign) CGFloat selectListItemHeight;
@property (readwrite, nonatomic, assign) CGFloat selectHeaderHeight;

//button
@property (readwrite, nonatomic, assign) CGFloat btnBorderWidth;
@property (readwrite, nonatomic, assign) CGFloat btnBorderRadius;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, assign) CGFloat btnBottomControlHeight;    //页面底部按钮高度
@property (readwrite, nonatomic, assign) CGFloat bottomControlHeight;    //页面底部区域高度
@property (readwrite, nonatomic, assign) CGFloat topControlHeight;    //页面顶部区域高度

//textfield
@property (readwrite, nonatomic, assign) CGFloat inputLineHeight;   //输入框底部线高

//checkable 按钮
@property (readwrite, nonatomic, assign) CGFloat checkableBtnHeight;

//过滤按钮
@property (readwrite, nonatomic, assign) CGFloat filterWidth;
@property (readwrite, nonatomic, assign) CGFloat filterHeight;

//notice
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;  //默认的无网络时提示信息的高度
@property (readwrite, nonatomic, assign) CGFloat noticeLogoWidth;
@property (readwrite, nonatomic, assign) CGFloat noticeLogoHeight;

//image
@property (readwrite, nonatomic, assign) CGFloat imgWidthLevel1;    //默认图片宽度
@property (readwrite, nonatomic, assign) CGFloat imgWidthLevel2;    //默认图片宽度
@property (readwrite, nonatomic, assign) CGFloat imgWidthLevel3;    //默认图片宽度
@property (readwrite, nonatomic, assign) CGFloat imgWidthLevel4;    //默认图片宽度


@property (readwrite, nonatomic, assign) CGFloat cameraImageWidth;  //拍照图片宽度
@property (readwrite, nonatomic, assign) CGFloat cameraImageHeight;  //拍照图片高度

//tabbar
@property (readwrite, nonatomic, assign) CGFloat tabbarHeight;
//statusbar
@property (readwrite, nonatomic, assign) CGFloat navigationbarHeight;
//statusbar
@property (readwrite, nonatomic, assign) CGFloat statusbarHeight;

//datePicker
@property (readwrite, nonatomic, assign) CGFloat datePickerHeight;
@property (readwrite, nonatomic, assign) CGFloat datePickerMarginLeft;
@property (readwrite, nonatomic, assign) CGFloat datePickerMarginRight;

//


//seperator
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;

//border
@property (readwrite, nonatomic, assign) CGFloat defaultBorderWidth;
@property (readwrite, nonatomic, assign) CGFloat defaultBorderRadius;
@property (readwrite, nonatomic, assign) CGFloat colorLblBorderRadius;


//sepHeight
@property (readwrite, nonatomic, assign) CGFloat sepHeight;

//列表项
@property (readwrite, nonatomic, assign) CGFloat listItemPaddingLeft;   //左边距
@property (readwrite, nonatomic, assign) CGFloat listItemPaddingRight;  //右边距
@property (readwrite, nonatomic, assign) CGFloat listItemBtnHeight;     //按钮高度
@property (readwrite, nonatomic, assign) CGFloat listItemInfoHeight;     //默认信息高度
@property (readwrite, nonatomic, assign) CGFloat listHeaderHeight;     //默认header高度
@property (readwrite, nonatomic, assign) CGFloat listFooterHeight;     //默认footer高度

//图表
@property (readwrite, nonatomic, assign) CGFloat chartItemHeaderHeaght; //
@property (readwrite, nonatomic, assign) CGFloat chartItemCountHeaght;  //
@property (readwrite, nonatomic, assign) CGFloat chartItemDescHeaght;   //

//功能
@property (readwrite, nonatomic, assign) CGFloat functionItemHeight;      //功能页面的列表项的高度
@property (readwrite, nonatomic, assign) CGFloat functionItemPaddingLeft;      //列表项距左边距
@property (readwrite, nonatomic, assign) CGFloat functionItemTextSize;      //功能页面的字体大小
@property (readwrite, nonatomic, assign) CGFloat functionItemLogoWidth;      //功能页面的logo宽度

//我的消息
@property (readwrite, nonatomic, assign) CGFloat msgItemHeight;   //总高度
@property (readwrite, nonatomic, assign) CGFloat msgNoticeHeight;   //总高度
@property (readwrite, nonatomic, assign) CGFloat msgNoticeLogoHeight;   //图标高度
@property (readwrite, nonatomic, assign) CGFloat msgPaddingLeft;   //左侧间距

//我的
@property (readwrite, nonatomic, assign) CGFloat userPaddingTop;      //上边距
@property (readwrite, nonatomic, assign) CGFloat userPaddingLeft;      //左边距
@property (readwrite, nonatomic, assign) CGFloat userPaddingRight;      //右边距

@property (readwrite, nonatomic, assign) CGFloat userBaseInfoHeight;      //列表项的高度

@property (readwrite, nonatomic, assign) CGFloat userItemHeight;      //列表项的高度
@property (readwrite, nonatomic, assign) CGFloat userItemSepHeight;      //列表项的间隔高度
@property (readwrite, nonatomic, assign) CGFloat userItemLogoWidth;      //logo宽度
@property (readwrite, nonatomic, assign) CGFloat userItemTextSize;      //字体大小


//设置
@property (readwrite, nonatomic, assign) CGFloat settingItemLogoWidth;
@property (readwrite, nonatomic, assign) CGFloat settingPaddingLeft;
@property (readwrite, nonatomic, assign) CGFloat settingPaddingRight;
@property (readwrite, nonatomic, assign) CGFloat settingItemHeight;      //列表项的高度
@property (readwrite, nonatomic, assign) CGFloat settingItemSepHeight;      //列表项的间隔高度


//巡检
@property (readwrite, nonatomic, assign) CGFloat filterControlHeight;
@property (readwrite, nonatomic, assign) CGFloat filterBtnWidth;
@property (readwrite, nonatomic, assign) CGFloat filterBtnHeight;

//分组
@property (readwrite, nonatomic, assign) CGFloat groupItemHeight;
@property (readwrite, nonatomic, assign) CGFloat groupSepHeight;

//库存
@property (readwrite, nonatomic, assign) CGFloat btnPaddingHeight;  //库存模块底部按钮的边距

@end
