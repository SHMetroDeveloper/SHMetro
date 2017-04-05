//
//  BaseBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^business_success_block) (NSInteger key, id object);
typedef void (^business_failure_block) (NSInteger key, NSError* error);

@interface BaseBusiness : NSObject

@end
