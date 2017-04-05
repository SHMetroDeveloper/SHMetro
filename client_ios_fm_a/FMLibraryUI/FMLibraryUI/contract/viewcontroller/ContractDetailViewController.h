//
//  ContractDetailViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"

@interface ContractDetailViewController : BaseViewController

- (instancetype) init;

- (void)setEditable:(BOOL)editable;

- (void) setContractWithId:(NSNumber *) contractId;

@end
