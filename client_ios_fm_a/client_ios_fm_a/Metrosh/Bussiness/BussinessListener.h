//
//  BussinessListener.h
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 27/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussinessInfo.h"

typedef void (^Block_OnFinish) ();
typedef void (^Block_OnFailure) ();

@protocol BussinessListener <NSObject>

@required
- (void) onSuccess: (BussinessInfo *) info;
- (void) onError: (BussinessInfo *) info;
@end
