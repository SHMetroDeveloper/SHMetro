//
//  FMColor.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMResourceTable.h"

@interface FMColor : NSObject

#pragma mark - 默认 颜色
@property (readwrite, nonatomic, strong) UIColor * themeColor;        //主题色
@property (readwrite, nonatomic, strong) UIColor * themeHighlightColor;        //主题色，高亮

@property (readwrite, nonatomic, strong) UIColor * mainBlack;       //黑色
@property (readwrite, nonatomic, strong) UIColor * mainWhite;       //白色
@property (readwrite, nonatomic, strong) UIColor * mainGreen;       //绿色
@property (readwrite, nonatomic, strong) UIColor * mainGreenHighlighted;       //绿色
@property (readwrite, nonatomic, strong) UIColor * mainBlue;       //蓝色
@property (readwrite, nonatomic, strong) UIColor * mainBlueHighlighted;       //蓝色高亮
@property (readwrite, nonatomic, strong) UIColor * mainTransparentGray;//半透明
@property (readwrite, nonatomic, strong) UIColor * mainRed;         //红色
@property (readwrite, nonatomic, strong) UIColor * mainRedHighlighted; //红色高亮
@property (readwrite, nonatomic, strong) UIColor * mainOrange;      //橘黄色
@property (readwrite, nonatomic, strong) UIColor * mainOrangeHighlighted;      //橘黄色高亮
@property (readwrite, nonatomic, strong) UIColor * mainVoilet;          //紫色
@property (readwrite, nonatomic, strong) UIColor * mainVoiletHighlight;          //紫色


@property (readwrite, nonatomic, strong) UIColor * mainText;          //主字体色
@property (readwrite, nonatomic, strong) UIColor * mainDesc;          //描述色

//placeholder
@property (readwrite, nonatomic, strong) UIColor * placeholder;

//深红色
@property (readwrite, nonatomic, strong) UIColor * darkRed;

//
@property (readwrite, nonatomic, strong) UIColor * mainBackground;  //

@property (readwrite, nonatomic, strong) UIColor * logoutRed;  //
@property (readwrite, nonatomic, strong) UIColor * noticeRed;  //通知类的提示信息

//高亮色
@property (readwrite, nonatomic, strong) UIColor * mainHighLight;  //

@property (readwrite, nonatomic, strong) UIColor * homeTabhostBg;
@property (readwrite, nonatomic, strong) UIColor * noteBeginItemBg;
@property (readwrite, nonatomic, strong) UIColor * inProcessItemBg;
@property (readwrite, nonatomic, strong) UIColor * finishItemBg;

@property (readwrite, nonatomic, strong) UIColor * navigationTitle;    //导航栏标题文本颜色
@property (readwrite, nonatomic, strong) UIColor * navigationSeperatorBg;   //导航栏分割线颜色
@property (readwrite, nonatomic, strong) UIColor * topbarIndicator;   //分割线颜色
@property (readwrite, nonatomic, strong) UIColor * topbarBg;           //topbar 背景色
@property (readwrite, nonatomic, strong) UIColor * topbarTextBlack;   //topbar 字体颜色

@property (readwrite, nonatomic, strong) UIColor * mainBound;   //边框颜色
@property (readwrite, nonatomic, strong) UIColor * seperatorLight;   //浅分割线
@property (readwrite, nonatomic, strong) UIColor * seperatorDialog; //自定义对话框按钮的分割线

//tabbar
@property (readwrite, nonatomic, strong) UIColor * tabbarBg;

//menu
@property (readwrite, nonatomic, strong) UIColor * menuItemColorNormal;
@property (readwrite, nonatomic, strong) UIColor * menuItemColorHighlight;
@property (readwrite, nonatomic, strong) UIColor * alertMenuItemColorNormal;    //弹出菜单
@property (readwrite, nonatomic, strong) UIColor * alertMenuItemColorCancel;    //弹出菜单
//@property (readwrite, nonatomic, strong) UIColor * alertMenuItemColorHighlight;

//功能
@property (readwrite, nonatomic, strong) UIColor * functionItemLayerBorder; //

//消息
@property (readwrite, nonatomic, strong) UIColor * msgTitle;    //消息标题
@property (readwrite, nonatomic, strong) UIColor * msgPatrol;   //巡检消息
@property (readwrite, nonatomic, strong) UIColor * msgOrderUndo;   //待处理工单
@property (readwrite, nonatomic, strong) UIColor * msgOrderApproval;   //待审核工单
@property (readwrite, nonatomic, strong) UIColor * msgOrderDispach;   //待派工工单
@property (readwrite, nonatomic, strong) UIColor * msgServiceCenter;   //服务台
@property (readwrite, nonatomic, strong) UIColor * msgInventory;    //库存
@property (readwrite, nonatomic, strong) UIColor * msgAsset;        //资产
@property (readwrite, nonatomic, strong) UIColor * msgMaintenance;   //计划性维护

@property (readwrite, nonatomic, strong) UIColor * grayLevel1;   //#333333
@property (readwrite, nonatomic, strong) UIColor * grayLevel2;   //#474747
@property (readwrite, nonatomic, strong) UIColor * grayLevel3;   //#666666
@property (readwrite, nonatomic, strong) UIColor * grayLevel4;   //#808080
@property (readwrite, nonatomic, strong) UIColor * grayLevel5;   //#999999
@property (readwrite, nonatomic, strong) UIColor * grayLevel6;   //#b3b3b3
@property (readwrite, nonatomic, strong) UIColor * grayLevel7;   //#cccccc
@property (readwrite, nonatomic, strong) UIColor * grayLevel8;   //#dddddd
@property (readwrite, nonatomic, strong) UIColor * grayLevel9;   //#f0f0f0
@property (readwrite, nonatomic, strong) UIColor * grayLevel10;  //#8a9492

