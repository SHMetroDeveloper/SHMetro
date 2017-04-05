//
//  FMTheme.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "FMTheme.h"
#import "FMColor.h"
#import "FMFont.h"
#import "BaseBundle.h"

static FMTheme * themeInstance;

@interface FMTheme ()
@property (readwrite, nonatomic, strong) NSString * nameExtFormat;  //资源名字扩展格式

@property (readwrite, nonatomic, assign) FMThemeType themeType;     //当前主题类型

@end

@implementation FMTheme

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!themeInstance) {
            themeInstance = [[FMTheme alloc] init];
        }
    });
    return themeInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _nameExtFormat = @"%@_%@";
        _themeType = FM_THEME_TYPE_SHANG;
    }
    return self;
}

- (void) setCurrentThemeType:(FMThemeType) type {
    _themeType = type;
}

//获取实际文件名
- (NSString *) getRealityNameByName:(NSString *) name {
    NSString * realName = name;
    NSString * extName = nil;
    switch(_themeType) {
        case FM_THEME_TYPE_SHANG:
            extName = @"shang";
            break;
        case FM_THEME_TYPE_DTZ:
            extName = @"dtz";
            break;
        default:
            break;
    }
    if(extName) {
        realName = [[NSString alloc] initWithFormat:_nameExtFormat, name, extName];
    }
    return realName;
}



- (UIImage *) getImageByName:(NSString *) name {
    UIImage * image;
    NSString * realName = [self getRealityNameByName:name];
//    image = [UIImage imageNamed:realName];
    image = [[BaseBundle getInstance] getPngImageByKeyDynamic:realName];
    if(!image) {    //如果获取指定资源失败就获取默认资源
//        image = [UIImage imageNamed:name];
        image = [[BaseBundle getInstance] getPngImageByKeyDynamic:name];
    }
    return image;
}
- (UIColor *) getColorByResource:(FMResourceType) type {
    UIColor * color;
    color = [[FMColor getInstance] getColorByResource:type theme:_themeType];
    return color;
}

- (UIFont *) getFontByResource:(FMResourceType) type {
    UIFont * font;
    return font;
}
@end
