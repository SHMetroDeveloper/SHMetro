//
//  RoundLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "RoundLabel.h"
#import "FMUtils.h"


@interface RoundLabel ()

@property (readwrite, nonatomic, strong) UILabel * msgLbl;
@property (readwrite, nonatomic, strong) NSString * content;

@end


@implementation RoundLabel

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_msgLbl) {
        _msgLbl = [[UILabel alloc] init];
        [_msgLbl setTextColor:[UIColor blackColor]];
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;   //去除边界
        _msgLbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_msgLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat radius = width < height ? width : height;
    [_msgLbl setFrame:CGRectMake(0, 0, width, height)];
    self.layer.cornerRadius = radius / 2;
    [self updateInfo];
}


- (void) updateInfo {
    [_msgLbl setText:_content];
}

- (void) setContent:(NSString *)content {
    _content = content;
    [self updateViews];
}

//设置字体
- (void) setFont:(UIFont *) font {
    [_msgLbl setFont:font];
}

- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor {
    [_msgLbl setTextColor:textColor];
    self.layer.borderColor = [borderColor CGColor];
}

- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor backgroundColor:(UIColor *) bgColor {
    [_msgLbl setTextColor:textColor];
    self.layer.borderColor = [borderColor CGColor];
    [self setImage:[FMUtils buttonImageFromColor:bgColor width:1 height:1]];
}

@end
