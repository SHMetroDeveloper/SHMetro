//
//  MessageSummaryTableViewHelper.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/20.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, MessageSummaryTableViewEventType) {
    MESSGE_SUMMARY_TABLE_VIEW_EVENT_TYPE_UNKNOW,  //
    MESSGE_SUMMARY_TABLE_VIEW_EVENT_TYPE_CLICK,  //删除
    MESSGE_SUMMARY_TABLE_VIEW_EVENT_TYPE_DELETE,  //查看更多
    MESSGE_SUMMARY_TABLE_VIEW_EVENT_TYPE_REFRESH,  //下拉刷新
    MESSGE_SUMMARY_TABLE_VIEW_EVENT_TYPE_LOADMORE,  //加载更多
};

@interface MessageSummaryTableViewHelper : NSObject<UITableViewDelegate, UITableViewDataSource>

//设置消息
- (void) setMsgArray:(NSMutableArray *) msgArray;

//设置事件监听
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
