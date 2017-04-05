//
//  PatrolHistoryDetailSpotContentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolServerConfig.h"

@interface PatrolHistoryDetailSpotContentItemView : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWith:(NSString *) content
           hasReport:(BOOL) hasReport
             hasLeak:(BOOL) hasLeak
        hasException:(BOOL) hasException;

//设置异常状态
- (void) setInfoWith:(NSString *) content
     exceptionStatus:(PatrolEquipmentExceptionStatus) exceptionStatus;
@end
