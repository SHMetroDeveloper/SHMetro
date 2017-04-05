//
//  SubmitSpotTaskEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "SubmitSpotTaskEntity.h"

#import "SystemConfig.h"
#import "PatrolServerConfig.h"

@implementation SubmitSpotTask

- (instancetype) initWithId:(NSNumber*)id resultSelect:(NSString*) resultSelect resultInput:(NSNumber*) resultInput comment:(NSString *)comment startTime:(NSNumber*) startDateTime endTime:(NSNumber*) endDateTime patrolTaskItemId: (NSNumber*) patrolTaskItemId {
    self = [super init];
    if(self) {
        self.id = id;
        self.resultSelect = resultSelect;
        self.resultInput = [[NSString alloc] initWithFormat:@"%.1f", resultInput.floatValue];
        self.comment = comment;
        self.startDateTime = startDateTime;
        self.endDateTime = endDateTime;
        self.patrolTaskItemId = patrolTaskItemId;
    }
    return self;
}

@end


//@implementation SubmitSpotTaskRequest
//
//- (instancetype) initWith:(NSInteger) userId tasks:(NSMutableArray*)patrolTaskItemDetails {
//    self = [super init];
//    if(self) {
//        
//    }
//    return self;
//}
//- (NSString *) getUrl {
//    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], PATROL_SUBMIT_SPOT_TASK_URL];
//    return res;
//}
//
//@end

