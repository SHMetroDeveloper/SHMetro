//
//  FMNavigationView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FMNavigationView.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"

NSInteger const FM_NAVIGATION_VIEW_SIZE_BACK_BUTTON_WITH = 40;  //默认的返回键的宽度
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_WITH = 70;  //默认的右侧按钮的宽度
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_WITH = 60;  //默认的右侧按钮的宽度
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_HEIGHT = 32;  //默认的右侧按钮的宽度
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_IMAGE_WITH = 24;  //默认的右侧图片按钮的宽度
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_SEP_WITH = 0;  //默认按钮间空格距离
NSInteger const FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_PADDING = 10;  //默认按钮边距
NSInteger const FM_NAVIGATION_VIEW_SIZE_TITLE_PADDING_LEFT = 20;  //默认标题距离左侧边距
NSInteger const MAX_MENU_ITEM_COUNT = 2;    //支持的右侧菜单按钮数

@interface FMNavigationView ()

@property (readwrite, nonatomic, copy) NSString * titleBackText;//返回键文字
@property (readwrite, nonatomic, copy) NSString * titleText;    //界面标题
@property (readwrite, nonatomic, copy) UIImage * titleImage;    //界面标题  --- 优先级比字符串高
@property (readwrite, nonatomic, strong) NSMutableArray * menuArray;//菜单数组，可以存文字
@property (readwrite, nonatomic, assign) NSInteger menuItemCount;//界面所支持的菜单数
@property (readwrite, nonatomic, strong) NSMutableArray * menuItemWidthArray;

@property (readwrite, nonatomic, strong) UIColor * titleColor;

@property (readwrite, nonatomic, assign) CGFloat imgTitleWidth;//图片标题的宽度
@property (readwrite, nonatomic, assign) CGFloat imgTitleHeight;//图片标题的高度

@property (readwrite, nonatomic, assign) BOOL showBack;//是否显示返回按钮
@property (readwrite, nonatomic, assign) BOOL showTitleText;//是否显示标题
@property (readwrite, nonatomic, assign) BOOL showMenus;//是否显示菜单
@property (readwrite, nonatomic, assign) BOOL showShadow;//是否显示阴影

@property (readwrite, nonatomic, strong) UIButton * backBtn;//返回按钮
@property (readwrite, nonatomic, strong) UIImageView * backImgView;//返回按钮图标

@property (readwrite, nonatomic, strong) UIView * backView;//自定义返回按钮
@property (readwrite, nonatomic, assign) CGFloat backWidth;//自定义返回按钮


@property (readwrite, nonatomic, strong) UILabel * titleTV;//标题
@property (readwrite, nonatomic, strong) UIImageView * titleIV;//标题

@property (readwrite, nonatomic, strong) UIView * menuView;//菜单
@property (readwrite, nonatomic, strong) UIColor * menuItemColorNormal;    //菜单按钮的默认颜色
@property (readwrite, nonatomic, strong) UIColor * menuItemColorHighlight; //菜单按钮按下的颜色
@property (readwrite, nonatomic, strong) UIColor * menuItemBackgroundColor; //菜单按钮背景色
@property (readwrite, nonatomic, strong) UIFont * menuFont;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, strong) NSObject<OnFMNavigationViewListener> * listener;


@end

@implementation FMNavigationView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        [self initDefaultSettings];
        
        _backBtn = [[UIButton alloc] init];
        _titleTV = [[UILabel alloc] init];
        _titleIV = [[UIImageView alloc] init];
        _menuView = [[UIView alloc] init];
        _backImgView = [[UIImageView alloc] init];
        [_backImgView setImage:[[FMTheme getInstance] getImageByName:@"pre_arrow_white_slim"]];
        _titleTV.textAlignment = NSTextAlignmentCenter;
        _titleTV.font = [FMFont getInstance].defaultFontLevel1;
        _titleIV.contentMode = UIViewContentModeScaleAspectFit;
        _titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_NAVIGATION_TITLE];
        [_titleTV setTextColor:_titleColor];
        
        [self.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        [self initBackGround];
        
        [_backBtn addSubview:_backImgView];
        
        [self addSubview:_backBtn];
        [self addSubview:_titleTV];
        [self addSubview:_titleIV];
        [self addSubview:_menuView];
        
//        [self setShowShadow:YES];
    }
   
}

- (void) updateViews {
    [self updateBackButton];
    [self updateTitle];
    [self updateMenu];
}

