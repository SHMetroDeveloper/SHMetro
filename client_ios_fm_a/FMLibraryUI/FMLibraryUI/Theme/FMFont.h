//
//  FMFont.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMFont : NSObject

- (instancetype) init;
+ (instancetype) getInstance;


//默认字体
@property (readwrite, nonatomic, strong) UIFont * defaultFontLevel1;
@property (readwrite, nonatomic, strong) UIFont * defaultFontLevel2;
@property (readwrite, nonatomic, strong) UIFont * defaultFontLevel3;
@property (readwrite, nonatomic, strong) UIFont * defaultFontLevel4;

//menu
@property (readwrite, nonatomic, strong) UIFont * menuTitleFont;
@property (readwrite, nonatomic, strong) UIFont * menuItemFont;


//默认的标签字体
@property (readwrite, nonatomic, strong) UIFont * defaultLabelFont;
//默认的按钮
@property (readwrite, nonatomic, strong) UIFont * defaultButtonFont;

//我的消息
@property (readwrite, nonatomic, strong) UIFont * msgItemFontLogo;  //左侧标签字体

//功能
@property (readwrite, nonatomic, strong) UIFont * functionItemFontMsg;

//我的
@property (readwrite, nonatomic, strong) UIFont * userItemFontMsg;
@property (readwrite, nonatomic, strong) UIFont * userItemFontStatus;

//列表
@property (readwrite, nonatomic, strong) UIFont * listFontHeaderLevel1;
@property (readwrite, nonatomic, strong) UIFont * listFontMsgLevel1;
@property (readwrite, nonatomic, strong) UIFont * listFontMsgLevel2;
@property (readwrite, nonatomic, strong) UIFont * listFontBtnLevel1;

@property (readwrite, nonatomic, strong) UIFont * listCodeFont;
@property (readwrite, nonatomic, strong) UIFont * ListTimeFont;
@property (readwrite, nonatomic, strong) UIFont * listPriorityFont;
@property (readwrite, nonatomic, strong) UIFont * listDescFont;

@property (readwrite, nonatomic, strong) UIFont * font44;  //单行高度大约是19
@property (readwrite, nonatomic, strong) UIFont * font42;
@property (readwrite, nonatomic, strong) UIFont * font38;  //单行高度大约是17

//图表
@property (readwrite, nonatomic, strong) UIFont * chartCountFont;
@property (readwrite, nonatomic, strong) UIFont * chartTitleFont;
@property (readwrite, nonatomic, strong) UIFont * chartDefaultFont;

//能源管理
@property (readwrite, nonatomic, strong) UIFont * energyItemTitleFont;
@property (readwrite, nonatomic, strong) UIFont * energyItemContentFont;

//获取指定大小的字体
+ (UIFont *) fontWithSize:(CGFloat) size;
//获取占指定像素大小的字体
+ (UIFont *)setFontByPX:(CGFloat) px;
@end




