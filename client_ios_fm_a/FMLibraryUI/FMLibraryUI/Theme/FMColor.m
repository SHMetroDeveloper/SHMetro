//
//  FMColor.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "FMColor.h"

static FMColor * instance = nil;

static NSMutableArray * chartColors = nil;

@implementation FMColor


- (instancetype) init {
    self = [super init];
    if(self) {
#pragma mark - 默认颜色
        _themeColor = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
        _themeHighlightColor = [UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1];
        
        _mainWhite = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _mainBlack = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _mainTransparentGray = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
        
        _mainGreen = [UIColor colorWithRed:0x5e/255.0 green:0xba/255.0 blue:0x15/255.0 alpha:1];
        
        _mainGreenHighlighted = [UIColor colorWithRed:0x54/255.0 green:0xa6/255.0 blue:0x12/255.0 alpha:1];
        
        _mainRed = [UIColor colorWithRed:0xff/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        _mainRedHighlighted = [UIColor colorWithRed:0xeb/255.0 green:0x5d/255.0 blue:0x5d/255.0 alpha:1];
        
        _mainBlue = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
        _mainBlueHighlighted = [UIColor colorWithRed:0x0e/255.0 green:0x9d/255.0 blue:0xe7/255.0 alpha:1];
        
        _mainOrange = [UIColor colorWithRed:0xff/255.0 green:0x99/255.0 blue:0/255.0 alpha:1];
        _mainOrangeHighlighted = [UIColor colorWithRed:0xed/255.0 green:0x8e/255.0 blue:0x00/255.0 alpha:1];
        
        _mainVoilet = [UIColor colorWithRed:159/255.0 green:136/255.0 blue:219/255.0 alpha:1];
        _mainVoiletHighlight = [UIColor colorWithRed:159/255.0 green:136/255.0 blue:219/255.0 alpha:1];
        
        _mainText = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _mainDesc = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//        _mainStatus = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//        _mainTime = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
        
        _placeholder = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:1];
        
        _darkRed = [UIColor colorWithRed:0xff/255.0 green:0x3a/255.0 blue:0x30/255.0 alpha:1];
        
        //灰色
        _grayLevel1 = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
        _grayLevel2 = [UIColor colorWithRed:0x47/255.0 green:0x47/255.0 blue:0x47/255.0 alpha:1];
        _grayLevel3 = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        _grayLevel4 = [UIColor colorWithRed:0x80/255.0 green:0x80/255.0 blue:0x80/255.0 alpha:1];
        _grayLevel5 = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1];
        _grayLevel6 = [UIColor colorWithRed:0xb3/255.0 green:0xb3/255.0 blue:0xb3/255.0 alpha:1];
        _grayLevel7 = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:1];
        _grayLevel8 = [UIColor colorWithRed:0xdd/255.0 green:0xdd/255.0 blue:0xdd/255.0 alpha:1];
        _grayLevel9 = [UIColor colorWithRed:0xf0/255.0 green:0xf0/255.0 blue:0xf0/255.0 alpha:1];
        _grayLevel10 = [UIColor colorWithRed:0x8a/255.0 green:0x94/255.0 blue:0x92/255.0 alpha:1];
        
        //下载状态颜色
        _downloadStatusUnDownloaded = [UIColor colorWithRed:0xff/255.0 green:0x26/255.0 blue:0x26/255.0 alpha:1];   //未下载
        _downloadStatusUnUpdated = [UIColor colorWithRed:0xff/255.0 green:0x99/255.0 blue:0x00/255.0 alpha:1];   //待更新
        _downloadStatusDownloaded = [UIColor colorWithRed:0x5e/255.0 green:0xba/255.0 blue:0x15/255.0 alpha:1];   //已下载
        
        _logoutRed = [UIColor colorWithRed:0xff/255.0 green:0x3a/255.0 blue:0x30/255.0 alpha:1];
        _noticeRed = [UIColor colorWithRed:0xff/255.0 green:0x2e/255.0 blue:0x2e/255.0 alpha:1];
        
        //主窗体
        _mainBackground = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        //高亮
        _mainHighLight = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        
        _homeTabhostBg = [UIColor colorWithRed:250/255.0 green:251/255.0 blue:254/255.0 alpha:1];
        _noteBeginItemBg = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _inProcessItemBg = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1];
        _finishItemBg = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:0/255.0 alpha:1];
        
