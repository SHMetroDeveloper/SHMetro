//
//  NewReportViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/7/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BaseDataEntity.h"


@interface NewReportViewController : BaseViewController

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

//处理从巡检过来的报障
- (void) setInforWithLocation:(Position *) location
                    equipment:(NSNumber *) equipId
                      content:(NSNumber *) contentId
                         desc:(NSString *) desc
                         imgs:(NSMutableArray *) imageIds;

//处理从需求过来的报障
- (void) setInfoWithRequestorId:(NSNumber *) requestorId
                           name:(NSString *) name
                          telno:(NSString *) telno
                  requirementId:(NSNumber *) reqId
                 andDescContent:(NSString *) content
                      andPhotos:(NSMutableArray *) photos;


@end
