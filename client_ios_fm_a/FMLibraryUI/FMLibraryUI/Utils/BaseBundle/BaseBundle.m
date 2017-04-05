//
//  BaseBundle.m
//  FMLibraryBase
//
//  Created by 杨帆 on 2/8/17.
//  Copyright © 2017 Facilityone. All rights reserved.
//

#import "BaseBundle.h"

static BaseBundle * bundleInstance;

static const NSString * FM_BASE_TABLE = @"base";

@interface BaseBundle ()

@property (readwrite, nonatomic, strong) NSString * bundleName;
@property (readwrite, nonatomic, strong) NSBundle * bundle;
@end

@implementation BaseBundle

+ (instancetype) getInstance {
    if(!bundleInstance) {
        bundleInstance = [[BaseBundle alloc] init];
    }
    return bundleInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _bundleName = @"FMLibraryUI";
        NSString * path = [[NSBundle mainBundle] pathForResource:_bundleName ofType:@"bundle"];
        _bundle = [NSBundle bundleWithPath:path];
    }
    return self;
}

- (instancetype) initWithName:(NSString *) bundleName {
    self = [super init];
    if(self) {
        _bundleName = bundleName;
        NSString * path = [[NSBundle mainBundle] pathForResource:_bundleName ofType:@"bundle"];
        _bundle = [NSBundle bundleWithPath:path];
    }
    return self;
}

//获取指定位置的指定字符串
- (NSString *) getStringByKey:(NSString *) key inTable:(NSString *) table {
    if(!table) {
        table = [FM_BASE_TABLE copy];
    }
    NSString * res = NSLocalizedStringFromTableInBundle(key, table, _bundle, nil);
    return res;
}


//静态获取 png 图片资源，用于使用率较高的较小的图片
- (UIImage *) getPngImageByKeyStatic:(NSString *) key {
    NSString * name = [[NSString alloc] initWithFormat:@"%@.bundle/images/%@", _bundleName, key];
    UIImage * res = [UIImage imageNamed:name];
    return res;
}

//静态获取 png 图片资源，用于使用率较低的较大的图片
- (UIImage *) getPngImageByKeyDynamic:(NSString *) key {
    NSString * path = [_bundle pathForResource:key ofType:@"png" inDirectory:@"images"];
    UIImage * res = [UIImage imageWithContentsOfFile:path];
    return res;
}
@end