//        _statusbarBg = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
//        _navigationBg = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
        _tabbarBg = [UIColor colorWithRed:0xfa/255.0 green:0xfa/255.0 blue:0xfa/255.0 alpha:1];
        _navigationTitle = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _navigationSeperatorBg = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:0.6];
        
        _mainBound = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
        
        _seperatorLight = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        _seperatorDialog = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        
        _topbarIndicator = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        _topbarBg = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:100];
        _topbarTextBlack = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
        _functionItemLayerBorder = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        
        _status_personal_un_accept = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:100];;
        _status_personal_accept = [UIColor colorWithRed:80/255.0 green:180/255.0 blue:0/255.0 alpha:1];
        _status_personal_back = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1];
        _status_personal_submit = [UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1];
        
        //工单列表
        _listHeaderMark = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
        
        _listCodeColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];  //工单号颜色
        _listTimeColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1];  //工单时间
        _listDescColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];  //工单描述信息
        _listPriorityColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];  //工单优先级
        
        
        _defaultLabel = [UIColor colorWithRed:0xb3/255.0 green:0xb3/255.0 blue:0xb3/255.0 alpha:1];
        

        //menu
        _menuItemColorNormal = [UIColor whiteColor];
        _menuItemColorHighlight = [UIColor colorWithRed:3/255.0 green:121/255.0 blue:254/255.0 alpha:100];
        
        _alertMenuItemColorNormal = [UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1];
        _alertMenuItemColorCancel = [UIColor colorWithRed:0xff/255.0 green:0x3a/255.0 blue:0x30/255.0 alpha:1];
        
        //二维码
        _qrcodeGreen = [UIColor colorWithRed:20/255.0 green:250/255.0 blue:20/255.0 alpha:1];
        _qrcodeGray = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        
        //虚线
        _boundDotted = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        
        //我的消息
        _msgTitle = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1];   //巡检消息
        _msgPatrol = [UIColor colorWithRed:160/255.0 green:189/255.0 blue:97/255.0 alpha:1];   //巡检消息
        _msgOrderUndo = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:64/255.0 alpha:1];   //待处理工单
        _msgOrderApproval = [UIColor colorWithRed:161/255.0 green:140/255.0 blue:218/255.0 alpha:1];   //待审核工单
        _msgOrderDispach = [UIColor colorWithRed:234/255.0 green:99/255.0 blue:143/255.0 alpha:1];   //待派工工单
        _msgServiceCenter = [UIColor colorWithRed:0/255.0 green:197/255.0 blue:204/255.0 alpha:1];   //服务台
        _msgInventory = [UIColor colorWithRed:114/255.0 green:140/255.0 blue:242/255.0 alpha:1];    //库存
        _msgAsset = [UIColor colorWithRed:0/255.0 green:201/255.0 blue:158/255.0 alpha:1];        //资产
        _msgMaintenance = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:233/255.0 alpha:1];   //计划性维护
        
        //计划性维护
        _maintenance_calendar_selected_bg = [UIColor colorWithRed:0x7a/255.0 green:0x7f/255.0 blue:0x85/255.0 alpha:1];   //日历选中区域背景色
        _maintenance_calendar_text_today = _darkRed;
        _maintenance_calendar_text_month = [UIColor whiteColor];
        _maintenance_calendar_text_other_month = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:0.4];
        
        //公告
        _typeProject = [UIColor colorWithRed:0xff/255.0 green:0x9e/255.0 blue:0x36/255.0 alpha:1];
        _typeCompany = [UIColor colorWithRed:0x1c/255.0 green:0x83/255.0 blue:0xc6/255.0 alpha:1];
        _typeSystem = [UIColor colorWithRed:0x1c/255.0 green:0x83/255.0 blue:0xc6/255.0 alpha:1];

        _typeTop = [UIColor colorWithRed:0x1a/255.0 green:0xb3/255.0 blue:0x94/255.0 alpha:1];
        
        //图表
        _chartTitleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _chartLabelColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        _chartDefaultColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        
        //弹框
        _dialogTitleBgColor = [UIColor colorWithRed:0xF2/255.0 green:0xF2/255.0 blue:0xF2/255.0 alpha:1];
        
        _audioRecord = [UIColor colorWithRed:160/255.0 green:231/255.0 blue:90/255.0 alpha:1];
        _audioCancel = [UIColor colorWithRed:14/255.0 green:177/255.0 blue:234/255.0 alpha:1];
        
#pragma mark - DTZ 颜色
        