//初始化返回按钮
- (void) updateBackButton {
    if(_showBack) {
        [_backBtn setFrame:[self getPositionOfBackButton:self.frame]];
        if(_backView) {
            [_backView setFrame:[self getPositionOfBackView]];
            [_backImgView setHidden:YES];
        } else {
            [_backImgView setFrame:[self getPositionOfBackImage]];
            [_backView setHidden:YES];
        }
    }
}

- (void) updateTitle {
    if(_showTitleText) {
        CGRect titleFrame = [self getPositionOfTitle:self.frame];
        [_titleTV setFrame:titleFrame];
        [_titleTV setTextColor:_titleColor];
        
        titleFrame.origin.x += (titleFrame.size.width - _imgTitleWidth)/2;
        titleFrame.origin.y += (titleFrame.size.height - _imgTitleHeight)/2;
        titleFrame.size.width = _imgTitleWidth;
        titleFrame.size.height = _imgTitleHeight;
        [_titleIV setFrame:titleFrame];
        
        [_titleTV setHidden:NO];
        [_titleIV setHidden:NO];
    } else {
        [_titleIV setHidden:YES];
        [_titleTV setHidden:YES];
    }
}

- (void) initBackGround {
    [self.backBtn setBackgroundColor:self.backgroundColor];
    [self.titleTV setBackgroundColor:self.backgroundColor];
    [self.menuView setBackgroundColor:self.backgroundColor];
}

- (void) updateMenu {
    if(self.showMenus) {
        [self.menuView setFrame:[self getPositionOfMenu:self.frame]];
        UIFont * defaultMenuFont = [FMFont getInstance].menuTitleFont;
        NSInteger count = [_menuArray count];
        NSInteger index = 0;
        CGFloat originX = 0;
        CGFloat menuImageWidth = [FMSize getInstance].menuItemImageWidth;
        CGFloat height = self.frame.size.height;
        
        NSArray * oldMenuArray = [_menuView subviews];
        for(UIView * menuItem in oldMenuArray) {
            [menuItem removeFromSuperview];
        }
        
        for(index=0;index<count;index++) {
            id menuItem = _menuArray[index];
            CGFloat itemWidth = [_menuItemWidthArray[index] floatValue];
            if([menuItem isKindOfClass:[NSString class]]) {
                NSString* menuText = menuItem;
//                CGRect rect = CGRectMake(originX, (height - FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_HEIGHT)/2, itemWidth, FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_HEIGHT);
                CGRect rect = CGRectMake(originX, 0, itemWidth, height);
                originX += itemWidth + FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_SEP_WITH;
                UIButton * menuItemBtn = [[UIButton alloc] initWithFrame:rect];
                [menuItemBtn setTitle:menuText forState:UIControlStateNormal];
                [menuItemBtn.titleLabel setFont:defaultMenuFont];
                [menuItemBtn setTitleColor:_menuItemColorNormal forState:UIControlStateNormal];
                [menuItemBtn setTitleColor:_menuItemColorHighlight forState:UIControlStateHighlighted];
                [menuItemBtn setBackgroundImage:[FMUtils buttonImageFromColor:_menuItemBackgroundColor width:1 height:1] forState:UIControlStateHighlighted];
                [menuItemBtn setTag:index];
                [menuItemBtn addTarget:self action:@selector(onMenuClick:) forControlEvents:UIControlEventTouchUpInside];
                [menuItemBtn.titleLabel setFont:_menuFont];
                [_menuView addSubview:menuItemBtn];
            } else if ([menuItem isKindOfClass:[UIImage class]]) {
                UIImage* menuImage = menuItem;
                UIImageView * menuImgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemWidth-menuImageWidth)/2, (height-menuImageWidth)/2, menuImageWidth, menuImageWidth)];
                [menuImgView setImage:menuImage];
                CGRect rect = CGRectMake(originX, 0, itemWidth, height);
                
                originX += itemWidth + FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_SEP_WITH;
                UIButton * menuItemBtn = [[UIButton alloc] initWithFrame:rect];
                [menuItemBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT] width:1 height:1] forState:UIControlStateHighlighted];
                [menuItemBtn addSubview:menuImgView];
//                [menuItemBtn setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
                [menuItemBtn setTag:index];
                [menuItemBtn addTarget:self action:@selector(onMenuClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.menuView addSubview:menuItemBtn];
            }
        }
    }
}

//依据导航栏整体的 frame 大小来计算 返回键的位置
- (CGRect) getPositionOfBackButton:(CGRect) frame {
    CGFloat width = FM_NAVIGATION_VIEW_SIZE_BACK_BUTTON_WITH;
    if(_backView) {
        CGFloat maxBackWidth = CGRectGetWidth(self.frame) - CGRectGetWidth(_menuView.frame)-_padding; //backview 所允许的最大宽度
        if(_backWidth > maxBackWidth) {
            _backWidth = maxBackWidth;
        }
        width = _backWidth;
    }
    CGRect res = CGRectMake(0, 0, width, frame.size.height);
    return res;
}