//下载状态颜色
@property (readwrite, nonatomic, strong) UIColor * downloadStatusUnDownloaded;   //未下载
@property (readwrite, nonatomic, strong) UIColor * downloadStatusUnUpdated;   //待更新
@property (readwrite, nonatomic, strong) UIColor * downloadStatusDownloaded;   //已下载

//WorkOrder
@property (readwrite, nonatomic, strong) UIColor * status_personal_un_accept;//
@property (readwrite, nonatomic, strong) UIColor * status_personal_accept;
@property (readwrite, nonatomic, strong) UIColor * status_personal_back;
@property (readwrite, nonatomic, strong) UIColor * status_personal_submit;

//列表
@property (readwrite, nonatomic, strong) UIColor * listHeaderMark;  //列表头的左侧标签

@property (readwrite, nonatomic, strong) UIColor * listCodeColor;      //工单编号
@property (readwrite, nonatomic, strong) UIColor * listTimeColor;      //工单时间
@property (readwrite, nonatomic, strong) UIColor * listPriorityColor;  //工单优先级
@property (readwrite, nonatomic, strong) UIColor * listDescColor;      //工单描述信息

//计划性维护
@property (readwrite, nonatomic, strong) UIColor * maintenance_calendar_selected_bg; //选中区域的背景色
@property (readwrite, nonatomic, strong) UIColor * maintenance_calendar_text_today; //今天的字体颜色
@property (readwrite, nonatomic, strong) UIColor * maintenance_calendar_text_month; //月内的字体颜色
@property (readwrite, nonatomic, strong) UIColor * maintenance_calendar_text_other_month; //其它月的字体颜色


//默认的标签颜色 --- 灰色
@property (readwrite, nonatomic, strong) UIColor * defaultLabel;

//虚线边框
@property (readwrite, nonatomic, strong) UIColor * boundDotted;

//二维码扫描
@property (readwrite, nonatomic, strong) UIColor * qrcodeGreen;
@property (readwrite, nonatomic, strong) UIColor * qrcodeGray;

//图表
@property (readwrite, nonatomic, strong) UIColor * chartTitleColor; //标题颜色
@property (readwrite, nonatomic, strong) UIColor * chartLabelColor; //标签颜色
@property (readwrite, nonatomic, strong) UIColor * chartDefaultColor;   //默认颜色

//弹框颜色
@property (readwrite, nonatomic, strong) UIColor * dialogTitleBgColor;   //弹框标题的背景色


@property (readwrite, nonatomic, strong) UIColor * audioRecord;   //录音按钮
@property (readwrite, nonatomic, strong) UIColor * audioCancel;   //取消按钮

//公告
@property (readwrite, nonatomic, strong) UIColor * typeProject;   //项目级
@property (readwrite, nonatomic, strong) UIColor * typeCompany;   //公司级
@property (readwrite, nonatomic, strong) UIColor * typeSystem;   //系统级
@property (readwrite, nonatomic, strong) UIColor * typeTop;       //置顶

#pragma mark - DTZ 颜色

#pragma mark - Shang 颜色
@property (readwrite, nonatomic, strong) UIColor * themeColor_shang;        //主题色
@property (readwrite, nonatomic, strong) UIColor * themeHighlightColor_shang;        //主题色


@property (readwrite, nonatomic, strong) UIColor * mainGreen_shang;       //绿色
@property (readwrite, nonatomic, strong) UIColor * mainGreenHighlighted_shang;       //绿色
@property (readwrite, nonatomic, strong) UIColor * mainBlue_shang;       //蓝色
@property (readwrite, nonatomic, strong) UIColor * mainBlueHighlighted_shang;       //蓝色高亮
@property (readwrite, nonatomic, strong) UIColor * mainRed_shang;         //红色
@property (readwrite, nonatomic, strong) UIColor * mainRedHighlighted_shang; //红色高亮
@property (readwrite, nonatomic, strong) UIColor * mainOrange_shang;      //橘黄色
@property (readwrite, nonatomic, strong) UIColor * mainOrangeHighlighted_shang;      //橘黄色高亮
@property (readwrite, nonatomic, strong) UIColor * mainVoilet_shang;          //紫色
@property (readwrite, nonatomic, strong) UIColor * mainVoiletHightlight_shang;          //紫色

@property (readwrite, nonatomic, strong) UIColor * homeTabhostBg_shang;

@property (readwrite, nonatomic, strong) UIColor * statusbarBg_shang;     //状态栏背景色
@property (readwrite, nonatomic, strong) UIColor * navigationBg_shang;    //导航栏背景色

@property (readwrite, nonatomic, strong) UIColor * tabbarImgColor_shang;
@property (readwrite, nonatomic, strong) UIColor * tabbarTextColor_shang;

@property (readwrite, nonatomic, strong) UIColor * listHeaderMark_shang;

- (instancetype) init;
+ (instancetype) getInstance;

//根据资源和主题来获取颜色
- (UIColor *) getColorByResource:(FMResourceType) resource theme:(FMThemeType) theme;

//获取一个随机色
+ (UIColor *) getRandomColor;

//从图表色库中获取一个颜色
+ (UIColor *) getChartColorByIndex:(NSInteger) index;

//从图标库中获取指定个数的颜色值
+ (NSMutableArray *) getChartColorsByCount:(NSInteger) count;

//获取指定颜色
//alpha --- 0~1 之间 浮点型
+ (UIColor *) getColorByAlpha:(CGFloat) alpha RedValue:(NSInteger) red greenValue:(NSInteger) green blueValue:(NSInteger) blue;



@end