#pragma mark - Shang 颜色
        _themeColor_shang = [UIColor colorWithRed:0x1A/255.0 green:0xB3/255.0 blue:0x94/255.0 alpha:1];        //主题色
        _themeHighlightColor_shang = [UIColor colorWithRed:0x18/255.0 green:0xa6/255.0 blue:0x89/255.0 alpha:1];        //主题色
        
        _mainGreen_shang = [UIColor colorWithRed:0x74/255.0 green:0xbc/255.0 blue:0x3a/255.0 alpha:1];       //绿色
        _mainGreenHighlighted_shang = [UIColor colorWithRed:0x6b/255.0 green:0xae/255.0 blue:0x36/255.0 alpha:1];       //绿色
        _mainBlue_shang = [UIColor colorWithRed:0x15/255.0 green:0x9f/255.0 blue:0xe6/255.0 alpha:1];       //蓝色
        _mainBlueHighlighted_shang = [UIColor colorWithRed:0x13/255.0 green:0x94/255.0 blue:0xd6/255.0 alpha:1];       //蓝色高亮
        _mainRed_shang = [UIColor colorWithRed:0xf5/255.0 green:0x58/255.0 blue:0x58/255.0 alpha:1];         //红色
        _mainRedHighlighted_shang = [UIColor colorWithRed:0xe0/255.0 green:0x51/255.0 blue:0x51/255.0 alpha:1]; //红色高亮
        _mainOrange_shang = [UIColor colorWithRed:0xff1A/255.0 green:0x9f/255.0 blue:0x0e/255.0 alpha:1];      //橘黄色
        _mainOrangeHighlighted_shang = [UIColor colorWithRed:0xf2/255.0 green:0x97/255.0 blue:0x0c/255.0 alpha:1];      //橘黄色高亮
        _mainVoilet_shang = [UIColor colorWithRed:0x96/255.0 green:0x7c/255.0 blue:0xd9/255.0 alpha:1];          //紫色
        _mainVoiletHightlight_shang = [UIColor colorWithRed:0x8c/255.0 green:0x74/255.0 blue:0xcb/255.0 alpha:1];          //紫色
        
        _listHeaderMark_shang = [UIColor colorWithRed:0x1A/255.0 green:0xB3/255.0 blue:0x94/255.0 alpha:1];
    }
    return self;
}
+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance) {
            instance = [[FMColor alloc] init];
        }
    });
    return instance;
}

//获取 DTZ 颜色
- (UIColor *) getColorOfDtzByResource:(FMResourceType)resource  {
    UIColor * color;
    switch(resource) {
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLACK:
            color = _mainBlack;
            break;
        default:
            break;
    }
    if(!color) {
        color = [self getColorDefaultByResource:resource];
    }
    return color;
}

//获取 Shang 颜色
- (UIColor *) getColorOfShangByResource:(FMResourceType)resource  {
    UIColor * color;
    switch(resource) {
        case FM_RESOURCE_TYPE_COLOR_THEME:
            color = _themeColor_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT:
            color = _themeHighlightColor_shang;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_THEME_N:
            color = _mainBlue_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_THEME_N_HIGHLIGHT:
            color = _mainBlueHighlighted_shang;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_MAIN_GREEN:
            color = _mainGreen_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_GREEN_HIGHLIGHT:
            color = _mainGreenHighlighted_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLUE:
            color = _mainBlue_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT:
            color = _mainBlueHighlighted_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_RED:
            color = _mainRed_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_RED_HIGHLIGHT:
            color = _mainRedHighlighted_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE:
            color = _mainOrange_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE_HIGHLIGHT:
            color = _mainOrangeHighlighted_shang;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_VOILET:
            color = _mainVoilet_shang;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK:   //列表头左侧的标记颜色
            color = _listHeaderMark_shang;
            break;
            
        default:
            break;
        
    }
    if(!color) {
        color = [self getColorDefaultByResource:resource];
    }
    return color;
}

