//
//  HttpClient.h
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BussinessUserInfo.h"
#import "BussinessListener.h"

@interface BussinessClient : NSObject

+(void) requestWithUrl : (BussinessInfo *) bussinessInfo
                  listener: (NSObject<BussinessListener> *)bussinesslistener;

+(void) analyzeUserInfo :(BussinessInfo *) bussinessInfo ;


@end
