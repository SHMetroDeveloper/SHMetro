//
//  FMImageUnitView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/25.
//  Copyright © 2016年 flynn. All rights reserved.
//


#import "FMImageUnitView.h"
#import "FMTheme.h"

@implementation FMImageUnitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageView];
        
        _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageButton];
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-20, 0, 20, 20)];
        _deleteButton.layer.cornerRadius = 10;
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
        [_deleteButton setImage:[[FMTheme getInstance] getImageByName:@"btn_close_selected"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
    }
    return self;
}

@end
