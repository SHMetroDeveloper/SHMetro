//
//  EquipmentUndoPatrolModel.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/21.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentUndoPatrolModel : NSObject

@property (nonatomic, strong) NSNumber *taskId;
@property (nonatomic, strong) NSString *taskName;

@property (nonatomic, strong) NSNumber *spotId;
@property (nonatomic, strong) NSString *spotName;

@property (nonatomic, strong) NSNumber *deviceId;
@property (nonatomic, assign) NSString *deviceName;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *projectId;

@end
