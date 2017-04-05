//
//  CaptionTextTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/13/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "CaptionTextTableViewCell.h"
#import "CaptionTextField.h"
#import "FMSize.h"

@interface CaptionTextTableViewCell () <OnClickListener>

@property (readwrite, nonatomic, strong) CaptionTextField * captionField;
@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, weak) id<OnClickListener> listener;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation CaptionTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        _defaultHeight = 92;
        _captionField = [[CaptionTextField alloc] init];
        
        [self.contentView addSubview:_captionField];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    [_captionField setFrame:CGRectMake(0, 0, width, height)];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateInfo {
    
}

//设置标题
- (void) setTitle:(NSString *) title {
    [_captionField setTitle:title];
}

//设置默认提示
- (void) setPlaceholder:(NSString *) placeholder {
    [_captionField setPlaceholder:placeholder];
}

//设置内容
- (void) setText:(NSString *) text {
    [_captionField setText:text];
}

- (void) setDesc:(NSString *) desc {
    [_captionField setDesc:desc];
}

- (void) setShowMark:(BOOL) showMark {
    [_captionField setShowMark:showMark];
}

//设置只读
- (void) setReadonly:(BOOL) readonly {
    [_captionField setEditable:!readonly];
}

//设置只显示一行
- (void) setShowOneLine:(BOOL) isOneLine {
    [_captionField setShowOneLine:isOneLine];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _listener = listener;
    [_captionField setOnClickListener:self];
}

- (NSString *) text {
    return _captionField.text;
}

#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    if(_listener) {
        [_listener onClick:self];
    }
}

@end