//获取默认颜色
- (UIColor *) getColorDefaultByResource:(FMResourceType)resource  {
    UIColor * color;
    switch(resource) {
        case FM_RESOURCE_TYPE_COLOR_THEME:
            color = _themeColor;
            break;
        case FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT:
            color = _themeHighlightColor;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_THEME_N:
            color = _mainGreen;
            break;
        case FM_RESOURCE_TYPE_COLOR_THEME_N_HIGHLIGHT:
            color = _mainGreenHighlighted;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLACK:
            color = _mainBlack;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_WHITE:
            color = _mainWhite;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_GREEN:
            color = _mainGreen;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_GREEN_HIGHLIGHT:
            color = _mainGreenHighlighted;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLUE:
            color = _mainBlue;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT:
            color = _mainBlueHighlighted;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_RED:
            color = _mainRed;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_RED_HIGHLIGHT:
            color = _mainRedHighlighted;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE:
            color = _mainOrange;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE_HIGHLIGHT:
            color = _mainOrangeHighlighted;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_VOILET:
            color = _mainVoilet;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_GRAY_L1:
            color = _grayLevel1;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L2:
            color = _grayLevel2;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L3:
            color = _grayLevel3;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L4:
            color = _grayLevel4;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L5:
            color = _grayLevel5;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L6:
            color = _grayLevel6;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L7:
            color = _grayLevel7;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L8:
            color = _grayLevel8;
            break;
        case FM_RESOURCE_TYPE_COLOR_GRAY_L9:
            color = _grayLevel9;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_GRAY_L10:
            color = _grayLevel10;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_MAIN_TEXT:
            color = _mainText;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAIN_DESC:
            color = _mainDesc;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL:
            color = _defaultLabel;
            break;
            
            
        case FM_RESOURCE_TYPE_COLOR_BACKGROUND:
            color = _mainBackground;
            break;
        case FM_RESOURCE_TYPE_COLOR_PLACEHOLDER:
            color = _placeholder;
            break;
        case FM_RESOURCE_TYPE_COLOR_RED_DARK:
            color = _darkRed;
            break;
        case FM_RESOURCE_TYPE_COLOR_RED_LOGOUT:
            color = _logoutRed;
            break;
        case FM_RESOURCE_TYPE_COLOR_RED_NOTICE:
            color = _noticeRed;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_NAVIGATION_TITLE:   //导航栏标题
            color = _navigationTitle;
            break;
        case FM_RESOURCE_TYPE_COLOR_MENU_ITEM_COLOR_NORMAL:   //导航栏菜单项文字颜色
            color = _menuItemColorNormal;
            break;
        case FM_RESOURCE_TYPE_COLOR_MENU_ITEM_COLOR_HIGHLIGHT:   //导航栏菜单项文字颜色，高亮状态
            color = _menuItemColorHighlight;
            break;

        case FM_RESOURCE_TYPE_COLOR_TABBAR_BG:
            color = _tabbarBg;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_BOUND:   //边框
            color = _mainBound;
            break;
        case FM_RESOURCE_TYPE_COLOR_BOUND_DOTTED:       //虚线边框
            color = _boundDotted;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_ALERT_MENU_ITEM_COLOR_NORMAL:   //弹出式菜单文字颜色
            color = _alertMenuItemColorNormal;
            break;
        case FM_RESOURCE_TYPE_COLOR_ALERT_MENU_ITEM_COLOR_CANCEL:   //弹出式菜单文字颜色，“取消”颜色
            color = _alertMenuItemColorCancel;
            break;
            
            //消息
        case FM_RESOURCE_TYPE_COLOR_MSG_TITLE:   //消息标题
            color = _msgTitle;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_PATROL:   //消息，巡检
            color = _msgPatrol;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_ORDER_UNDO:   //待处理工单
            color = _msgOrderUndo;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_ORDER_APPROVAL:   //待审批工单
            color = _msgOrderApproval;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_ORDER_DISPACH:   //待派工工单
            color = _msgOrderDispach;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_REQUIREMENT:   //需求
            color = _msgServiceCenter;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_INVENTORY:   //库存
            color = _msgInventory;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_ASSET:   //资产
            color = _msgAsset;
            break;
        case FM_RESOURCE_TYPE_COLOR_MSG_MAINTENANCE:   //计划性维护
            color = _msgMaintenance;
            break;
            
            //离线下载
        case FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED:   //未下载
            color = _downloadStatusUnDownloaded;
            break;
        case FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNUPDATED:   //未更新
            color = _downloadStatusUnUpdated;
            break;
        case FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_DOWNLOADED:   //已下载
            color = _downloadStatusDownloaded;
            break;
            
            //列表
        case FM_RESOURCE_TYPE_COLOR_LIST_HEADER_MARK:   //列表头左侧的标记颜色
            color = _listHeaderMark;
            break;
            
            //计划性维护日历
        case FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_SELECT_BG:   //选中日期的背景色
            color = _maintenance_calendar_selected_bg;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_TODAY:   //当天的字体颜色
            color = _maintenance_calendar_text_today;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_MONTH:   //当月的字体颜色
            color = _maintenance_calendar_text_month;
            break;
        case FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_OTHER_MONTH:   //其它月份的字体颜色
            color = _maintenance_calendar_text_other_month;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_UNACCEPT:
            color = _status_personal_un_accept;
            break;
        case FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_ACCEPT:
            color = _status_personal_accept;
            break;
        case FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_BACK:
            color = _status_personal_back;
            break;
        case FM_RESOURCE_TYPE_COLOR_ORDER_LABORER_STATUS_SUBMIT:
            color = _status_personal_submit;
            break;
            
            //弹框
        case FM_RESOURCE_TYPE_COLOR_DIALOG_TITLE_BG:
            color = _dialogTitleBgColor;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_AUDIO_RECORD:
            color = _audioRecord;
            break;
        case FM_RESOURCE_TYPE_COLOR_AUDIO_CANCEL:
            color = _audioCancel;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_QRCODE_BOUND:
            color = _qrcodeGreen;
            break;
        case FM_RESOURCE_TYPE_COLOR_QRCODE_BORDER:
            color = _qrcodeGray;
            break;
            
        case FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_PROJECT:   //
            color = _typeProject;
            break;
        case FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_COMPANY:   //
            color = _typeCompany;
            break;
        case FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_SYSTEM:   //
            color = _typeSystem;
            break;
        case FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_TOP:   //
            color = _typeTop;
            break;
    }
    return color;
}

