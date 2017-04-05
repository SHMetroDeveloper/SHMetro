//
//  CacheViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/2/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "CacheViewController.h"
#import "ToggleItemView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMCache.h"
#import "SystemConfig.h"
#import "DXAlertView.h"
#import "BaseBundle.h"

@interface CacheViewController () <OnMessageHandleListener>
@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) ToggleItemView * fileItemView;         //文件（图片，音频，视频）
@property (readwrite, nonatomic, strong) ToggleItemView * baseDataItemView;     //基础数据
@property (readwrite, nonatomic, strong) ToggleItemView * patrolItemView;       //巡检任务
@property (readwrite, nonatomic, strong) ToggleItemView * preferenceItemView;   //简单配置
@property (readwrite, nonatomic, strong) ToggleItemView * messageItemView;      //消息

@property (readwrite, nonatomic, strong) NSMutableDictionary * results;  //缓存清理结果

@end

@implementation CacheViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_setting_cache" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"cache_clear" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        
        CGFloat width = CGRectGetWidth(frame);
        
        
        CGFloat itemHeight = 50;
        CGFloat sepHeight = 10;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        CGFloat originY = sepHeight;
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _fileItemView = [[ToggleItemView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        
        [_fileItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"cache_item_file" inTable:nil]];
        [_fileItemView setPadding:padding];
        [_fileItemView setStatus:NO];
        [_fileItemView setShowBottomSeperator:YES];
        _fileItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += itemHeight + sepHeight;
        
        _baseDataItemView = [[ToggleItemView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        [_baseDataItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"cache_item_base_data" inTable:nil]];
        [_baseDataItemView setPadding:padding];
        [_baseDataItemView setStatus:NO];
        [_baseDataItemView setShowBottomSeperator:YES];
        _baseDataItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += itemHeight + sepHeight;
        
        _patrolItemView = [[ToggleItemView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        [_patrolItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"cache_item_patrol" inTable:nil]];
        [_patrolItemView setPadding:padding];
        [_patrolItemView setStatus:NO];
        [_patrolItemView setShowBottomSeperator:YES];
        _patrolItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += itemHeight + sepHeight;
        
        
//        _messageItemView = [[ToggleItemView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
//        [_messageItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"cache_item_message" inTable:nil]];
//        [_messageItemView setPadding:padding];
//        [_messageItemView setStatus:NO];
//        [_messageItemView setShowBottomSeperator:YES];
//        _messageItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
//        originY += itemHeight + sepHeight;
        
        _preferenceItemView = [[ToggleItemView alloc] initWithFrame:CGRectMake(0, originY, width, itemHeight)];
        [_preferenceItemView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"cache_item_preference" inTable:nil]];
        [_preferenceItemView setPadding:padding];
        [_preferenceItemView setStatus:NO];
        [_preferenceItemView setShowBottomSeperator:YES];
        _preferenceItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        originY += itemHeight + sepHeight;

        
        _mainContainerView.contentSize = CGSizeMake(width, originY);
        
        [_mainContainerView addSubview:_fileItemView];
        [_mainContainerView addSubview:_baseDataItemView];
        [_mainContainerView addSubview:_patrolItemView];
//        [_mainContainerView addSubview:_messageItemView];
        [_mainContainerView addSubview:_preferenceItemView];
        
        
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FMCache getInstance] setOnMessageHandleListener:self];
    [self initCacheSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self saveCacheSettings];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self clearCache];
    }
}

- (void) initCacheSettings {
    
    BOOL clearFile = [SystemConfig needClearFile];
    BOOL clearBaseData = [SystemConfig needClearBaseData];
    BOOL clearPatrolTask = [SystemConfig needClearPatrolTask];
    BOOL clearBaseSetting = [SystemConfig needClearBaseSetting];
    BOOL clearNotification = [SystemConfig needClearNotification];
    
    [_fileItemView setStatus:clearFile];
    [_baseDataItemView setStatus:clearBaseData];
    [_patrolItemView setStatus:clearPatrolTask];
    [_preferenceItemView setStatus:clearBaseSetting];
    [_messageItemView setStatus:clearNotification];
    
    _results = [[NSMutableDictionary alloc] init];
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"file"];
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"baseData"];
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"patrolTask"];
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"baseSetting"];
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"notification"];
}

- (void) saveCacheSettings {
    BOOL clearFile = [_fileItemView isToggleOn];
    BOOL clearBaseData = [_baseDataItemView isToggleOn];
    BOOL clearPatrolTask = [_patrolItemView isToggleOn];
    BOOL clearBaseSetting = [_preferenceItemView isToggleOn];
    BOOL clearNotification = [_messageItemView isToggleOn];
    
    [SystemConfig setClearFile:clearFile];
    [SystemConfig setClearBaseData:clearBaseData];
    [SystemConfig setClearPatrolTask:clearPatrolTask];
    [SystemConfig setClearBaseSetting:clearBaseSetting];
    [SystemConfig setClearNotification:clearNotification];
}

//是否需要清除临时文件
- (BOOL) needClearFiles {
    return [_fileItemView isToggleOn];
}

//是否需要清除基础数据
- (BOOL) needClearBaseData {
    return [_baseDataItemView isToggleOn];
}

