//
//  PhotoItem.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/3.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoItemType) {
    PHOTO_TYPE_UNKNOW,      //
    PHOTO_TYPE_REMOTE,      //远程
    PHOTO_TYPE_LOCAL        //本地
};

//图片来源
typedef NS_ENUM(NSInteger, PhotoItemOrigin) {
    PHOTO_ORIGIN_UNKNOW,      //
    PHOTO_ORIGIN_IMAGE,      //图片
    PHOTO_ORIGIN_AUDIO,      //音频
    PHOTO_ORIGIN_VIDEO       //视频图片
};

@interface PhotoItem : NSObject

@property (readwrite, nonatomic, assign) PhotoItemType type;        //是否为远程图片
@property (readwrite, nonatomic, assign) PhotoItemOrigin origin;    //是否为图片
@property (readwrite, nonatomic, strong) NSURL * url;               //远程图片的 url 地址
@property (readwrite, nonatomic, strong) NSURL * originUrl;         //远程视频的url

@property (readwrite, nonatomic, strong) UIImage * image;
@property (readwrite, nonatomic, strong) NSString * path;

- (instancetype) init;
//为远程图片设置 url 地址
- (void) setUrl:(NSURL *)url;
//
- (void) setImage:(UIImage *)image;
//判断是否为远程图片
- (BOOL) isRemotePhoto;
//判断是否为本地图片
- (BOOL) isLocalPhoto;

//设置来源
- (void) setOrigin:(PhotoItemOrigin)origin;
- (void) setOriginUrl:(NSURL *)originUrl;
@end