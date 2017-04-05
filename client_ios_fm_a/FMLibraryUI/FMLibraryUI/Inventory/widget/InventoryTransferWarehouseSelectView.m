//
//  InventoryTransferWarehouseSelectView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryTransferWarehouseSelectView.h"
#import "VerticalLabelView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMFont.h"

@interface InventoryTransferWarehouseSelectView () <OnClickListener>
@property (readwrite, nonatomic, strong) VerticalLabelView * srcLbl;
@property (readwrite, nonatomic, strong) VerticalLabelView * targetLbl;
@property (readwrite, nonatomic, strong) UIImageView * arrowImgView;
@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, strong) NSString * srcName;
@property (readwrite, nonatomic, strong) NSString * targetName;

@property (readwrite, nonatomic, strong) UIFont * labelFont;
@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation InventoryTransferWarehouseSelectView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _imgWidth = 50;
        
        _srcLbl = [[VerticalLabelView alloc] init];
        _targetLbl = [[VerticalLabelView alloc] init];
        _arrowImgView = [[UIImageView alloc] init];
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [_srcLbl setOnClickListener:self];
        [_targetLbl setOnClickListener:self];
        
        [_srcLbl setDesc:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_warehouse_src_desc" inTable:nil]];
        [_targetLbl setDesc:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_warehouse_target_desc" inTable:nil]];
        
        [_srcLbl setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_warehouse_src_desc_placeholder" inTable:nil]];
        [_targetLbl setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_warehouse_target_desc_placeholder" inTable:nil]];
        
        _srcLbl.tag = INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC;
        _targetLbl.tag = INVENTORY_TRANSFER_WAREHOUSE_SELECT_TARGET;
        
        [_arrowImgView setImage:[[FMTheme getInstance] getImageByName:@"aarow"]];
        
        [self addSubview:_arrowImgView];
        [self addSubview:_srcLbl];
        [self addSubview:_targetLbl];
        [self addSubview:_bottomSeperator];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat imgHeight = _imgWidth;
    CGFloat itemWidth = (width - _imgWidth) / 2;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    [_arrowImgView setFrame:CGRectMake(itemWidth, (height-imgHeight)/2, _imgWidth, imgHeight)];
    [_srcLbl setFrame:CGRectMake(0, 0, itemWidth, height)];
    [_targetLbl setFrame:CGRectMake(width-itemWidth, 0, itemWidth, height)];
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_srcLbl setContent:_srcName];
    [_targetLbl setContent:_targetName];
}

- (void) setInfoWithSrcWarehouse:(NSString *) srcName targetWarehouse:(NSString *) targetName {
    _srcName = srcName;
    _targetName = targetName;
    [self updateViews];
}

- (void) setShowBottomSeperator:(BOOL) show {
    if(show) {
        [_bottomSeperator setHidden:NO];
    } else {
        [_bottomSeperator setHidden:YES];
    }
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

#pragma mark - 点击
- (void) onClick:(UIView *)view {
    if(view == _srcLbl) {
        [_listener onItemClick:self subView:_srcLbl];
    } else if(view == _targetLbl) {
        [_listener onItemClick:self subView:_targetLbl];
    }
}
@end
