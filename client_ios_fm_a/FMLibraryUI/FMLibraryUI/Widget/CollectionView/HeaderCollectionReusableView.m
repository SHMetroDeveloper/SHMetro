//
//  HeaderCollectionReusableView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/22.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "HeaderCollectionReusableView.h"
#import "FMTheme.h"

@interface  HeaderCollectionReusableView()

@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIImage * headerImage;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation HeaderCollectionReusableView

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
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self updateImage];
        
        [self addSubview:_headerImageView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [_headerImageView setFrame:CGRectMake(0, 0, width, height)];
}

- (void) updateImage {
    if (_headerImage) {
        [_headerImageView setImage:_headerImage];
    } else {
        [_headerImageView setImage:[[FMTheme getInstance] getImageByName:@"service_center_banner"]];
    }
}


- (void) setHeaderImage:(UIImage *)headerImage {
    _headerImage = headerImage;
    [self updateImage];
    [self updateViews];
}


@end
