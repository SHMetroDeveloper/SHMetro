//
//  MultiSelectViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/20.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "NodeList.h"
#import "OnMessageHandleListener.h"


//结果类型
typedef NS_ENUM(NSInteger, MultiInfoSelectResultType) {
    RESULT_TYPE_OK_MULTI_INFO_SELECT,
    RESULT_TYPE_CANCEL_MULTI_INFO_SELECT
};


@interface MultiSelectViewController : BaseViewController < UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
//直接请求（不含参数）
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;

//设置数据
- (void) setInfoWith:(NodeList *) nodes;

//设置被选中的数据，NodeItem 数组
- (void) setSelectDataByArray:(nullable NSMutableArray *) nodeArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

