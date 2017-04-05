//
//  UserPhotoSetEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/13/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface UserPhotoSetParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * photoId;

- (instancetype) init;
- (NSString *) getUrl;
@end
