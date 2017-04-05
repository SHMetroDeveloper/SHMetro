//
//  BulletinAttachmentView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/9.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinAttachmentView.h"

#import "FMUtilsPackages.h"

@interface BulletinAttachmentView ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation BulletinAttachmentView

- (void) updateViews {
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat itemHeight = 31.5f;
    for (UIButton *attachmentBtn in self.subviews) {
        CGSize titleLabelSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font44 andContent:attachmentBtn.currentTitle andMaxWidth:self.frame.size.width];
        [attachmentBtn setFrame:CGRectMake(originX, originY, titleLabelSize.width, itemHeight)];
        originY += itemHeight;
    }
}

- (void) updateInfo {
    for (BulletinAttachment *attachment in _dataArray) {
        UIButton *attachmentButton = [UIButton new];
        [attachmentButton setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [attachmentButton setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [attachmentButton setTitle:attachment.name forState:UIControlStateNormal];
        attachmentButton.titleLabel.font = [FMFont getInstance].font44;
        attachmentButton.tag = attachment.attachmentId.integerValue;
        [attachmentButton addTarget:self action:@selector(onAttachmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attachmentButton];
    }
    
    [self updateViews];
}

- (void) setAttachmentDataArray:(NSMutableArray *) dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    } else {
        [_dataArray removeAllObjects];
    }
    
    [_dataArray addObjectsFromArray:dataArray];
    [self updateInfo];
}

- (void) onAttachmentBtnClick:(id) sender {
    UIButton *btn = (UIButton *)sender;
    BulletinAttachment *attachment = [[BulletinAttachment alloc] init];
    attachment.name = btn.currentTitle;
    attachment.attachmentId = [NSNumber numberWithInteger:btn.tag];
    _actionBlock(attachment);
}

+ (CGFloat) getHeightByAttachmentCount:(NSInteger) count {
    CGFloat height = 0;
    CGFloat itemHeight = 31.5f;
    height = itemHeight * count;
    return height;
}

@end