//是否需要清除巡检任务
- (BOOL) needClearPatrolTasks {
    return [_patrolItemView isToggleOn];
}

//是否需要清除基础设置
- (BOOL) needClearBaseSettings {
    return [_preferenceItemView isToggleOn];
}

//是否需要清除推送消息记录
- (BOOL) needClearNotification {
    return [_messageItemView isToggleOn];
}

//是否需要清除缓存
- (BOOL) needClearCache {
    BOOL res = [self needClearFiles] || [self needClearBaseData] || [self needClearPatrolTasks] || [self needClearBaseSettings] || [self needClearNotification];
    return res;
}

//清除文件缓存
- (void) clearFileCache {
    [_results setValue:[NSNumber numberWithBool:NO] forKeyPath:@"file"];
    [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_FILE];
}

//清除基础数据缓存
- (void) clearBaseDataCache {
    [_results setValue:[NSNumber numberWithBool:NO] forKeyPath:@"baseData"];
    [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_BASE_DATA];
}

//清除巡检任务缓存
- (void) clearPatrolTaskCache {
    [_results setValue:[NSNumber numberWithBool:NO] forKeyPath:@"patrolTask"];
    [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_PATROL_TASK];
}

//清除基础设置缓存
- (void) clearBaseSettingsCache {
    [_results setValue:[NSNumber numberWithBool:NO] forKeyPath:@"baseSetting"];
    [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_USER_PREFERENCE];
}

//清除推送消息缓存
- (void) clearNotificationCache {
    [_results setValue:[NSNumber numberWithBool:NO] forKeyPath:@"notification"];
    [[FMCache getInstance] clearCacheSizeByType:FM_CACHE_TYPE_USER_NOTIFICATION];
}

//清除缓存
- (void) clearCache {
    if([self needClearCache]) {
        DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[self getClearNotice] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        
        alertView.leftBlock= ^() {
            if([self needClearFiles]) {
                [self clearFileCache];
            }
            if([self needClearBaseData]) {
                [self clearBaseDataCache];
            }
            if([self needClearPatrolTasks]) {
                [self clearPatrolTaskCache];
            }
            if([self needClearBaseSettings]) {
                [self clearBaseSettingsCache];
            }
            if([self needClearNotification]) {
                [self clearNotificationCache];
            }
        };
        alertView.rightBlock= ^() {
            
        };
        [alertView show];
        
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"cache_notice_select_none" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (NSString *) getClearNotice {
    NSString * res = @"";
    res = [[BaseBundle getInstance] getStringByKey:@"cache_notice_clear_text" inTable:nil];
    return res;
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([FMCache class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"resultType"];
            FMCacheType type = [tmpNumber integerValue];
            switch (type) {
                case FM_CACHE_TYPE_FILE:
                    [self performSelectorOnMainThread:@selector(noticeFileCleared) withObject:nil waitUntilDone:NO];
                    break;
                case FM_CACHE_TYPE_BASE_DATA:
                    [self performSelectorOnMainThread:@selector(noticeBaseDataCleared) withObject:nil waitUntilDone:NO];
                    break;
                case FM_CACHE_TYPE_PATROL_TASK:
                    [self performSelectorOnMainThread:@selector(noticePatrolTaskCleared) withObject:nil waitUntilDone:NO];
                    break;
                case FM_CACHE_TYPE_USER_PREFERENCE:
                    [self performSelectorOnMainThread:@selector(noticeBaseSettingCleared) withObject:nil waitUntilDone:NO];
                    break;
                case FM_CACHE_TYPE_USER_NOTIFICATION:
                    [self performSelectorOnMainThread:@selector(noticeNotificationCleared) withObject:nil waitUntilDone:NO];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void) noticeFileCleared {
    FMLog(@"文件清除成功。");
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"file"];
    [self noticeTaskFinished];
}


- (void) noticeBaseDataCleared {
    FMLog(@"基础数据清除成功。");
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"baseData"];
    [self noticeTaskFinished];
}

- (void) noticePatrolTaskCleared {
    FMLog(@"巡检任务清除成功。");
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"patrolTask"];
    [self noticeTaskFinished];
}

- (void) noticeBaseSettingCleared {
    FMLog(@"基础设置清除成功。");
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"baseSetting"];
    [self noticeTaskFinished];
}

- (void) noticeNotificationCleared {
    FMLog(@"推送记录清除成功。");
    [_results setValue:[NSNumber numberWithBool:YES] forKeyPath:@"notification"];
    [self noticeTaskFinished];
}

- (void) noticeTaskFinished {
    BOOL res = YES;
    NSNumber * tmpNumber = [_results valueForKeyPath:@"file"];
    res = res && tmpNumber.boolValue;
    if(res) {
        tmpNumber = [_results valueForKeyPath:@"baseData"];
        res = res && tmpNumber.boolValue;
    }
    
    if(res) {
        tmpNumber = [_results valueForKeyPath:@"patrolTask"];
        res = res && tmpNumber.boolValue;
    }
    
    if(res) {
        tmpNumber = [_results valueForKeyPath:@"baseSetting"];
        res = res && tmpNumber.boolValue;
    }
    
    if(res) {
        tmpNumber = [_results valueForKeyPath:@"notification"];
        res = res && tmpNumber.boolValue;
    }
    if(res) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"cache_notice_clear_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

@end
