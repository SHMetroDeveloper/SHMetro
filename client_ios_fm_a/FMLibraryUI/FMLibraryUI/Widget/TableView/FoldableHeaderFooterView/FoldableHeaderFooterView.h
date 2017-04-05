//
//  FoldableHeaderFooterView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotateView.h"
@class FoldableHeaderFooterView;

@protocol FoldableHeaderFooterViewDelegate <NSObject>

@optional

/**
 *  FoldableHeaderFooterView's event.
 *
 *  @param (FoldableHeaderFooterView *) headerFooterView object.
 *  @param event                  Event data.
 */
- (void)FoldableHeaderFooterView:(FoldableHeaderFooterView *) headerFooterView event:(id)event;

@end

@interface FoldableHeaderFooterView : UITableViewHeaderFooterView

/**
 *  FoldableHeaderFooterView's delegate.
 */
@property (nonatomic, weak) id <FoldableHeaderFooterViewDelegate> delegate;

/**
 *  UITableView's section.
 */
@property (nonatomic) NSInteger section;

@end