//计算返回按钮上图标所在的位置
- (CGRect) getPositionOfBackImage {
    CGFloat width = FM_NAVIGATION_VIEW_SIZE_BACK_BUTTON_WITH;
    CGFloat backImgWidth = [FMSize getInstance].imgWidthLevel2;
    CGRect res = CGRectMake((width-backImgWidth)/2, (width-backImgWidth)/2, backImgWidth, backImgWidth);
    return res;
}

//计算返回按钮上自定义view所在的位置
- (CGRect) getPositionOfBackView {
    CGRect res = CGRectMake(0, 0, _backWidth, self.frame.size.height);
    return res;
}

//依据导航栏整体的 frame 大小来计算 菜单 的位置
- (CGRect) getPositionOfMenu:(CGRect) frame {
    CGFloat menuWidth = [self getWidthOfMenu];
    CGFloat orginx = frame.size.width - menuWidth;
    CGRect res = CGRectMake(orginx, 0, menuWidth, frame.size.height);
    return res;
}

//计算菜单所需要的宽度
- (CGFloat) getWidthOfMenu {
    CGFloat res = 0;
    if(self.showMenus) {
        NSInteger count = [self.menuArray count];
        for(NSInteger index=0;index<count;index++) {
            CGFloat itemWidth = [_menuItemWidthArray[index] floatValue];
            res += itemWidth;
            res += FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_SEP_WITH;
        }
    }
    return res;
}


//依据导航栏整体 frame 大小来计算标题的位置
- (CGRect) getPositionOfTitle:(CGRect) frame {
    CGFloat menuWidth = [self getWidthOfMenu];
    CGFloat originX = 0;
    if(self.showBack) {
        if(_backView) {
            originX = _backWidth;
        } else {
            originX = FM_NAVIGATION_VIEW_SIZE_BACK_BUTTON_WITH;
        }
    } else {
        originX = FM_NAVIGATION_VIEW_SIZE_TITLE_PADDING_LEFT;
    }
    if(originX < menuWidth) {   //
        originX = menuWidth;
    }
    CGRect res = CGRectMake(originX, 0, frame.size.width - originX * 2, frame.size.height);
    return res;
}



//默认设置
- (void) initDefaultSettings {
    _showBack = NO;
    _showTitleText = NO;
    _showMenus = NO;
    
    _titleBackText = @"";
    _titleText = @"";
    
    _menuItemCount = 0;
    _padding = [FMSize getInstance].defaultPadding / 2;
    
    _menuItemColorNormal = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    _menuItemColorHighlight = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    _menuItemBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME_HIGHLIGHT];
    
    _imgTitleWidth = [FMSize getInstance].navigationTitleImgWidth;
    _imgTitleHeight = [FMSize getInstance].navigationTitleImgHeight;
    
    self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    
//    _menuFont = [FMFont getInstance].defaultFontLevel2;
    _menuFont = [FMFont fontWithSize:16];
}

- (void) setShowBackButton: (BOOL) show {
    self.showBack = show;
    [self updateBackButton];
    [self updateTitle];
}

- (void) setShowBound:(BOOL) show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) setShowTitle: (BOOL) show {
    self.showTitleText = show;
    [self updateTitle];
}

- (void) setShowMenu: (BOOL) show {
    self.showMenus = show;
    
    [self updateMenu];
    [self updateTitle];
}

- (void) setTitle:(NSString*) title {
    _titleText = title;
    [_titleTV setHidden:NO];
    [_titleIV setHidden:YES];
    [_titleTV setText:_titleText];
    _showTitleText = YES;
    [self updateTitle];
}

- (void) setTitleWithImage:(UIImage*) imgTitle {
    _titleImage = imgTitle;
    [_titleTV setHidden:YES];
    [_titleIV setHidden:NO];
    [_titleIV setImage:_titleImage];
    [self updateTitle];
}

//设置返回按钮
- (void) setBackBarWithView:(UIView *) backView andbackWidth:(CGFloat) backWidth {
    self.showBack = YES;
    
    _backView = backView;
    _backView.userInteractionEnabled = NO;
    _backWidth = backWidth;
    [_backBtn addSubview:_backView];
    [self updateBackButton];
    [self updateTitle];
}

