//
//  NetPage.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const NET_PAGE_DEFAULT_SIZE;


//用于从网络上获取时
@interface NetPageParam : NSObject
@property (readwrite, nonatomic, strong) NSNumber * pageNumber;
@property (readwrite, nonatomic, strong) NSNumber * pageSize;
- (instancetype) init;
- (void) reset;
@end

@interface NetPage : NetPageParam


@property (readwrite, nonatomic, strong) NSNumber * totalPage;
@property (readwrite, nonatomic, strong) NSNumber * totalCount;

- (instancetype) init;
- (void) reset;
- (BOOL) isFirstPage;
- (BOOL) haveMorePage;
- (NSNumber *) nextPage;
- (void) setPage: (NetPage *) page;
- (void) setPageWithDictionary: (NSDictionary *) page;

@end

