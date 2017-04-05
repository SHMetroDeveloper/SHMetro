//
//  BussinessInfo.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "BussinessInfo.h"

@implementation BussinessInfo

+(NSString *) getUrlWithType : (NSInteger) iType {
    
    if ( dicUrl == NULL ) {
        //test
        //NSString * strRootUrl = @"http://183.78.182.4:8181/";
        
        //release
        NSString * strRootUrl = @"http://222.66.139.89:8081/";
        
        dicUrl = [[NSMutableDictionary alloc] init];

        [dicUrl setValue: [strRootUrl stringByAppendingString: @"shmetro2/login.action" ]
                  forKey:[NSString stringWithFormat:@"%zd" , BUSSINESS_LOGIN]];
        
        [dicUrl setValue: [strRootUrl stringByAppendingString: @"common/search_task.action"]
                  forKey: [NSString stringWithFormat:@"%zd" , BUSSINESS_QUERY_TASK]];
        
        [dicUrl setValue: [strRootUrl stringByAppendingString: @"message/search_current_user_message.action"]
                  forKey: [NSString stringWithFormat:@"%zd" , BUSSINESS_QUERY_MESSAGE]];
    }
    return dicUrl[[NSString stringWithFormat:@"%zd" ,iType]];
};

-(instancetype) initWithType : (NSInteger) iType {

    self.iType = iType ;
    self.strUrl = [BussinessInfo getUrlWithType: iType];
    
    return self;
};

@end
