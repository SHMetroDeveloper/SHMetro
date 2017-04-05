//
//  QuickReportViewController.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseDataEntity.h"

@interface QuickReportViewController : BaseViewController

//处理从巡检过来的报障
- (void) setInforWithLocation:(Position *) location
                    equipment:(NSNumber *) equipId
                      content:(NSNumber *) contentId
                         desc:(NSString *) desc
                         imgs:(NSMutableArray *) imageIds;

//处理从资产过来的快速报障
- (void) setEquipmentId:(NSNumber *)eqId;

@end
