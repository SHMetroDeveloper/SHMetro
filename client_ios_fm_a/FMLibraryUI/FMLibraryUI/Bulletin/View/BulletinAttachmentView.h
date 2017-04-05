//
//  BulletinAttachmentView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/9.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletinDetailEntity.h"

typedef void(^BulletinAttachmenActionBlock)(BulletinAttachment *attachment);

@interface BulletinAttachmentView : UIView

@property (nonatomic, copy) BulletinAttachmenActionBlock actionBlock;

- (void) setAttachmentDataArray:(NSMutableArray *) dataArray;

+ (CGFloat) getHeightByAttachmentCount:(NSInteger) count;

@end
