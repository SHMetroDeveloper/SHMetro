//
//  LimitTextView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "LimitTextView.h"
#import "FMSize.h"
#import "FMColor.h"
#import "FMFont.h"
#import "FMUtils.h"

#import "BaseBundle.h"


@interface LimitTextView () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) BaseTextView * textView;
@property (readwrite, nonatomic, strong) UILabel * capacityLbl;

@property (readwrite, nonatomic, assign) NSInteger capacity;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation LimitTextView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _capacity= 0;   //默认不限制
        
        _textView = [[BaseTextView alloc] init];
        [_textView setOnViewResizeListener:self];
        _capacityLbl = [[UILabel alloc] init];
        _capacityLbl.textColor = [FMColor getInstance].grayLevel4;
        _capacityLbl.font = [FMFont fontWithSize:11];
        
        [self addSubview:_textView];
        [self addSubview:_capacityLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
}

- (void) updateCapacity {
    if(_capacity == 0) {
        [_capacityLbl setHidden:YES];
    } else {
        [_capacityLbl setHidden:NO];
        _capacityLbl.text = [self getCapacityDesc];
    }
}

- (NSString *) getCapacityDesc {
    NSString * desc = @"";
    NSInteger count = [[_textView getContent] length];
    if(_capacity > 0) {
        if(count == 0) {
            desc = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"input_capacity_format" inTable:nil], _capacity];
        } else {
            
        }
    }
    
    return desc;
}



- (void) setContent:(NSString *) content {
    [_textView setContentWith:content];
}
- (NSString *) getContent {
    NSString * content;
    return content;
}

- (void) setMaxCapacity:(NSInteger) capacity {
    _capacity = capacity;
    [self updateCapacity];
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _textView) {
        CGRect frame = _textView.frame;
        CGSize oldSize = frame.size;
        if(oldSize.width != newSize.width || oldSize.height != newSize.height) {
            frame.size = newSize;
            _textView.frame = frame;
            [self updateViews];
        }
    }
}

@end
