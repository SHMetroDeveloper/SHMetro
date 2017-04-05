//
//  PhotoItem.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/3.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PhotoItem.h"
#import "FMUtils.h"

@interface PhotoItem ()

@end


@implementation PhotoItem

- (instancetype) init {
    self = [super init];
    if(self) {
        _type = PHOTO_TYPE_UNKNOW;
        _origin = PHOTO_ORIGIN_IMAGE;
    }
    return self;
}

- (void) setUrl:(NSURL *)url {
    _type = PHOTO_TYPE_REMOTE;
    if(url && [url isKindOfClass:[NSURL class]]) {
        _url = url;
    }
}
- (void) setImage:(UIImage *)image {
    _type = PHOTO_TYPE_LOCAL;
    if(image) {
        _image = image;
    }
}

- (BOOL) isRemotePhoto {
    return _type == PHOTO_TYPE_REMOTE;
}

- (BOOL) isLocalPhoto {
    return _type == PHOTO_TYPE_LOCAL;
}

- (void) setOrigin:(PhotoItemOrigin)origin {
    _origin = origin;
}

- (void) setOriginUrl:(NSURL *)originUrl {
    _originUrl = originUrl;
}

@end
