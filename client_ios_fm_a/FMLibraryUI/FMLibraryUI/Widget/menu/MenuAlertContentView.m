//
//  MenuAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MenuAlertContentView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface MenuAlertContentView () <UITableViewDelegate, UITableViewDataSource>
@property (readwrite, nonatomic, strong) UITableView * menuTableView;

@property (readwrite, nonatomic, strong) NSMutableArray * menus;
@property (readwrite, nonatomic, strong) UIFont * font;
@property (readwrite, nonatomic, strong) UIColor * color;
@property (readwrite, nonatomic, assign) BOOL showCancel;   //是否显示取消

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MenuAlertContentView

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
        
        _font = [FMFont getInstance].defaultFontLevel2;
        _color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _itemHeight = 50;
        
        _menuTableView = [[UITableView alloc] init];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.delaysContentTouches = NO;
        
        [self addSubview:_menuTableView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_menuTableView setFrame:CGRectMake(0, 0, width, height)];
}

- (void) updateInfo {
    [_menuTableView reloadData];
}

- (void) setMenuWithArray:(NSMutableArray *) array {
    _menus = array;
    [self updateInfo];
}

- (void) setFont:(UIFont *) font {
    _font = font;
}


//设置是否显示取消按钮
- (void) setShowCancelMenu:(BOOL) show {
    if(_showCancel != show) {
        _showCancel = show;
        [self updateInfo];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener {
    _handler = listener;
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_menus count];
    if(_showCancel) {
        count += 1;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = _itemHeight;
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSString * cellIdentifier = @"CellMenu";
    NSInteger position = indexPath.row;
    
    SeperatorView * seperator;
    
    CGFloat itemHeight = _itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id item in subViews) {
            if([item isKindOfClass:[SeperatorView class]]) {
                seperator = item;
                break;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    
    if(seperator) {
        [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
    }
    
    
    NSString * strMenu;
    if(position < [_menus count]) {
        strMenu = _menus[position];
        cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ALERT_MENU_ITEM_COLOR_NORMAL];
    } else if(_showCancel) {
        strMenu = [[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil];
        cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_ALERT_MENU_ITEM_COLOR_CANCEL];
    }
    [cell.textLabel setText:strMenu];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [FMFont getInstance].font42;
    
    return cell;
}

#pragma mark - 点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    MenuAlertViewType type = MENU_ALERT_TYPE_NORMAL;
    if(_showCancel && position == [_menus count]) {
        type = MENU_ALERT_TYPE_CANCEL;
    }
    [self notifySelectedMenuItem:position type:type];
}

- (void) notifySelectedMenuItem:(NSInteger) position type:(MenuAlertViewType) type {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"menuType"];
        [msg setValue:[NSNumber numberWithInteger:position] forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

//- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath;
//}


#pragma mark - 计算所需要的高度
+ (CGFloat) calculateHeightByCount:(NSInteger) menuCount showCancel:(BOOL) showCancel {
    CGFloat height = 0;
    CGFloat itemHeight = 50;
    if(showCancel) {
        height = itemHeight * (menuCount + 1);
    } else {
        height = itemHeight * menuCount;
    }
    return height;
}

@end
