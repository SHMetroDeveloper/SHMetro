//
//  NetPage.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "NetPage.h"

NSInteger const NET_PAGE_DEFAULT_SIZE = 10;


@implementation NetPageParam

- (instancetype) init {
    self = [super init];
    if(self) {
        [self reset];
    }
    return self;
}
- (void) reset {
    _pageNumber = [NSNumber numberWithInteger:0];
    _pageSize = [NSNumber numberWithInteger:NET_PAGE_DEFAULT_SIZE];
}

@end

@implementation NetPage

- (instancetype) init {
    self = [super init];
    if(self){
        [self reset];
    }
    return self;
}

- (void) reset {
    [super reset];
    _totalCount = nil;
    _totalPage = nil;
}

- (BOOL) isFirstPage {
    if(self.pageNumber.integerValue == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) haveMorePage {
    if((_totalPage && _totalPage.integerValue > 0) && (self.pageNumber && _totalPage && self.pageNumber.integerValue < _totalPage.integerValue-1)) {
        return YES;
    } else {
        return NO;
    }
}

- (NSNumber *) nextPage {
    NSInteger tmp = self.pageNumber.integerValue + 1;
    if(_totalPage > 0) {
        if(tmp > _totalPage.integerValue - 1) {
            self.pageNumber = [NSNumber numberWithInteger: _totalPage.integerValue - 1];
        } else {
           self.pageNumber = [NSNumber numberWithInteger:tmp];
        }
    } else {
        self.pageNumber = 0;
    }
    return self.pageNumber;
}

- (void) setPage: (NetPage *) page {
    self.pageNumber = page.pageNumber;
    self.pageSize = page.pageSize;
    _totalPage = page.totalPage;
    _totalCount = page.totalCount;
}

- (void) setPageWithDictionary: (NSDictionary *) page {
    id tmp = [page valueForKeyPath:@"pageNumber"];
    if(tmp && ![tmp isKindOfClass:[NSNull class]]) {
        self.pageNumber = [tmp copy];
    } else {
        self.pageNumber = nil;
    }
    tmp = [page valueForKeyPath:@"pageSize"];
    if(tmp && ![tmp isKindOfClass:[NSNull class]]) {
        self.pageSize = [tmp copy];
    } else {
        self.pageSize = nil;
    }
    tmp = [page valueForKeyPath:@"totalPage"];
    if(tmp && ![tmp isKindOfClass:[NSNull class]]) {
        _totalPage = [tmp copy];
    } else {
        _totalPage = nil;
    }
    tmp = [page valueForKeyPath:@"totalCount"];
    if(tmp && ![tmp isKindOfClass:[NSNull class]]) {
        _totalCount = [tmp copy];
    } else {
        _totalCount = nil;
    }
}

@end