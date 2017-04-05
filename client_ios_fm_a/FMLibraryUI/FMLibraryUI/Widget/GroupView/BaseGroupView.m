//
//  BaseGroupView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseGroupView.h"
#import "SeperatorView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"



@interface BaseGroupView ()

@property (readwrite, nonatomic, strong) NSMutableArray * memberViews;  //成员 view
@property (readwrite, nonatomic, strong) NSMutableArray * seperatorViews;  //成员 view

@property (readwrite, nonatomic, assign) BOOL showSeperator;            //显示分隔线
@property (readwrite, nonatomic, assign) BOOL showBounds;               //显示边框

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat memberHeight;          //子view 高度
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;       //分隔线高度

@property (readwrite, nonatomic, assign) BaseGroupViewBoundsType boundsType;    //边框类型

@end

@implementation BaseGroupView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSettings];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initSettings {
    _paddingLeft = 15;
    _paddingRight = _paddingLeft;
    _paddingTop = 0;
    _paddingBottom = 0;
    _memberHeight = 40;
    _seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    _showSeperator = YES;   //默认显示分割线
    _showBounds = NO;      //默认显示边框
    
    _boundsType = BOUNDS_TYPE_NONE;
    
    _memberViews = [[NSMutableArray alloc] init];
    _seperatorViews = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    if(height == 0 || width == 0) {
        return;
    }
    NSInteger i = 0;
    CGFloat originY = _paddingTop;
    _memberHeight = height / [_memberViews count];
    for(UIView * view in _memberViews) {
        if(originY > _paddingTop) {
            if(_showSeperator) {
                SeperatorView * sepView = nil;
                if(i < [_seperatorViews count]) {
                    sepView = _seperatorViews[i];
                
                } else {
                    sepView = [[SeperatorView alloc] init];
                    [_seperatorViews addObject:sepView];
                    [self addSubview:sepView];
                }
                [sepView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, _seperatorHeight)];
                [sepView setHidden:NO];
                i++;
            }
        }
        [view setFrame:CGRectMake(0, originY, width, _memberHeight)];
        originY += _memberHeight;
        
    }
    for(;i<[_seperatorViews count];i++) {
        SeperatorView * sepView = _seperatorViews[i];
        [sepView setHidden:YES];
    }
    [self updateBounds];
}

- (void) updateBounds {
    if(_showBounds) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        if(_boundsType == BOUNDS_TYPE_CIRCLE) {
            self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        } else if (_boundsType == BOUNDS_TYPE_RECT) {
            self.layer.cornerRadius = 0;
        }
    } else {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

- (void) setMembers:(NSMutableArray *) viewsArray {
    _memberViews = viewsArray;
    for(UIView * view in _memberViews) {
        if(view) {
            [self addSubview:view];
        }
    }
    [self updateViews];
}

- (void) addMember:(UIView *) view {
    if(view) {
        [_memberViews addObject:view];
        [self addSubview:view];
        [self updateViews];
    }
}

- (void) setBoundsType:(BaseGroupViewBoundsType)boundsType {
    _boundsType = boundsType;
    if(_boundsType != BOUNDS_TYPE_NONE) {
        _showBounds = YES;
    } else {
        _showBounds = NO;
    }
    [self updateViews];
}

- (void) setItemHeight:(CGFloat) itemHeight {
    _memberHeight = itemHeight;
}

//设置是否显示分割线
- (void) setShowSeperator:(BOOL) show {
    _showSeperator = show;
    [self updateViews];
}

@end