//
//  SubmitSpotTaskEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface SubmitSpotTask : NSObject

@property (readwrite, nonatomic, strong) NSNumber* id;
@property (readwrite, nonatomic, strong) NSString* resultSelect;
@property (readwrite, nonatomic, strong) NSString* resultInput;
@property (readwrite, nonatomic, strong) NSString* comment;
@property (readwrite, nonatomic, strong) NSNumber* startDateTime;
@property (readwrite, nonatomic, strong) NSNumber* endDateTime;
@property (readwrite, nonatomic, strong) NSNumber* patrolTaskItemId;

- (instancetype) initWithId:(NSNumber*)id resultSelect:(NSString*) resultSelect resultInput:(NSNumber*) resultInput comment:(NSString *)comment startTime:(NSNumber*) startDateTime endTime:(NSNumber*) endDateTime patrolTaskItemId: (NSNumber*) patrolTaskItemId;

@end


//@interface SubmitSpotTaskRequest : BaseRequest
//
//@property (readwrite, nonatomic, assign) NSInteger userId;
//@property (readwrite, nonatomic, strong) NSMutableArray * patrolTaskItemDetails;
//
//- (instancetype) initWith:(NSInteger) userId tasks:(NSMutableArray*)patrolTaskItemDetails;
//- (NSString *) getUrl;
//
//@end
