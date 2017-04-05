//
//  ContractBaseInfoTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractDetailEntity.h"

typedef NS_ENUM(NSInteger, ContractBaseInfoActionType) {
    CONTRACT_BASEINFO_ACTION_TYPE_ATTACHMENT,
    CONTRACT_BASEINFO_ACTION_TYPE_PHONE,
};

typedef void(^ContractBaseInfoActionBlock)(ContractBaseInfoActionType type, id object);

@interface ContractBaseInfoTableViewCell : UITableViewCell

@property (nonatomic, copy) ContractBaseInfoActionBlock actionBlock;

- (void)setExpand:(BOOL)isExpand;

- (void)setContractDetail:(ContractDetailEntity *)detail;

+ (CGFloat)calculateHeightByExpand:(BOOL)isExpand andContractDetail:(ContractDetailEntity *)detail;

@end
