//
//  BussinessInfo.h
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM( NSInteger, BussinessType) {
    
    BUSSINESS_LOGIN  = 0 ,
    BUSSINESS_QUERY_MESSAGE ,
    BUSSINESS_QUERY_TASK
};

static NSMutableDictionary * dicUrl = NULL ;

@interface BussinessInfo : NSObject

@property (readwrite, nonatomic, assign) NSInteger iType ;
@property (readwrite, nonatomic, strong) NSString * strUrl ;

@property (readwrite, nonatomic, strong) NSMutableDictionary * dicHeaders ;
@property (readwrite, nonatomic, strong) NSMutableDictionary * dicBodys ;

@property (readwrite, nonatomic, strong) AFHTTPRequestOperation * afOperation ;
@property (readwrite, nonatomic, strong) NSDictionary * dicResponses ;
@property (readwrite, nonatomic, strong) NSError * error ;

-(instancetype) initWithType : (NSInteger) iType ;
+(NSString *) getUrlWithType :  (NSInteger) iType ;

@end
