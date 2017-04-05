//
//  ContractRecordTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/27.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContractRecordActionBlock)(id object);

@interface ContractRecordTableViewCell : UITableViewCell

@property (nonatomic, copy) ContractRecordActionBlock actionBlock;

- (void)setSeperatorGapped:(BOOL)isGapped;

//设置头像图片Url
- (void)setPortraitWithImageId:(NSNumber *) imageId;

- (void)setInfoWithName:(NSString *)name
                   desc:(NSString *)desc
                   time:(NSNumber *)time
                 status:(NSInteger)status
             attachment:(NSMutableArray *)attachment;

+ (CGFloat)calculateHeightByDesc:(NSString *)content andAttachmentCount:(NSInteger)count;

@end
