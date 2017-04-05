//
//  CaptionMultipleTextTableViewCell.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "CaptionMultipleTextTableViewCell.h"
#import "CaptionTextView.h"
#import "FMSize.h"

@interface CaptionMultipleTextTableViewCell () <OnClickListener>

@property (readwrite, nonatomic, strong) CaptionTextView * captionTextView;
@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, weak) id<OnClickListener> listener;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation CaptionMultipleTextTableViewCell

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
        //        _captionField = [[CaptionTextField alloc] init];
        _captionTextView = [[CaptionTextView alloc] init];
        
        //        [self.contentView addSubview:_captionField];
        [self.contentView addSubview:_captionTextView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    //    [_captionField setFrame:CGRectMake(0, 0, width, height)];
    [_captionTextView setFrame:CGRectMake(0, 0, width, height)];
    
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
    [_captionTextView setTitle:title];
}

//设置默认提示
- (void) setPlaceholder:(NSString *) placeholder {
    [_captionTextView setPlaceholder:placeholder];
}

//设置内容
- (void) setText:(NSString *) text {
    [_captionTextView setText:text];
}


- (NSString *) text {
    return _captionTextView.text;
}

- (void) setDesc:(NSString *) desc {
    [_captionTextView setDesc:desc];
}

- (void) setShowMark:(BOOL) showMark {
    [_captionTextView setShowMark:showMark];
}

//设置只读
- (void) setReadonly:(BOOL) readonly {
    [_captionTextView setEditable:!readonly];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _listener = listener;
    [_captionTextView setOnClickListener:self];
}

#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    if(_listener) {
        [_listener onClick:self];
    }
}

@end
