//
//  FMSearchController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+pinyin.h"
typedef NS_ENUM(NSInteger, SearchActionType) {
    FUZZY_SEARCH_ACTION_TYPE_CANCEL,   //取消搜索
    FUZZY_SEARCH_ACTION_TYPE_DONE,     //确认搜索内容
};

typedef void (^TextChangeBlock) (NSString *text);
typedef void (^ActionBlock) (SearchActionType actionType);

@interface SearchStoreEntity : NSObject
@property (nonatomic, copy) NSString *name;             //搜索名字
@property (nonatomic, copy) NSString *namePinyin;       //搜索名字的拼音，应该在获取的时候就转为拼音
@property (nonatomic, copy) NSString *nameAcronyms;     //搜索名字的首字母缩写
@property (nonatomic, strong) id identification;        //要搜索的东西的唯一标识
@end

@interface FMSearchController : UISearchController
@property (nonatomic, copy) TextChangeBlock textChangeBlock;
@property (nonatomic, copy) ActionBlock actionBlock;

- (instancetype)initWithSearchResultsController:(nullable UIViewController *)searchResultsController;
@end
