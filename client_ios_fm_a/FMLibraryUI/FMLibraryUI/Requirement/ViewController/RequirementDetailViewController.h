//
//  RequirementDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/24.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"

@interface RequirementDetailViewController : BaseViewController

- (instancetype) init;

- (void) setInforWith:(NSNumber *) reqId;
- (void) setEditable:(BOOL) editable;
- (void) setCommentable:(BOOL) commentable;

@end
