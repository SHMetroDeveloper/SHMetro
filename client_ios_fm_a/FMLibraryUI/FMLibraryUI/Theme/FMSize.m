//
//  FMSize.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FMSize.h"

static FMSize * sizeInstance;

@implementation FMSize

- (instancetype) init {
    self = [super init];
    if(self) {
        //动画
        _defaultAnimationDuration = 0.3;
        
        _navigationTitleImgWidth = 111;
        _navigationTitleImgHeight = 20;
        
        //menu
        _menuItemWidth = 40;
        _menuItemImageWidth = 20;
        _menuBackImageWidth = 24;
        
        _defaultPadding = 17;
        _listePadding = 15;
        _defaultNoticeHeight = 30;
        
        
        //screen
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        _screenContentHeight = [UIScreen mainScreen].bounds.size.height - 64;
        _screenContentWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        _padding20 = 7.0f;
        _padding30 = 10.0f;
        _padding40 = 13.0f;
        _padding50 = 16.0f;
        _padding60 = 19.0f;
        _padding70 = 22.0f;
        _padding80 = 25.0f;
        _padding90 = 28.0f;
        _padding100 = 31.0f;
        
        //selectList
        _selectListItemHeight = 40;
        _selectHeaderHeight = 52;
        //按钮
        _btnBorderWidth = 1;
        _btnBorderRadius = 4;
        _btnWidth = 70;
        _btnHeight = 30;
        
        _btnBottomControlHeight = 40;
        _bottomControlHeight = 52;
        _topControlHeight = 40;
        
        _checkableBtnHeight = 35;
        
        _filterWidth = 65;
        _filterHeight = 65;
        
        //输入框线高
        _inputLineHeight = 0.4;
        
        //图片
        _imgWidthLevel1 = 32;
        _imgWidthLevel2 = 24;
        _imgWidthLevel3 = 18;
        _imgWidthLevel4 = 12;
        
        _cameraImageWidth = 24;
        _cameraImageHeight = 20;
        
        //tabhost
        _tabbarHeight = 49;
        
        //navigationbar
        _navigationbarHeight = 44;
        
        //statusbar
        _statusbarHeight = 20;
        
        _noticeHeight = 120;
        _noticeLogoWidth = 46;
        _noticeLogoHeight = 60;
        
        _datePickerHeight = 216;
        _datePickerMarginLeft = 10;
        _datePickerMarginRight = 10;
        
        _seperatorHeight = 0.4;
        
        _defaultBorderWidth = 0.4;
        _defaultBorderRadius = 2;
        _colorLblBorderRadius = 2;
        
        _sepHeight = 4;
        
        
        //列表
        _listItemPaddingLeft = 17;
        _listItemPaddingRight = 17;
        _listItemBtnHeight = 26;
        _listItemInfoHeight = 20;
        _listHeaderHeight = 48;
        _listFooterHeight = 10;
        
        //图表
        _chartItemHeaderHeaght = 40;
        _chartItemCountHeaght = 50;
        _chartItemDescHeaght = 30;
        
        //功能
        _functionItemHeight = 60;
        _functionItemPaddingLeft = 10;
        _functionItemTextSize = 16;
        _functionItemLogoWidth = 48;
        
        //我的消息
        _msgItemHeight = 80;
        _msgNoticeHeight = 120;
        _msgNoticeLogoHeight = 60;
        _msgPaddingLeft = 35;
        
        //我的
        _userPaddingTop = 20;
        _userPaddingLeft = 15;
        _userPaddingRight = 15;
        _userBaseInfoHeight = 200;
        _userItemHeight = 48;
        _userItemSepHeight = 10;
        _userItemLogoWidth = 20;
        _userItemTextSize = 16;
        
        //设置
        _settingItemLogoWidth = 24;
        _settingPaddingLeft = 15;
        _settingPaddingRight = 15;
        _settingItemHeight = 48;
        _settingItemSepHeight = 10;
        
        //巡检
        _filterControlHeight = 60;
        _filterBtnWidth = 80;
        _filterBtnHeight = 30;
        
        //分组
        _groupItemHeight = 50;
        _groupSepHeight = 10;
        
        //库存
        _btnPaddingHeight = 7;
    }
    return self;
}

+ (instancetype) getInstance {
    if(!sizeInstance) {
        sizeInstance = [[FMSize alloc] init];
    }
    return sizeInstance;
}


/**
 转换px尺寸
 */
+ (CGFloat)getSizeByPixel:(CGFloat) pixel {
    
    NSInteger length = pixel / 3;
    
    return length;
}

@end



