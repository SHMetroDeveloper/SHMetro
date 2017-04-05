//
//  InventoryStorageInEditMaterialTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryMaterialDetailEntity.h"
#import "SeperatorTableViewCell.h"

typedef void(^AttachmentClickActionBlock)(InventoryMaterialDetailAttachment *attachment);
typedef void(^PhotoShowActionBlock)(NSNumber *photoPosition);

@interface InventoryMaterialBaseInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showPhotos;
@property (nonatomic, assign) BOOL showAttachments;
@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) InventoryMaterialDetail *materialDetail;

@property (nonatomic, copy) AttachmentClickActionBlock attachmentBlock;
@property (nonatomic, copy) PhotoShowActionBlock photoBlock;

+ (CGFloat)getItemHeightByExpand:(BOOL)isExpand
                     description:(NSString *)desc
                      photoCount:(NSInteger)photoCount
                 attachmentCount:(NSInteger)attachmentCount;

@end