//根据资源和主题来获取颜色
- (UIColor *) getColorByResource:(FMResourceType) resource theme:(FMThemeType) theme {
    UIColor * color;
    switch(theme) {
        case FM_THEME_TYPE_DTZ:
            color = [self getColorOfDtzByResource:resource];
            break;
        case FM_THEME_TYPE_SHANG:
            color = [self getColorOfShangByResource:resource];
            break;
        default:
            color = [self getColorDefaultByResource:resource];
            break;
    }
    return color;
}

//获取一个随机色
+ (UIColor *) getRandomColor {
    UIColor * color;
    CGFloat hue = ( arc4random() / 10 * 10 % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() / 10 * 10 % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() / 10 * 10 % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

//从图表色库中获取一个颜色
+ (UIColor *) getChartColorByIndex:(NSInteger) index {
    UIColor * color;
    if(!chartColors) {
        [FMColor initChartColorLibrary];
    }
    NSInteger count = [chartColors count];
    if(count > 0){
        index %= count;
        color = chartColors[index];
    }
    return color;
}
//从图标库中获取指定个数的颜色值
+ (NSMutableArray *) getChartColorsByCount:(NSInteger) count {
    NSMutableArray * colors = [[NSMutableArray alloc] init];
    if(!chartColors) {
        [FMColor initChartColorLibrary];
    }
    NSInteger maxCount = [chartColors count];
    for(NSInteger index = 0; index < count; index++) {
        NSInteger key = index;
        if(key >= maxCount) {
            key %= maxCount;
        }
        UIColor * color = chartColors[key];
        [colors addObject:color];
    }
    return colors;
}

//初始化图表色库
+ (void) initChartColorLibrary {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"chartcolors" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if(data && [data count] > 0) {
        if(!chartColors) {
            chartColors = [[NSMutableArray alloc] init];
        } else {
            [chartColors removeAllObjects];
        }
        for(NSString * key in data) {
            NSDictionary * obj = [data valueForKeyPath:key];
            CGFloat alpha = [[obj valueForKeyPath:@"alpha"] floatValue];
            NSInteger r = [[obj valueForKeyPath:@"red"] integerValue];
            NSInteger g = [[obj valueForKeyPath:@"green"] integerValue];
            NSInteger b = [[obj valueForKeyPath:@"blue"] integerValue];
            UIColor * color = [FMColor getColorByAlpha:alpha RedValue:r greenValue:g blueValue:b];
            [chartColors addObject:color];
        }
    }
    NSLog(@"读取数据成功");
}

//获取指定颜色
+ (UIColor *) getColorByAlpha:(CGFloat) alpha RedValue:(NSInteger) red greenValue:(NSInteger) green blueValue:(NSInteger) blue {
    UIColor * color;
    color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];;
    return color;
}

@end

