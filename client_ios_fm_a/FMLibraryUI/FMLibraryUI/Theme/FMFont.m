//
//  FMFont.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FMFont.h"

static FMFont * fontInstance;

@implementation FMFont

- (instancetype) init {
    self = [super init];
    if(self) {
        _defaultFontLevel1 = [UIFont fontWithName:@"Helvetica" size:18];
        _defaultFontLevel2 = [UIFont fontWithName:@"Helvetica" size:14];
        _defaultFontLevel3 = [UIFont fontWithName:@"Helvetica" size:12];
        _defaultFontLevel4 = [UIFont fontWithName:@"Helvetica" size:10];

        
        //menu
        _menuTitleFont = [UIFont fontWithName:@"Helvetica" size:16];
        _menuItemFont = [UIFont fontWithName:@"Helvetica" size:12];
        
        _defaultLabelFont = [UIFont fontWithName:@"Helvetica" size:14];
        
        _defaultButtonFont = [UIFont fontWithName:@"Helvetica" size:15];
        
        _listFontHeaderLevel1 = [UIFont fontWithName:@"Helvetica" size:16];
        _listFontMsgLevel1 = [UIFont fontWithName:@"Helvetica" size:14];
        _listFontMsgLevel2 = [UIFont fontWithName:@"Helvetica" size:14];
        _listFontBtnLevel1 = [UIFont fontWithName:@"Helvetica" size:16];

//        _listCodeFont = [FMFont setFontByPX:44];
        _listCodeFont = [UIFont fontWithName:@"Helvetica" size:14];
//        _listPriorityFont = [FMFont setFontByPX:38];
        _listPriorityFont = [UIFont fontWithName:@"Helvetica" size:13];
//        _ListTimeFont = [FMFont setFontByPX:38];
        _ListTimeFont = [UIFont fontWithName:@"Helvetica" size:13];
//        _listDescFont = [FMFont setFontByPX:38];
        _listDescFont = [UIFont fontWithName:@"Helvetica" size:13];
        
//        _font44 = [FMFont setFontByPX:42];
//        _font42 = [FMFont setFontByPX:42];
//        _font38 = [FMFont setFontByPX:38];
        
        _font44 = [FMFont fontWithSize:14];
        _font42 = [FMFont fontWithSize:14];
        _font38 = [FMFont fontWithSize:13];
        
        //我的消息
        _msgItemFontLogo = [UIFont fontWithName:@"Helvetica" size:18];
        
        _functionItemFontMsg = [UIFont fontWithName:@"Helvetica" size:16];
        
        _userItemFontMsg = [UIFont fontWithName:@"Helvetica" size:16];
        _userItemFontStatus = [UIFont fontWithName:@"Helvetica" size:10];
        
        _chartCountFont = [UIFont fontWithName:@"Helvetica" size:32];
        _chartTitleFont = [UIFont fontWithName:@"Helvetica" size:14];
        _chartDefaultFont = [UIFont fontWithName:@"Helvetica" size:12];
        
        //能源
        _energyItemTitleFont = [UIFont fontWithName:@"Helvetica" size:36];
        _energyItemContentFont = [UIFont fontWithName:@"Helvetica" size:36];
    }
    return self;
}

+ (instancetype) getInstance {
    if(!fontInstance) {
        fontInstance = [[FMFont alloc] init];
    }
    return fontInstance;
}

+ (UIFont *)setFontByPX:(CGFloat) px {
    UIFont * realFont;
//    CGFloat size = (px * 72.f)/192.f;
    CGFloat size = (NSInteger)(px/3);
    realFont = [UIFont fontWithName:@"Helvetica" size:size];
    return realFont;
}

//获取指定大小的字体
+ (UIFont *) fontWithSize:(CGFloat) size {
    UIFont * font = [UIFont fontWithName:@"Helvetica" size:size];
    return font;
}

@end




