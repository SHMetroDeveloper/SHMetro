//
//  PatrolContentItemExceptionMarkEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

@interface PatrolContentItemExceptionMarkEntity : NSObject

@end

@interface PatrolContentItemExceptionMarkRequestParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * contentId;
- (instancetype) initWithContentId:(NSNumber *) contentId;
- (NSString*) getUrl;
@end