- (void) setMenuWithTextArray: (NSArray*) textArray {
    NSInteger count = [textArray count];
    NSInteger i = 0;
    if(count > MAX_MENU_ITEM_COUNT) {
        self.menuItemCount = MAX_MENU_ITEM_COUNT;
    } else {
        self.menuItemCount = count;
    }
    if(self.menuArray) {
        [self.menuArray removeAllObjects];
    } else {
        self.menuArray = [[NSMutableArray alloc] init];
    }
    
    for(i=0;i<self.menuItemCount;i++) {
        [self.menuArray addObject:[textArray objectAtIndex:i]];
    }
    
    if(!_menuItemWidthArray) {
        _menuItemWidthArray = [[NSMutableArray alloc] init];
    } else {
        [_menuItemWidthArray removeAllObjects];
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, MAXFLOAT)];
    [label setFont:_menuFont];
    for(NSString * menuItemText in _menuArray) {
        CGFloat itemWidth = [FMUtils widthForString:label value:menuItemText];
        itemWidth += FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_PADDING * 2;
        [_menuItemWidthArray addObject:[NSNumber numberWithFloat:itemWidth]];
    }
    
    
    self.showMenu = YES;
    
    [self updateMenu];
    
}

- (void) setMenuWithImageArray: (NSArray*) imageArray {
    NSInteger count = [imageArray count];
    NSInteger i = 0;
    if(count > MAX_MENU_ITEM_COUNT) {
        self.menuItemCount = MAX_MENU_ITEM_COUNT;
    } else {
        self.menuItemCount = count;
    }
    if(self.menuArray) {
        [self.menuArray removeAllObjects];
    } else {
        self.menuArray = [[NSMutableArray alloc] init];
    }
    
    for(i=0;i<self.menuItemCount;i++) {
        [self.menuArray addObject:[imageArray objectAtIndex:i]];
    }
    
    if(!_menuItemWidthArray) {
        _menuItemWidthArray = [[NSMutableArray alloc] init];
    } else {
        [_menuItemWidthArray removeAllObjects];
    }
    for(id item in _menuArray) {    //自动计算菜单所需宽度
        [_menuItemWidthArray addObject:[NSNumber numberWithFloat:FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_IMAGE_WITH]];
    }
    
    self.showMenu = YES;
    
    [self updateMenu];
    
}

- (void) setMenuWithArray: (NSArray*) menuArray {
    NSInteger count = [menuArray count];
    NSInteger i = 0;
    CGFloat height = self.frame.size.height;
    if(count > MAX_MENU_ITEM_COUNT) {
        self.menuItemCount = MAX_MENU_ITEM_COUNT;
    } else {
        self.menuItemCount = count;
    }
    if(self.menuArray) {
        [self.menuArray removeAllObjects];
    } else {
        self.menuArray = [[NSMutableArray alloc] init];
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, MAXFLOAT)];
    [label setFont:_menuFont];
    
    for(i=0;i<self.menuItemCount;i++) {
        [self.menuArray addObject:[menuArray objectAtIndex:i]];
    }
    
    if(!_menuItemWidthArray) {
        _menuItemWidthArray = [[NSMutableArray alloc] init];
    } else {
        [_menuItemWidthArray removeAllObjects];
    }
    for(id item in _menuArray) {//自动计算菜单所需宽度
        if([item isKindOfClass:[NSString class]]) {
            NSString * menuItemText = item;
            CGFloat itemWidth = [FMUtils widthForString:label value:menuItemText];
            itemWidth += FM_NAVIGATION_VIEW_SIZE_MENU_ITEM_PADDING * 2;
            [_menuItemWidthArray addObject:[NSNumber numberWithFloat:itemWidth]];
        } else if ([item isKindOfClass:[UIImage class]]) {
            [_menuItemWidthArray addObject:[NSNumber numberWithFloat:height]];
        }
        
    }
    
    self.showMenu = YES;
    
    [self updateMenu];
    
}

- (void) setBackgroundWith:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    [self initBackGround];
}

//设置标题颜色
- (void) setTitleColor:(UIColor *) titleColor {
    _titleColor = titleColor;
    [_titleTV setTextColor:_titleColor];
}

- (void) setShowShadow:(BOOL) showShadow {
    _showShadow = showShadow;
    if(_showShadow) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 1;//阴影半径，默认3
    }
}

- (void) setOnFMNavigationViewListener: (NSObject<OnFMNavigationViewListener> *) listener {
    self.listener = listener;
}

//返回回调
- (void) goBack {
    if(self.listener) {
        [self.listener onBackButtonPressed];
    }
}

//菜单点击回调
- (void) onMenuClick:(id) sender{
    UIButton * menuItem = sender;
    NSInteger position = menuItem.tag;
    if(self.listener) {
        [self.listener onMenuItemClicked:position];
    }
}


@end
