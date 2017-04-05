//
//  ContractEquipmentViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "NetPage.h"

@interface ContractEquipmentViewController : BaseViewController

- (void)setContractId:(NSNumber *)contractId equipmentDataArray:(NSMutableArray *)dataArray andNetPage:(NetPage *)netPage;

@end
