//
//  AttachmentViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface AttachmentViewController : BaseViewController

- (instancetype)initWithAttachmentURL:(NSURL *) attachmentUrl;

- (void) setTitleByFileName:(NSString *) fileName;

@end
