//
//  TransQueryMessage.h
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 30/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussinessInfo.h"
#import "BussinessClient.h"
#import "BussinessListener.h"

@interface TransQueryMessage : NSObject <BussinessListener>

@property (readwrite, nonatomic, copy) Block_OnFinish onFinish ;
@property (readwrite, nonatomic, copy) Block_OnFailure onFailure ;

@property (readwrite, nonatomic, strong) BussinessInfo * bussinessinfo ;

- (instancetype) init ;

- (void) request : (void (^)()) onFinish
        onFailer : (void (^)()) onFailure ;

@end
