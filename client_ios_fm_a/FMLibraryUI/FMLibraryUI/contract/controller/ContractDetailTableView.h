//
//  ContractDetailTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractDetailEntity.h"
#import "ContractEquipment.h"

typedef NS_ENUM(NSInteger, ContractDetalActionType) {
    CONTRACT_DETAIL_ACTION_PHONE,  //打电话
    CONTRACT_DETAIL_ACTION_ATTACHMENT,  //查看附件
    CONTRACT_DETAIL_ACTION_HISTORY_ATTACHMENT,  //查看操作记录附件
    CONTRACT_DETAIL_ACTION_HISTORY_MORE,  //查看更多操作记录
    CONTRACT_DETAIL_ACTION_EQUIPMENT,  //查看关联设备
    CONTRACT_DETAIL_ACTION_EQUIPMENT_MORE,  //查看更多关联设备
};

typedef void(^ContractDetailActionBlock)(ContractDetalActionType type, id object);

@interface ContractDetailTableView : UITableView

@property (nonatomic, copy) ContractDetailActionBlock actionBlock;

//设置合同详情，浅复制 copy
- (void)setContractDetail:(ContractDetailEntity *)contractDetail;

//设置关联设备
- (void)setEquipmentDataArray:(NSMutableArray *)equipmentDataArray;

@end
